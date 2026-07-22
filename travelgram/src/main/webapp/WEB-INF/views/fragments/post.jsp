<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:url var="profileUrl" value="${param.profile}"/><c:url var="imageUrl" value="${param.image}"/>
<article class="tg-panel tg-post">
    <header class="tg-post-header"><img class="tg-avatar" src="${profileUrl}" alt="${param.user}">
        <div class="tg-user-meta"><strong>${param.user}</strong><small>${param.place} · 2시간 전</small></div>
        <button class="tg-icon-btn" aria-label="더보기"><i class="bi bi-three-dots"></i></button>
    </header>
    <img class="tg-post-image" src="${imageUrl}" alt="${param.place} 여행 사진">
    <div class="tg-actions">
        <button class="tg-icon-btn" data-like-button data-like-target="#likes-${param.id}" aria-label="좋아요"><i
                class="bi bi-heart"></i></button>
        <button class="tg-icon-btn" aria-label="댓글"><i class="bi bi-chat"></i></button>
        <button class="tg-icon-btn" aria-label="공유"><i class="bi bi-send"></i></button>
        <button class="tg-icon-btn save" aria-label="저장"><i class="bi bi-bookmark"></i></button>
    </div>
    <div class="tg-post-body"><p class="likes" id="likes-${param.id}" data-count="${param.likes}">
        좋아요 ${param.likes}개</p>
        <p><strong>${param.user}</strong> ${param.caption} <a class="tg-hashtag" href="#tag">#여행기록 #travelgram</a></p>
        <button class="tg-muted-btn">댓글 모두 보기</button>
        <div data-comment-list></div>
    </div>
    <form class="tg-comment" data-comment-form><i class="bi bi-emoji-smile"></i><input placeholder="댓글 달기..."
                                                                                       aria-label="댓글">
        <button type="submit">게시</button>
    </form>
</article>
