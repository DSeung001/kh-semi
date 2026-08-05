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

            <section class="zt-panel zt-mission-list" id="missionListSection">
                <c:choose>
                    <c:when test="${empty missions}">
                        <p class="text-center text-muted py-4">등록된 미션이 없습니다.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="mission" items="${missions}">
                            <c:set var="cardClass" value="zt-mission-card"/>
                            <c:if test="${mission.periodStatus == 'EXPIRED'}">
                                <c:set var="cardClass" value="zt-mission-card is-expired"/>
                            </c:if>
                            <c:if test="${mission.periodStatus == 'UPCOMING'}">
                                <c:set var="cardClass" value="zt-mission-card is-upcoming"/>
                            </c:if>

                            <article class="${cardClass}">
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
                                        <c:choose>
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
                                    <p class="zt-muted small mb-1">${mission.description}</p>
                                    <p class="zt-muted small mb-0">
                                        <c:choose>
                                            <c:when test="${mission.startAt != null && mission.endAt != null}">
                                                기간: ${mission.startAt} ~ ${mission.endAt}
                                            </c:when>
                                            <c:when test="${mission.startAt != null}">
                                                시작: ${mission.startAt}
                                            </c:when>
                                            <c:when test="${mission.endAt != null}">
                                                종료: ${mission.endAt}
                                            </c:when>
                                            <c:otherwise>
                                                기간 제한 없음
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                <c:choose>
                                    <c:when test="${mission.available}">
                                        <a class="btn btn-warning fw-bold"
                                           href="${pageContext.request.contextPath}/mission/active?missionId=${mission.missionId}">
                                            상세보기
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
</body>
</html>
