<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:url var="soraProfile" value="/assets/images/profile-sora.svg"/>
<c:url var="minProfile" value="/assets/images/profile-min.svg"/>
<aside class="tg-right-rail">
    <section id="login" class="tg-card"><h2>로그인</h2>
        <p class="tg-note">여행 기록을 남기고 새로운 여행자를 만나보세요.</p>
        <form class="tg-stack" data-demo-form><input class="form-control form-control-sm" placeholder="아이디"
                                                     aria-label="아이디"><input class="form-control form-control-sm"
                                                                             type="password" placeholder="비밀번호"
                                                                             aria-label="비밀번호">
            <button class="btn btn-primary btn-sm" type="submit">로그인</button>
        </form>
        <div class="tg-auth-links"><a href="#signup">회원가입</a><a href="#forgot">비밀번호 찾기</a></div>
    </section>
    <section class="tg-card tg-suggestions"><h2>추천 여행자</h2>
        <div class="tg-user-row"><img class="tg-avatar small" src="${soraProfile}" alt="travel_sora">
            <div><strong>travel_sora</strong><small>서울 골목 여행</small></div>
            <button data-follow-button>팔로우</button>
        </div>
        <div class="tg-user-row"><img class="tg-avatar small" src="${minProfile}" alt="budget_min">
            <div><strong>budget_min</strong><small>가성비 여행</small></div>
            <button data-follow-button>팔로우</button>
        </div>
    </section>
</aside>
