package com.zzanmat.tour.chat.service;

import com.zzanmat.tour.chat.dto.ChatMessage;
import com.zzanmat.tour.member.dto.MemberDto;

import java.util.List;

public interface ChatService {

    ChatMessage save(MemberDto loginMember, String content);

    List<ChatMessage> listRecent(int limit);
}
