<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="여행 게시물 사진 및 댓글 상세 페이지">
  <title>피드 상세 | Travelgram</title>
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
  <h1>피드 상세</h1>
  <p>게시물 사진과 댓글을 한 화면에서 확인합니다.</p>
</header>

<article class="tg-panel overflow-hidden">
  <header class="tg-post-header">
    <img class="tg-avatar" src="${pageContext.request.contextPath}/assets/images/profile-ethan.svg" alt="travel_ethan 프로필">
    <div class="tg-user-meta"><strong>travel_ethan</strong><span>서울 · 2시간 전</span></div>
    <button class="tg-icon-btn fs-5"><i class="bi bi-three-dots"></i></button>
  </header>

  <img class="tg-detail-image" src="${pageContext.request.contextPath}/assets/images/seoul.svg" alt="서울 여행 사진">

  <div class="tg-post-actions">
    <button class="tg-icon-btn" data-like-button data-like-target="#detail-likes"><i class="bi bi-heart"></i></button>
    <button class="tg-icon-btn"><i class="bi bi-chat"></i></button>
    <button class="tg-icon-btn"><i class="bi bi-send"></i></button>
    <button class="tg-icon-btn tg-save-btn"><i class="bi bi-bookmark"></i></button>
  </div>

  <div class="tg-post-body">
    <p id="detail-likes" data-count="128" class="fw-bold">좋아요 128개</p>
    <p><strong>travel_ethan</strong> 서울에서 교통비 포함 2만 원으로 하루 여행을 다녀왔습니다.
      <a class="tg-hashtag" href="${pageContext.request.contextPath}/tag.jsp">#서울여행 #가성비여행</a>
    </p>
  </div>

  <section id="comments" class="tg-comments-box border-top">
    <h2 class="h6 fw-bold">댓글</h2>
    <div data-comment-list>
      <div class="tg-comment-row">
        <img class="tg-avatar tg-avatar-sm" src="${pageContext.request.contextPath}/assets/images/profile-sora.svg" alt="">
        <p class="small mb-0"><strong>travel_sora</strong> 이동 동선이 정말 깔끔하네요. 다음 주에 따라가 볼게요!</p>
        <button class="tg-icon-btn fs-6"><i class="bi bi-heart"></i></button>
      </div>
      <div class="tg-comment-row">
        <img class="tg-avatar tg-avatar-sm" src="${pageContext.request.contextPath}/assets/images/profile-min.svg" alt="">
        <p class="small mb-0"><strong>budget_min</strong> 망원시장 메뉴도 추천해 주세요.</p>
        <button class="tg-icon-btn fs-6"><i class="bi bi-heart"></i></button>
      </div>
    </div>
  </section>

  <form class="tg-comment-form" data-comment-form>
    <i class="bi bi-emoji-smile"></i>
    <input type="text" placeholder="댓글 입력" aria-label="댓글 입력">
    <button class="tg-link-button" type="submit">게시</button>
  </form>
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
