<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="수락한 여행 미션 진행 페이지">
  <title>진행 중인 미션 | 짠맛투어</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
</head>
<body>
<div class="zt-app">

  <header class="zt-mobile-header">
    <a class="zt-brand" href="${pageContext.request.contextPath}/home">
      <span>짠맛투어</span>
    </a>
    <a href="${pageContext.request.contextPath}/login" class="fs-5" aria-label="로그인"><i class="bi bi-box-arrow-in-right"></i></a>
  </header>
  <nav class="zt-mobile-nav" aria-label="모바일 메뉴">
    <a href="${pageContext.request.contextPath}/home" class="" aria-label="home"><i class="bi bi-house"></i></a>
    <a href="${pageContext.request.contextPath}/my-travel" class="" aria-label="짠맛투어"><i class="bi bi-grid-3x3-gap"></i></a>
    <a href="${pageContext.request.contextPath}/new-post" class="" aria-label="new"><i class="bi bi-plus-square"></i></a>
    <a href="${pageContext.request.contextPath}/chat" class="" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
    <a href="${pageContext.request.contextPath}/profile" class="" aria-label="profile"><i class="bi bi-person-circle"></i></a>
  </nav>

  <div class="zt-layout">

    <jsp:include page="/WEB-INF/views/components/sidebar.jsp">
      <jsp:param name="activePage" value="mission" />
    </jsp:include>

    <main class="zt-content">

      <header class="zt-page-header">
        <h1>진행 중인 미션</h1>
        <p id="mission-title-display" class="fw-medium text-dark">
          <c:choose>
            <c:when test="${mission != null}">${mission.title}</c:when>
            <c:otherwise>여행 미션 진행 현황</c:otherwise>
          </c:choose>
        </p>
      </header>

      <section class="zt-panel zt-profile-card">
        <div class="ratio ratio-21x9 rounded-3 overflow-hidden mb-4">
          <img src="${pageContext.request.contextPath}/assets/images/seoul.svg" class="object-fit-cover" alt="진행 중인 여행 미션">
        </div>

        <!-- 전체 진행률 및 프로그레스 바 -->
        <div class="mb-4">
          <div class="d-flex justify-content-between mb-2">
            <strong>전체 진행률</strong>
            <span id="progress-text-display" class="zt-muted">0 / 0</span>
          </div>

          <div class="progress zt-mission-progress" role="progressbar" aria-label="미션 진행률" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">
            <div id="progress-bar-element" class="progress-bar" style="width: 0%"></div>
          </div>
        </div>

        <!-- 비로그인 시 안내 영역 (기본 숨김 처리 후 JS로 제어) -->
        <div id="login-required-banner" class="alert alert-light border text-center py-4 mb-4" style="display: none;">
          <p class="text-muted mb-2">미션 인증 상태를 확인하고 포인트를 적립하려면 로그인이 필요합니다.</p>
          <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-primary fw-bold px-4">로그인하러 가기</a>
        </div>

        <!-- DB 연동 실시간 체크리스트 동적 렌더링 영역 -->
        <div class="list-group mb-4" id="checklist-container">
          <!-- 기본 기본 체크리스트 구조 (JS가 데이터를 받아오면 동적으로 갱신함) -->
          <label class="list-group-item d-flex gap-3 py-3 align-items-center">
            <input class="form-check-input flex-shrink-0" type="checkbox" disabled>
            <span><strong>대중교통으로 출발하기</strong><small class="d-block text-secondary">교통카드 내역 또는 이동 경로 인증</small></span>
          </label>
          <label class="list-group-item d-flex gap-3 py-3 align-items-center">
            <input class="form-check-input flex-shrink-0" type="checkbox" disabled>
            <span><strong>무료 명소 방문하기</strong><small class="d-block text-secondary">무료 명소 사진 한 장 업로드</small></span>
          </label>
          <label class="list-group-item d-flex gap-3 py-3 align-items-center">
            <input class="form-check-input flex-shrink-0" type="checkbox" disabled>
            <span><strong>만원 이하 식사하기</strong><small class="d-block text-secondary">영수증 또는 메뉴판 인증</small></span>
          </label>
          <label class="list-group-item d-flex gap-3 py-3 align-items-center">
            <input class="form-check-input flex-shrink-0" type="checkbox" disabled>
            <span><strong>여행 후기 작성하기</strong><small class="d-block text-secondary">피드에 여행 동선과 경비를 공유</small></span>
          </label>
        </div>

        <!-- 단일화된 깔끔한 인증 게시물 작성 버튼 -->
        <button type="button" id="authPostBtn" class="btn btn-primary zt-primary-btn w-100 py-2">
          인증 게시물 작성하고 미션 인증하기
        </button>
      </section>

    </main>

  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

