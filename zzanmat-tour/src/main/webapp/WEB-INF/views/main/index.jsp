<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="인스타그램 스타일 여행 커뮤니티 메인 피드">
  <title>메인 피드 | 짠맛투어</title>
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
  <a href="${pageContext.request.contextPath}/home" class="active" aria-label="home"><i class="bi bi-house"></i></a>
<a href="${pageContext.request.contextPath}/my-travel" class="" aria-label="짠맛투어"><i class="bi bi-grid-3x3-gap"></i></a>
<a href="${pageContext.request.contextPath}/new-post" class="" aria-label="new"><i class="bi bi-plus-square"></i></a>
<a href="${pageContext.request.contextPath}/chat" class="" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
<a href="${pageContext.request.contextPath}/profile" class="" aria-label="profile"><i class="bi bi-person-circle"></i></a>
</nav>

  <div class="tg-layout">
    

<jsp:include page="/WEB-INF/views/components/sidebar.jsp">
  <jsp:param name="activePage" value="home" />
</jsp:include>

    <main class="tg-content">
      
<form class="input-group tg-search" role="search" data-demo-form data-message="검색 기능은 서버 연결 후 구현됩니다.">
  <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
  <input class="form-control bg-white" type="search" placeholder="여행지, 사용자, 해시태그 검색">
  <button class="btn btn-outline-secondary" type="submit">검색</button>
</form>

<section class="tg-panel tg-story-strip" aria-label="여행 스토리">
  <a class="tg-story" href="#">
  <div class="tg-story-ring"><img src="${pageContext.request.contextPath}/assets/images/seoul.svg" alt="서울여행 스토리"></div>
  <span>서울여행</span>
</a>
  <a class="tg-story" href="#">
  <div class="tg-story-ring"><img src="${pageContext.request.contextPath}/assets/images/busan.svg" alt="부산맛집 스토리"></div>
  <span>부산맛집</span>
</a>
  <a class="tg-story" href="#">
  <div class="tg-story-ring"><img src="${pageContext.request.contextPath}/assets/images/jeju.svg" alt="제주한달 스토리"></div>
  <span>제주한달</span>
</a>
  <a class="tg-story" href="#">
  <div class="tg-story-ring"><img src="${pageContext.request.contextPath}/assets/images/gangneung.svg" alt="바다여행 스토리"></div>
  <span>바다여행</span>
</a>
  <a class="tg-story" href="#">
  <div class="tg-story-ring"><img src="${pageContext.request.contextPath}/assets/images/gyeongju.svg" alt="역사산책 스토리"></div>
  <span>역사산책</span>
</a>
  <a class="tg-story" href="#">
  <div class="tg-story-ring"><img src="${pageContext.request.contextPath}/assets/images/sokcho.svg" alt="혼행러 스토리"></div>
  <span>혼행러</span>
</a>
</section>


<article class="tg-panel tg-post">
  <header class="tg-post-header">
    <img class="tg-avatar" src="${pageContext.request.contextPath}/assets/images/profile-ethan.svg" alt="travel_ethan 프로필">
    <div class="tg-user-meta">
      <strong><a href="${pageContext.request.contextPath}/profile">travel_ethan</a></strong>
      <span>서울 · 2시간 전</span>
    </div>
    <button class="tg-icon-btn fs-5" type="button" aria-label="더보기"><i class="bi bi-three-dots"></i></button>
  </header>
  <a href="${pageContext.request.contextPath}/post-detail">
    <img class="tg-post-image landscape" src="${pageContext.request.contextPath}/assets/images/seoul.svg" alt="서울 여행 사진">
  </a>
  <div class="tg-post-actions">
    <button class="tg-icon-btn" type="button" aria-label="좋아요" data-like-button data-like-target="#likes-main1">
      <i class="bi bi-heart"></i>
    </button>
    <a class="tg-icon-btn" href="${pageContext.request.contextPath}/post-detail#comments" aria-label="댓글"><i class="bi bi-chat"></i></a>
    <button class="tg-icon-btn" type="button" aria-label="공유"><i class="bi bi-send"></i></button>
    <button class="tg-icon-btn tg-save-btn" type="button" aria-label="저장"><i class="bi bi-bookmark"></i></button>
  </div>
  <div class="tg-post-body">
    <p id="likes-main1" data-count="128" class="fw-bold">좋아요 128개</p>
    <p><strong class="me-1">travel_ethan</strong>교통비 포함 2만 원으로 서울 하루 여행을 다녀왔습니다. <a class="tg-hashtag" href="#">#서울여행 #가성비여행 #여행기록</a></p>
    <a class="tg-muted d-block mb-1" href="${pageContext.request.contextPath}/post-detail#comments">댓글 모두 보기</a>
    <div data-comment-list></div>
    <small class="tg-muted">2026년 7월 20일</small>
  </div>
  <form class="tg-comment-form" data-comment-form>
    <i class="bi bi-emoji-smile"></i>
    <input type="text" placeholder="댓글 달기..." aria-label="댓글">
    <button class="tg-link-button" type="submit">게시</button>
  </form>
</article>



<article class="tg-panel tg-post">
  <header class="tg-post-header">
    <img class="tg-avatar" src="${pageContext.request.contextPath}/assets/images/profile-sora.svg" alt="travel_sora 프로필">
    <div class="tg-user-meta">
      <strong><a href="${pageContext.request.contextPath}/profile">travel_sora</a></strong>
      <span>제주 · 2시간 전</span>
    </div>
    <button class="tg-icon-btn fs-5" type="button" aria-label="더보기"><i class="bi bi-three-dots"></i></button>
  </header>
  <a href="${pageContext.request.contextPath}/post-detail">
    <img class="tg-post-image " src="${pageContext.request.contextPath}/assets/images/jeju.svg" alt="제주 여행 사진">
  </a>
  <div class="tg-post-actions">
    <button class="tg-icon-btn" type="button" aria-label="좋아요" data-like-button data-like-target="#likes-main2">
      <i class="bi bi-heart"></i>
    </button>
    <a class="tg-icon-btn" href="${pageContext.request.contextPath}/post-detail#comments" aria-label="댓글"><i class="bi bi-chat"></i></a>
    <button class="tg-icon-btn" type="button" aria-label="공유"><i class="bi bi-send"></i></button>
    <button class="tg-icon-btn tg-save-btn" type="button" aria-label="저장"><i class="bi bi-bookmark"></i></button>
  </div>
  <div class="tg-post-body">
    <p id="likes-main2" data-count="245" class="fw-bold">좋아요 245개</p>
    <p><strong class="me-1">travel_sora</strong>비가 와도 좋았던 제주 동쪽 작은 마을 산책. <a class="tg-hashtag" href="#">#제주여행 #혼자여행 #짠맛투어</a></p>
    <a class="tg-muted d-block mb-1" href="${pageContext.request.contextPath}/post-detail#comments">댓글 모두 보기</a>
    <div data-comment-list></div>
    <small class="tg-muted">2026년 7월 20일</small>
  </div>
  <form class="tg-comment-form" data-comment-form>
    <i class="bi bi-emoji-smile"></i>
    <input type="text" placeholder="댓글 달기..." aria-label="댓글">
    <button class="tg-link-button" type="submit">게시</button>
  </form>
</article>


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
