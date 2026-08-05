<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="여행 미션 진행 페이지">
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
        <c:if test="${mission != null}">
          <p class="zt-muted small mb-0" id="mission-period-display">
            <c:choose>
              <c:when test="${mission.startAt != null && mission.endAt != null}">
                수행 기간: ${mission.startAt} ~ ${mission.endAt}
              </c:when>
              <c:otherwise>기간 제한 없음</c:otherwise>
            </c:choose>
            <c:if test="${mission.periodStatus == 'EXPIRED'}"> · 기간 종료</c:if>
            <c:if test="${mission.periodStatus == 'UPCOMING'}"> · 예정</c:if>
          </p>
        </c:if>
      </header>

      <section class="zt-panel zt-profile-card">
        <div class="ratio ratio-21x9 rounded-3 overflow-hidden mb-4">
          <img src="${pageContext.request.contextPath}/assets/images/seoul.svg" class="object-fit-cover" alt="진행 중인 여행 미션">
        </div>

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
          <h5 class="mb-0">미션 진행 현황</h5>
          <button type="button" class="btn btn-sm btn-outline-primary" onclick="refreshMissionProgress()">
            <i class="bi bi-arrow-clockwise"></i> 진행도 새로고침
          </button>
        </div>

        <span class="status-text" id="missionStatus">상태: -</span>

        <p id="progress-summary" class="text-secondary mb-4">진행 정보를 불러오는 중입니다.</p>

        <button type="button" id="authPostBtn" class="btn btn-primary zt-primary-btn w-100 py-3 fw-bold mb-3">
          인증 게시물 작성하고 미션 인증하기
        </button>

        <button type="button" id="completeBtn" class="btn btn-outline-success w-100 py-3 fw-bold mb-3" style="display:none;">
          미션 완료하기
        </button>

      </section>

    </main>

  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

<script>
  const contextPath = "${pageContext.request.contextPath}";

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
      document.getElementById("progress-summary").innerText = "조회할 미션 정보가 없습니다. 미션 목록에서 미션을 선택해주세요.";
    }

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

    const completeBtn = document.getElementById("completeBtn");
    if (completeBtn) {
      completeBtn.addEventListener("click", function () {
        completeMission();
      });
    }
  });

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

  function completeMission() {
    fetch(contextPath + '/api/mission/complete', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({missionId: Number(missionId)})
    })
      .then(res => res.json())
      .then(data => {
        if (data && data.success) {
          alert("미션이 완료되었습니다.");
          refreshMissionProgress();
        } else {
          alert((data && data.message) ? data.message : "미션 완료에 실패했습니다.");
        }
      })
      .catch(err => {
        console.error("미션 완료 처리 에러:", err);
        alert("미션 완료 중 오류가 발생했습니다.");
      });
  }

  function statusLabel(status, periodStatus) {
    if (periodStatus === 'EXPIRED') return '기간 종료';
    if (periodStatus === 'UPCOMING') return '예정';
    if (status === 'DONE') return '완료';
    if (status === 'IN_PROGRESS') return '진행 중';
    if (status === 'READY') return '대기';
    if (!status) return '미시작';
    return status;
  }

  function refreshMissionProgress() {
    if (!missionId) return;

    fetch(contextPath + '/api/mission/progress?missionId=' + missionId)
      .then(res => res.json())
      .then(response => {
        if (!response || !response.success || !response.data) return;

        const data = response.data;
        const currentCount = data.currentCount || 0;
        const targetCount = data.targetCount || 0;
        const percent = data.percent || 0;

        document.getElementById("progress-text-display").innerText = currentCount + " / " + targetCount;

        const bar = document.getElementById("progress-bar-element");
        bar.style.width = percent + "%";
        bar.setAttribute("aria-valuenow", percent);

        document.getElementById("missionStatus").innerText =
          "상태: " + statusLabel(data.status, data.periodStatus);

        const summary = document.getElementById("progress-summary");
        if (!data.loggedIn) {
          summary.innerText = "로그인하면 기간 내 미션이 자동으로 시작됩니다.";
        } else if (data.periodStatus === 'EXPIRED') {
          summary.innerText = "이 미션은 수행 기간이 종료되었습니다.";
        } else if (data.periodStatus === 'UPCOMING') {
          summary.innerText = "아직 시작 전인 미션입니다. 기간이 되면 자동으로 수행됩니다.";
        } else if (data.status === 'DONE') {
          summary.innerText = "미션을 완료했습니다." + (data.rewardReceived ? " 보상이 지급되었습니다." : "");
        } else if (!data.status) {
          summary.innerText = "진행 정보를 준비하는 중입니다.";
        } else {
          summary.innerText = "목표 " + targetCount + "회 중 " + currentCount + "회 진행했습니다. (보상 " + (data.rewardPoint || 0) + "P)";
        }

        const canAct = data.loggedIn && data.available && data.status === 'IN_PROGRESS';
        const authPostBtn = document.getElementById("authPostBtn");
        const completeBtn = document.getElementById("completeBtn");
        if (authPostBtn) {
          authPostBtn.style.display = canAct ? "block" : "none";
        }
        if (completeBtn) {
          completeBtn.style.display = canAct ? "block" : "none";
        }
      })
      .catch(err => {
        console.error("진행 상황 동기화 실패:", err);
      });
  }
</script>
</body>
</html>
