<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
<div class="tg-app">
  
<header class="tg-mobile-header">
  <a class="tg-brand" href="${pageContext.request.contextPath}/home">
    <span>짠맛투어</span>
  </a>
  <a href="${pageContext.request.contextPath}/login" class="fs-5" aria-label="로그인"><i class="bi bi-box-arrow-in-right"></i></a>
</header>
<nav class="tg-mobile-nav" aria-label="모바일 메뉴">
  <a href="${pageContext.request.contextPath}/home" class="" aria-label="home"><i class="bi bi-house"></i></a>
<a href="${pageContext.request.contextPath}/my-travel" class="active" aria-label="짠맛투어"><i class="bi bi-grid-3x3-gap"></i></a>
<a href="${pageContext.request.contextPath}/new-post" class="" aria-label="new"><i class="bi bi-plus-square"></i></a>
<a href="${pageContext.request.contextPath}/chat" class="" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
<a href="${pageContext.request.contextPath}/profile" class="" aria-label="profile"><i class="bi bi-person-circle"></i></a>
</nav>

  <div class="tg-layout tg-layout-wide">
    
<jsp:include page="/WEB-INF/views/components/sidebar.jsp">
  <jsp:param name="activePage" value="my-travel" />
</jsp:include>

    <main class="tg-content">
      
<header class="tg-panel tg-my-travel-title">
  <span class="tg-muted small d-block">짠맛투어</span>
  나만의 여행 일기
</header>

<div class="d-flex justify-content-end gap-2 mb-2 px-2">
  <button class="btn btn-sm btn-dark"><i class="bi bi-sort-down me-1"></i>최신순</button>
  <button class="btn btn-sm btn-outline-secondary">조회순</button>
  <button class="btn btn-sm btn-outline-secondary">인기순</button>
</div>

<section class="tg-travel-grid" aria-label="나만의 여행 사진 그리드">
  <a class="tg-grid-card " href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/seoul.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
<a class="tg-grid-card narrow" href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/profile-ethan.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
<a class="tg-grid-card " href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/busan.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
<a class="tg-grid-card " href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/jeju.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
<a class="tg-grid-card narrow" href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/profile-sora.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
<a class="tg-grid-card " href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/gangneung.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
<a class="tg-grid-card " href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/gyeongju.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
<a class="tg-grid-card narrow" href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/profile-min.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
<a class="tg-grid-card " href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/sokcho.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
<a class="tg-grid-card " href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/jeonju.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
<a class="tg-grid-card narrow" href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/profile-ethan.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
<a class="tg-grid-card " href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/incheon.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
<a class="tg-grid-card " href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/busan.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
<a class="tg-grid-card narrow" href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/profile-sora.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
<a class="tg-grid-card " href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/seoul.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
<a class="tg-grid-card " href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/jeju.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
<a class="tg-grid-card narrow" href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/profile-min.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
<a class="tg-grid-card " href="${pageContext.request.contextPath}/post-detail">
      <img src="${pageContext.request.contextPath}/assets/images/gyeongju.svg" alt="여행 사진">
      <span class="tg-grid-overlay"><i class="bi bi-heart-fill me-2"></i> 128</span>
    </a>
</section>

    </main>
    
<aside class="tg-right-rail">
  <section class="tg-login-card">
    <h2>로그인</h2>
    <p class="tg-right-note mb-3">여행 기록을 남기고 다른 여행자와 정보를 나눠보세요.</p>
    <form data-demo-form data-message="로그인 데모입니다." data-redirect="${pageContext.request.contextPath}/home">
      <input class="form-control form-control-sm mb-2" type="text" placeholder="아이디" aria-label="아이디">
      <input class="form-control form-control-sm mb-2" type="password" placeholder="비밀번호" aria-label="비밀번호">
      <button class="btn btn-primary tg-primary-btn btn-sm w-100" type="submit">로그인</button>
    </form>
    <div class="d-flex justify-content-between mt-3 tg-right-note">
      <a href="${pageContext.request.contextPath}/signup">회원가입</a>
      <a href="${pageContext.request.contextPath}/forgot-password">비밀번호 찾기</a>
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
