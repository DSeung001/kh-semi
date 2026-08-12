<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
        method="post"
        enctype="multipart/form-data">
    <c:if test="${not empty missionId}">
      <input type="hidden" name="missionId" value="${missionId}">
    </c:if>

  <div class="col-lg-6">
    <div class="zt-post-image-uploader"
         data-post-image-uploader>

      <div class="zt-post-main-preview">
        <div id="post-image-empty"
            class="zt-post-image-empty">
          <i class="bi bi-images display-5"></i>
          <strong>사진을 선택하세요</strong>
          <small>JPG, PNG 파일을 최대 5장까지 선택할 수 있습니다.</small>
        </div>

        <img id="post-main-preview"
             class="zt-post-main-image"
             src=""
             alt="선택한 사진 미리보기"
             hidden>
      </div>

      <div class="zt-post-thumbnail-row">
        <div id="post-thumbnail-list"
             class="zt-post-thumbnail-list">
        </div>

        <label class="zt-post-add-image"
               for="new-post-image">
          <i class="bi bi-plus-lg"></i>
          <span>사진</span>

          <input id="new-post-image"
                 name="imageFiles"
                 type="file"
                 accept="image/jpeg,image/png"
                 multiple
                 hidden>
        </label>
      </div>

      <p class="zt-post-image-count">
        선택한 사진
        <strong id="post-image-count">0</strong>
        / 5
      </p>

    </div>
  </div>

    <div class="col-lg-6">
      <div class="mb-3">
        <label class="form-label" for="post-title">제목</label>
        <input id="post-title" name="title" class="form-control" type="text" maxlength="60" placeholder="여행 제목" required>
      </div>
      <div class="mb-3">
        <label class="form-label"
               for="post-place">여행 장소</label>
        <input id="post-place" name="place" class="form-control" type="text" placeholder="예: 서울 망원동" required>
      </div>
      <div class="mb-3">
        <label class="form-label" for="post-content">내용</label>
        <textarea id="post-content"
                  name="content"
                  class="form-control"
                  rows="8"
                  placeholder="여행 내용을 적어 주세요."
                  required></textarea>
      </div>

      <div class="mb-3">
        <label class="form-label" for="transport-cost">교통비</label>
        <input id="transport-cost"
               name="transportCost"
               class="form-control"
               type="number"
               min="0"
               value="0"
               onfocus="if (this.value === '0') { this.value = ''; }"
               onblur="if (this.value === '') { this.value = '0'; }"
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
               onfocus="if (this.value === '0') { this.value = ''; }"
               onblur="if (this.value === '') { this.value = '0'; }"
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
               onfocus="if (this.value === '0') { this.value = ''; }"
               onblur="if (this.value === '') { this.value = '0'; }"
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
<script src="${pageContext.request.contextPath}/assets/js/post-image-preview.js"></script>
<script>
  // 서버에서 비속어/도배/글자수 제한으로 인해 errorMessage를 전달받은 경우 즉시 팝업 경고창 출력
  <c:if test="${not empty errorMessage}">
  alert("${errorMessage}");
  </c:if>

  // 특수문자, 띄어쓰기, 리트스피크(Leetspeak) 변형을 원천 무력화하는 정규화 함수
  function getSanitizedText(str) {
    if (!str) return "";
    return str.toLowerCase()
            .replace(/[\s\p{P}\p{S}]/gu, "") // 공백, 구두점, 특수문자 전면 제거
            .replace(/@/g, "a")
            .replace(/1/g, "i")
            .replace(/3/g, "e")
            .replace(/4/g, "a")
            .replace(/0/g, "o")
            .replace(/5/g, "s")
            .replace(/7/g, "t");
  }

  document.addEventListener("DOMContentLoaded", function () {
    const submitBtn = document.querySelector("#submitBtn") || document.querySelector("button[type='submit']") || document.querySelector(".zt-submit-btn");
    const postForm = document.querySelector("#postSubmitForm") || document.querySelector("form");

    function validateAndBlock(e) {
      const titleInput = document.querySelector("#postTitle") || document.querySelector("input[name='title']");
      const contentInput = document.querySelector("#postContent") || document.querySelector("textarea[name='content']");

      const title = titleInput ? titleInput.value.trim() : "";
      const content = contentInput ? contentInput.value.trim() : "";

      // 1. 내용 공백 및 글자수 체크 (10자 미만)
      if (content === "" || content.length < 10) {
        alert("미션 인증을 위해 내용을 10자 이상 작성해주세요.");
        if (e) {
          e.preventDefault();
          e.stopImmediatePropagation();
        }
        return false;
      }

      // 2. 한국어 자음/모음 도배 체크 (ㅋㅋㅋ, ㅠㅠㅠ 등)
      const koreanJamoOnly = /^[ㄱ-ㅎㅏ-ㅣ\s]+$/;
      if (koreanJamoOnly.test(content)) {
        alert("자음이나 모음만으로는 미션을 인증할 수 없습니다. 의미 있는 내용을 입력해주세요.");
        if (e) {
          e.preventDefault();
          e.stopImmediatePropagation();
        }
        return false;
      }

      // 3. 동일한 문자/알파벳 과도한 반복 체크 (예: aaaaaa, ㅠㅠㅠㅠㅠㅠ 등 6회 이상)
      const excessiveRepetition = /(.)\1{5,}/;
      if (excessiveRepetition.test(content)) {
        alert("동일한 문자나 알파벳의 지나친 반복은 등록할 수 없습니다.");
        if (e) {
          e.preventDefault();
          e.stopImmediatePropagation();
        }
        return false;
      }

      // 4. 정화된 텍스트(Leetspeak 및 특수문자 제거 적용)를 통한 한·영 비속어 및 금지어 필터링
      const cleanContent = getSanitizedText(content);
      const cleanTitle = getSanitizedText(title);

      // 한국어 및 영어 주요 비속어, 슬랭, 패드립 리스트
      const badWords = [
        // 한국어
        "시발", "욕설", "병신", "개새끼", "ㅅㅂ", "ㅂㅅ", "지랄", "미친", "새끼", "꺼져", "호구",
        // 영어 비속어 및 슬랭 (English Profanity & Slang)
        "fuck", "shit", "bitch", "asshole", "motherfucker", "bastard", "crap",
        "dick", "pussy", "cunt", "slut", "whore", "fag", "nigger", "stfu", "gtfo"
      ];

      for (let word of badWords) {
        const cleanWord = getSanitizedText(word);
        if (cleanContent.includes(cleanWord) || cleanTitle.includes(cleanWord)) {
          alert("욕설, 비속어 또는 부적절한 영어 표현은 올릴 수 없습니다.");
          if (e) {
            e.preventDefault();
            e.stopImmediatePropagation();
            if (e.stopPropagation) e.stopPropagation();
          }
          return false;
        }
      }

      return true; // 모든 검증 통과
    }

    // 폼 제출(submit) 이벤트 차단 바인딩
    if (postForm) {
      postForm.addEventListener("submit", function (e) {
        if (!validateAndBlock(e)) {
          e.preventDefault();
          e.stopImmediatePropagation();
        }
      }, true);
    }

    // 버튼 클릭(click) 이벤트 강제 차단 바인딩 (AJAX 및 일반 제출 양쪽 대응)
    if (submitBtn) {
      submitBtn.addEventListener("click", function (e) {
        if (!validateAndBlock(e)) {
          e.preventDefault();
          e.stopImmediatePropagation();
          e.stopPropagation();
        }
      }, true);
    }
  });
</script>



</body>
</html>
