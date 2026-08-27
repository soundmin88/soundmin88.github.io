-- 컴퓨터 시스템 통합 마스터 관리 시스템 - 설비 마스터 테이블
-- supabase/schema.sql 을 먼저 적용한 뒤, 이 파일을 SQL Editor에서 전체 실행하세요.
-- 회사 시스템에서 추출하는 실제 컬럼(순번 제외)을 그대로 반영했습니다.

create table if not exists public.equipment_master (
  id uuid primary key default gen_random_uuid(),

  team text,                    -- 팀
  part text,                    -- 파트
  location text,                -- 설비위치
  dosage_form text,             -- 제형
  room_no text,                 -- 실번호
  legacy_mgmt_no text,          -- 기존관리번호
  equipment_no text not null unique, -- 설비번호 (고유 식별자, 업로드 시 기준 키)
  equipment_name text,          -- 설비명
  equipment_grade text,         -- 설비등급
  install_date text,            -- 설치일자 (원본 형식 YYYYMMDD 그대로 보관)
  machine_capacity text,        -- 기계능력
  model text,                   -- 모델
  serial_no text,               -- Serial#
  manufacturer text,            -- 제조사
  supplier text,                -- 공급업체
  is_regulated text,            -- 법정설비여부 (Y/N)
  origin_country text,          -- 제조국
  utility text,                 -- 사용Utility
  equipment_type text,          -- 설비유형 (설비/계측기)
  revision_status text,         -- Revision 진행상태
  is_latest_version text,       -- 최신Version 여부 (Y/N)
  revision_no text,             -- Revision 번호
  equipment_status text,        -- 설비상태

  created_by uuid references public.profiles(id),
  updated_by uuid references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.equipment_master enable row level security;

-- 승인된 사용자는 모두 조회 가능
drop policy if exists "equipment_master_select" on public.equipment_master;
create policy "equipment_master_select" on public.equipment_master
  for select using (
    exists (select 1 from public.profiles where id = auth.uid() and status = 'approved')
  );

-- 등록/수정/삭제는 관리자만 가능
drop policy if exists "equipment_master_write" on public.equipment_master;
create policy "equipment_master_write" on public.equipment_master
  for all using (public.is_admin()) with check (public.is_admin());

-- 등록/수정 시 작성자·수정일시 자동 기록
create or replace function public.set_equipment_master_audit()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    new.created_by := auth.uid();
  end if;
  new.updated_by := auth.uid();
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists equipment_master_audit on public.equipment_master;
create trigger equipment_master_audit
  before insert or update on public.equipment_master
  for each row execute procedure public.set_equipment_master_audit();
