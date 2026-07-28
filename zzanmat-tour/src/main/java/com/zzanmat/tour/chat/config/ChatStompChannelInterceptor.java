package com.zzanmat.tour.chat.config;

import com.zzanmat.tour.common.util.SessionConst;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.messaging.support.MessageHeaderAccessor;

import java.util.Map;

// ChannelInterceptor는 메시지 전달 전에 처리하는 필터 역할
public class ChatStompChannelInterceptor implements ChannelInterceptor {

    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        // StompHeaderAccessor: 메시지 헤더 접근자, 메시지 헤더 정보를 접근하고 수정할 수 있는 헬퍼 클래스
        StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor.class);
        // 메시지 헤더 접근자가 없으면 메시지 반환
        if (accessor == null) {
            return message;
        }

        // 메시지 요청이 SEND일 때 채팅 메시지 전송 요청인지 판단
        // StompCommand: 주요 CONNECT, DISCONNECT, SUBSCRIBE, UNSUBSCRIBE, SEND, MESSAGE
        if (StompCommand.SEND.equals(accessor.getCommand())
                && "/app/chat.send".equals(accessor.getDestination())) {
            Map<String, Object> sessionAttributes = accessor.getSessionAttributes();
            // 세션 속성이 없거나 로그인 회원이 없으면 null 반환
            if (sessionAttributes == null || sessionAttributes.get(SessionConst.LOGIN_MEMBER) == null) {
                return null;
            }
        }

        return message;
    }
}
