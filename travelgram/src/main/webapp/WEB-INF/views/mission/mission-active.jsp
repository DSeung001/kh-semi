<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="수락한 여행 미션 진행 페이지">
  <title>진행 중인 미션 | Travelgram</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
  
</head>
<body>
<div class="tg-app">
  
<header class="tg-mobile-header">
  <a class="tg-brand" href="${pageContext.request.contextPath}/index.jsp">
    <span class="tg-brand-mark"><i class="bi bi-camera"></i></span>
    <span>travelgram</span>
  </a>
  <a href="${pageContext.request.contextPath}/login.jsp" class="fs-5" aria-label="로그인"><i class="bi bi-box-arrow-in-right"></i></a>
</header>
<nav class="tg-mobile-nav" aria-label="모바일 메뉴">
  <a href="${pageContext.request.contextPath}/index.jsp" class="" aria-label="home"><i class="bi bi-house"></i></a>
<a href="${pageContext.request.contextPath}/travelgram.jsp" class="" aria-label="travelgram"><i class="bi bi-grid-3x3-gap"></i></a>
<a href="${pageContext.request.contextPath}/new-post.jsp" class="" aria-label="new"><i class="bi bi-plus-square"></i></a>
<a href="${pageContext.request.contextPath}/chat.jsp" class="" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
<a href="${pageContext.request.contextPath}/profile.jsp" class="" aria-label="profile"><i class="bi bi-person-circle"></i></a>
</nav>

  <div class="tg-layout tg-layout-two">
    
<jsp:include page="/components/sidebar.jsp">
  <jsp:param name="activePage" value="mission" />
</jsp:include>

    <main class="tg-content">
      
<header class="tg-page-header">
  <h1>진행 중인 미션</h1>
  <p data-active-mission-title>만원으로 서울 하루 여행</p>
</header>

<section class="tg-panel tg-profile-card">
  <div class="ratio ratio-21x9 rounded-3 overflow-hidden mb-4">
    <img src="${pageContext.request.contextPath}/assets/images/seoul.svg" class="object-fit-cover" alt="진행 중인 여행 미션">
  </div>

  <div class="mb-4">
    <div class="d-flex justify-content-between mb-2">
      <strong>전체 진행률</strong><span class="tg-muted">2 / 4</span>
    </div>
    <div class="progress tg-mission-progress" role="progressbar" aria-label="미션 진행률" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100">
      <div class="progress-bar" style="width: 50%"></div>
    </div>
  </div>

  <div class="list-group mb-4">
    <label class="list-group-item d-flex gap-3 py-3">
      <input class="form-check-input flex-shrink-0" type="checkbox" checked>
      <span><strong>대중교통으로 출발하기</strong><small class="d-block text-secondary">교통카드 내역 또는 이동 경로 인증</small></span>
    </label>
    <label class="list-group-item d-flex gap-3 py-3">
      <input class="form-check-input flex-shrink-0" type="checkbox" checked>
      <span><strong>무료 명소 방문하기</strong><small class="d-block text-secondary">무료 명소 사진 한 장 업로드</small></span>
    </label>
    <label class="list-group-item d-flex gap-3 py-3">
      <input class="form-check-input flex-shrink-0" type="checkbox">
      <span><strong>만원 이하 식사하기</strong><small class="d-block text-secondary">영수증 또는 메뉴판 인증</small></span>
    </label>
    <label class="list-group-item d-flex gap-3 py-3">
      <input class="form-check-input flex-shrink-0" type="checkbox">
      <span><strong>여행 후기 작성하기</strong><small class="d-block text-secondary">피드에 여행 동선과 경비를 공유</small></span>
    </label>
  </div>

  <a class="btn btn-primary tg-primary-btn w-100 py-2" href="${pageContext.request.contextPath}/new-post.jsp">인증 게시물 작성</a>
</section>

    </main>
    
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

</body>
</html>
