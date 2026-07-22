<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:url var="homeUrl" value="/"/>
<aside class="tg-sidebar">
    <a class="tg-brand" href="${homeUrl}"><b class="tg-brand-mark"><i
            class="bi bi-camera"></i></b><span>travelgram</span></a>
    <nav class="tg-nav" aria-label="주요 메뉴">
        <a class="tg-nav-link ${param.active eq 'home' ? 'active' : ''}" href="${homeUrl}"><i
                class="bi bi-house"></i><span>홈</span></a>
        <a class="tg-nav-link" href="#discover"><i class="bi bi-grid-3x3-gap"></i><span>여행 둘러보기</span></a>
        <a class="tg-nav-link" href="#chat"><i class="bi bi-chat-dots"></i><span>실시간 채팅</span></a>
        <a class="tg-nav-link" href="#tag"><i class="bi bi-hash"></i><span>태그</span></a>
        <a class="tg-nav-link" href="#mission"><i class="bi bi-flag"></i><span>Mission Possible</span></a>
        <a class="tg-nav-link" href="#profile"><i class="bi bi-person-circle"></i><span>내 정보</span></a>
        <a class="tg-nav-link" href="#new"><i class="bi bi-plus-square"></i><span>게시물 만들기</span></a>
    </nav>
    <footer class="tg-sidebar-footer">이용약관 · 개인정보처리방침<br>© 2026 Travelgram</footer>
</aside>
