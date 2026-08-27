-- 컴퓨터 시스템 통합 마스터 관리 시스템
-- Supabase SQL Editor에서 이 파일 전체를 한 번에 실행하세요.

-- 1. 사용자 프로필 테이블
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  name text not null default '',
  department text not null default '',
  role text not null default 'user' check (role in ('admin', 'user')),
  status text not null default 'pending' check (status in ('pending', 'approved', 'rejected', 'disabled')),
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

-- 2. 관리자 여부 확인 함수 (RLS 정책의 무한 재귀를 피하기 위해 security definer 사용)
create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin' and status = 'approved'
  );
$$;

-- 3. RLS 정책
drop policy if exists "profiles_select" on public.profiles;
create policy "profiles_select" on public.profiles
  for select using (auth.uid() = id or public.is_admin());

drop policy if exists "profiles_update_admin" on public.profiles;
create policy "profiles_update_admin" on public.profiles
  for update using (public.is_admin());

-- insert/delete는 클라이언트에서 직접 하지 않음 (아래 트리거로만 생성)

-- 4. 회원가입 시 auth.users -> profiles 자동 생성 트리거
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, name, department, role, status)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'name', ''),
    coalesce(new.raw_user_meta_data->>'department', ''),
    'user',
    'pending'
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 5. 최초 관리자 지정 (회원가입 1회 진행 후, 아래 이메일을 본인 계정으로 바꿔서 실행)
-- update public.profiles set role = 'admin', status = 'approved' where email = 'your-email@company.com';
