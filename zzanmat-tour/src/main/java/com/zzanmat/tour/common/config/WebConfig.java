package com.zzanmat.tour.common.config;

import com.zzanmat.tour.common.interceptor.AdminInterceptor;
import com.zzanmat.tour.common.interceptor.AutoLoginInterceptor;
import com.zzanmat.tour.common.interceptor.CacheControlInterceptor;
import com.zzanmat.tour.common.interceptor.LoginInterceptor;
import com.zzanmat.tour.member.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.File;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Value("${file.upload-dir}")
    private String uploadDir;

    @Autowired
    private MemberService memberService;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String absoultePath = new File(uploadDir).getAbsolutePath();

        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + absoultePath + File.separator);
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        // JSP/컨트롤러 응답은 캐시하지 않음.
        // CSS, JS, 이미지, 업로드 파일은 성능을 위해 제외.
        registry.addInterceptor(new CacheControlInterceptor())
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/assets/**",
                        "/uploads/**",
                        "/webjars/**",
                        "/favicon.ico"
                );

        registry.addInterceptor(new AutoLoginInterceptor(memberService))
                .addPathPatterns("/**") // 웹사이트의 모든 경로에서 자동 로그인 체크를 실행합니다.
                .excludePathPatterns("/login", "/logout", "/css/**", "/js/**", "/images/**");
        // 단, 로그인, 로그아웃 페이지나 정적 파일(css, js, 이미지)은 무한 루프나 불필요한 동작을 막기 위해 제외합니다.

        registry.addInterceptor(new LoginInterceptor())
                //로그인 해야만 접근 가능한 페이지 경로
                .addPathPatterns(
                        // 추후 접근페이지 설정
                        "/member/profile",
                        "/new-post",
                        "/edit-post",
                        "/delete-post",
                        "/member/follow/**",
                        "/post-like",
                        "/comment-like",
                        "/comments",
                        "/comments/**",
                        "/api/chat/images"
                );

        registry.addInterceptor(new AdminInterceptor())
                .addPathPatterns("/admin", "/admin/**", "/api/admin/**");
    }
}