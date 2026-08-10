package com.zzanmat.tour.chat.controller;

import com.zzanmat.tour.chat.dto.ChatMessage;
import com.zzanmat.tour.chat.service.ChatService;
import com.zzanmat.tour.common.dto.ApiResponse;
import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.mission.service.MissionService;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/chat")
public class ChatRestController {

    private final ChatService chatService;
    private final SimpMessagingTemplate messagingTemplate;
    private final MissionService missionService;

    public ChatRestController(
            ChatService chatService,
            SimpMessagingTemplate messagingTemplate,
            MissionService missionService
    ) {
        this.chatService = chatService;
        this.messagingTemplate = messagingTemplate;
        this.missionService = missionService;
    }

    @GetMapping("/messages")
    public ApiResponse<List<ChatMessage>> messages(
            @RequestParam(defaultValue = "50") int limit
    ) {
        return ApiResponse.success(chatService.listRecent(limit));
    }

    @PostMapping("/images")
    public ApiResponse<ChatMessage> uploadImage(
            @RequestParam("image") MultipartFile image,
            @SessionAttribute(SessionConst.LOGIN_MEMBER) MemberDto loginMember
    ) throws IOException {
        ChatMessage message = chatService.saveImage(loginMember, image);
        if (message != null) {
            messagingTemplate.convertAndSend("/topic/public", message);
            missionService.recordEventProgress(loginMember.getId(), "OPEN_CHAT", null);
        }
        return ApiResponse.success(message);
    }
}
