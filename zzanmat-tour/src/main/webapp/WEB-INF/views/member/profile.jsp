<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
      <c:if test="${not empty message}">
        <script>
          alert("<c:out value="${message}"/>");
        </script>
      </c:if>

      <c:if test="${not empty error}">
        <script>
          alert("<c:out value="${error}"/>");
        </script>
      </c:if>

      <c:if test="${not empty withdrawError}">
        <script>
          alert("<c:out value="${withdrawError}"/>");
        </script>
      </c:if>
<header class="zt-page-header">
  <h1>내 정보</h1>
  <p>프로필과 계정 정보를 확인하고 수정합니다.</p>
</header>

<section class="zt-panel zt-profile-card zt-panel-shadow">
  <div class="zt-profile-hero">
    <c:choose>
      <c:when test="${not empty userInfo.profile}">
        <img id="my-profile"
              src="${pageContext.request.contextPath}<c:out value="${userInfo.profile}"/>"
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
        <h2 class="h5 mb-0"><c:out value="${userInfo.userId}"/></h2>
      </div>
      <p class="zt-muted small mb-0 mt-2">가성비 좋은 여행 동선을 기록합니다.</p>
      <div class="zt-profile-stats">
        <div><strong><c:out value="${userPostCnt}" default="0"/></strong><span>게시물</span></div>
        <div><strong><c:out value="${userInfo.followerCount}" default="0"/></strong><span>팔로워</span></div>
        <div><strong><c:out value="${userInfo.followingCount}" default="0"/></strong><span>팔로잉</span></div>
        <div><strong><fmt:formatNumber value="${empty pointBalance ? 0 : pointBalance}" type="number"/>P</strong><span>포인트</span></div>
      </div>
      <div class="mt-3">
        <a class="btn btn-warning btn-sm fw-bold" href="${pageContext.request.contextPath}/shop">포인트 상점</a>
      </div>
    </div>
    <div class="logoutArea">
      <a href="${pageContext.request.contextPath}/member/logout">
        <i class="bi bi-box-arrow-right" aria-hidden="true"></i>
        <span>로그아웃</span>
      </a>
    </div>
  </div>

  <form action="/member/update" method="post" id="profileForm" class="row g-3" enctype="multipart/form-data">
    <div class="col-12">
      <label for="profile-image_update" class="form-label">수정할 프로필 이미지</label>
      <input type="hidden" name="originProfileName" value="<c:out value="${userInfo.profile}"/>">
      <input id="profile-image-inputUpdate" name="profileImage" class="form-control" type="file" accept="image/jpeg,image/png">
    </div>
    <div class="col-md-6">
      <label for="nickname" class="form-label">닉네임</label>
      <input id="nickname" name="nickname" class="form-control" maxlength="30" type="text" value="<c:out value="${userInfo.nickname}"/>">
    </div>
    <div class="col-md-6">
      <label for="name" class="form-label">이름</label>
      <input type="hidden" name="userId" value="<c:out value="${userInfo.userId}"/>">
      <input id="name" name="userName" class="form-control" type="text" maxlength="10" value="<c:out value="${userInfo.userName}"/>">
    </div>
    <div class="col-12">
      <label for="email" class="form-label">이메일</label>
      <div class="input-group">
        <input disabled id="email" name="email" class="form-control" type="email" value="<c:out value="${userInfo.email}"/>">
      </div>
    </div>
    <div class="col-12">
      <label for="bio" class="form-label">소개</label>
      <textarea id="bio" name="bio" class="form-control" rows="4" maxlength="150"><c:out value="${userInfo.bio}"/></textarea>
    </div>
    <c:choose>
      <c:when test="${userInfo.loginType == 'KAKAO'}">
        <c:set var="withdrawAction" value="${pageContext.request.contextPath}/member/withdraw/kakao"/>
      </c:when>
      <c:when test="${userInfo.loginType == 'NAVER'}">
        <c:set var="withdrawAction" value="${pageContext.request.contextPath}/member/withdraw/naver"/>
      </c:when>
      <c:otherwise>
        <c:set var="withdrawAction" value="${pageContext.request.contextPath}/member/withdraw/general"/>
      </c:otherwise>
    </c:choose>
    <div class="col-12 d-flex justify-content-center gap-3 mt-4">
      <button type="button"
              data-bs-toggle="modal"
              data-bs-target="#withdrawConfirmModal"
              class="btn btn-outline-danger px-4">탈퇴하기
      </button>
      <button id="saveBtn" class="btn btn-primary zt-primary-btn px-4" type="submit">수정 완료</button>
    </div>
  </form>
</section>

<form id="withdrawForm" action="${withdrawAction}" method="post"></form>
<div class="modal fade" id="withdrawConfirmModal" tabindex="-1" aria-labelledby="withdrawConfirmModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h2 class="modal-title fs-5" id="withdrawConfirmModalLabel">회원 탈퇴 전 확인해주세요.</h2>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body">
        탈퇴하면 프로필 이미지, 이름, 닉네임, 소개 정보가 삭제 또는 익명화됩니다.
        이후 계정을 복구하더라도 기존 프로필 정보는 복구되지 않습니다.
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
        <button type="button" id="confirmWithdrawBtn" class="btn btn-danger">탈퇴 진행</button>
      </div>
    </div>
  </div>
</div>

    </main>
    
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/member.js"></script>

</body>
</html>
