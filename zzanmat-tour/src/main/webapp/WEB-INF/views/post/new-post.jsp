<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="여행 게시물 작성 페이지 / Travel Post Creation Page">
  <title>새 게시물 / New Post | 짠맛투어</title>
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
        <h1>새 게시물 만들기 / Create New Post</h1>
        <p>사진, 여행 동선, 경비와 태그를 입력합니다. / Enter photos, travel route, expenses, and tags.</p>
      </header>

      <section class="zt-panel zt-profile-card">
        <!-- 폼 제출 시 강력 검증 함수 호출 -->
        <form class="row g-4"
              action="${pageContext.request.contextPath}/new-post"
              method="post"
              enctype="multipart/form-data"
              onsubmit="return validateAndBlock(event);">
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
                  <strong>사진을 선택하세요 / Select Photos</strong>
                  <small>JPG, PNG 파일을 최대 5장까지 선택할 수 있습니다. / Up to 5 JPG/PNG files.</small>
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
                  <span>사진 / Photo</span>

                  <input id="new-post-image"
                         name="imageFiles"
                         type="file"
                         accept="image/jpeg,image/png"
                         multiple
                         hidden>
                </label>
              </div>

              <p class="zt-post-image-count">
                선택한 사진 / Selected Photos:
                <strong id="post-image-count">0</strong>
                / 5
              </p>

            </div>
          </div>

          <div class="col-lg-6">
            <div class="mb-3">
              <label class="form-label" for="post-title">제목 / Title</label>
              <input id="post-title" name="title" class="form-control" type="text" maxlength="60" placeholder="여행 제목을 입력하세요 / Enter travel title" required>
            </div>
            <div class="mb-3">
              <label class="form-label" for="post-place">여행 장소 / Location</label>
              <input id="post-place" name="place" class="form-control" type="text" placeholder="예: 서울 망원동 / e.g., Mangwon-dong, Seoul" required>
            </div>
            <div class="mb-3">
              <label class="form-label" for="post-content">내용 / Content</label>
              <textarea id="post-content"
                        name="content"
                        class="form-control"
                        rows="8"
                        placeholder="여행 내용을 적어 주세요. (최소 10자 이상) / Please write at least 10 characters."
                        required></textarea>
            </div>

            <div class="mb-3">
              <label class="form-label" for="transport-cost">교통비 / Transport Cost</label>
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
              <label class="form-label" for="food-cost">식비 / Food Cost</label>
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
                입장료 및 기타 비용 / Other Expenses
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
              <label class="form-label" for="post-tags">태그 / Tags</label>
              <input id="post-tags" class="form-control" type="text" placeholder="#서울여행 #가성비여행 / #Travel #Budget">
            </div>
            <div class="form-check form-switch mb-4">
              <input id="share-route" class="form-check-input" type="checkbox" checked>
              <label class="form-check-label" for="share-route">여행 동선 공개 / Share Travel Route</label>
            </div>
            <button class="btn btn-primary zt-primary-btn w-100 py-2" type="submit">작성 완료 / Complete</button>
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
  const isKoreanLang = navigator.language.startsWith('ko');

  function getSanitizedText(str) {
    if (!str) return "";
    return str.toLowerCase()
            .replace(/[\s\p{P}\p{S}]/gu, "")
            .replace(/@/g, "a")
            .replace(/1/g, "i")
            .replace(/3/g, "e")
            .replace(/4/g, "a")
            .replace(/0/g, "o")
            .replace(/5/g, "s")
            .replace(/7/g, "t");
  }

  function validateAndBlock(e) {
    const titleInput = document.querySelector("#post-title");
    const contentInput = document.querySelector("#post-content");

    const title = titleInput ? titleInput.value.trim() : "";
    const content = contentInput ? contentInput.value.trim() : "";

    // 1. 최소 길이 체크 (10자 미만)
    if (content === "" || content.length < 10) {
      alert(isKoreanLang
              ? "미션 인증을 위해 내용을 10자 이상 작성해주세요."
              : "Please write at least 10 characters for mission verification.");
      if (e) e.preventDefault();
      return false;
    }

    // 2. 순수 자음/모음 테러 글 차단 (예: ㅋㅋㅋ, ㅎㅎㅎ, ㅠㅠ)
    if (/^[ㄱ-ㅎㅏ-ㅣ\s]+$/.test(content)) {
      alert(isKoreanLang
              ? "자음이나 모음만으로는 미션을 인증할 수 없습니다."
              : "You cannot verify the mission with consonants or vowels only.");
      if (e) e.preventDefault();
      return false;
    }

    // 3. [강력 업그레이드] 키보드 난타 영단어 차단 (모음이 있더라도 8글자 이상 연속으로 의미 없이 길게 늘어쓴 난타, 예: asdjsadhal...)
    const words = content.split(/\s+/);
    for (let word of words) {
      // 8글자 이상의 영단어 중, 정상적인 영어 단어 사전에 자주 쓰이는 패턴이 아닌 무작위 연타 패턴 감지
      if (/^[a-zA-Z]{8,}$/.test(word)) {
        // 자음과 모음이 번갈아 나오는 정상 단어 형태가 아니라 알파벳이 무작위로 뭉쳐 있는 난타 판정
        const consonantClusters = word.match(/[b-df-hj-np-tv-z]{4,}/i); // 자음이 4개 이상 연속되면 난타
        if (consonantClusters || /(.)\1{2,}/.test(word)) {
          alert(isKoreanLang
                  ? "[차단] 의미 없는 키보드 난타 글은 등록할 수 없습니다."
                  : "Meaningless keyboard mash is not allowed.");
          if (e) e.preventDefault();
          return false;
        }
      }
    }

    // 4. 한글 자음/모음 파편이나 의미 없는 기호가 섞인 도배/테러 글 차단
    const hasBrokenKorean = /[ㄱ-ㅎㅏ-ㅣ]/.test(content);
    const hasRegionalTitle = /seoul|busan|daegu|incheon|광주|대전|울산|제주|서울|부산|대구|인천/.test(title.toLowerCase());

    if (hasRegionalTitle && (hasBrokenKorean || content.length < 15)) {
      alert(isKoreanLang
              ? "[차단] 지역명 제목에 무의미한 자음/모음 파편이나 도배성 내용은 인증될 수 없습니다."
              : "Spam or broken text with regional titles is not allowed.");
      if (e) e.preventDefault();
      return false;
    }

    // 5. 반복적인 글자 도배 차단 (예: ㅋㅋㅋㅋㅋ, aaaaaa 등)
    if (/(.)\1{4,}/.test(content) || /(..+)\1{3,}/.test(content)) {
      alert(isKoreanLang
              ? "[차단] 반복적인 도배성 내용은 등록할 수 없습니다."
              : "Repetitive spam content is not allowed.");
      if (e) e.preventDefault();
      return false;
    }

    // 6. 욕설 및 비속어 필터링
    const cleanContent = getSanitizedText(content);
    const cleanTitle = getSanitizedText(title);

    const badWords = [
      "시발", "씨발", "병신", "개새끼", "ㅅㅂ", "ㅂㅅ", "지랄", "미친", "꺼져", "엿먹", "닥쳐",
      "fuck", "shit", "bitch", "asshole", "motherfucker", "bastard", "cunt", "dick"
    ];

    for (let word of badWords) {
      const cleanWord = getSanitizedText(word);
      if (cleanContent.includes(cleanWord) || cleanTitle.includes(cleanWord)) {
        alert(isKoreanLang
                ? "욕설, 비속어 또는 부적절한 테러성 내용은 올릴 수 없습니다."
                : "Profanity, slang, or inappropriate content cannot be uploaded.");
        if (e) e.preventDefault();
        return false;
      }
    }

    return true; // 정상적인 영어/한글 후기는 모두 정상 통과!
  }
</script>
</body>
</html>