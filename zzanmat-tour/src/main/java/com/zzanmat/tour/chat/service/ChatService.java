package com.zzanmat.tour.chat.service;

import com.zzanmat.tour.chat.dto.ChatMessage;
import com.zzanmat.tour.member.dto.MemberDto;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface ChatService {

    ChatMessage save(MemberDto loginMember, String content);

    ChatMessage saveImage(MemberDto loginMember, MultipartFile imageFile) throws IOException;

    List<ChatMessage> listRecent(int limit);
}
