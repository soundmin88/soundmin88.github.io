// Supabase 클라이언트 초기화 및 인증/권한 공용 함수
// 이 파일은 supabase-config.js, supabase-js CDN 스크립트 다음에 로드되어야 합니다.

const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

const STATUS_LABEL = {
  pending: "승인 대기",
  approved: "승인됨",
  rejected: "거절됨",
  disabled: "비활성화",
};

const ROLE_LABEL = {
  admin: "관리자",
  user: "일반 사용자",
};

async function getCurrentProfile() {
  const { data: { session } } = await supabaseClient.auth.getSession();
  if (!session) return null;

  const { data, error } = await supabaseClient
    .from("profiles")
    .select("*")
    .eq("id", session.user.id)
    .single();

  if (error) {
    console.error(error);
    return null;
  }
  return data;
}

// 로그인 + 승인된 사용자만 통과. 통과 시 profile 반환, 아니면 null(리다이렉트 처리됨)
async function requireApprovedUser() {
  const profile = await getCurrentProfile();

  if (!profile) {
    location.href = "login.html";
    return null;
  }

  if (profile.status === "pending") {
    alert("관리자 승인 대기 중인 계정입니다. 승인 후 이용해주세요.");
    await supabaseClient.auth.signOut();
    location.href = "login.html";
    return null;
  }

  if (profile.status !== "approved") {
    alert("계정이 비활성화되었습니다. 관리자에게 문의해주세요.");
    await supabaseClient.auth.signOut();
    location.href = "login.html";
    return null;
  }

  return profile;
}

// 승인된 관리자만 통과
async function requireAdmin() {
  const profile = await requireApprovedUser();
  if (!profile) return null;

  if (profile.role !== "admin") {
    alert("관리자만 접근할 수 있는 페이지입니다.");
    location.href = "dashboard.html";
    return null;
  }
  return profile;
}

async function logout() {
  await supabaseClient.auth.signOut();
  location.href = "login.html";
}
