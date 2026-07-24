package com.zzanmat.tour.common.interceptor;

import com.zzanmat.tour.common.util.SessionConst;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class LoginInterceptor implements HandlerInterceptor {

    /*@Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false); // false : 세션이 없으면 null반환
        boolean isLoggedIn = session != null && session.getAttribute(SessionConst.LOGIN_MEMBER) != null;
        if (isLoggedIn){
            return true; //로그인 되어있으면 그대로 controller로 진행
        }

        if(isApiRequest(request)){ //데이터만 주고받는 Ajax요청이다
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 응답 http상태코드를 401로 전달
            response.setContentType("application/json; charset=UTF-8");
            try (PrintWriter writer = response.getWriter()){
                writer.write("{\"success\":false, \"message\":\"로그인이 필요합니다\"}");
            }
        } else {
            //일반적인 경우
            String redirectURL = URLEncoder.encode(request.getRequestURI(), StandardCharsets.UTF_8);
            response.sendRedirect("/member/login?redirectURL=" + redirectURL);
        }

        return false;
    }

    private boolean isApiRequest(HttpServletRequest request){
        String uri = request.getRequestURI();
        String requestedWith = request.getHeader("X-Requested-With");
        String accept = request.getHeader("Accept");
        return uri.startsWith(request.getContextPath() + "/api/")
                || "XMLHttpRequest".equals(requestedWith)
                || (accept != null && accept.contains("application/json"));

    }*/

}