<script>
  const contextPath = "${pageContext.request.contextPath}";

  // URL 파라미터에서 미션 ID 안전하게 추출
  const urlParams = new URLSearchParams(window.location.search);
  let rawMissionId = urlParams.get('missionId');
  let missionId = '';

  if (rawMissionId) {
    missionId = rawMissionId.toString().split(/[:?#]/)[0].replace(/[^0-9]/g, '');
  }
  if (!missionId) {
    missionId = "${mission != null ? mission.missionId : '1'}";
  }

  document.addEventListener("DOMContentLoaded", function () {
    // 페이지 진입 시 실시간 DB 진행 상황 동기화 호출
    loadDynamicMissionProgress();

    // 인증 게시물 작성 버튼 클릭 이벤트
    const authPostBtn = document.getElementById("authPostBtn");
    if (authPostBtn) {
      authPostBtn.addEventListener("click", function (e) {
        e.preventDefault();

        // 로그인 여부 체크 후 글 작성 페이지로 이동 (미션 ID 동반 전송)
        fetch(contextPath + '/member/api/check-login', { method: 'GET' })
                .then(response => {
                  if (response.status === 401 || response.status === 403 || !response.ok) {
                    throw new Error("LOGIN_REQUIRED");
                  }
                  return response.json();
                })
                .then(isLoggedIn => {
                  if (isLoggedIn === true || (isLoggedIn && isLoggedIn.success)) {
                    window.location.href = contextPath + "/new-post?missionId=" + missionId;
                  } else {
                    throw new Error("LOGIN_REQUIRED");
                  }
                })
                .catch(() => {
                  alert("로그인이 필요한 서비스입니다. 로그인 페이지로 이동합니다.");
                  window.location.href = contextPath + "/member/login";
                });
      });
    }
  });

  // DB 연동 실시간 체크리스트 및 프로그레스바 동적 갱신 함수
  function loadDynamicMissionProgress() {
    fetch(contextPath + '/mission/api/progress?missionId=' + missionId)
            .then(res => {
              if (res.status === 401 || res.status === 403) {
                // 비회원인 경우 로그인 안내 배너 표시
                document.getElementById("login-required-banner").style.display = "block";
                return null;
              }
              if (!res.ok) throw new Error("서버 통신 오류");
              return res.json();
            })
            .then(statusMap => {
              if (!statusMap || typeof statusMap !== 'object' || Array.isArray(statusMap)) {
                return;
              }

              // 비회원이 아닐 경우 로그인 배너 숨김
              document.getElementById("login-required-banner").style.display = "none";
              const container = document.getElementById("checklist-container");
              container.innerHTML = "";

              const entries = Object.entries(statusMap);
              if (entries.length === 0) return;

              let completedCount = 0;
              const totalCount = entries.length;

              // DB에서 가져온 인증 항목 상태에 맞춰 체크박스 동적 생성
              entries.forEach(([itemName, isChecked]) => {
                if (isChecked) completedCount++;

                const label = document.createElement("label");
                label.className = "list-group-item d-flex gap-3 py-3 align-items-center";
                label.innerHTML = `
                        <input class="form-check-input flex-shrink-0" type="checkbox" \${isChecked ? 'checked' : ''} disabled>
                        <span><strong>\${itemName}</strong><small class="d-block text-secondary">\${isChecked ? '인증 완료됨' : '인증 대기 중'}</small></span>
                    `;
                container.appendChild(label);
              });

              // 실시간 프로그레스바 퍼센트 계산 및 반영
              const percent = Math.round((completedCount / totalCount) * 100);
              document.getElementById("progress-text-display").innerText = completedCount + " / " + totalCount;

              const bar = document.getElementById("progress-bar-element");
              bar.style.width = percent + "%";
              bar.setAttribute("aria-valuenow", percent);

              // 미션 100% 달성 시 포인트 자동 적립 및 마이페이지 이동
              if (percent === 100) {
                triggerAutomaticCompletion();
              }
            })
            .catch(err => {
              console.error("진행 상황 동기화 실패:", err);
            });
  }

  // 미션 완료 시 포인트 자동 적립 처리 함수
  function triggerAutomaticCompletion() {
    fetch(contextPath + '/mission/api/complete', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({missionId: Number(missionId)})
    })
            .then(res => {
              if (res.ok) return res.json();
            })
            .then(data => {
              if (data && data.success) {
                alert("축하합니다! 미션 조건이 모두 충족되어 마이페이지로 포인트가 자동 적립되었습니다! 🎉");
                window.location.href = contextPath + "/my-travel";
              }
            })
            .catch(err => {
              console.error("자동 완료 처리 에러:", err);
            });
  }
</script>
</body>
</html>