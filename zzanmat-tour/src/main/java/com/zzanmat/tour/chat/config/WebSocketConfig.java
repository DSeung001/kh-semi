package com.zzanmat.tour.chat.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

@Configuration // 스프링 설정 클래스 지정
@EnableWebSocketMessageBroker // WebSocket 메시지 브로커 활성화
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
    // WebSocketMessageBrokerConfigurer 인터페이스를 구현하여 WebSocket 설정을 구성

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        // 메시지 브로커 설정, 기본 스프링 제공 브로커 사용
        registry.enableSimpleBroker("/topic");
        // 애플리케이션 접두사 설정
        registry.setApplicationDestinationPrefixes("/app");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // STOMP 엔드포인트 등록
        // STOMP: Simple Text Oriented Messaging Protocol
        // WebSocket 연결을 위한 엔드포인트 등록
        // 이걸로 웹소켓 연결하면, 브로커로 메시지 전달 받을 수 있음
        registry.addEndpoint("/ws")
                .addInterceptors(new HttpSessionHandshakeInterceptor())
                .withSockJS();
    }

    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        // 채팅 메시지 인터셉터 등록
        // 인터셉터는 메시지 전달 전에 처리하는 필터 역할
        registration.interceptors(new ChatStompChannelInterceptor());
    }
}
