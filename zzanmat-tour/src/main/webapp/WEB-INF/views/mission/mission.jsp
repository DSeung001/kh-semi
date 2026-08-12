<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="여행 미션 목록">
    <title>여행 미션 | 짠맛투어</title>
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
        <a href="${pageContext.request.contextPath}/new-post" class="" aria-label="new"><i class="bi bi-plus-square"></i></a>
        <a href="${pageContext.request.contextPath}/chat" class="" aria-label="chat"><i class="bi bi-chat-dots"></i></a>
        <a href="${pageContext.request.contextPath}/profile" class="" aria-label="profile"><i class="bi bi-person-circle"></i></a>
    </nav>
    <div class="zt-layout">

        <jsp:include page="/WEB-INF/views/components/sidebar.jsp">
            <jsp:param name="activePage" value="mission" />
        </jsp:include>

        <main class="zt-content">

            <header class="zt-page-header">
                <h1>여행 미션</h1>
                <p>조건에 맞는 행동을 하면 포인트가 쌓여요.</p>
            </header>

            <section class="zt-panel zt-mission-list" id="missionListSection">
                <c:choose>
                    <c:when test="${empty missions}">
                        <p class="text-center text-muted py-4">등록된 미션이 없습니다.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="mission" items="${missions}">
                            <c:set var="isDone" value="${mission.userStatus == 'DONE'}"/>
                            <c:set var="cardClass" value="zt-mission-card"/>
                            <c:choose>
                                <c:when test="${isDone}">
                                    <c:set var="cardClass" value="zt-mission-card is-done"/>
                                </c:when>
                                <c:when test="${mission.periodStatus == 'EXPIRED'}">
                                    <c:set var="cardClass" value="zt-mission-card is-expired"/>
                                </c:when>
                                <c:when test="${mission.periodStatus == 'UPCOMING'}">
                                    <c:set var="cardClass" value="zt-mission-card is-upcoming"/>
                                </c:when>
                            </c:choose>

                            <article class="${cardClass}">
                                <div class="zt-mission-icon">
                                    <i class="bi
                                        <c:choose>
                                            <c:when test='${mission.missionType == "COMMENT"}'>bi-chat-left-text</c:when>
                                            <c:when test='${mission.missionType == "LIKE"}'>bi-heart</c:when>
                                            <c:when test='${mission.missionType == "CHAT"}'>bi-chat-dots</c:when>
                                            <c:when test='${mission.missionType == "POST"}'>bi-pencil-square</c:when>
                                            <c:otherwise>bi-bookmark-check</c:otherwise>
                                        </c:choose>">
                                    </i>
                                </div>
                                <div>
                                    <div class="d-flex flex-wrap gap-2 align-items-center mb-1">
                                        <h2 class="h6 fw-bold mb-0">${mission.title}</h2>
                                        <span class="zt-chip">
                                            <c:choose>
                                                <c:when test='${mission.missionType == "COMMENT"}'>댓글</c:when>
                                                <c:when test='${mission.missionType == "LIKE"}'>좋아요</c:when>
                                                <c:when test='${mission.missionType == "CHAT"}'>오픈 채팅</c:when>
                                                <c:otherwise>포스트</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <span class="badge bg-success-subtle text-success border border-success-subtle">
                                            +<fmt:formatNumber value="${mission.rewardPoint}" type="number"/>P
                                        </span>
                                        <c:choose>
                                            <c:when test="${isDone}">
                                                <span class="badge bg-success">완료</span>
                                            </c:when>
                                            <c:when test="${mission.periodStatus == 'EXPIRED'}">
                                                <span class="badge bg-secondary">기간 종료</span>
                                            </c:when>
                                            <c:when test="${mission.periodStatus == 'UPCOMING'}">
                                                <span class="badge bg-info-subtle text-info border border-info-subtle">예정</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle">진행 가능</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <p class="small mb-1 fw-medium">
                                        <c:choose>
                                            <c:when test="${isDone}">미션 완료</c:when>
                                            <c:when test='${mission.missionType == "COMMENT"}'>댓글 작성으로 도전</c:when>
                                            <c:when test='${mission.missionType == "LIKE"}'>좋아요로 도전</c:when>
                                            <c:when test='${mission.missionType == "CHAT"}'>채팅 메시지로 도전</c:when>
                                            <c:otherwise>게시글 작성으로 도전</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <p class="zt-muted small mb-1">${mission.description}</p>
                                    <p class="zt-muted small mb-0">
                                        <c:choose>
                                            <c:when test="${mission.startAt != null && mission.endAt != null}">
                                                <c:set var="startAtText" value="${mission.startAt}"/>
                                                <c:set var="endAtText" value="${mission.endAt}"/>
                                                기간: ${fn:replace(startAtText, 'T', ' ')} ~ ${fn:replace(endAtText, 'T', ' ')}
                                            </c:when>
                                            <c:when test="${mission.startAt != null}">
                                                <c:set var="startAtText" value="${mission.startAt}"/>
                                                시작: ${fn:replace(startAtText, 'T', ' ')}
                                            </c:when>
                                            <c:when test="${mission.endAt != null}">
                                                <c:set var="endAtText" value="${mission.endAt}"/>
                                                종료: ${fn:replace(endAtText, 'T', ' ')}
                                            </c:when>
                                            <c:otherwise>
                                                기간 제한 없음
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                <c:choose>
                                    <c:when test="${isDone}">
                                        <a class="btn btn-success fw-bold"
                                           href="${pageContext.request.contextPath}/mission/active?missionId=${mission.missionId}">
                                            완료
                                        </a>
                                    </c:when>
                                    <c:when test="${mission.available}">
                                        <a class="btn btn-warning fw-bold"
                                           href="${pageContext.request.contextPath}/mission/active?missionId=${mission.missionId}">
                                            도전하기
                                        </a>
                                    </c:when>
                                    <c:when test="${mission.periodStatus == 'EXPIRED'}">
                                        <button class="btn btn-secondary fw-bold" type="button" disabled>기간 종료</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-outline-secondary fw-bold" type="button" disabled>예정</button>
                                    </c:otherwise>
                                </c:choose>
                            </article>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </section>

        </main>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
