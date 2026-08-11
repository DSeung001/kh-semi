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
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/post-detail.css">
  
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
<a href="${pageContext.request.contextPath}/my-travel" class="active" aria-label="여행 이야기"><i class="bi bi-grid-3x3-gap"></i></a>
<a href="${pageContext.request.contextPath}/new-post" class="" aria-label="new"><i class="bi bi-plus-square"></i></a>
<a href="${pageContext.request.contextPath}/chat" class="" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
<a href="${pageContext.request.contextPath}/profile" class="" aria-label="profile"><i class="bi bi-person-circle"></i></a>
</nav>

  <div class="zt-layout">

<jsp:include page="/WEB-INF/views/components/sidebar.jsp">
  <jsp:param name="activePage" value="my-travel" />
</jsp:include>

    <main class="zt-content">
    <c:url var="commentLoginUrl" value="/member/login">
      <c:param name="redirectURL" value="/post-detail?postId=${post.postId}#comments"/>
    </c:url>
<article class="zt-panel overflow-hidden">

  <div class="zt-detail-title-area">
    <span class="zt-detail-category">여행 이야기</span>

    <h1 class="zt-detail-title">
      <c:out value="${post.title}"/>
    </h1>
  </div>
  <header class="zt-post-header zt-detail-author-header">

    <div class="zt-detail-author">
      <c:choose>
        <c:when test="${not empty post.authorProfile}">
          <img class="zt-avatar"
               src="${pageContext.request.contextPath}${post.authorProfile}"
               alt="작성자 프로필"
               onerror="this.onerror=null;
                        this.src='${pageContext.request.contextPath}/assets/images/profile-ethna.svg';">
        </c:when>

        <c:otherwise>
          <img class="zt-avatar"
               src="${pageContext.request.contextPath}/assets/images/profile-ethan.svg"
               alt="기본 프로필">
        </c:otherwise>
      </c:choose>

      <div class="zt-user-meta">

        <!-- 첫 번째 줄: 닉네임 + 팔로우 -->
        <div class="zt-detail-author-main">
          <strong>
            <c:out value="${post.authorNickname}" default="알 수 없는 사용자"/>
          </strong>

          <c:if test="${not empty sessionScope.loginMember and not isOwnPost}">
            <button type="button" class="zt-follow-button ${isFollowing ? 'is-following' : ''}"
                    data-follow-button
                    data-logged-in="true"
                    data-context-path="${pageContext.request.contextPath}"
                    data-following-id="${post.userId}"
                    data-following="${isFollowing}">

              <c:choose>
                <c:when test="${isFollowing}">팔로잉</c:when>
                <c:otherwise>팔로우</c:otherwise>
              </c:choose>
            </button>
          </c:if>

          <c:if test="${empty sessionScope.loginMember}">
            <button type="button"
                    class="zt-follow-button"
                    data-follow-button
                    data-logged-in="false"
                    data-context-path="${pageContext.request.contextPath}"
                    data-following-id="${post.userId}"
                    data-following="false">
              팔로우
            </button>
          </c:if>
        </div>

        <!-- 두 번째 줄: 작성일 + 조회수 -->
        <div class="zt-detail-author-sub">
          <span>
            <c:out value="${post.formattedCreateAt}"/>
          </span>
          <span>조회수 <c:out value="${post.viewCount}" default="0"/></span>
        </div>
      </div>
    </div>

    <!-- 본인 게시글일 때만 수정·삭제 -->
    <c:if test="${isOwnPost}">
      <div class="zt-detail-owner-actions">
        <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/edit-post?postId=${post.postId}">수정</a>
        <form action="${pageContext.request.contextPath}/delete-post" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
          <input type="hidden" name="postId" value="${post.postId}">
          <button type="submit" class="btn btn-outline-danger btn-sm">삭제</button>
        </form>
      </div>
    </c:if>
  </header>
  <%--<header class="zt-post-header">
    &lt;%&ndash;<img class="zt-avatar" src="${pageContext.request.contextPath}/assets/images/profile-ethan.svg" alt="travel_ethan 프로필">&ndash;%&gt;
      <c:choose>
        <c:when test="${not empty post.authorProfile}">
          <img class="zt-avatar" src="${pageContext.request.contextPath}${post.authorProfile}" alt="작성자 프로필">
        </c:when>

        <c:otherwise>
          <img class="zt-avatar" src="${pageContext.request.contextPath}/assets/images/profile-ethan.svg" alt="기본 프로필">
        </c:otherwise>
      </c:choose>

    <div class="zt-user-meta">
      <div class="d-flex align-items-center gap-2">
        <strong>
          <c:out value="${post.authorNickname}"/>
        </strong>

        <!-- 로그인했으며 자신의 글이 아닌 경우 -->
        <c:if test="${not empty sessionScope.loginMember and not isOwnPost}">
          <button type="button"
                  class="zt-follow-button btn btn-link btn-sm p-0 text-decoration-none ${isFollowing ? 'is-following' : ''}"
                  data-follow-button
                  data-context-path="${pageContext.request.contextPath}"
                  data-following-id="${post.userId}"
                  data-following="${isFollowing}">

            <c:choose>
              <c:when test="${isFollowing}">
                팔로잉
              </c:when>
              <c:otherwise>
                팔로우
              </c:otherwise>
            </c:choose>

          </button>
        </c:if>

        &lt;%&ndash;<c:if test="${empty sessionScope.loginMember}">
          <a href="${pageContext.request.contextPath}/member/login?redirectURL=${pageContext.request.contextPath}/post-detail?postId=${post.postId}"
             class="btn btn-link btn-sm p-0 text-decoration-none">
            팔로우
          </a>
        </c:if>&ndash;%&gt;

      </div>
    </div>
  </header>--%>

  <%--<c:if test="${not empty sessionScope.loginMember
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

  </c:if>--%>

  <c:choose>
    <c:when test="${not empty post.images}">
      <div class="zt-detail-carousel" data-detail-carousel>

        <div class="zt-detail-slides">
          <c:forEach var="image" items="${post.images}" varStatus="status">

            <img class="zt-detail-image zt-detail-slide ${status.first ? 'is-active' : ''}"
                 src="${pageContext.request.contextPath}${image.uploadPath}"
                 alt="${image.originName}"
                 data-slide-index="${status.index}"
                 onerror="this.onerror=null;
                          this.src='${pageContext.request.contextPath}/assets/images/zzanmat-default.jpg';">
          </c:forEach>
        </div>

        <c:if test="${post.images.size() > 1}">
          <button type="button"
                  class="zt-detail-carousel-button zt-detail-carousel-prev"
                  data-carousel-prev
                  aria-label="이전 사진">
            <i class="bi bi-chevron-left"></i>
          </button>

          <button type="button"
                  class="zt-detail-carousel-button zt-detail-carousel-next"
                  data-carousel-next
                  aria-label="다음 사진">
              <i class="bi bi-chevron-right"></i>
          </button>

          <div class="zt-detail-carousel-count">
            <span data-carousel-current>1</span>
            /
            <span data-carousel-total>${post.images.size()}</span>
          </div>
        </c:if>
      </div>
    </c:when>

    <c:otherwise>
      <img class="zt-detail-image"
           src="${pageContext.request.contextPath}/assets/images/zzanmat-default.jpg"
           alt="등록된 사진이 없습니다">
    </c:otherwise>
  </c:choose>

  <div class="zt-post-actions">
    <c:choose>
      <c:when test="${not empty sessionScope.loginMember}">
        <form action="${pageContext.request.contextPath}/post-like" method="post" class="d-inline">
          <input type="hidden" name="postId" value="${post.postId}">
          <button type="submit" class="zt-icon-btn" aria-label="좋아요">
            <c:choose>
              <c:when test="${liked}">
                <i class="bi bi-heart-fill text-danger"
                   data-like-icon></i>
              </c:when>

              <c:otherwise>
                <i class="bi bi-heart"
                   data-like-icon></i>
              </c:otherwise>
            </c:choose>
          </button>
        </form>
      </c:when>

      <c:otherwise>
        <button class="zt-icon-btn"
                type="button"
                aria-label="로그인 후 좋아요"
                data-login-prompt
                data-login-message="좋아요를 누르려면 로그인이 필요합니다. 로그인하시겠습니까?"
                data-login-url="${commentLoginUrl}">

          <i class="bi bi-heart"></i>
        </button>
      </c:otherwise>
    </c:choose>

