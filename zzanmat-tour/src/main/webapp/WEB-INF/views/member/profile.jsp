<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="사용자 프로필 및 계정 정보 수정">
  <title>내 정보 | 짠맛투어</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/member.css">
  
</head>
<body>

<c:if test="${not empty message}">
  <script>
    // 서버에서 넘어온 메시지를 JS 변수에 담음
    const msg = "${message}";

    // 브라우저 sessionStorage에 저장된 값과 비교하거나,
    // 페이지가 새로고침/재조회될 때 중복 실행을 막기 위해 플래그 활용
    if (msg) {
      alert(msg);
      // 알림을 띄운 뒤 히스토리를 갱신하거나
      history.replaceState;
      //history.replaceState를 써서 새로고침 시 데이터 재요청 방지
    }
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

<header class="zt-page-header">
  <h1>내 정보</h1>
  <p>프로필과 계정 정보를 확인하고 수정합니다.</p>
</header>

<section class="zt-panel zt-profile-card zt-panel-shadow">
  <div class="zt-profile-hero">
    <c:choose>
      <c:when test="${not empty userInfo.profile}">
        <img id="my-profile"
              src="${pageContext.request.contextPath}${userInfo.profile}"
              alt="프로필 이미지"
              class="my-profile">
      </c:when>

      <c:otherwise>
        <img id="my-profile"
              src="${pageContext.request.contextPath}/assets/images/no-image.jpg"
              alt="기본 프로필 이미지"
              class="my-profile">
      </c:otherwise>
    </c:choose>
    <div class="flex-grow-1">
      <div class="d-flex flex-wrap gap-2 align-items-center">
        <h2 class="h5 mb-0">${userInfo.userId}</h2>
        <%--<a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/new-post">새 게시물</a>--%>
      </div>
      <p class="zt-muted small mb-0 mt-2">가성비 좋은 여행 동선을 기록합니다.</p>
      <div class="zt-profile-stats">
        <div><strong>18</strong><span>게시물</span></div>
        <div><strong>324</strong><span>팔로워</span></div>
        <div><strong>201</strong><span>팔로잉</span></div>
      </div>
    </div>
    <div class="logoutArea">
      <a href="${pageContext.request.contextPath}/member/logout">
        <img class="logout" src="${pageContext.request.contextPath}/assets/images/logout.png" alt="로그아웃">
        <span>logout</span>
      </a>
    </div>
  </div>

  <form action="/member/update" method="post" id="profileForm" class="row g-3" enctype="multipart/form-data">
    <div class="col-12">
      <label for="profile-image_update" class="form-label">수정할 프로필 이미지</label>
      <input type="hidden" name="originProfileName" value="${userInfo.profile}">
      <input id="profile-image-inputUpdate" name="profileImage" class="form-control" type="file" accept="image/*">
    </div>
    <div class="col-md-6">
      <label for="nickname" class="form-label">닉네임</label>
      <input id="nickname" name="nickname" class="form-control" type="text" value="${userInfo.nickname}">
    </div>
    <div class="col-md-6">
      <label for="name" class="form-label">이름</label>
      <input type="hidden" name="userId" value="${userInfo.userId}">
      <input id="name" name="userName" class="form-control" type="text" value="${userInfo.userName}">
    </div>
    <div class="col-12">
      <label for="email" class="form-label">이메일</label>
      <div class="input-group">
        <input id="email" name="email" class="form-control" type="email" value="${userInfo.email}">
        <button class="btn btn-outline-secondary" type="button">인증</button>
      </div>
    </div>
    <div class="col-12">
      <label for="bio" class="form-label">소개</label>
      <textarea id="bio" name="bio" class="form-control" rows="4" maxlength="200">${userInfo.bio}</textarea>
    </div>
    <div class="col-12 d-flex justify-content-center gap-3 mt-4">
      <button id="withdrawBtn" class="btn btn-outline-danger px-4"
              formaction="/member/withdraw"
              onclick="return confirm('정말 탈퇴하시겠습니까?')">탈퇴하기</button>
      <button id="saveBtn" class="btn btn-primary zt-primary-btn px-4" type="submit">수정 완료</button>
    </div>
  </form>
</section>

    </main>
    
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/member.js"></script>

</body>
</html>
