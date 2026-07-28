package com.zzanmat.tour.chat.service;

import com.zzanmat.tour.chat.dto.ChatMessage;
import com.zzanmat.tour.chat.mapper.ChatMapper;
import com.zzanmat.tour.member.dto.MemberDto;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;

@Service
public class ChatServiceImpl implements ChatService {

    private static final DateTimeFormatter TIME_FORMAT = DateTimeFormatter.ofPattern("HH:mm");

    private final ChatMapper chatMapper;

    // 채팅 서비스 생성자
    public ChatServiceImpl(ChatMapper chatMapper) {
        this.chatMapper = chatMapper;
    }

    @Override
    public ChatMessage save(MemberDto loginMember, String content) {
        // 로그인 회원이 없거나 회원 아이디가 없으면 null 반환
        if (loginMember == null || loginMember.getId() == null) {
            return null;
        }
        // 채팅 내용이 없으면 null 반환
        if (!StringUtils.hasText(content)) {
            return null;
        }

        // 채팅 내용 정리
        String trimmed = content.trim();
        // 채팅 내용이 300자 초과하면 300자로 자름, DDL 정의를 따름
        if (trimmed.length() > 300) {
            trimmed = trimmed.substring(0, 300);
        }

        // 채팅 내용 저장
        chatMapper.insertMessage(loginMember.getId(), trimmed);

        // 응답 생성
        ChatMessage response = new ChatMessage();
        response.setUserId(loginMember.getId());
        response.setSender(loginMember.getNickname());
        response.setContent(trimmed);
        response.setTime(LocalTime.now().format(TIME_FORMAT));
        return response;
    }

    @Override
    public List<ChatMessage> listRecent(int limit) {
        // 최근 채팅 메시지 조회
        int safeLimit = Math.max(1, Math.min(limit, 50));
        List<ChatMessage> messages = chatMapper.selectRecent(safeLimit);
        if (messages == null || messages.isEmpty()) {
            return Collections.emptyList();
        }
        // 최근 채팅 메시지 역순으로 정렬
        Collections.reverse(messages);
        return messages;
    }
}
