<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="여행 사진을 모아 보는 짠맛투어 페이지">
  <title>나만의 여행 일기 | 짠맛투어</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
  
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
<a href="${pageContext.request.contextPath}/my-travel" class="active" aria-label="짠맛투어"><i class="bi bi-grid-3x3-gap"></i></a>
<a href="${pageContext.request.contextPath}/new-post" class="" aria-label="new"><i class="bi bi-plus-square"></i></a>
<a href="${pageContext.request.contextPath}/chat" class="" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
<a href="${pageContext.request.contextPath}/profile" class="" aria-label="profile"><i class="bi bi-person-circle"></i></a>
</nav>

  <div class="zt-layout">
    
<jsp:include page="/WEB-INF/views/components/sidebar.jsp">
  <jsp:param name="activePage" value="my-travel" />
</jsp:include>

    <main class="zt-content">
      
<header class="zt-panel zt-my-travel-title">
  <span class="zt-muted small d-block">짠맛투어</span>
  나만의 여행 일기
</header>
    <form action="${pageContext.request.contextPath}/my-travel"
          method="get"
          class="d-flex align-items-center mb-2 px-2">

        <label for="post-sort" class="visually-hidden">
            게시글 정렬 기준
        </label>

        <select id="post-sort"
                name="sort"
                class="form-select form-select-sm w-auto ms-auto"
                aria-label="게시글 정렬 기준"
                onchange="this.form.submit()">
            <option value = "latest"
                    ${sort eq 'latest' ? 'selected' : ''}>
            최신순
            </option>

            <option value = "views"
                    ${sort eq 'views' ? 'selected' : ''}>
                조회순
            </option>

            <option value = "popular"
                    ${sort eq 'popular' ? 'selected' : ''}>
                인기순
            </option>
        </select>
    </form>


<section class="zt-travel-grid" aria-label="나만의 여행 게시글">
    <c:forEach var="post" items="${posts}">
        <a class="zt-grid-card"
           href="${pageContext.request.contextPath}/post-detail?postId=${post.postId}">

            <img src="${pageContext.request.contextPath}/assets/images/seoul.svg"
                 alt="${post.title}">

            <span class="zt-grid-overlay">
                ${post.title}
                <i class="bi bi-eye-fill ms-2 me-1"></i>
                ${post.viewCount}
            </span>

        </a>
    </c:forEach>
</section>


    </main>
    
<aside class="zt-right-rail">
  <section class="zt-login-card">
    <h2>로그인</h2>
    <p class="zt-right-note mb-3">여행 기록을 남기고 다른 여행자와 정보를 나눠보세요.</p>
    <form data-demo-form data-message="로그인 데모입니다." data-redirect="${pageContext.request.contextPath}/home">
      <input class="form-control form-control-sm mb-2" type="text" placeholder="아이디" aria-label="아이디">
      <input class="form-control form-control-sm mb-2" type="password" placeholder="비밀번호" aria-label="비밀번호">
      <button class="btn btn-primary zt-primary-btn btn-sm w-100" type="submit">로그인</button>
    </form>
    <div class="d-flex justify-content-between mt-3 zt-right-note">
      <a href="${pageContext.request.contextPath}/signup">회원가입</a>
      <a href="${pageContext.request.contextPath}/forgot-password">비밀번호 찾기</a>
    </div>
  </section>

  <section class="zt-suggestion-card">
    <h2>추천 여행자</h2>
    <div class="zt-user-row">
      <img class="zt-avatar zt-avatar-sm" src="${pageContext.request.contextPath}/assets/images/profile-sora.svg" alt="소라 프로필">
      <div class="zt-user-meta"><strong>travel_sora</strong><span>서울 골목 여행</span></div>
      <button class="zt-link-button" data-follow-button>팔로우</button>
    </div>
    <div class="zt-user-row">
      <img class="zt-avatar zt-avatar-sm" src="${pageContext.request.contextPath}/assets/images/profile-min.svg" alt="민 프로필">
      <div class="zt-user-meta"><strong>budget_min</strong><span>가성비 여행</span></div>
      <button class="zt-link-button" data-follow-button>팔로우</button>
    </div>
    <p class="zt-right-note mb-0">이 화면은 정적 프론트엔드 시안입니다. 로그인과 데이터 저장은 서버 연결 후 동작합니다.</p>
  </section>
</aside>

  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

</body>
</html>
