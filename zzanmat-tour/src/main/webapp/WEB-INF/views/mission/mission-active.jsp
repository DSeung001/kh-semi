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
  <style>
    .zt-mission-progress { background-color: #eee; border-radius: 8px; height: 20px; overflow: hidden; }
    .progress-bar { background-color: #4CAF50; transition: width 0.3s ease; }
    .status-text { font-weight: bold; margin-bottom: 15px; display: block; }
  </style>
</head>
<body>
<div class="zt-app">

  <header class="zt-mobile-header">
    <a class="zt-brand" href="${pageContext.request.contextPath}/home">
      <span>짠맛투어</span>
    </a>
    <a href="${pageContext.request.contextPath}/member/login" class="fs-5" aria-label="로그인"><i class="bi bi-box-arrow-in-right"></i></a>
  </header>

  <nav class="zt-mobile-nav" aria-label="모바일 메뉴">
    <a href="${pageContext.request.contextPath}/home" aria-label="home"><i class="bi bi-house"></i></a>
    <a href="${pageContext.request.contextPath}/my-travel" aria-label="짠맛투어"><i class="bi bi-grid-3x3-gap"></i></a>
    <a href="${pageContext.request.contextPath}/new-post" aria-label="new"><i class="bi bi-plus-square"></i></a>
    <a href="${pageContext.request.contextPath}/chat" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
    <a href="${pageContext.request.contextPath}/profile" aria-label="profile"><i class="bi bi-person-circle"></i></a>
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
            <c:otherwise>선택된 미션 정보가 없습니다.</c:otherwise>
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

        <div class="d-flex justify-content-between align-items-center mb-3">
          <h5 class="mb-0">실시간 미션 인증 현황</h5>
          <button type="button" class="btn btn-sm btn-outline-primary" onclick="refreshMissionProgress()">
            <i class="bi bi-arrow-clockwise"></i> 진행도 새로고침
          </button>
        </div>

        <!-- 미션 상태 텍스트 -->
        <span class="status-text" id="missionStatus">상태: 진행 중 (인증 게시물 작성 시 자동으로 체크 및 반영됩니다)</span>

        <!-- DB 연동 실시간 체크리스트 동적 렌더링 영역 -->
        <div class="list-group mb-4" id="checklist-container">
          <!-- 동적으로 데이터가 바인딩 -->
        </div>

        <!-- 인증 게시물 작성 버튼 -->
        <button type="button" id="authPostBtn" class="btn btn-primary zt-primary-btn w-100 py-3 fw-bold mb-3">
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

  // URL 파라미터에서 미션 ID를 동적으로 추출 (모델에 바인딩된 ID가 존재할 경우 fallback 활용)
  const urlParams = new URLSearchParams(window.location.search);
  let rawMissionId = urlParams.get('missionId');
  let missionId = '';

  if (rawMissionId) {
    missionId = rawMissionId.toString().replace(/[^0-9]/g, '');
  }
  if (!missionId) {
    missionId = "${mission != null ? mission.missionId : ''}";
  }

  document.addEventListener("DOMContentLoaded", function () {
    if (missionId) {
      refreshMissionProgress();
    } else {
      document.getElementById("checklist-container").innerHTML = `
            <div class="list-group-item text-center text-muted py-4 rounded-3 border">
                조회할 미션 정보가 없습니다. 미션 목록에서 미션을 선택해주세요.
            </div>
        `;
    }

    // 인증 게시물 작성 버튼 클릭 이벤트 (로그인 검증 및 현재 미션 페이지 복귀 주소 연동)
    const authPostBtn = document.getElementById("authPostBtn");
    if (authPostBtn) {
      authPostBtn.addEventListener("click", function (e) {
        e.preventDefault();
        if (!missionId) {
          alert("미션 정보가 올바르지 않습니다.");
          return;
        }
        checkLoginAndMovePost(missionId);
      });
    }
  });

  // POST 방식으로 로그인 상태 체크 후 현재 미션 페이지로 복귀하도록 요청하는 함수
  function checkLoginAndMovePost(targetMissionId) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = contextPath + '/mission/check-auth-and-move';

    const missionInput = document.createElement('input');
    missionInput.type = 'hidden';
    missionInput.name = 'missionId';
    missionInput.value = targetMissionId;
    form.appendChild(missionInput);

    const urlInput = document.createElement('input');
    urlInput.type = 'hidden';
    urlInput.name = 'redirectUrl';
    urlInput.value = window.location.pathname + window.location.search;
    form.appendChild(urlInput);

    document.body.appendChild(form);
    form.submit();
  }

  // 미션 완료 시 포인트 자동 적립 처리 함수
  function triggerAutomaticCompletion() {
    fetch(contextPath + '/api/mission/complete', {
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

  // DB 연동 실시간 체크리스트 및 프로그레스바 동적 갱신 함수
  function refreshMissionProgress() {
    if (!missionId) return;

    fetch(contextPath + '/api/mission/progress?missionId=' + missionId)
            .then(res => res.json())
            .then(response => {
              if (!response || !response.success) return;

              const statusMap = response.data;
              if (!statusMap || typeof statusMap !== 'object') return;

              const container = document.getElementById("checklist-container");
              container.innerHTML = "";

              const entries = Object.entries(statusMap);
              if (entries.length === 0) return;

              let completedCount = 0;
              const totalCount = entries.length;

              entries.forEach(([itemName, isChecked]) => {
                if (isChecked) completedCount++;

                const label = document.createElement("label");
                label.className = "list-group-item d-flex gap-3 py-3 align-items-center shadow-sm mb-2 rounded-3";

                const input = document.createElement("input");
                input.className = "form-check-input flex-shrink-0";
                input.type = "checkbox";
                input.checked = isChecked;
                input.disabled = true; // 시스템 인증 연동형이므로 사용자 임의 조작 방지

                const span = document.createElement("span");
                const strong = document.createElement("strong");
                strong.innerText = itemName;

                const small = document.createElement("small");
                small.className = "d-block " + (isChecked ? "text-success fw-bold" : "text-secondary");
                small.innerText = isChecked ? '✨ 시스템 인증 완료됨' : '⏳ 인증 대기 중 (게시글 작성 필요)';

                span.appendChild(strong);
                span.appendChild(small);

                label.appendChild(input);
                label.appendChild(span);
                container.appendChild(label);
              });

              // 프로그레스 바 동적 반영
              const percent = Math.round((completedCount / totalCount) * 100);
              document.getElementById("progress-text-display").innerText = completedCount + " / " + totalCount;

              const bar = document.getElementById("progress-bar-element");
              bar.style.width = percent + "%";
              bar.setAttribute("aria-valuenow", percent);

              // 100% 달성 및 로그인 상태일 경우 자동 완료 처리 트리거
              if (percent === 100 && response.isLoggedIn) {
                triggerAutomaticCompletion();
              }
            })
            .catch(err => {
              console.error("진행 상황 동기화 실패:", err);
            });
  }
</script>
</body>
</html>