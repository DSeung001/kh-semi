package com.zzanmat.tour.common.interceptor;

import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.member.dto.MemberDto;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class AdminInterceptor implements HandlerInterceptor {

    private static final String ADMIN_ROLE = "ADMIN";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        MemberDto loginMember = null;
        if (session != null) {
            Object attr = session.getAttribute(SessionConst.LOGIN_MEMBER);
            if (attr instanceof MemberDto) {
                loginMember = (MemberDto) attr;
            }
        }

        if (loginMember != null && ADMIN_ROLE.equals(loginMember.getRole())) {
            return true;
        }

        if (isApiRequest(request)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json; charset=UTF-8");
            try (PrintWriter writer = response.getWriter()) {
                writer.write("{\"success\":false,\"message\":\"관리자 권한이 필요합니다.\"}");
            }
            return false;
        }

        if (loginMember == null) {
            String redirectURL = URLEncoder.encode(request.getRequestURI(), StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/member/login?redirectURL=" + redirectURL);
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
        return false;
    }

    private boolean isApiRequest(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String requestedWith = request.getHeader("X-Requested-With");
        String accept = request.getHeader("Accept");
        return uri.startsWith(request.getContextPath() + "/api/")
                || "XMLHttpRequest".equals(requestedWith)
                || (accept != null && accept.contains("application/json"));
    }
}
