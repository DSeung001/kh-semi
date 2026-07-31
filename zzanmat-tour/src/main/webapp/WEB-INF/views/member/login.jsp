<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="짠맛투어 로그인 페이지">
  <title>로그인 | 짠맛투어</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/member.css">

</head>
<body>

<c:if test="${not empty joinSuccess}">
  <script>
    alert("회원가입이 완료되었습니다. 로그인 해주세요.");
  </script>
</c:if>

<c:if test="${not empty error}">
  <script>
    alert("${error}");
  </script>
</c:if>

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
<a href="${pageContext.request.contextPath}/chat" class="" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
<a href="${pageContext.request.contextPath}/profile" class="active" aria-label="profile"><i class="bi bi-person-circle"></i></a>
</nav>

  <div class="zt-layout">
    
<jsp:include page="/WEB-INF/views/components/sidebar.jsp">
  <jsp:param name="activePage" value="profile" />
</jsp:include>

    <main class="zt-content">
      
<div class="zt-auth-wrap">
  <section class="zt-panel zt-auth-card zt-panel-shadow zt-signup-card">
    <h1 class="zt-auth-title">login</h1>
    <form id="loginForm" method="post" action="/member/login">
      <div class="form-floating mb-3">
        <input id="login-id" name="userId" class="form-control" type="text" placeholder="아이디" required>
        <label for="login-id">아이디</label>
      </div>
      <div class="form-floating mb-3">
        <input id="login-password" name="userPassword" class="form-control" type="password" placeholder="비밀번호" required>
        <label for="login-password">비밀번호</label>
      </div>

      <div class="d-flex flex-wrap gap-3 mb-3">
        <div class="form-check">
          <input id="save-check" class="form-check-input" type="checkbox">
          <label class="form-check-label small" for="save-id">아이디 저장</label>
        </div>
        <div class="form-check">
          <input id="remember-me" name="rememberMe" class="form-check-input" type="checkbox">
          <label class="form-check-label small" for="auto-login">자동 로그인</label>
        </div>
      </div>

      <button class="btn btn-primary zt-primary-btn w-100 py-2" type="submit">로그인</button>
    </form>

    <div class="d-flex justify-content-center flex-wrap gap-2 my-3 small">
      <a href="${pageContext.request.contextPath}/member/forgot-password">아이디 찾기</a>
      <span class="zt-muted">/</span>
      <a href="${pageContext.request.contextPath}/member/forgot-password">비밀번호 찾기</a>
      <span class="zt-muted">/</span>
      <a href="${pageContext.request.contextPath}/member/signup">회원가입</a>
    </div>

    <div class="zt-divider">또는</div>

    <a href="/oauth2/authorization/kakao" class="btn zt-social-kakao w-100 py-2 mb-3 text-decoration-none">
      <i class="bi bi-chat-fill me-2"></i>카카오로 시작하기
    </a>
    <button class="btn zt-social-naver w-100 py-2" type="button">
      <strong class="me-2">N</strong>네이버로 시작하기
    </button>
  </section>
</div>

    </main>
    
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/member.js"></script>

</body>
</html>
