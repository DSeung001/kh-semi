<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="여행 게시물 작성 페이지">
  <title>새 게시물 | 짠맛투어</title>
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
<a href="${pageContext.request.contextPath}/my-travel" class="" aria-label="짠맛투어"><i class="bi bi-grid-3x3-gap"></i></a>
<a href="${pageContext.request.contextPath}/new-post" class="active" aria-label="new"><i class="bi bi-plus-square"></i></a>
<a href="${pageContext.request.contextPath}/chat" class="" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
<a href="${pageContext.request.contextPath}/profile" class="" aria-label="profile"><i class="bi bi-person-circle"></i></a>
</nav>

  <div class="zt-layout">

<jsp:include page="/WEB-INF/views/components/sidebar.jsp">
  <jsp:param name="activePage" value="new-post" />
</jsp:include>

    <main class="zt-content">

<header class="zt-page-header">
  <h1>새 게시물 만들기</h1>
  <p>사진, 여행 동선, 경비와 태그를 입력합니다.</p>
</header>

<section class="zt-panel zt-profile-card">
  <form class="row g-4"
        action="${pageContext.request.contextPath}/new-post"
        method="post">
  <div class="col-lg-6">
      <label class="zt-upload-zone p-3" for="new-post-image" data-upload-preview>
        <span>
          <i class="bi bi-images display-5 d-block mb-3"></i>
          <strong class="d-block mb-1">사진을 선택하세요</strong>
          <small class="zt-muted">JPG, PNG 파일을 업로드할 수 있습니다.</small>
        </span>
      </label>
    </div>

    <div class="col-lg-6">
      <div class="mb-3">
        <label class="form-label" for="post-title">제목</label>
        <input id="post-title" name="title" class="form-control" type="text" maxlength="60" placeholder="여행 제목" required>
      </div>
      <div class="mb-3">
        <label class="form-label"
               for="post-place">여행 장소</label>
        <input id="post-place" class="form-control" type="text" placeholder="예: 서울 망원동">
      </div>
      <div class="mb-3">
        <label class="form-label" for="post-content">내용</label>
        <textarea id="post-content"
                  name="content"
                  class="form-control"
                  rows="8"
                  placeholder="여행 내용을 적어 주세요."
                  required>

        </textarea>
      </div>

      <div class="mb-3">
        <label class="form-label" for="transport-cost">교통비</label>
        <input id="transport-cost"
               name="transportCost"
               class="form-control"
               type="number"
               min="0"
               value="0"
               required>
      </div>

      <div class="mb-3">
        <label class="form-label" for="food-cost">식비</label>
        <input id="food-cost"
               name="foodCost"
               class="form-control"
               type="number"
               min="0"
               value="0"
               required>
      </div>

      <div class="mb-3">
        <label class="form-label" for="other-cost">
          입장료 및 기타 비용
        </label>
        <input id="other-cost"
               name="otherCost"
               class="form-control"
               type="number"
               min="0"
               value="0"
               required>
      </div>


      <div class="mb-3">
        <label class="form-label" for="post-tags">태그</label>
        <input id="post-tags" class="form-control" type="text" placeholder="#서울여행 #가성비여행">
      </div>
      <div class="form-check form-switch mb-4">
        <input id="share-route" class="form-check-input" type="checkbox" checked>
        <label class="form-check-label" for="share-route">여행 동선 공개</label>
      </div>
      <button class="btn btn-primary zt-primary-btn w-100 py-2" type="submit">작성 완료</button>
    </div>
  </form>
</section>

    </main>
    
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>

</body>
</html>
