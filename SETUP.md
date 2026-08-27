# 컴퓨터 시스템 통합 마스터 관리 시스템 - 설정 가이드

이 사이트는 GitHub Pages(정적 호스팅) + Supabase(로그인·데이터베이스)로 동작합니다.
아래 순서대로 진행하면 로그인/회원가입/사용자 관리 기능이 바로 동작합니다.

## 1. Supabase 프로젝트 생성
1. https://supabase.com 접속 후 무료 회원가입
2. "New project" 클릭 → 프로젝트 이름, 비밀번호(DB 비밀번호, 잊지 않게 저장), 리전(서울에서 가깝게 Northeast Asia 권장) 입력 후 생성
3. 생성 완료까지 1~2분 대기

## 2. 데이터베이스 스키마 적용
1. Supabase 대시보드 좌측 메뉴 → **SQL Editor**
2. 이 저장소의 `supabase/schema.sql` 파일 내용을 전체 복사해서 붙여넣기
3. **Run** 클릭해서 실행 (테이블, 트리거, 보안 정책이 한 번에 생성됩니다)

## 3. 접속 키 복사 및 코드에 반영
1. 대시보드 좌측 메뉴 → **Project Settings > API**
2. **Project URL**과 **anon public** key 복사
3. 이 저장소의 `assets/js/supabase-config.js` 파일을 열어 아래처럼 채워넣기:
   ```js
   const SUPABASE_URL = "https://xxxxxxxx.supabase.co";
   const SUPABASE_ANON_KEY = "eyJxxxxxxxxxxxxxxxxxxxxx...";
   ```
   (anon key는 공개되어도 되는 키입니다. 데이터 보호는 DB의 보안 정책(RLS)이 담당합니다.)

## 4. 이메일 인증 설정 확인
1. 대시보드 → **Authentication > Providers > Email** 이 켜져 있는지 확인
2. 사내 테스트 단계에서 이메일 인증 확인 절차를 생략하고 싶다면
   **Authentication > Settings**에서 "Confirm email"을 잠시 꺼두는 것도 가능합니다
   (실사용 전환 시에는 다시 켜는 것을 권장합니다)

## 5. 최초 관리자 계정 만들기
1. 배포된 사이트에서 `signup.html`로 일반 가입 진행 (본인 회사 이메일 사용)
2. Supabase 대시보드 → **SQL Editor**에서 아래 실행 (이메일만 본인 것으로 교체):
   ```sql
   update public.profiles
   set role = 'admin', status = 'approved'
   where email = 'your-email@company.com';
   ```
3. 다시 로그인하면 상단에 "사용자 관리" 메뉴가 나타납니다.
4. 이후 다른 직원의 가입 승인은 관리자 계정으로 로그인해서 `admin-users.html`에서 처리하면 됩니다.

## 6. 설비 마스터 테이블 추가 적용
회사 시스템에서 추출하는 설비 마스터 컬럼을 반영한 테이블입니다. Supabase SQL Editor에서 `supabase/schema_master.sql` 내용 전체를 붙여넣고 실행해주세요. (2번 단계와 같은 방식입니다.)

적용 후 사용 방법:
- **조회**: 로그인 후 상단 "설비 마스터" 메뉴에서 검색/조회 (모든 승인된 사용자 가능)
- **일괄 등록/갱신**: 관리자 계정으로 로그인 → "설비 마스터 업로드" → 엑셀에서 헤더 포함 표 전체를 복사해 붙여넣기 → 미리보기 확인 → 업로드 실행. 설비번호가 이미 있으면 내용이 갱신되고, 없으면 새로 등록됩니다.
- **개별 등록/수정/삭제**: 관리자만 가능, "설비 마스터" 목록에서 "+ 새 설비 등록" 또는 각 행의 "상세" 클릭

## 파일 구성
- `login.html` / `signup.html` - 로그인 / 회원가입(관리자 승인 대기)
- `dashboard.html` - 로그인 후 메인 화면 (마스터 파일 기능은 다음 단계 예정)
- `admin-users.html` - 관리자 전용 사용자 승인/권한 관리 화면
- `assets/js/supabase-config.js` - Supabase 접속 정보 (직접 채워넣는 파일)
- `supabase/schema.sql` - DB 테이블/보안 정책 스크립트

## 다음 단계
마스터 파일 등록/조회 기능은 로그인·사용자 관리가 정상 동작하는 것을 확인한 뒤 이어서 만듭니다.
