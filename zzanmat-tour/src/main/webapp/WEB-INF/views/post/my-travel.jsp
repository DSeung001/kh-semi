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
          class="zt-travel-toolbar">

        <label for="post-keyword" class="visually-hidden">
            게시글 제목 또는 내용 검색
        </label>

        <input id="post-keyword"
               type="search"
               name="keyword"
               value="${keyword}"
               class="form-control zt-travel-search-input"
               placeholder="제목 또는 내용을 검색하세요"
               aria-label="게시글 제목 또는 내용 검색">

        <button type="submit"
                class="btn zt-travel-search-button">
            <i class="bi bi-search"></i>
            <span>검색</span>
        </button>

        <label for="post-sort" class="visually-hidden">
            게시글 정렬 기준
        </label>

        <select id="post-sort"
                name="sort"
                class="form-select zt-travel-sort"
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


<section id="post-grid"
         class="zt-travel-grid"
         aria-label="나만의 여행 게시글"
         data-context-path="${pageContext.request.contextPath}"
         data-sort="${sort}"
         data-keyword="${keyword}"
         data-total-pages="${totalPages}">

    <c:forEach var="post" items="${posts}">
        <a class="zt-grid-card"
           href="${pageContext.request.contextPath}/post-detail?postId=${post.postId}">

            <c:choose>
                <c:when test="${not empty post.thumbnailPath}">
                    <img src="${pageContext.request.contextPath}${post.thumbnailPath}"
                         alt="${post.title}">
                </c:when>

                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/assets/images/seoul.svg"
                         alt="${post.title}">
                </c:otherwise>
            </c:choose>

            <span class="zt-grid-overlay">
                ${post.title}
                <i class="bi bi-eye-fill ms-2 me-1"></i>
                ${post.viewCount}
            </span>

        </a>
    </c:forEach>

</section>

<c:if test="${empty posts}">
    <div class="zt-panel text-center py-5">
        <i class="bi bi-search fs-2 text-secondary"></i>

        <p class="mt-3 mb-2">
            검색 결과가 없습니다.
        </p>

        <c:if test="${not empty keyword}">
            <p class="text-secondary small">
                '<c:out value="${keyword}"/>'이(가)
                포함된 게시글을 찾지 못했습니다.
            </p>

            <a class="btn btn-sm btn-outline-secondary"
               href="${pageContext.request.contextPath}/my-travel">
                전체 게시글 보기
            </a>
        </c:if>
    </div>
</c:if>
        <div id="post-scroll-sentinel"
             class="text-center py-4">
            <div id="post-loading"
                 class="spinner-border text-primary"
                 role="status"
                 hidden>

                <span class="visually-hidden">
                    게시글을 불러오는 중입니다.
                </span>
            </div>

        </div>

    </main>
    
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/post-infinite-scroll.js"></script>


</body>
</html>
