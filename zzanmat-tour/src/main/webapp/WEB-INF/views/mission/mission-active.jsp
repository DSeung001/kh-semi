<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="여행 미션 진행 페이지">
  <title>미션 도전 | 짠맛투어</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
  <style>
    .zt-mission-progress { background-color: #eee; border-radius: 8px; height: 20px; overflow: hidden; }
    .progress-bar { background-color: #4CAF50; transition: width 0.3s ease; }
    .status-text { font-weight: bold; margin-bottom: 12px; display: block; }
    .zt-mission-steps { padding-left: 1.2rem; margin-bottom: 1rem; }
    .zt-mission-steps li { margin-bottom: 0.25rem; }
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
        <h1>미션 도전</h1>
        <p id="mission-title-display" class="fw-medium text-dark mb-1">
          <c:choose>
            <c:when test="${mission != null}">${mission.title}</c:when>
            <c:otherwise>선택된 미션 정보가 없습니다.</c:otherwise>
          </c:choose>
        </p>
        <c:if test="${mission != null}">
          <p class="mb-1">
            <span class="badge bg-success-subtle text-success border border-success-subtle">
              완료 보상 <fmt:formatNumber value="${mission.rewardPoint}" type="number"/>포인트
            </span>
          </p>
          <p class="zt-muted small mb-0" id="mission-period-display">
            <c:choose>
              <c:when test="${mission.startAt != null && mission.endAt != null}">
                <c:set var="startAtText" value="${mission.startAt}"/>
                <c:set var="endAtText" value="${mission.endAt}"/>
                수행 기간: ${fn:replace(startAtText, 'T', ' ')} ~ ${fn:replace(endAtText, 'T', ' ')}
              </c:when>
              <c:when test="${mission.startAt != null}">
                <c:set var="startAtText" value="${mission.startAt}"/>
                시작: ${fn:replace(startAtText, 'T', ' ')}
              </c:when>
              <c:when test="${mission.endAt != null}">
                <c:set var="endAtText" value="${mission.endAt}"/>
                종료: ${fn:replace(endAtText, 'T', ' ')}
              </c:when>
              <c:otherwise>기간 제한 없음</c:otherwise>
            </c:choose>
            <c:if test="${mission.periodStatus == 'EXPIRED'}"> · 기간 종료</c:if>
            <c:if test="${mission.periodStatus == 'UPCOMING'}"> · 예정</c:if>
          </p>
        </c:if>
      </header>

      <section class="zt-panel zt-profile-card">
        <c:if test="${mission != null}">
          <div class="mb-4">
            <strong class="d-block mb-2">이렇게 하면 돼요</strong>
            <ol class="zt-mission-steps small mb-0">
              <li>아래 조건을 확인해요</li>
              <li>
                <c:choose>
                  <c:when test="${mission.missionType == 'COMMENT'}">게시글로 가서 댓글을 달아요</c:when>
                  <c:when test="${mission.missionType == 'LIKE'}">게시물에서 좋아요를 눌러요</c:when>
                  <c:when test="${mission.missionType == 'CHAT'}">오픈 채팅에서 메시지를 보내요</c:when>
                  <c:otherwise>조건에 맞는 게시글을 작성해요</c:otherwise>
                </c:choose>
              </li>
              <li>따로 완료 버튼 없이 자동으로 진행·완료돼요</li>
            </ol>
          </div>

          <div class="mb-4" id="mission-conditions">
            <strong>수행 조건</strong>
            <ul class="mb-0 mt-2">
              <c:choose>
                <c:when test="${mission.missionType == 'COMMENT'}">
                  <li>댓글 작성</li>
                </c:when>
                <c:when test="${mission.missionType == 'LIKE'}">
                  <li>게시글 또는 댓글에 좋아요</li>
                </c:when>
                <c:when test="${mission.missionType == 'CHAT'}">
                  <li>오픈 채팅 메시지 전송</li>
                </c:when>
                <c:otherwise>
                  <li>게시글 작성</li>
                  <c:if test="${not empty mission.placeKeyword}">
                    <li>장소에 &quot;<c:out value="${mission.placeKeyword}"/>&quot; 포함</li>
                  </c:if>
                  <c:if test="${mission.maxTotalCost != null and mission.maxTotalCost > 0}">
                    <li>총 경비 <c:out value="${mission.maxTotalCost}"/>원 이하</li>
                  </c:if>
                </c:otherwise>
              </c:choose>
            </ul>
          </div>
        </c:if>

        <div class="mb-4">
          <div class="d-flex justify-content-between align-items-center mb-2">
            <strong>진행률</strong>
            <a href="javascript:void(0)" class="small text-decoration-none" onclick="refreshMissionProgress()">다시 불러오기</a>
          </div>
          <div class="d-flex justify-content-between mb-2">
            <span class="status-text mb-0" id="missionStatus">상태: -</span>
            <span id="progress-text-display" class="zt-muted">0 / 0</span>
          </div>
          <div class="progress zt-mission-progress" role="progressbar" aria-label="미션 진행률" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">
            <div id="progress-bar-element" class="progress-bar" style="width: 0%"></div>
          </div>
          <p id="progress-summary" class="text-secondary small mt-2 mb-0">진행 정보를 불러오는 중입니다.</p>
        </div>

        <button type="button" id="missionActionBtn" class="btn btn-primary zt-primary-btn w-100 py-3 fw-bold mb-3">
          <c:choose>
            <c:when test="${mission != null && mission.missionType == 'COMMENT'}">미션 하러가기 · 댓글 달기</c:when>
            <c:when test="${mission != null && mission.missionType == 'LIKE'}">미션 하러가기 · 좋아요 하기</c:when>
            <c:when test="${mission != null && mission.missionType == 'CHAT'}">미션 하러가기 · 채팅 보내기</c:when>
            <c:otherwise>미션 하러가기 · 게시글 쓰기</c:otherwise>
          </c:choose>
        </button>

        <a class="btn btn-outline-secondary w-100" href="${pageContext.request.contextPath}/mission">미션 목록으로</a>
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

  const missionType = "${mission != null ? mission.missionType : 'POST'}";

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
    if (!missionId) {
      const summary = document.getElementById("progress-summary");
      if (summary) summary.innerText = "미션 정보가 확인되지 않습니다.";
      return;
    }

    fetch(contextPath + '/api/mission/progress?missionId=' + missionId)
      .then(res => {
        if (!res.ok) throw new Error('Network response was not ok');
        return res.json();
      })
      .then(response => {
        if (!response || !response.success || !response.data) return;

        const data = response.data;
        const currentCount = data.currentCount || 0;
        const targetCount = data.targetCount || 0;
        const percent = data.percent || 0;

        const textDisplay = document.getElementById("progress-text-display");
        if (textDisplay) textDisplay.innerText = currentCount + " / " + targetCount;

        const bar = document.getElementById("progress-bar-element");
        if (bar) {
          bar.style.width = percent + "%";
          bar.setAttribute("aria-valuenow", percent);
        }

        const statusEl = document.getElementById("missionStatus");
        if (statusEl) statusEl.innerText = "상태: " + statusLabel(data.status, data.periodStatus);

        const summary = document.getElementById("progress-summary");
        if (summary) {
          if (!data.loggedIn) {
            summary.innerText = "로그인하면 미션을 진행할 수 있어요.";
          } else if (data.periodStatus === 'EXPIRED') {
            summary.innerText = "이 미션은 수행 기간이 끝났어요.";
          } else if (data.periodStatus === 'UPCOMING') {
            summary.innerText = "아직 시작 전인 미션이에요.";
          } else if (data.status === 'DONE') {
            summary.innerText = data.rewardReceived
                    ? "미션 완료! 포인트가 지급됐어요."
                    : "미션 완료!";
          } else {
            summary.innerText = "목표 " + targetCount + "회 중 " + currentCount + "회 진행 중이에요.";
          }
        }

        const actionBtn = document.getElementById("missionActionBtn");
        if (actionBtn) {
          const canAct = data.loggedIn && data.available && data.status !== 'DONE';
          actionBtn.style.display = canAct ? "block" : "none";
        }
      })
      .catch(err => {
        console.error("진행 상황 동기화 실패:", err);
        const summary = document.getElementById("progress-summary");
        if (summary) summary.innerText = "미션 정보를 불러오지 못했습니다.";
      });
  }

  document.addEventListener("DOMContentLoaded", function () {
    if (missionId) {
      refreshMissionProgress();
    } else {
      const summary = document.getElementById("progress-summary");
      if (summary) summary.innerText = "조회할 미션 정보가 없습니다.";
      const actionBtn = document.getElementById("missionActionBtn");
      if (actionBtn) actionBtn.style.display = "none";
    }

    const actionBtn = document.getElementById("missionActionBtn");
    if (actionBtn) {
      actionBtn.addEventListener("click", function (e) {
        e.preventDefault();
        if (missionType === 'CHAT') {
          window.location.href = contextPath + '/chat';
          return;
        }
        if (missionType === 'COMMENT' || missionType === 'LIKE') {
          window.location.href = contextPath + '/my-travel';
          return;
        }
        if (!missionId) {
          alert("미션 정보가 올바르지 않습니다.");
          return;
        }
        window.location.href = contextPath + '/new-post?missionId=' + missionId;
      });
    }
  });

  window.addEventListener("pageshow", function () {
    if (missionId) refreshMissionProgress();
  });
  document.addEventListener("visibilitychange", function () {
    if (document.visibilityState === "visible" && missionId) {
      refreshMissionProgress();
    }
  });
</script>
</body>
</html>
