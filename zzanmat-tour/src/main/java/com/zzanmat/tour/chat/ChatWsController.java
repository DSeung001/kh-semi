package com.zzanmat.tour.chat;

import com.zzanmat.tour.chat.dto.ChatMessage;
import com.zzanmat.tour.chat.service.ChatService;
import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.member.dto.MemberDto;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;

import java.util.Map;

@Controller
public class ChatWsController {

    private final ChatService chatService;

    public ChatWsController(ChatService chatService) {
        this.chatService = chatService;
    }

    @MessageMapping("/chat.send")
    @SendTo("/topic/public")
    // 채팅 메시지 전송
    public ChatMessage send(ChatMessage message, SimpMessageHeaderAccessor headerAccessor) {
        // 채팅 메시지가 없거나 채팅 내용이 없으면 null 반환
        if (message == null || !StringUtils.hasText(message.getContent())) {
            return null;
        }

        // 로그인 여부 판단
        Map<String, Object> sessionAttributes = headerAccessor.getSessionAttributes();
        MemberDto loginMember = sessionAttributes == null
                ? null
                : (MemberDto) sessionAttributes.get(SessionConst.LOGIN_MEMBER);

        if (loginMember == null) {
            return null;
        }

        // 채팅 메시지 저장
        return chatService.save(loginMember, message.getContent());
    }
}
