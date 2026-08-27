// 설비 마스터 컬럼 정의: 회사 시스템에서 추출되는 원본 헤더(label)와 DB 컬럼(key) 매핑
// 업로드 파싱, 등록/수정 폼, 상세보기가 모두 이 정의를 공유합니다.

const MASTER_FIELDS = [
  { key: "team", label: "팀" },
  { key: "part", label: "파트" },
  { key: "location", label: "설비위치" },
  { key: "dosage_form", label: "제형" },
  { key: "room_no", label: "실번호" },
  { key: "legacy_mgmt_no", label: "기존관리번호" },
  { key: "equipment_no", label: "설비번호", required: true },
  { key: "equipment_name", label: "설비명" },
  { key: "equipment_grade", label: "설비등급" },
  { key: "install_date", label: "설치일자" },
  { key: "machine_capacity", label: "기계능력" },
  { key: "model", label: "모델" },
  { key: "serial_no", label: "Serial#" },
  { key: "manufacturer", label: "제조사" },
  { key: "supplier", label: "공급업체" },
  { key: "is_regulated", label: "법정설비여부" },
  { key: "origin_country", label: "제조국" },
  { key: "utility", label: "사용Utility" },
  { key: "equipment_type", label: "설비유형" },
  { key: "revision_status", label: "Revision 진행상태" },
  { key: "is_latest_version", label: "최신Version 여부" },
  { key: "revision_no", label: "Revision 번호" },
  { key: "equipment_status", label: "설비상태" },
];

// 목록 화면에 보여줄 핵심 컬럼만 추린 것
const MASTER_LIST_FIELDS = ["equipment_no", "equipment_name", "team", "part", "location", "equipment_grade", "equipment_status"];
