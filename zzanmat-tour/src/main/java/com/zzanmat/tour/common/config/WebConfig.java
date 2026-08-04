package com.zzanmat.tour.common.config;

import com.zzanmat.tour.common.interceptor.LoginInterceptor;
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

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String absoultePath = new File(uploadDir).getAbsolutePath();

        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + absoultePath + File.separator);
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginInterceptor())
                //로그인 해야만 접근 가능한 페이지 경로
                .addPathPatterns(
                        // 추후 접근페이지 설정
                        "/member/profile",
                        "/new-post",
                        "/edit-post",
                        "/delete-post",
                        "/post-like",
                        "/comments",
                        "/comments/**"
                );
    }
}
