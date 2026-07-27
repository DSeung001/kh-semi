package com.zzanmat.tour.common.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http){
        http
                .csrf(AbstractHttpConfigurer::disable) // CSRF 토큰 검증을 끄겠다
                .formLogin(AbstractHttpConfigurer::disable) // 시큐리티의 자동 로그인 페이지를 끄겠다.
                .httpBasic(AbstractHttpConfigurer::disable) // http베이직 인증도 사용하지 않겠다.
                .logout(AbstractHttpConfigurer::disable) // 시큐리티가 제공하는 로그아웃처리도 사용하지 않겠다.
                .authorizeHttpRequests(auth -> auth.anyRequest().permitAll()); //모든요청 허용
        return http.build();
    }

    // BCryptPasswordEncoder(비밀번호 단방향 암호화)
    // 암호화 후 저장해서 로그인시에는 passwordEncoder.matches(입력값, 저장된암호문)로 일치여부를 검증
    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }

}
