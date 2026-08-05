<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="여행 미션 목록">
    <title>미션 | 짠맛투어</title>
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
                <h1>Mission Possible</h1>
                <p>재미있는 여행 미션에 도전하고 인증 기록을 남겨보세요.</p>
            </header>

            <!-- 서버사이드 렌더링(JSTL)을 통한 미션 목록 영역 -->
            <section class="zt-panel zt-mission-list" id="missionListSection">
                <c:choose>
                    <c:when test="${empty missions}">
                        <p class="text-center text-muted py-4">등록된 미션이 없습니다.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="mission" items="${missions}">
                            <article class="zt-mission-card">
                                <div class="zt-mission-icon">
                                    <i class="bi
                                        <c:choose>
                                            <c:when test='${mission.missionType == "POST"}'>bi-wallet2</c:when>
                                            <c:when test='${mission.missionType == "PHOTO"}'>bi-camera</c:when>
                                            <c:when test='${mission.missionType == "VIDEO"}'>bi-camera-video</c:when>
                                            <c:when test='${mission.missionType == "SHORTS"}'>bi-film</c:when>
                                            <c:otherwise>bi-bookmark-check</c:otherwise>
                                        </c:choose>">
                                    </i>
                                </div>
                                <div>
                                    <div class="d-flex flex-wrap gap-2 align-items-center mb-1">
                                        <h2 class="h6 fw-bold mb-0">${mission.title}</h2>
                                        <span class="zt-chip">${mission.missionType}</span>
                                        <span class="badge bg-success-subtle text-success border border-success-subtle">
                                            +<fmt:formatNumber value="${mission.rewardPoint}" type="number"/>P
                                        </span>
                                    </div>
                                    <p class="zt-muted small mb-0">${mission.description}</p>
                                </div>
                                <button class="btn btn-warning fw-bold" type="button"
                                        data-mission-accept
                                        data-mission-id="${mission.missionId}"
                                        data-redirect="${pageContext.request.contextPath}/mission/active?missionId=${mission.missionId}">
                                    미션 수락
                                </button>
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
        // 미션 수락 버튼 클릭 이벤트 처리 (POST 방식 로그인 검증 연동)
        document.addEventListener("click", function (e) {
            const btn = e.target.closest("[data-mission-accept]");
            if (btn) {
                const missionId = btn.getAttribute("data-mission-id");
                const redirectUrl = btn.getAttribute("data-redirect");

                if (!missionId || isNaN(missionId)) {
                    alert("유효하지 않은 미션입니다.");
                    return;
                }

                // POST 폼 제출 함수 호출
                checkLoginAndAcceptMission(missionId, redirectUrl);
            }
        });
    });

    // 서버로 POST 요청을 보내 로그인 상태를 확인하고 미션을 수락/진행시키는 전역 함수

    function checkLoginAndAcceptMission(mId, redirectUrl) {
        const form = document.createElement('form');
        form.method = 'POST';

        // 🚨 수정 포인트: check-auth-and-post (게시물용) 대신 미션 수락/진행을 처리하는 전용 엔드포인트로 변경
        // 예: /mission/accept 또는 /mission/check-auth-and-accept 등 백엔드 매핑 주소에 맞게 수정
        form.action = contextPath + '/mission/accept';

        // 미션 ID 파라미터 추가
        const missionInput = document.createElement('input');
        missionInput.type = 'hidden';
        missionInput.name = 'missionId';
        missionInput.value = mId;
        form.appendChild(missionInput);

        // 최종 이동 목적지 URL 파라미터 추가
        if (redirectUrl) {
            const redirectInput = document.createElement('input');
            redirectInput.type = 'hidden';
            redirectInput.name = 'redirectUrl';
            redirectInput.value = redirectUrl;
            form.appendChild(redirectInput);
        }

        document.body.appendChild(form);
        form.submit();
    }
</script>
</body>
</html>