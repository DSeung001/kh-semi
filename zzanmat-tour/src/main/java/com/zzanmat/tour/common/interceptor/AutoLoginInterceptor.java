package com.zzanmat.tour.common.interceptor;

import com.zzanmat.tour.common.util.CookieTokenUtils;
import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.member.service.MemberService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

public class AutoLoginInterceptor implements HandlerInterceptor {

    private final MemberService memberService;

    public AutoLoginInterceptor(MemberService memberService) {
        this.memberService = memberService;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();

        MemberDto loginMember = (MemberDto) session.getAttribute(SessionConst.LOGIN_MEMBER);
        if (loginMember != null) {
            if (!memberService.isCurrentLoginSession(loginMember.getId(), session.getId())) {
                session.invalidate();
                expireAutoLoginCookie(response);
                response.sendRedirect(request.getContextPath() + "/member/login?duplicateLogin=true");
                return false;
            }
            return true;
        }

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("autoLoginToken".equals(cookie.getName())) {
                    String token = cookie.getValue();

                    // 쿠키 서명 검증 및 아이디 추출
                    String username = CookieTokenUtils.validateAndGetUsername(token);

                    if (username != null) {
                        // DB에 토큰을 찾을 필요 없이, 아이디로 회원 정보만 조회하여 세션 복구
                        MemberDto member = memberService.findDetailByUserId(username);
                        if (member != null && !Boolean.TRUE.equals(member.getDeleted())) {
                            memberService.registerLoginSession(member.getId(), session.getId());
                            member.setLoginSessionId(session.getId());
                            session.setAttribute(SessionConst.LOGIN_MEMBER, member);
                        }
                    }
                    break;
                }
            }
        }
        return true;
    }

    private void expireAutoLoginCookie(HttpServletResponse response) {
        Cookie cookie = new Cookie("autoLoginToken", "");
        cookie.setPath("/");
        cookie.setMaxAge(0);
        cookie.setHttpOnly(true);
        response.addCookie(cookie);
    }
}
