<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <h1>회원가입</h1>
        <p>프로필을 설정하고 짠맛투어의 여행 기록을 시작해 보세요.</p>
      </header>
      <section class="zt-panel zt-auth-card zt-panel-shadow zt-signup-card">
        <form id="signupBtn" class="row g-3" method="post" action="${pageContext.request.contextPath}/member/signup" enctype="multipart/form-data">
          <div class="col-12">
            <fieldset class="zt-signup-profile">
              <legend class="form-label mb-3">프로필 설정 <span class="zt-optional">선택</span></legend>
              <div class="zt-signup-profile-content">
                <label id="label_profile-preview" class="zt-profile-upload" for="signup-profile-image">
                  <img id="profile-preview" class="profile-preview" alt="프로필 미리보기" style="display:none;">
                  <%--<span class="zt-profile-upload-icon">
                    <i class="bi bi-person"></i>
                  </span>--%>
                  <%--<span id="profile-preview-placeholder" class="zt-profile-upload-text">사진 추가</span>--%>
                </label>
                <div class="flex-grow-1">
                  <input id="signup-profile-image" name="profileImage" class="form-control" type="file" accept="image/*">
                  <p class="form-text mb-0">JPG, PNG 등 이미지 파일을 선택할 수 있습니다.</p>
                </div>
              </div>
            </fieldset>
          </div>
          <div class="col-12">
            <label class="form-label" for="signup-id">아이디</label>
            <div class="input-group">
              <input id="signup-id" name="userId" class="form-control" type="text" required>
              <button id="checkUsernameDuplicateBtn" class="btn btn-outline-secondary" type="button">중복 확인</button>
            </div>
            <p id="signupIdMessage" class="signup-message" role="alert"></p>
          </div>
          <div class="col-12">
            <label class="form-label" for="signup-email">이메일</label>
            <div class="input-group">
              <input id="signup-email" name="email" class="form-control" type="email" required>
              <button id="sendCodeBtn" class="btn btn-outline-secondary" type="button">인증</button>
            </div>
            <p id="signupEmailMessage" class="signup-message" role="alert"></p>
          </div>
          <div class="col-12">
            <%--<label class="form-label" for="signup-email"></label>--%>
            <div class="input-group auth-email auth-email-area">
              <input id="email-auth-section" name="email" class="form-control" type="number" maxlength="6">
              <button id="authConfirmBtn" class="btn btn-outline-secondary" type="button">인증 확인</button>
            </div>
            <p id="signupEmailMessage" class="signup-message" role="alert"></p>
          </div>
          <div class="col-md-6">
            <label class="form-label" for="signup-password">비밀번호</label>
            <input id="signup-password" name="userPassword" class="form-control" type="password" required>
            <p id="passwordValidationMessage" class="form-message" role="alert"></p>
          </div>
          <div class="col-md-7">
            <label class="form-label" for="signup-password2">비밀번호 확인</label>
            <input id="signup-password2" class="form-control" type="password" required>
            <p id="passwordConfirmMessage" class="form-message" role="alert"></p>
          </div>
          <div class="col-12">
            <label class="form-label" for="signup-nickname">닉네임</label>
            <input id="signup-nickname" name="nickname" class="form-control" type="text" required>
          </div>
          <div class="col-md-6">
            <label class="form-label" for="signup-name">이름</label>
            <input id="signup-name" name="userName" class="form-control" type="text" autocomplete="name">
          </div>
          <div class="col-md-6">
            <label class="form-label" for="signup-bio">소개</label>
            <textarea id="signup-bio" name="bio" class="form-control" rows="3" maxlength="150" placeholder="나를 소개하는 짧은 글을 작성해 주세요."></textarea>
          </div>
          <div class="col-12 form-check ms-2">
            <input id="terms" class="form-check-input" type="checkbox" required>
            <label for="terms" class="form-check-label small">이용약관과 개인정보처리방침에 동의합니다.</label>
          </div>
          <div class="col-12">
            <button class="btn btn-primary zt-primary-btn w-100 py-2" type="submit">가입하기</button>
          </div>
        </form>
        <p class="text-center small mt-4 mb-0">이미 계정이 있나요? <a class="text-primary fw-bold" href="${pageContext.request.contextPath}/member/login">로그인</a></p>
      </section>
    </main>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/member.js"></script>
</body>
</html>