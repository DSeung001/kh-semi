<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="아이디 및 비밀번호 찾기">
  <title>계정 찾기 | 짠맛투어</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/member.css">

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
    <a href="${pageContext.request.contextPath}/chat" class="" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
    <a href="${pageContext.request.contextPath}/profile" class="active" aria-label="profile"><i class="bi bi-person-circle"></i></a>
  </nav>
  <div class="zt-layout">
    <jsp:include page="/WEB-INF/views/components/sidebar.jsp">
      <jsp:param name="activePage" value="profile" />
    </jsp:include>
    <main class="zt-content">

      <header class="zt-page-header">
        <h1>계정 찾기</h1>
        <p>가입한 이메일로 본인 인증을 진행합니다.</p>
      </header>
      <section class="zt-panel zt-profile-card zt-panel-shadow">
        <ul class="nav nav-tabs mb-4" role="tablist">
          <li class="nav-item" role="presentation">
            <button class="nav-link ${param.tab eq 'password' ? '' : 'active'}"
                    data-bs-toggle="tab" data-bs-target="#find-id" type="button">아이디 찾기</button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link ${param.tab eq 'password' ? 'active' : ''}"
                    data-bs-toggle="tab" data-bs-target="#find-password" type="button">비밀번호 찾기</button>
          </li>
        </ul>
        <div class="tab-content">
          <div id="find-password" class="tab-pane fade ${param.tab eq 'password' ? 'show active' : ''}">
            <form id="forgot-password" class="row g-3" novalidate>
              <div class="col-12" data-email-verification data-send-url="/email/password-send" data-account-purpose="password">
                <label for="find-password-id" class="form-label">아이디</label>
                <input id="find-password-id" class="form-control mb-3" type="text" placeholder="가입한 아이디를 입력하세요" data-user-id required>
                <label for="find-password-email" class="form-label">가입 이메일</label>
                <div class="input-group">
                  <input id="find-password-email" class="form-control" type="email" placeholder="user01@example.com" data-email-input required>
                  <button class="btn btn-outline-secondary" type="button" data-send-code>인증</button>
                </div>
                <div class="input-group account-auth-area mt-2" data-auth-area>
                  <input class="form-control" type="text" inputmode="numeric" maxlength="6" pattern="[0-9]{6}" placeholder="인증번호 6자리 입력" data-auth-code disabled>
                  <span class="input-group-text email-auth-timer" data-auth-timer aria-live="polite">03:00</span>
                  <button class="btn btn-outline-secondary" type="button" data-verify-code disabled>인증 확인</button>
                </div>
                <p class="form-message mt-2 mb-0" data-auth-message role="alert"></p>
              </div>
              <div class="col-12">
                <label class="form-label" for="signup-password">새 비밀번호</label>
                <input id="signup-password" name="userPassword" class="form-control" type="password" required disabled data-password-field>
                <p id="passwordValidationMessage" class="form-message" role="alert"></p>
              </div>
              <div class="col-12">
                <label class="form-label" for="signup-password2">새 비밀번호 확인</label>
                <input id="signup-password2" class="form-control" type="password" required disabled data-password-field>
                <p id="passwordConfirmMessage" class="form-message" role="alert"></p>
              </div>
              <div class="col-12">
                <button id="resetPasswordBtn" class="btn btn-primary zt-primary-btn" type="button" disabled data-password-field>비밀번호 변경</button>
                <p id="resetPasswordMessage" class="form-message mt-2 mb-0" role="alert"></p>
              </div>
            </form>
          </div>
          <div id="find-id" class="tab-pane fade ${param.tab eq 'password' ? '' : 'show active'}">
            <form id="forgot-id" class="row g-3" novalidate>
              <div class="col-12" data-email-verification data-send-url="/email/find-id-send" data-account-purpose="id">
                <label for="find-id-email" class="form-label">가입 이메일</label>
                <div class="input-group">
                  <input id="find-id-email" class="form-control" type="email" placeholder="user01@example.com" data-email-input required>
                  <button class="btn btn-outline-secondary" type="button" data-send-code>인증</button>
                </div>
                <div class="input-group account-auth-area mt-2" data-auth-area>
                  <input class="form-control" type="text" inputmode="numeric" maxlength="6" pattern="[0-9]{6}" placeholder="인증번호 6자리 입력" data-auth-code disabled>
                  <span class="input-group-text email-auth-timer" data-auth-timer aria-live="polite">03:00</span>
                  <button class="btn btn-outline-secondary" type="button" data-verify-code disabled>인증 확인</button>
                </div>
                <p class="form-message mt-2 mb-0" data-auth-message role="alert"></p>
              </div>
            </form>
          </div>
        </div>
      </section>
    </main>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/member.js"></script>
</body>
</html>