<button class="zt-icon-btn zt-comment-summary-button"
        type="button"
        data-comment-toggle
        aria-expanded="false"
        aria-controls="comment-list"
        aria-label="댓글 보기">

  <i class="bi bi-chat"></i>
</button>


    <%-- 동작하지 않는 버튼들 주석 처리 --%>
    <%--<button class="zt-icon-btn" type="button">
      <i class="bi bi-chat"></i>
    </button>

    <button class="zt-icon-btn" type="button">
      <i class="bi bi-send"></i>
    </button>

    <button class="zt-icon-btn zt-save-btn" type="button">
      <i class="bi bi-bookmark"></i>
    </button>--%>
  </div>

  <p id="detail-likes"
     class="fw-bold px-3 mb-2">
    좋아요
    <span data-like-count>
      <c:out value="${likeCount}"/>
    </span>개
  </p>

  <div class="zt-post-body">

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
        <fmt:formatNumber value="${post.transportCost + post.foodCost + post.otherCost}"/>원
      </strong>
    </div>

    <%-- 조회 수 상단으로 옮김 추후 삭제 --%>
    <%--<p class="zt-muted small mb-0">
      조회수: <c:out value="${post.viewCount}"/>
    </p>--%>
  </div>

  <section id="comments" class="zt-comments-box border-top">

    <h2 class="h6 fw-bold">댓글</h2>

    <div id="comment-list"
         data-comment-list
         hidden>

      <c:choose>
        <c:when test="${empty comments}">
          <p class="zt-muted small mb-0">
            아직 작성된 댓글이 없습니다.
          </p>
        </c:when>

        <c:otherwise>
          <c:forEach var="comment" items="${comments}">
            <div class="zt-comment-row ${not empty comment.parentCommentId ? 'is-reply' : ''}">
              <img class="zt-avatar zt-avatar-sm" src="${pageContext.request.contextPath}/assets/images/profile-sora.svg" alt="댓글 작성자 프로필">

              <div class="flex-grow-1">
                <p class="small mb-1">
                  <strong>
                    <c:out value="${comment.nickname}"/>
                  </strong>

                  <c:choose>
                    <c:when test="${comment.deleted}">
                      <span class="zt-deleted-comment">
                        삭제된 댓글입니다.
                      </span>
                    </c:when>

                    <c:otherwise>
                      <span data-comment-content>
                        <c:out value="${comment.content}"/>
                      </span>
                    </c:otherwise>
                  </c:choose>
                </p>

                <c:if test="${not comment.deleted}">
                <div class="zt-comment-like-count">
                  좋아요
                  <span data-comment-like-count>
                    <c:out value="${comment.likeCount}"/>
                  </span>개
                </div>
                </c:if>

                <c:if test="${not empty sessionScope.loginMember
                              and empty comment.parentCommentId
                              and not comment.deleted}">

                  <button class="zt-comment-action-button"
                          type="button"
                          data-comment-reply-button
                          data-comment-id="${comment.commentId}"
                          data-comment-nickname="${comment.nickname}">
                    답글 달기
                  </button>
                </c:if>

                <c:if test="${sessionScope.loginMember.id eq comment.userId
                              and not comment.deleted}">

                  <div class="zt-comment-actions">

                    <button class="zt-comment-action-button" type="button" data-comment-edit-button data-comment-id="${comment.commentId}">수정</button>

                    <form action="${pageContext.request.contextPath}/comments/delete"
                          method="post"
                          onsubmit="return confirm('댓글을 삭제하시겠습니까?');">

                      <input type="hidden"
                             name="commentId"
                             value="${comment.commentId}">

                      <input type="hidden"
                             name="postId"
                             value="${post.postId}">

                      <button class="zt-comment-action-button zt-comment-delete-button"
                              type="submit">
                        삭제
                      </button>
                    </form>

                  </div>
                </c:if>
              </div>

              <c:if test="${not comment.deleted}">
              <button class="zt-comment-like-button ${comment.liked ? 'is-liked' : ''}"
                      type="button"
                      data-comment-like-button
                      data-comment-id="${comment.commentId}"
                      data-post-id="${post.postId}"
                      data-logged-in="${not empty sessionScope.loginMember}"
                      data-like-action="${pageContext.request.contextPath}/comment-like"
                      data-login-url="${pageContext.request.contextPath}/member/login">

                <i class="bi ${comment.liked ? 'bi-heart-fill' : 'bi-heart'}"
                   data-comment-like-icon></i>
                </button>
              </c:if>

            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>
  </section>

  <c:choose>
    <c:when test="${not empty sessionScope.loginMember}">
      <form id="comment-form"
            class="zt-comment-form"
            action="${pageContext.request.contextPath}/comments"
            method="post"
            data-create-action="${pageContext.request.contextPath}/comments"
            data-update-action="${pageContext.request.contextPath}/comments/update">

        <input type="hidden"
               name="postId"
               value="${post.postId}">

        <input id="comment-parent-id"
               type="hidden"
               name="parentCommentId"
               disabled>

        <input id="comment-edit-id"
               type="hidden"
               name="commentId"
               disabled>

        <i class="bi bi-emoji-smile"></i>

        <input id="comment-content"
               type="text"
               name="content"
               maxlength="300"
               placeholder="댓글 입력"
               aria-label="댓글 입력"
               required>

        <button id="comment-edit-cancel"
                class="zt-comment-action-button"
                type="button"
                hidden>
          취소
        </button>

        <button id="comment-submit-button"
                class="zt-link-button"
                type="submit">
          게시
        </button>
      </form>
    </c:when>

    <c:otherwise>
     <div class="zt-comment-form">
       <button class="zt-comment-login-button"
               type="button"
               data-login-prompt
               data-login-message="댓글을 작성하려면 로그인이 필요합니다. 로그인하시겠습니까?"
               data-login-url="${commentLoginUrl}">

         로그인 후 댓글을 작성할 수 있습니다.
       </button>
     </div>
    </c:otherwise>
  </c:choose>
</article>

    </main>

  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/follow.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/post-detail.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/post-detail-carousel.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/post-like.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/comment-edit.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/comment-like.js"></script>

</body>
</html>
