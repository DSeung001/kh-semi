<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html><html lang="ko"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>홈 | Travelgram</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<c:url var="globalCss" value="/assets/css/global.css"/><c:url var="themeCss" value="/assets/css/theme.css"/><c:url
        var="layoutCss" value="/assets/css/layout.css"/><c:url var="componentsCss"
                                                               value="/assets/css/components.css"/><c:url var="appJs"
                                                                                                          value="/assets/js/app.js"/>
<link rel="stylesheet" href="${globalCss}">
<link rel="stylesheet" href="${themeCss}">
<link rel="stylesheet" href="${layoutCss}">
<link rel="stylesheet" href="${componentsCss}">
</head><body><div class="tg-app">
<jsp:include page="fragments/header.jsp"/>
<div class="tg-layout">
    <jsp:include page="fragments/sidebar.jsp">
        <jsp:param name="active" value="home"/>
    </jsp:include>
    <main class="tg-content"><h1 class="visually-hidden">Travelgram 여행 피드</h1>
        <form class="input-group tg-search" role="search" data-demo-form><span class="input-group-text bg-white"><i
                class="bi bi-search"></i></span><input class="form-control bg-white" type="search"
                                                       placeholder="여행지, 사용자, 해시태그 검색" aria-label="검색">
            <button class="btn btn-outline-secondary">검색</button>
        </form>
        <section class="tg-panel tg-stories" aria-label="여행 스토리"><c:forEach var="story"
                                                                            items="${['seoul:서울여행','busan:부산맛집','jeju:제주한달','gangneung:바다여행','gyeongju:역사산책','sokcho:즉흥여행']}"><c:set
                var="parts" value="${story.split(':')}"/><c:url var="storyImage"
                                                                value="/assets/images/${parts[0]}.svg"/><a
                class="tg-story" href="#${parts[0]}"><b><img src="${storyImage}"
                                                             alt="${parts[1]}"></b><span>${parts[1]}</span></a></c:forEach>
        </section>
        <jsp:include page="fragments/post.jsp">
            <jsp:param name="id" value="seoul"/>
            <jsp:param name="user" value="travel_ethan"/>
            <jsp:param name="place" value="서울"/>
            <jsp:param name="profile" value="/assets/images/profile-ethan.svg"/>
            <jsp:param name="image" value="/assets/images/seoul.svg"/>
            <jsp:param name="caption" value="교통비 포함 2만원으로 즐긴 서울 하루 여행 코스예요."/>
            <jsp:param name="likes" value="128"/>
        </jsp:include>
        <jsp:include page="fragments/post.jsp">
            <jsp:param name="id" value="jeju"/>
            <jsp:param name="user" value="travel_sora"/>
            <jsp:param name="place" value="제주"/>
            <jsp:param name="profile" value="/assets/images/profile-sora.svg"/>
            <jsp:param name="image" value="/assets/images/jeju.svg"/>
            <jsp:param name="caption" value="비가 내려 더 좋았던 제주 동쪽의 작은 마을 여행."/>
            <jsp:param name="likes" value="245"/>
        </jsp:include>
    </main>
    <jsp:include page="fragments/right-rail.jsp"/>
</div>
<nav class="tg-mobile-nav"><c:url var="homeUrl" value="/"/><a class="active" href="${homeUrl}" aria-label="홈"><i
        class="bi bi-house"></i></a><a href="#discover" aria-label="둘러보기"><i class="bi bi-grid-3x3-gap"></i></a><a
        href="#new" aria-label="만들기"><i class="bi bi-plus-square"></i></a><a href="#chat" aria-label="채팅"><i
        class="bi bi-chat-dots"></i></a><a href="#profile" aria-label="프로필"><i class="bi bi-person-circle"></i></a>
</nav>
</div><script src="${appJs}"></script></body></html>
