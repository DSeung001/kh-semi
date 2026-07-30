<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="수락한 여행 미션 진행 페이지">
  <title>Mission Possible | 짠맛투어</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
</head>

<meta charset="UTF-8">
<title>짬맛투어 - Mission Possible</title>
<style>
  .progress-container { width: 100%; background-color: #e0e0e0; border-radius: 5px; margin: 10px 0; height: 12px; overflow: hidden; }
  .progress-bar { height: 100%; background-color: #4CAF50; transition: width 0.4s ease; }
  .mission-card { border: 1px solid #ddd; padding: 15px; border-radius: 8px; margin-bottom: 10px; background: #fff; }
  .completed-card { background-color: #f9f9f9; border-color: #c3e6cb; }
</style>
</head>
<body>

<div class="main-content">
  <h2>Mission Possible</h2>

  <!-- 실시간 전체 진행률 텍스트 표시 -->
  <div>
    <span>전체 진행률</span>
    <span><strong>${completedCount}</strong> / ${totalCount}</span>
  </div>

  <!-- 실시간 프로그레스 바 너비 적용 -->
  <div class="progress-container">
    <div class="progress-bar" style="width: ${progressPercent}%;"></div>
  </div>

  <hr>

  <h3>진행 중인 미션</h3>

  <!-- DB에서 가져온 미션 리스트를 동적으로 출력 -->
  <c:forEach var="item" items="${missionList}">
    <div class="mission-card ${item.completed ? 'completed-card' : ''}">
      <label>
        <!-- 미션 완료 여부에 따른 자동 체크박스 연동 -->
        <input type="checkbox" disabled="disabled" ${item.completed ? 'checked' : ''} />
        <strong>${item.title}</strong>
      </label>
      <p>${item.description}</p>
      <p style="font-size: 12px; color: #666;">보상 포인트: ${item.rewardPoint}P</p>

      <!-- 미완료 상태일 때만 완료 버튼 노출 -->
      <c:if test="${!item.completed}">
        <form action="${pageContext.request.contextPath}/mission/complete" method="post">
          <input type="hidden" name="missionId" value="${item.missionId}" />
          <button type="submit">미션 완료하기</button>
        </form>
      </c:if>

      <!-- 완료 상태일 때 텍스트 표시 -->
      <c:if test="${item.completed}">
        <span style="color: green; font-weight: bold;">[미션 완료됨]</span>
      </c:if>
    </div>
  </c:forEach>

</div>

<body>
<div class="zt-app">

  <header class="zt-mobile-header">
    <a class="zt-brand" href="${pageContext.request.contextPath}/home">
      <span>짠맛투어</span>
    </a>
    <a href="${pageContext.request.contextPath}/login" class="fs-5" aria-label="로그인"><i class="bi bi-box-arrow-in-right"></i></a>
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

      <header class="zt-page-header mb-4">
        <h1 class="fw-bold">진행 중인 미션</h1>
      </header>

      <!-- 메인 패널 박스 -->
      <section class="zt-panel p-4 bg-white shadow-sm rounded-4 border">

        <!-- 상단 대표 이미지 영역 -->
        <div class="ratio ratio-21x9 rounded-3 overflow-hidden mb-4 bg-light">
          <img src="${pageContext.request.contextPath}/assets/images/seoul.svg" class="object-fit-cover" alt="진행 중인 여행 미션">
        </div>

        <!-- 전체 진행률 및 카운트 표시 영역 -->
        <div class="mb-4">
          <div class="d-flex justify-content-between align-items-center mb-2">
            <strong class="text-dark">전체 진행률</strong>
            <!-- 실시간 텍스트 (예: 3 / 10) -->
            <span class="text-muted fw-bold" id="progressText">
                            ${not empty completedCount ? completedCount : 2} / ${not empty totalCount ? totalCount : 4}
                        </span>
          </div>

          <!-- 실시간 프로그레스바 -->
          <c:set var="progress" value="${not empty progressPercent ? progressPercent : 50.0}" />
          <div class="progress" style="height: 10px; background-color: #e9ecef;" role="progressbar" aria-valuenow="${progress}" aria-valuemin="0" aria-valuemax="100">
            <div class="progress-bar bg-primary" id="missionProgressBar" style="width: ${progress}%; transition: width 0.4s ease;"></div>
          </div>
        </div>

        <div class="mission-container">
          <h2>진행 중인 미션</h2>

          <!-- 전체 진행률 동적 출력 (예: 1 / 4) -->
          <div class="progress-header">
            <span>전체 진행률</span>
            <span>${completedCount} / ${totalCount}</span>
          </div>

          <!-- 프로그레스바 게이지 너비 동적 반영 (백분율 연동) -->
          <div class="progress-bar-background">
            <div class="progress-bar-gauge" style="width: ${progressPercent}%;"></div>
          </div>

          <!-- 미션 목록 반복문 -->
          <c:forEach var="mission" items="${userMissions}">
            <div class="mission-card">
              <!-- 미션 상태가 DONE이면 자동으로 체크박스에 체크(checked) 렌더링 -->
              <input type="checkbox"
                     <c:if test="${mission.status == 'DONE'}">checked</c:if>
                     disabled />

              <label>${mission.title}</label>
              <p>${mission.description}</p>

              <!-- 미션이 완료되지 않았다면 완료 인증 버튼 표시 -->
              <c:if test="${mission.status != 'DONE'}">
                <form action="/api/missions/complete/${mission.missionId}" method="post">
                  <button type="submit">미션 완료하기</button>
                </form>
              </c:if>
            </div>
          </c:forEach>
        </div>

        <!-- 미션 체크리스트 그룹 -->
        <div class="list-group mb-4 border-0" id="missionChecklistGroup">

          <label class="list-group-item d-flex gap-3 py-3 align-items-center border rounded-3 mb-2 shadow-sm">
            <input class="form-check-input flex-shrink-0 mission-checkbox fs-5" type="checkbox" data-mission-id="1" checked>
            <span>
                            <strong class="d-block text-dark">대중교통으로 출발하기</strong>
                            <small class="text-secondary">교통카드 내역 또는 이동 경로 인증</small>
                        </span>
          </label>

          <!-- 예시 2 -->
          <label class="list-group-item d-flex gap-3 py-3 align-items-center border rounded-3 mb-2 shadow-sm">
            <input class="form-check-input flex-shrink-0 mission-checkbox fs-5" type="checkbox" data-mission-id="2" checked>
            <span>
                            <strong class="d-block text-dark">무료 명소 방문하기</strong>
                            <small class="text-secondary">무료 명소 사진 한 장 업로드</small>
                        </span>
          </label>

          <!-- 예시 3 -->
          <label class="list-group-item d-flex gap-3 py-3 align-items-center border rounded-3 mb-2 shadow-sm">
            <input class="form-check-input flex-shrink-0 mission-checkbox fs-5" type="checkbox" data-mission-id="3">
            <span>
                            <strong class="d-block text-dark">만원 이하 식사하기</strong>
                            <small class="text-secondary">영수증 또는 메뉴판 인증</small>
                        </span>
          </label>

          <!-- 예시 4 -->
          <label class="list-group-item d-flex gap-3 py-3 align-items-center border rounded-3 mb-4 shadow-sm">
            <input class="form-check-input flex-shrink-0 mission-checkbox fs-5" type="checkbox" data-mission-id="4">
            <span>
                            <strong class="d-block text-dark">여행 후기 작성하기</strong>
                            <small class="text-secondary">피드에 여행 동선과 경비를 공유</small>
                        </span>
          </label>

        </div>

        <!-- 인증 게시물 작성 버튼 -->
        <a class="btn btn-primary zt-primary-btn w-100 py-3 fw-bold rounded-3 shadow-sm" href="${pageContext.request.contextPath}/new-post">
          인증 게시물 작성
        </a>

      </section>

    </main>

  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

<!-- 새로고침 없는 실시간 진행률 연동 스크립트 -->
<script>
  document.addEventListener("DOMContentLoaded", function () {
    const contextPath = "${pageContext.request.contextPath}";

    // 체크박스를 클릭(체크/해제)할 때 비동기 통신 수행
    document.addEventListener("change", async function (e) {
      if (e.target && e.target.classList.contains("mission-checkbox")) {
        const checkbox = e.target;
        const missionId = checkbox.getAttribute("data-mission-id");

        try {
          // 백엔드의 미션 상태 변경 API 호출 (포인트 적립 및 완료 상태 업데이트)
          const response = await fetch(`\${contextPath}/api/mission/complete/\${missionId}`, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            }
          });

          if (!response.ok) {
            throw new Error("미션 상태 업데이트에 실패했습니다.");
          }

          // 백엔드가 반환한 UserMissionResponseDto 데이터 수신
          const data = await response.json();
          // 예상 반환 데이터 구조: { completedCount: 3, totalCount: 4, progressPercent: 75.0, ... }

          // 1. 프로그레스바 너비 실시간 애니메이션 반영
          const progressBar = document.getElementById("missionProgressBar");
          if (progressBar) {
            progressBar.style.width = `\${data.progressPercent}%`;
            progressBar.setAttribute("aria-valuenow", data.progressPercent);
          }

          // 2. 상단 텍스트 카운트 실시간 반영 (예: "3 / 4")
          const progressText = document.getElementById("progressText");
          if (progressText) {
            progressText.innerText = `\${data.completedCount} / \${data.totalCount}`;
          }

        } catch (error) {
          console.error("에러 발생:", error);
          alert("처리 중 오류가 발생했습니다.");
          // 실패 시 체크박스 상태 원복
          checkbox.checked = !checkbox.checked;
        }
      }
    });
  });
</script>

</body>
</html>
