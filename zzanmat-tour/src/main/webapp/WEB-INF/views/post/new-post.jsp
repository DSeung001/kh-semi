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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/post-image-preview.js"></script>

<script>
  const contextPath = "${pageContext.request.contextPath}";

  // URL 및 서버에서 missionId 안전하게 가져오기
  const urlParams = new URLSearchParams(window.location.search);
  let rawMissionId = urlParams.get('missionId');
  let missionId = '';

  if (rawMissionId) {
    missionId = rawMissionId.toString().replace(/[^0-9]/g, '');
  }
  if (!missionId) {
    missionId = "${mission != null ? mission.missionId : ''}";
  }

  const missionType = "${mission != null ? mission.missionType : 'POST'}";

  // 페이지 로드 시 미션 진행률 동기화 및 폼 검증 실행
  document.addEventListener("DOMContentLoaded", function () {
    console.log("현재 감지된 missionId:", missionId); // F12 콘솔에서 확인용

    if (missionId) {
      refreshMissionProgress();
    } else {
      const summary = document.getElementById("progress-summary");
      if (summary) summary.innerText = "조회할 미션 정보가 없습니다. 미션 목록에서 미션을 선택해주세요.";
      const actionBtn = document.getElementById("missionActionBtn");
      if (actionBtn) actionBtn.style.display = "none";
    }

    const actionBtn = document.getElementById("missionActionBtn");
    if (actionBtn) {
      actionBtn.addEventListener("click", function (e) {
        e.preventDefault();
        if (missionType === 'CHAT') {
          window.location.href = contextPath + '/chat';
          return;
        }
        if (missionType === 'COMMENT' || missionType === 'LIKE') {
          window.location.href = contextPath + '/my-travel';
          return;
        }
        if (!missionId) {
          alert("미션 정보가 올바르지 않습니다.");
          return;
        }
        window.location.href = contextPath + '/new-post?missionId=' + missionId;
      });
    }

    // --- 게시글 작성 폼 비속어 및 도배 방지 검증 로직 ---
    const submitBtn = document.querySelector("#submitBtn") || document.querySelector("button[type='submit']") || document.querySelector(".zt-submit-btn");
    const postForm = document.querySelector("#postSubmitForm") || document.querySelector("form");

    function validateAndBlock(e) {
      const titleInput = document.querySelector("#postTitle") || document.querySelector("input[name='title']");
      const contentInput = document.querySelector("#postContent") || document.querySelector("textarea[name='content']");

      const title = titleInput ? titleInput.value.trim() : "";
      const content = contentInput ? contentInput.value.trim() : "";

      if (content === "" || content.length < 10) {
        alert("미션 인증을 위해 내용을 10자 이상 작성해주세요.");
        if (e) { e.preventDefault(); e.stopImmediatePropagation(); }
        return false;
      }

      const koreanJamoOnly = /^[ㄱ-ㅎㅏ-ㅣ\s]+$/;
      if (koreanJamoOnly.test(content)) {
        alert("자음이나 모음만으로는 미션을 인증할 수 없습니다. 의미 있는 내용을 입력해주세요.");
        if (e) { e.preventDefault(); e.stopImmediatePropagation(); }
        return false;
      }

      const excessiveRepetition = /(.)\1{5,}/;
      if (excessiveRepetition.test(content)) {
        alert("동일한 문자나 알파벳의 지나친 반복은 등록할 수 없습니다.");
        if (e) { e.preventDefault(); e.stopImmediatePropagation(); }
        return false;
      }

      const cleanContent = getSanitizedText(content);
      const cleanTitle = getSanitizedText(title);
      const badWords = [
        "시발", "씨발", "병신", "개새끼", "ㅅㅂ", "ㅂㅅ", "지랄", "미친", "꺼져",
        "fuck", "shit", "motherfucker", "scum", "bitch", "asshole", "bastard"
      ];

      for (let word of badWords) {
        const cleanWord = getSanitizedText(word);
        if (cleanContent.includes(cleanWord) || cleanTitle.includes(cleanWord)) {
          alert("욕설이나 비속어는 올릴 수 없습니다.");
          if (e) { e.preventDefault(); e.stopImmediatePropagation(); if (e.stopPropagation) e.stopPropagation(); }
          return false;
        }
      }
      return true;
    }

    if (postForm) {
      postForm.addEventListener("submit", function (e) {
        if (!validateAndBlock(e)) {
          e.preventDefault();
          e.stopImmediatePropagation();
        }
      }, true);
    }

    if (submitBtn) {
      submitBtn.addEventListener("click", function (e) {
        if (!validateAndBlock(e)) {
          e.preventDefault();
          e.stopImmediatePropagation();
          if (e.stopPropagation) e.stopPropagation();
        }
      }, true);
    }
  });

  window.addEventListener("pageshow", function () {
    if (missionId) refreshMissionProgress();
  });
  document.addEventListener("visibilitychange", function () {
    if (document.visibilityState === "visible" && missionId) {
      refreshMissionProgress();
    }
  });

  function statusLabel(status, periodStatus) {
    if (periodStatus === 'EXPIRED') return '기간 종료';
    if (periodStatus === 'UPCOMING') return '예정';
    if (status === 'DONE') return '완료';
    if (status === 'IN_PROGRESS') return '진행 중';
    if (status === 'READY') return '대기';
    if (!status) return '미시작';
    return status;
  }
  function refreshMissionProgress() {
    if (!missionId) {
      console.warn("missionId가 존재하지 않습니다.");
      return;
    }

    console.log("진행률 조회 요청 URL:", contextPath + '/api/mission/progress?missionId=' + missionId);

    fetch(contextPath + '/api/mission/progress?missionId=' + missionId)
            .then(res => {
              if (!res.ok) {
                throw new Error("서버 응답 코드가 비정상적입니다: " + res.status);
              }
              return res.json();
            })
            .then(response => {
              console.log("서버 응답 데이터:", response);

              if (!response || !response.success || !response.data) {
                console.warn("데이터 형식이 올바르지 않습니다.");
                return;
              }

              const data = response.data;
              const currentCount = data.currentCount || 0;
              const targetCount = data.targetCount || 0;
              const percent = data.percent || 0;

              const textDisplay = document.getElementById("progress-text-display");
              if (textDisplay) textDisplay.innerText = currentCount + " / " + targetCount;

              const bar = document.getElementById("progress-bar-element");
              if (bar) {
                bar.style.width = percent + "%";
                bar.setAttribute("aria-valuenow", percent);
              }

              const statusEl = document.getElementById("missionStatus");
              if (statusEl) statusEl.innerText = "상태: " + statusLabel(data.status, data.periodStatus);

              const summary = document.getElementById("progress-summary");
              if (summary) {
                if (!data.loggedIn) {
                  summary.innerText = "로그인하면 미션을 진행할 수 있어요.";
                } else if (data.periodStatus === 'EXPIRED') {
                  summary.innerText = "이 미션은 수행 기간이 끝났어요.";
                } else if (data.periodStatus === 'UPCOMING') {
                  summary.innerText = "아직 시작 전인 미션이에요.";
                } else if (data.status === 'DONE') {
                  summary.innerText = data.rewardReceived ? "미션 완료! 포인트가 지급됐어요." : "미션 완료!";
                } else {
                  summary.innerText = "목표 " + targetCount + "회 중 " + currentCount + "회 진행 중이에요.";
                }
              }

              const canAct = data.loggedIn && data.available && data.status !== 'DONE';
              const actionBtn = document.getElementById("missionActionBtn");
              if (actionBtn) {
                actionBtn.style.display = canAct ? "block" : "none";
              }
            })
            .catch(err => {
              console.error("진행 상황 동기화 중 에러 발생:", err);
            });
  }
    // 1. 우회 문자, 특수문자, 리트스피크(Leetspeak) 정화 함수
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

    document.addEventListener("DOMContentLoaded", function () {
    const postForm = document.querySelector("form");
    const submitBtn = document.querySelector("button[type='submit']") || document.querySelector(".zt-primary-btn");

    function validateAndBlock(e) {
    const titleInput = document.querySelector("#post-title") || document.querySelector("input[name='title']");
    const contentInput = document.querySelector("#post-content") || document.querySelector("textarea[name='content']");

    const title = titleInput ? titleInput.value.trim() : "";
    const content = contentInput ? contentInput.value.trim() : "";

    // ① 글자수 10자 미만 차단
    if (content === "" || content.length < 10) {
    alert("미션 인증을 위해 내용을 10자 이상 작성해주세요.");
    if (e) {
    e.preventDefault();
    e.stopImmediatePropagation();
  }
    return false;
  }

    // ② 자음/모음 도배 체크 (ㅋㅋㅋ, ㅠㅠㅠ 등)
    if (/^[ㄱ-ㅎㅏ-ㅣ\s]+$/.test(content)) {
    alert("자음이나 모음만으로는 미션을 인증할 수 없습니다. 의미 있는 내용을 입력해주세요.");
    if (e) {
    e.preventDefault();
    e.stopImmediatePropagation();
  }
    return false;
  }

    // ③ 동일 문자 지나친 반복 체크 (6회 이상)
    if (/(.)\1{5,}/.test(content)) {
    alert("동일한 문자나 알파벳의 지나친 반복은 등록할 수 없습니다.");
    if (e) {
    e.preventDefault();
    e.stopImmediatePropagation();
  }
    return false;
  }

    // ④ 한·영 비속어 및 우회 욕설 필터링 (정화된 텍스트 검사)
    const cleanContent = getSanitizedText(content);
    const cleanTitle = getSanitizedText(title);

    const badWords = [
    "시발", "씨발", "병신", "개새끼", "ㅅㅂ", "ㅂㅅ", "지랄", "미친", "꺼져", "호구",
    "fuck", "shit", "motherfucker", "scum", "bitch", "asshole", "bastard", "crap", "stfu"
    ];

    for (let word of badWords) {
    const cleanWord = getSanitizedText(word);
    if (cleanContent.includes(cleanWord) || cleanTitle.includes(cleanWord)) {
    alert("욕설, 비속어 또는 부적절한 도배 문자는 올릴 수 없습니다.");
    if (e) {
    e.preventDefault();
    e.stopImmediatePropagation();
    if (e.stopPropagation) e.stopPropagation();
  }
    return false;
  }
  }

    return true; // 모든 검증 통과 시 정상 등록 진행
  }

    // 폼 전송(submit) 이벤트 가로채기
    if (postForm) {
    postForm.addEventListener("submit", function (e) {
    if (!validateAndBlock(e)) {
    e.preventDefault();
    e.stopImmediatePropagation();
  }
  }, true);
  }

    // 버튼 클릭(click) 이벤트 가로채기 (이중 방어)
    if (submitBtn) {
    submitBtn.addEventListener("click", function (e) {
    if (!validateAndBlock(e)) {
    e.preventDefault();
    e.stopImmediatePropagation();
    if (e.stopPropagation) e.stopPropagation();
  }
  }, true);
  }
  });
</script>
</body>
</html>