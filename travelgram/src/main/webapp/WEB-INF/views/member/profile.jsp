<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="사용자 프로필 및 계정 정보 수정">
  <title>내 정보 | Travelgram</title>
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

  <div class="tg-layout tg-layout-two">
    
<jsp:include page="/WEB-INF/views/components/sidebar.jsp">
  <jsp:param name="activePage" value="profile" />
</jsp:include>

    <main class="tg-content">
      
<header class="tg-page-header">
  <h1>내 정보</h1>
  <p>프로필과 계정 정보를 확인하고 수정합니다.</p>
</header>

<section class="tg-panel tg-profile-card tg-panel-shadow">
  <div class="tg-profile-hero">
    <img class="tg-avatar tg-avatar-lg" src="${pageContext.request.contextPath}/assets/images/profile-ethan.svg" alt="내 프로필">
    <div class="flex-grow-1">
      <div class="d-flex flex-wrap gap-2 align-items-center">
        <h2 class="h5 mb-0">travel_ethan</h2>
        <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/new-post.jsp">새 게시물</a>
      </div>
      <p class="tg-muted small mb-0 mt-2">가성비 좋은 여행 동선을 기록합니다.</p>
      <div class="tg-profile-stats">
        <div><strong>18</strong><span>게시물</span></div>
        <div><strong>324</strong><span>팔로워</span></div>
        <div><strong>201</strong><span>팔로잉</span></div>
      </div>
    </div>
  </div>

  <form class="row g-3" data-demo-form data-message="프로필 수정 데모입니다.">
    <div class="col-12">
      <label for="profile-image" class="form-label">프로필 이미지</label>
      <input id="profile-image" class="form-control" type="file" accept="image/*">
    </div>
    <div class="col-md-6">
      <label for="nickname" class="form-label">닉네임</label>
      <input id="nickname" class="form-control" type="text" value="travel_ethan">
    </div>
    <div class="col-md-6">
      <label for="name" class="form-label">이름</label>
      <input id="name" class="form-control" type="text" value="Ethan">
    </div>
    <div class="col-12">
      <label for="email" class="form-label">이메일</label>
      <div class="input-group">
        <input id="email" class="form-control" type="email" value="user01@example.com">
        <button class="btn btn-outline-secondary" type="button">인증</button>
      </div>
    </div>
    <div class="col-12">
      <label for="bio" class="form-label">소개</label>
      <textarea id="bio" class="form-control" rows="4">가성비 좋은 여행 동선을 기록합니다.</textarea>
    </div>
    <div class="col-12 d-flex justify-content-center gap-3 mt-4">
      <button class="btn btn-outline-danger px-4" type="button">탈퇴하기</button>
      <button class="btn btn-primary tg-primary-btn px-4" type="submit">수정 완료</button>
    </div>
  </form>
</section>

    </main>
    
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

</body>
</html>
