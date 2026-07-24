<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="짠맛투어 회원가입 페이지">
  <title>회원가입 | 짠맛투어</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
  
</head>
<body>
<div class="tg-app">
  
<header class="tg-mobile-header">
  <a class="tg-brand" href="${pageContext.request.contextPath}/home">
    <span>짠맛투어</span>
  </a>
  <a href="${pageContext.request.contextPath}/login" class="fs-5" aria-label="로그인"><i class="bi bi-box-arrow-in-right"></i></a>
</header>
<nav class="tg-mobile-nav" aria-label="모바일 메뉴">
  <a href="${pageContext.request.contextPath}/home" class="" aria-label="home"><i class="bi bi-house"></i></a>
<a href="${pageContext.request.contextPath}/my-travel" class="" aria-label="짠맛투어"><i class="bi bi-grid-3x3-gap"></i></a>
<a href="${pageContext.request.contextPath}/new-post" class="" aria-label="new"><i class="bi bi-plus-square"></i></a>
<a href="${pageContext.request.contextPath}/chat" class="" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
<a href="${pageContext.request.contextPath}/profile" class="active" aria-label="profile"><i class="bi bi-person-circle"></i></a>
</nav>

  <div class="tg-layout tg-layout-two">
    
<jsp:include page="/WEB-INF/views/components/sidebar.jsp">
  <jsp:param name="activePage" value="profile" />
</jsp:include>

    <main class="tg-content">
      
<div class="tg-auth-wrap">
  <section class="tg-panel tg-auth-card tg-panel-shadow">
    <h1 class="h3 text-center fw-bold mb-2">회원가입</h1>
    <p class="tg-muted text-center small mb-4">여행을 기록하고 새로운 여행자를 만나보세요.</p>

    <form class="row g-3" data-demo-form data-message="회원가입 데모입니다." data-redirect="${pageContext.request.contextPath}/login">
      <div class="col-12">
        <label class="form-label" for="signup-id">아이디</label>
        <div class="input-group">
          <input id="signup-id" class="form-control" type="text" required>
          <button class="btn btn-outline-secondary" type="button">중복 확인</button>
        </div>
      </div>
      <div class="col-12">
        <label class="form-label" for="signup-email">이메일</label>
        <div class="input-group">
          <input id="signup-email" class="form-control" type="email" required>
          <button class="btn btn-outline-secondary" type="button">인증</button>
        </div>
      </div>
      <div class="col-md-6">
        <label class="form-label" for="signup-password">비밀번호</label>
        <input id="signup-password" class="form-control" type="password" required>
      </div>
      <div class="col-md-6">
        <label class="form-label" for="signup-password2">비밀번호 확인</label>
        <input id="signup-password2" class="form-control" type="password" required>
      </div>
      <div class="col-12">
        <label class="form-label" for="signup-nickname">닉네임</label>
        <input id="signup-nickname" class="form-control" type="text" required>
      </div>
      <div class="col-12 form-check ms-2">
        <input id="terms" class="form-check-input" type="checkbox" required>
        <label for="terms" class="form-check-label small">이용약관과 개인정보처리방침에 동의합니다.</label>
      </div>
      <div class="col-12">
        <button class="btn btn-primary tg-primary-btn w-100 py-2" type="submit">가입하기</button>
      </div>
    </form>

    <p class="text-center small mt-4 mb-0">이미 계정이 있나요? <a class="text-primary fw-bold" href="${pageContext.request.contextPath}/login">로그인</a></p>
  </section>
</div>

    </main>
    
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

</body>
</html>
