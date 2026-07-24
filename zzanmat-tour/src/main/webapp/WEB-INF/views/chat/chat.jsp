<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="여행 커뮤니티 실시간 채팅">
  <title>실시간 톡 | 짠맛투어</title>
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
<a href="${pageContext.request.contextPath}/chat" class="active" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
<a href="${pageContext.request.contextPath}/profile" class="" aria-label="profile"><i class="bi bi-person-circle"></i></a>
</nav>

  <div class="zt-layout">
    
<jsp:include page="/WEB-INF/views/components/sidebar.jsp">
  <jsp:param name="activePage" value="chat" />
</jsp:include>

    <main class="zt-content">
      
<section class="zt-panel zt-chat-shell">
  <header class="zt-chat-header d-flex align-items-center justify-content-between">
    <div>
      <h1 class="h5 mb-1">Talk for Travel</h1>
      <p class="zt-muted zt-small mb-0">실시간으로 여행 정보와 동선을 나눠보세요.</p>
    </div>
    <span class="zt-chip"><i class="bi bi-circle-fill text-success"></i> 18명 접속</span>
  </header>

  <div class="zt-chat-list">
    <article class="zt-chat-item">
      <img class="zt-avatar" src="${pageContext.request.contextPath}/assets/images/profile-sora.svg" alt="travel_sora 프로필">
      <div>
        <div class="d-flex gap-2 align-items-center mb-1">
          <strong class="small">travel_sora</strong>
          <span class="zt-muted small">14:18</span>
        </div>
        <div class="zt-chat-bubble">
          오늘 성수동 카페거리 사람 많나요? 조용한 곳 추천 부탁드려요.
        </div>
      </div>
    </article>

    <article class="zt-chat-item">
      <img class="zt-avatar" src="${pageContext.request.contextPath}/assets/images/profile-min.svg" alt="budget_min 프로필">
      <div>
        <div class="d-flex gap-2 align-items-center mb-1">
          <strong class="small">budget_min</strong>
          <span class="zt-muted small">14:20</span>
        </div>
        <div class="zt-chat-bubble">
          서울숲 뒤쪽 골목은 비교적 한산했습니다. 2호선 쪽보다 수인분당선 쪽 출구가 좋아요.
        </div>
      </div>
    </article>

    <article class="zt-chat-item">
      <img class="zt-avatar" src="${pageContext.request.contextPath}/assets/images/profile-ethan.svg" alt="travel_ethan 프로필">
      <div>
        <div class="d-flex gap-2 align-items-center mb-1">
          <strong class="small">travel_ethan</strong>
          <span class="zt-muted small">14:23</span>
        </div>
        <div class="zt-chat-bubble">
          사진과 함께 동선을 정리해서 나만의 여행실에도 올려둘게요!
        </div>
      </div>
    </article>
  </div>

  <form class="zt-chat-compose" data-demo-form data-message="메시지 전송 데모입니다.">
    <div class="input-group">
      <label class="btn btn-light border" for="chat-image" aria-label="이미지 업로드"><i class="bi bi-image"></i></label>
      <input id="chat-image" type="file" class="d-none" accept="image/*">
      <input class="form-control bg-white" type="text" placeholder="메시지를 입력하세요" aria-label="메시지">
      <button class="btn btn-primary zt-primary-btn" type="submit">전송</button>
    </div>
  </form>
</section>

    </main>
    
<aside class="zt-right-rail">
  <section class="zt-login-card">
    <h2>로그인</h2>
    <p class="zt-right-note mb-3">여행 기록을 남기고 다른 여행자와 정보를 나눠보세요.</p>
    <form data-demo-form data-message="로그인 데모입니다." data-redirect="${pageContext.request.contextPath}/home">
      <input class="form-control form-control-sm mb-2" type="text" placeholder="아이디" aria-label="아이디">
      <input class="form-control form-control-sm mb-2" type="password" placeholder="비밀번호" aria-label="비밀번호">
      <button class="btn btn-primary zt-primary-btn btn-sm w-100" type="submit">로그인</button>
    </form>
    <div class="d-flex justify-content-between mt-3 zt-right-note">
      <a href="${pageContext.request.contextPath}/signup">회원가입</a>
      <a href="${pageContext.request.contextPath}/forgot-password">비밀번호 찾기</a>
    </div>
  </section>

  <section class="zt-suggestion-card">
    <h2>추천 여행자</h2>
    <div class="zt-user-row">
      <img class="zt-avatar zt-avatar-sm" src="${pageContext.request.contextPath}/assets/images/profile-sora.svg" alt="소라 프로필">
      <div class="zt-user-meta"><strong>travel_sora</strong><span>서울 골목 여행</span></div>
      <button class="zt-link-button" data-follow-button>팔로우</button>
    </div>
    <div class="zt-user-row">
      <img class="zt-avatar zt-avatar-sm" src="${pageContext.request.contextPath}/assets/images/profile-min.svg" alt="민 프로필">
      <div class="zt-user-meta"><strong>budget_min</strong><span>가성비 여행</span></div>
      <button class="zt-link-button" data-follow-button>팔로우</button>
    </div>
    <p class="zt-right-note mb-0">이 화면은 정적 프론트엔드 시안입니다. 로그인과 데이터 저장은 서버 연결 후 동작합니다.</p>
  </section>
</aside>

  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

</body>
</html>
