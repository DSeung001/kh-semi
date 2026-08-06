package com.zzanmat.tour.chat.service;

import com.zzanmat.tour.chat.dto.ChatImageDto;
import com.zzanmat.tour.chat.dto.ChatMessage;
import com.zzanmat.tour.chat.mapper.ChatMapper;
import com.zzanmat.tour.common.util.FileUploadUtil;
import com.zzanmat.tour.common.util.SavedFile;
import com.zzanmat.tour.member.dto.MemberDto;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;

@Service
public class ChatServiceImpl implements ChatService {

    private static final DateTimeFormatter TIME_FORMAT = DateTimeFormatter.ofPattern("HH:mm");

    private final ChatMapper chatMapper;
    private final FileUploadUtil fileUploadUtil;

    @Value("${file.upload-dir.chat}")
    private String chatUploadDir;

    public ChatServiceImpl(ChatMapper chatMapper, FileUploadUtil fileUploadUtil) {
        this.chatMapper = chatMapper;
        this.fileUploadUtil = fileUploadUtil;
    }

    @Override
    public ChatMessage save(MemberDto loginMember, String content) {
        if (loginMember == null || loginMember.getId() == null) {
            return null;
        }
        if (!StringUtils.hasText(content)) {
            return null;
        }

        String trimmed = content.trim();
        if (trimmed.length() > 300) {
            trimmed = trimmed.substring(0, 300);
        }

        ChatMessage message = new ChatMessage();
        message.setUserId(loginMember.getId());
        message.setContent(trimmed);
        chatMapper.save(message);

        message.setSender(loginMember.getNickname());
        message.setTime(LocalTime.now().format(TIME_FORMAT));
        return message;
    }

    @Override
    @Transactional
    public ChatMessage saveImage(MemberDto loginMember, MultipartFile imageFile) throws IOException {
        if (loginMember == null || loginMember.getId() == null) {
            return null;
        }
        if (imageFile == null || imageFile.isEmpty()) {
            throw new IllegalArgumentException("이미지 파일이 필요합니다.");
        }

        String contentType = imageFile.getContentType();
        if (!"image/jpeg".equals(contentType) && !"image/png".equals(contentType)) {
            throw new IllegalArgumentException("JPG 또는 PNG 이미지만 등록할 수 있습니다.");
        }

        SavedFile savedFile = fileUploadUtil.save(
                imageFile,
                chatUploadDir,
                "/uploads/chat"
        );

        ChatImageDto image = new ChatImageDto();
        image.setOriginName(savedFile.getOriginalName());
        image.setUploadPath(savedFile.getPath());
        image.setImageOrder(1);
        chatMapper.saveImage(image);

        ChatMessage message = new ChatMessage();
        message.setUserId(loginMember.getId());
        message.setContent("");
        chatMapper.save(message);

        chatMapper.saveTalkImage(message.getChatId(), image.getUploadId());

        message.setSender(loginMember.getNickname());
        message.setImageUrl(savedFile.getPath());
        message.setTime(LocalTime.now().format(TIME_FORMAT));
        return message;
    }

    @Override
    public List<ChatMessage> listRecent(int limit) {
        int safeLimit = Math.max(1, Math.min(limit, 50));
        List<ChatMessage> messages = chatMapper.findRecent(safeLimit);
        if (messages == null || messages.isEmpty()) {
            return Collections.emptyList();
        }
        Collections.reverse(messages);
        return messages;
    }
}