<script>
    const contextPath = "${pageContext.request.contextPath}";

    document.addEventListener("DOMContentLoaded", function () {
        // 1. 등록 버튼 또는 폼을 모두 감지
        const submitBtn = document.querySelector("#submitBtn") || document.querySelector("button[type='submit']") || document.querySelector(".zt-submit-btn");
        const postForm = document.querySelector("#postSubmitForm") || document.querySelector("form");

        function validateAndBlock(e) {
            const titleInput = document.querySelector("#postTitle") || document.querySelector("input[name='title']");
            const contentInput = document.querySelector("#postContent") || document.querySelector("textarea[name='content']");

            const title = titleInput ? titleInput.value.trim() : "";
            const content = contentInput ? contentInput.value.trim() : "";

            // 2. 내용 공백 및 글자수 체크
            if (content === "" || content.length < 10) {
                alert("미션 인증을 위해 내용을 10자 이상 작성해주세요.");
                if (e) {
                    e.preventDefault();
                    e.stopImmediatePropagation();
                }
                return false;
            }

            // 3. 자음/모음 도배 체크 (ㅋㅋㅋ, ㅠㅠㅠ 등)
            const koreanJamoOnly = /^[ㄱ-ㅎㅏ-ㅣ\s]+$/;
            if (koreanJamoOnly.test(content)) {
                alert("자음이나 모음만으로는 미션을 인증할 수 없습니다. 의미 있는 내용을 입력해주세요.");
                if (e) {
                    e.preventDefault();
                    e.stopImmediatePropagation();
                }
                return false;
            }

            // 4. 동일한 문자 과도한 반복 체크
            const excessiveRepetition = /(.)\1{5,}/;
            if (excessiveRepetition.test(content)) {
                alert("동일한 문자나 알파벳의 지나친 반복은 등록할 수 없습니다.");
                if (e) {
                    e.preventDefault();
                    e.stopImmediatePropagation();
                }
                return false;
            }

            // 5. 욕설 및 비속어 필터링
            const badWords = [ "fuck", "shit","motherfucker", " scum", "시발", "씨발", "병신", "개새끼", "ㅅㅂ", "ㅂㅅ"];
            for (let word of badWords) {
                if (content.toLowerCase().includes(word.toLowerCase()) ||
                    title.toLowerCase().includes(word.toLowerCase())) {
                    alert("욕설이나 비속어는 올릴 수 없습니다.");
                    if (e) {
                        e.preventDefault();
                        e.stopImmediatePropagation();
                    }
                    return false;
                }
            }
            return true; // 검증 통과
        }

        // 폼 제출(submit) 이벤트 차단
        if (postForm) {
            postForm.addEventListener("submit", function (e) {
                if (!validateAndBlock(e)) {
                    e.preventDefault();
                    e.stopImmediatePropagation();
                }
            }, true);
        }

        // 버튼 클릭(click) 이벤트 강제 차단 (AJAX 방식 대응)
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

    // 특수문자, 띄어쓰기, 리트스피크(Leetspeak) 변형을 원천 무력화하는 정규화 함수
    function getSanitizedText(str) {
        if (!str) return "";
        return str.toLowerCase()
            .replace(/[\s\p{P}\p{S}]/gu, "") // 공백, 구두점, 특수문자 전면 제거
            .replace(/@/g, "a")              // 문자 변형(Leetspeak) 치환 예시
            .replace(/1/g, "i")
            .replace(/3/g, "e")
            .replace(/4/g, "a")
            .replace(/0/g, "o");
    }

    document.addEventListener("DOMContentLoaded", function () {
        const postForm = document.querySelector("#postSubmitForm") || document.querySelector("form");

        if (postForm) {
            postForm.submitEventAttached = true;
            postForm.addEventListener("submit", function (e) {
                const titleInput = document.querySelector("#postTitle") || document.querySelector("input[name='title']");
                const contentInput = document.querySelector("#postContent") || document.querySelector("textarea[name='content']");

                const title = titleInput ? titleInput.value.trim() : "";
                const content = contentInput ? contentInput.value.trim() : "";

                // 1. 공백 및 최소 글자수 검증
                if (content === "" || content.length < 10) {
                    alert("미션 인증을 위해 내용을 10자 이상 작성해주세요.");
                    e.preventDefault();
                    e.stopImmediatePropagation();
                    return false;
                }

                // 2. 자음/모음 도배 검증 (ㅋㅋㅋ, ㅠㅠㅠ)
                if (/^[ㄱ-ㅎㅏ-ㅣ\s]+$/.test(content)) {
                    alert("자음이나 모음만으로는 미션을 인증할 수 없습니다.");
                    e.preventDefault();
                    e.stopImmediatePropagation();
                    return false;
                }

                // 3. 정화된 텍스트로 우회 욕설 필터링 검사
                const cleanContent = getSanitizedText(content);
                const cleanTitle = getSanitizedText(title);

                // 핵심 비속어 및 금지어 풀 (필요에 따라 확장)
                const badWords = ["시발", "fuck", "shit", "병신"," motherfucker", "scum", "개새끼", "ㅅㅂ", "ㅂㅅ"];

                for (let word of badWords) {
                    const cleanWord = getSanitizedText(word);
                    if (cleanContent.includes(cleanWord) || cleanTitle.includes(cleanWord)) {
                        alert("욕설이나 비속어는 올릴 수 없습니다.");
                        e.preventDefault();
                        e.stopImmediatePropagation();
                        return false;
                    }
                }
            }, true);
        }
    });

</script>
</body>
</html>
