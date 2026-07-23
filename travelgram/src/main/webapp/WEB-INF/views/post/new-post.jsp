<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="여행 게시물 작성 페이지">
  <title>새 게시물 | Travelgram</title>
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
<a href="${pageContext.request.contextPath}/new-post.jsp" class="active" aria-label="new"><i class="bi bi-plus-square"></i></a>
<a href="${pageContext.request.contextPath}/chat.jsp" class="" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
<a href="${pageContext.request.contextPath}/profile.jsp" class="" aria-label="profile"><i class="bi bi-person-circle"></i></a>
</nav>

  <div class="tg-layout tg-layout-wide">
    
<jsp:include page="/components/sidebar.jsp">
  <jsp:param name="activePage" value="new-post" />
</jsp:include>

    <main class="tg-content">
      
<header class="tg-page-header">
  <h1>새 게시물 만들기</h1>
  <p>사진, 여행 동선, 경비와 태그를 입력합니다.</p>
</header>

<section class="tg-panel tg-profile-card">
  <form class="row g-4" data-demo-form data-message="게시물 작성 데모입니다." data-redirect="${pageContext.request.contextPath}/index.jsp">
    <div class="col-lg-6">
      <label class="tg-upload-zone p-3" for="new-post-image" data-upload-preview>
        <span>
          <i class="bi bi-images display-5 d-block mb-3"></i>
          <strong class="d-block mb-1">사진을 선택하세요</strong>
          <small class="tg-muted">JPG, PNG 파일을 업로드할 수 있습니다.</small>
        </span>
      </label>
      <input id="new-post-image" class="d-none" type="file" accept="image/*" data-upload-input required>
    </div>

    <div class="col-lg-6">
      <div class="mb-3">
        <label class="form-label" for="post-title">제목</label>
        <input id="post-title" class="form-control" type="text" maxlength="60" placeholder="여행 제목" required>
      </div>
      <div class="mb-3">
        <label class="form-label" for="post-place">여행 장소</label>
        <input id="post-place" class="form-control" type="text" placeholder="예: 서울 망원동">
      </div>
      <div class="mb-3">
        <label class="form-label" for="post-content">내용</label>
        <textarea id="post-content" class="form-control" rows="8" placeholder="동선, 비용, 팁을 적어주세요." required></textarea>
      </div>
      <div class="mb-3">
        <label class="form-label" for="post-tags">태그</label>
        <input id="post-tags" class="form-control" type="text" placeholder="#서울여행 #가성비여행">
      </div>
      <div class="form-check form-switch mb-4">
        <input id="share-route" class="form-check-input" type="checkbox" checked>
        <label class="form-check-label" for="share-route">여행 동선 공개</label>
      </div>
      <button class="btn btn-primary tg-primary-btn w-100 py-2" type="submit">작성 완료</button>
    </div>
  </form>
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
