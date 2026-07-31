<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="여행 게시물 사진 및 댓글 상세 페이지">
  <title>피드 상세 | 짠맛투어</title>
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
  <a href="${pageContext.request.contextPath}/home" class="active" aria-label="home"><i class="bi bi-house"></i></a>
<a href="${pageContext.request.contextPath}/my-travel" class="" aria-label="짠맛투어"><i class="bi bi-grid-3x3-gap"></i></a>
<a href="${pageContext.request.contextPath}/new-post" class="" aria-label="new"><i class="bi bi-plus-square"></i></a>
<a href="${pageContext.request.contextPath}/chat" class="" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
<a href="${pageContext.request.contextPath}/profile" class="" aria-label="profile"><i class="bi bi-person-circle"></i></a>
</nav>

  <div class="zt-layout">
    
<jsp:include page="/WEB-INF/views/components/sidebar.jsp">
  <jsp:param name="activePage" value="home" />
</jsp:include>

    <main class="zt-content">

<article class="zt-panel overflow-hidden">
  <header class="zt-post-header">
    <img class="zt-avatar" src="${pageContext.request.contextPath}/assets/images/profile-ethan.svg" alt="travel_ethan 프로필">
    <div class="zt-user-meta"><strong>travel_ethan</strong><span>서울 · 2시간 전</span></div>
    <button class="zt-icon-btn fs-5"><i class="bi bi-three-dots"></i></button>
  </header>

  <c:if test="${not empty sessionScope.loginMember
                and sessionScope.loginMember.id == post.userId}">

    <div class="p-3 text-end">
      <a class="btn btn-outline-secondary btn-sm"
         href="${pageContext.request.contextPath}/edit-post?postId=${post.postId}">
        수정
      </a>

      <form action="${pageContext.request.contextPath}/delete-post"
            method="post"
            class="d-inline"
            onsubmit="return confirm('정말 삭제하시겠습니까?');">

        <input type="hidden"
               name="postId"
               value="${post.postId}">

        <button type="submit"
                class="btn btn-outline-danger btn-sm">
          삭제
        </button>
      </form>
    </div>

  </c:if>

  <img class="zt-detail-image" src="${pageContext.request.contextPath}/assets/images/seoul.svg" alt="서울 여행 사진">

  <div class="zt-post-actions">
    <button class="zt-icon-btn" data-like-button data-like-target="#detail-likes"><i class="bi bi-heart"></i></button>
    <button class="zt-icon-btn"><i class="bi bi-chat"></i></button>
    <button class="zt-icon-btn"><i class="bi bi-send"></i></button>
    <button class="zt-icon-btn zt-save-btn"><i class="bi bi-bookmark"></i></button>
  </div>

  <div class="zt-post-body">
   <p class="fw-bold">
     <c:out value="${post.title}"/>
   </p>

    <p>
      <c:out value="${post.content}"/>
    </p>

    <div class="border rounded p-3 mb-3">
      <h2 class="h6 fw-bold mb-3">여행 경비</h2>

      <div class="d-flex justify-content-between mb-2">
        <span>교통비</span>
        <strong>
          <fmt:formatNumber value="${post.transportCost}"/>원
        </strong>
      </div>

      <div class="d-flex justify-content-between mb-2">
        <span>식비</span>
        <strong>
          <fmt:formatNumber value="${post.foodCost}"/>원
        </strong>
      </div>

      <div class="d-flex justify-content-between mb-2">
        <span>입장료 및 기타 비용</span>
        <strong>
          <fmt:formatNumber value="${post.otherCost}"/>원
        </strong>
      </div>
    </div>

    <hr>

    <div class="d-flex justify-content-between">
      <span class="fw-bold">총비용</span>
      <strong class="text-primary">
        <fmt:formatNumber
            value="${post.transportCost + post.foodCost + post.otherCost}"/>원
      </strong>
    </div>

    <p class="zt-muted small mb-0">
      작성자 번호:
      <c:out value="${post.userId}"/>

      . 조회수:
      <c:out value="${post.viewCount}"/>
    </p>
  </div>

  <section id="comments" class="zt-comments-box border-top">
    <h2 class="h6 fw-bold">댓글</h2>
    <div data-comment-list>
      <div class="zt-comment-row">
        <img class="zt-avatar zt-avatar-sm" src="${pageContext.request.contextPath}/assets/images/profile-sora.svg" alt="">
        <p class="small mb-0"><strong>travel_sora</strong> 이동 동선이 정말 깔끔하네요. 다음 주에 따라가 볼게요!</p>
        <button class="zt-icon-btn fs-6"><i class="bi bi-heart"></i></button>
      </div>
      <div class="zt-comment-row">
        <img class="zt-avatar zt-avatar-sm" src="${pageContext.request.contextPath}/assets/images/profile-min.svg" alt="">
        <p class="small mb-0"><strong>budget_min</strong> 망원시장 메뉴도 추천해 주세요.</p>
        <button class="zt-icon-btn fs-6"><i class="bi bi-heart"></i></button>
      </div>
    </div>
  </section>

  <form class="zt-comment-form" data-comment-form>
    <i class="bi bi-emoji-smile"></i>
    <input type="text" placeholder="댓글 입력" aria-label="댓글 입력">
    <button class="zt-link-button" type="submit">게시</button>
  </form>
</article>

    </main>
    
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

</body>
</html>
