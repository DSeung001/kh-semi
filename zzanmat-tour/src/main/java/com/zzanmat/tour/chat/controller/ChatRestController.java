package com.zzanmat.tour.chat.controller;

import com.zzanmat.tour.chat.dto.ChatMessage;
import com.zzanmat.tour.chat.service.ChatService;
import com.zzanmat.tour.common.dto.ApiResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/chat")
public class ChatRestController {

    private final ChatService chatService;

    // 의존성 주입
    public ChatRestController(ChatService chatService) {
        this.chatService = chatService;
    }

    @GetMapping("/messages")
    // 최근 채팅 메시지 조회
    public ApiResponse<List<ChatMessage>> messages(@RequestParam(defaultValue = "50") int limit) {
        return ApiResponse.success(chatService.listRecent(limit));
    }
}
