<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core" %>
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
<div class="zt-app">

<header class="zt-mobile-header">
    <a class="zt-brand" href="${pageContext.request.contextPath}/home">
        <span>짠맛투어</span>
    </a>
    <a href="${pageContext.request.contextPath}/login" class="fs-5" aria-label="로그인"><i
            class="bi bi-box-arrow-in-right"></i></a>
</header>
<nav class="zt-mobile-nav" aria-label="모바일 메뉴">
    <a href="${pageContext.request.contextPath}/home" class="active" aria-label="home"><i class="bi bi-house"></i></a>
    <a href="${pageContext.request.contextPath}/my-travel" class="" aria-label="짠맛투어"><i class="bi bi-grid-3x3-gap"></i></a>
    <a href="${pageContext.request.contextPath}/new-post" class="" aria-label="new"><i
            class="bi bi-plus-square"></i></a>
    <a href="${pageContext.request.contextPath}/chat" class="" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
    <a href="${pageContext.request.contextPath}/profile" class="" aria-label="profile"><i
            class="bi bi-person-circle"></i></a>
</nav>

<div class="zt-layout">


<jsp:include page="/WEB-INF/views/components/sidebar.jsp">
    <jsp:param name="activePage" value="home"/>
</jsp:include>

<main class="zt-content">
<c:if test="${not empty message}">
    <script>
        alert("${message}");
    </script>
</c:if>
<form class="input-group zt-search" role="search" data-demo-form data-message="검색 기능은 서버 연결 후 구현됩니다.">
    <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
    <input class="form-control bg-white" type="search" placeholder="여행지, 사용자, 해시태그 검색">
    <button class="btn btn-outline-secondary" type="submit">검색</button>
</form>

<c:forEach items="${latestPosts}" var="post">

    <article class="zt-panel zt-post">

    <header class="zt-post-header">
    <div class="zt-user-meta">
    <strong>
    <c:out value="${post.title}"/>
    </strong>

    <span>
    조회수 <c:out value="${post.viewCount}"/>
    </span>
    </div>
    </header>

    <a href="${pageContext.request.contextPath}/post-detail?postId=${post.postId}">

    <c:choose>

        <c:when test="${not empty post.thumbnailPath}">
            <img class="zt-post-image"
                 src="${pageContext.request.contextPath}${post.thumbnailPath}"
                 alt="게시글 대표 이미지">
        </c:when>

        <c:otherwise>
            <img class="zt-post-image"
                 src="${pageContext.request.contextPath}/assets/images/seoul.svg"
                 alt="기본 여행 이미지">
        </c:otherwise>

    </c:choose>

    </a>

    <div class="zt-post-actions">

    <form class="zt-main-like-form zt-main-stat"
    action="${pageContext.request.contextPath}/post-like"
    method="post">

    <input type="hidden"
           name="postId"
           value="${post.postId}">

    <button type="submit"
            class="zt-icon-btn"
            aria-label="좋아요">

    <c:choose>
        <c:when test="${post.liked}">
            <i class="bi bi-heart-fill text-danger"
               data-like-icon></i>
        </c:when>

        <c:otherwise>
            <i class="bi bi-heart"
               data-like-icon></i>
        </c:otherwise>
    </c:choose>

    </button>

    <span data-like-count>
        <c:out value="${post.likeCount}"/>
    </span>

    </form>

    <a class="zt-icon-btn zt-main-stat"
        href="${pageContext.request.contextPath}/post-detail?postId=${post.postId}#comments"
        aria-label="댓글">

    <i class="bi bi-chat"></i>

    <span>
        <c:out value="${post.commentCount}"/>
    </span>
    </a>

    <button class="zt-icon-btn"
            type="button"
            aria-label="공유">
        <i class="bi bi-send"></i>
    </button>

    <button class="zt-icon-btn zt-save-btn"
            type="button"
            aria-label="저장">
        <i class="bi bi-bookmark"></i>
    </button>
    </div>

    <div class="zt-post-body">
     <p>
        <strong>
            <c:out value="${post.title}"/>
        </strong>
     </p>

     <p class="zt-muted">
        조회수 <c:out value="${post.viewCount}"/>
        </p>
    </div>

    </article>

</c:forEach>


    </main>
    </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/post-like.js"></script>

    </body>
    </html>
