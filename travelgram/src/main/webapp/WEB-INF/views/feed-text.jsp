<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="텍스트 중심 여행 피드 상세 페이지">
  <title>여행 기록 상세 | Travelgram</title>
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
  <a href="${pageContext.request.contextPath}/index.jsp" class="active" aria-label="home"><i class="bi bi-house"></i></a>
<a href="${pageContext.request.contextPath}/travelgram.jsp" class="" aria-label="travelgram"><i class="bi bi-grid-3x3-gap"></i></a>
<a href="${pageContext.request.contextPath}/new-post.jsp" class="" aria-label="new"><i class="bi bi-plus-square"></i></a>
<a href="${pageContext.request.contextPath}/chat.jsp" class="" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
<a href="${pageContext.request.contextPath}/profile.jsp" class="" aria-label="profile"><i class="bi bi-person-circle"></i></a>
</nav>

  <div class="tg-layout">
    
<jsp:include page="/components/sidebar.jsp">
  <jsp:param name="activePage" value="home" />
</jsp:include>

    <main class="tg-content">
      
<header class="tg-page-header">
  <h1>여행 기록 상세</h1>
  <p>사진 없이 동선과 경비를 자세히 공유하는 게시물입니다.</p>
</header>

<article class="tg-panel tg-text-detail">
  <header class="d-flex align-items-center gap-3 mb-4">
    <img class="tg-avatar" src="${pageContext.request.contextPath}/assets/images/profile-ethan.svg" alt="travel_ethan 프로필">
    <div class="tg-user-meta">
      <strong>travel_ethan</strong>
      <span>2026년 7월 20일 · 서울</span>
    </div>
    <button class="tg-icon-btn fs-5 ms-auto"><i class="bi bi-three-dots"></i></button>
  </header>

  <div class="d-flex justify-content-between gap-3 mb-3">
    <h2 class="h4 fw-bold mb-0">서울 2만 원 하루 여행 코스</h2>
    <span class="tg-muted small">created_at</span>
  </div>

  <div class="tg-article-content">#서울여행 #가성비여행

오전 10시 홍대입구역에서 출발했습니다.

1. 경의선숲길 산책
2. 망원시장 점심
3. 한강공원 이동
4. 무료 전시 관람
5. 버스를 이용해 귀가

총경비
교통비 3,000원
점심 8,000원
간식 4,500원
기타 2,000원

총 17,500원을 사용했습니다. 이동 시간이 길지 않아 초보 혼행러도 따라가기 쉬운 코스였습니다.</div>

  <div class="tg-post-actions px-0 mt-2">
    <button class="tg-icon-btn" data-like-button><i class="bi bi-heart"></i></button>
    <a class="tg-icon-btn" href="${pageContext.request.contextPath}/post-detail.jsp#comments"><i class="bi bi-chat"></i></a>
    <button class="tg-icon-btn"><i class="bi bi-send"></i></button>
    <button class="tg-icon-btn tg-save-btn"><i class="bi bi-bookmark"></i></button>
  </div>
  <p class="fw-bold mb-1">좋아요 94개</p>
  <a class="tg-muted small" href="${pageContext.request.contextPath}/post-detail.jsp#comments">댓글 12개 보기</a>
</article>

    </main>
    
<aside class="tg-right-rail">
  <section class="tg-login-card">
    <h2>로그인</h2>
    <p class="tg-right-note mb-3">여행 기록을 남기고 다른 여행자와 정보를 나눠보세요.</p>
    <form data-demo-form data-message="로그인 데모입니다." data-redirect="${pageContext.request.contextPath}/index.jsp">
      <input class="form-control form-control-sm mb-2" type="text" placeholder="아이디" aria-label="아이디">
      <input class="form-control form-control-sm mb-2" type="password" placeholder="비밀번호" aria-label="비밀번호">
      <button class="btn btn-primary tg-primary-btn btn-sm w-100" type="submit">로그인</button>
    </form>
    <div class="d-flex justify-content-between mt-3 tg-right-note">
      <a href="${pageContext.request.contextPath}/signup.jsp">회원가입</a>
      <a href="${pageContext.request.contextPath}/forgot-password.jsp">비밀번호 찾기</a>
    </div>
  </section>

  <section class="tg-suggestion-card">
    <h2>추천 여행자</h2>
    <div class="tg-user-row">
      <img class="tg-avatar tg-avatar-sm" src="${pageContext.request.contextPath}/assets/images/profile-sora.svg" alt="소라 프로필">
      <div class="tg-user-meta"><strong>travel_sora</strong><span>서울 골목 여행</span></div>
      <button class="tg-link-button" data-follow-button>팔로우</button>
    </div>
    <div class="tg-user-row">
      <img class="tg-avatar tg-avatar-sm" src="${pageContext.request.contextPath}/assets/images/profile-min.svg" alt="민 프로필">
      <div class="tg-user-meta"><strong>budget_min</strong><span>가성비 여행</span></div>
      <button class="tg-link-button" data-follow-button>팔로우</button>
    </div>
    <p class="tg-right-note mb-0">이 화면은 정적 프론트엔드 시안입니다. 로그인과 데이터 저장은 서버 연결 후 동작합니다.</p>
  </section>
</aside>

  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

</body>
</html>
