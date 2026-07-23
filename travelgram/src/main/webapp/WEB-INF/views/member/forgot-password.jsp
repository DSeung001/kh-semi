<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="아이디 및 비밀번호 찾기">
  <title>계정 찾기 | Travelgram</title>
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
<a href="${pageContext.request.contextPath}/profile.jsp" class="active" aria-label="profile"><i class="bi bi-person-circle"></i></a>
</nav>

  <div class="tg-layout tg-layout-wide">
    
<jsp:include page="/components/sidebar.jsp">
  <jsp:param name="activePage" value="profile" />
</jsp:include>

    <main class="tg-content">
      
<header class="tg-page-header">
  <h1>계정 찾기</h1>
  <p>가입한 이메일로 본인 인증을 진행합니다.</p>
</header>

<section class="tg-panel tg-profile-card tg-panel-shadow">
  <ul class="nav nav-tabs mb-4" role="tablist">
    <li class="nav-item" role="presentation">
      <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#find-password" type="button">비밀번호 찾기</button>
    </li>
    <li class="nav-item" role="presentation">
      <button class="nav-link" data-bs-toggle="tab" data-bs-target="#find-id" type="button">아이디 찾기</button>
    </li>
  </ul>

  <div class="tab-content">
    <div id="find-password" class="tab-pane fade show active">
      <form class="row g-3" data-demo-form data-message="인증 메일 발송 데모입니다.">
        <div class="col-md-3">
          <label for="find-email" class="col-form-label">이메일</label>
        </div>
        <div class="col-md-7">
          <input id="find-email" class="form-control" type="email" placeholder="user01@example.com" required>
        </div>
        <div class="col-md-2">
          <button class="btn btn-outline-secondary w-100" type="submit">인증</button>
        </div>
      </form>
    </div>

    <div id="find-id" class="tab-pane fade">
      <form class="row g-3" data-demo-form data-message="아이디 찾기 인증 데모입니다.">
        <div class="col-md-3">
          <label for="find-name" class="col-form-label">이름</label>
        </div>
        <div class="col-md-9">
          <input id="find-name" class="form-control" type="text" required>
        </div>
        <div class="col-md-3">
          <label for="find-id-email" class="col-form-label">이메일</label>
        </div>
        <div class="col-md-7">
          <input id="find-id-email" class="form-control" type="email" required>
        </div>
        <div class="col-md-2">
          <button class="btn btn-outline-secondary w-100" type="submit">인증</button>
        </div>
      </form>
    </div>
  </div>
</section>

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
