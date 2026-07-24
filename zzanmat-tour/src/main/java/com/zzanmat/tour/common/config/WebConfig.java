package com.zzanmat.tour.common.config;

import com.zzanmat.tour.common.interceptor.LoginInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginInterceptor())
                //로그인 해야만 접근 가능한 페이지 경로
                .addPathPatterns(
                        // 추후 접근페이지 설정
                        /*"/member/mypage"*/
                );
    }
}
