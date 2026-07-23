<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="여행 미션 목록">
  <title>미션 | Travelgram</title>
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
  <h1>Mission Possible</h1>
  <p>재미있는 여행 미션에 도전하고 인증 기록을 남겨보세요.</p>
</header>

<section class="tg-panel tg-mission-list">
  <article class="tg-mission-card">
      <div class="tg-mission-icon"><i class="bi bi-wallet2"></i></div>
      <div>
        <div class="d-flex flex-wrap gap-2 align-items-center mb-1">
          <h2 class="h6 fw-bold mb-0">만원으로 서울 하루 여행</h2>
          <span class="tg-chip">서울</span>
        </div>
        <p class="tg-muted small mb-0">교통비를 포함해 10,000원 이하로 서울 하루 코스를 완주해보세요.</p>
      </div>
      <button class="btn btn-warning fw-bold" type="button" data-mission-accept data-mission="만원으로 서울 하루 여행" data-redirect="${pageContext.request.contextPath}/mission-active.jsp">미션 수락</button>
    </article>
<article class="tg-mission-card">
      <div class="tg-mission-icon"><i class="bi bi-basket"></i></div>
      <div>
        <div class="d-flex flex-wrap gap-2 align-items-center mb-1">
          <h2 class="h6 fw-bold mb-0">지역 시장 한 끼 도전</h2>
          <span class="tg-chip">전국</span>
        </div>
        <p class="tg-muted small mb-0">전통시장에서 8,000원 이하 한 끼를 찾아 인증하세요.</p>
      </div>
      <button class="btn btn-warning fw-bold" type="button" data-mission-accept data-mission="지역 시장 한 끼 도전" data-redirect="${pageContext.request.contextPath}/mission-active.jsp">미션 수락</button>
    </article>
<article class="tg-mission-card">
      <div class="tg-mission-icon"><i class="bi bi-bus-front"></i></div>
      <div>
        <div class="d-flex flex-wrap gap-2 align-items-center mb-1">
          <h2 class="h6 fw-bold mb-0">대중교통만 이용하기</h2>
          <span class="tg-chip">전국</span>
        </div>
        <p class="tg-muted small mb-0">자가용과 택시 없이 하루 여행 동선을 완성하세요.</p>
      </div>
      <button class="btn btn-warning fw-bold" type="button" data-mission-accept data-mission="대중교통만 이용하기" data-redirect="${pageContext.request.contextPath}/mission-active.jsp">미션 수락</button>
    </article>
<article class="tg-mission-card">
      <div class="tg-mission-icon"><i class="bi bi-camera"></i></div>
      <div>
        <div class="d-flex flex-wrap gap-2 align-items-center mb-1">
          <h2 class="h6 fw-bold mb-0">무료 명소 세 곳 방문</h2>
          <span class="tg-chip">전국</span>
        </div>
        <p class="tg-muted small mb-0">입장료가 없는 명소 세 곳을 방문하고 사진을 남기세요.</p>
      </div>
      <button class="btn btn-warning fw-bold" type="button" data-mission-accept data-mission="무료 명소 세 곳 방문" data-redirect="${pageContext.request.contextPath}/mission-active.jsp">미션 수락</button>
    </article>
<article class="tg-mission-card">
      <div class="tg-mission-icon"><i class="bi bi-recycle"></i></div>
      <div>
        <div class="d-flex flex-wrap gap-2 align-items-center mb-1">
          <h2 class="h6 fw-bold mb-0">플라스틱 없는 여행</h2>
          <span class="tg-chip">친환경</span>
        </div>
        <p class="tg-muted small mb-0">일회용 플라스틱 사용 없이 여행을 마쳐보세요.</p>
      </div>
      <button class="btn btn-warning fw-bold" type="button" data-mission-accept data-mission="플라스틱 없는 여행" data-redirect="${pageContext.request.contextPath}/mission-active.jsp">미션 수락</button>
    </article>
</section>

    </main>
    
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

</body>
</html>
