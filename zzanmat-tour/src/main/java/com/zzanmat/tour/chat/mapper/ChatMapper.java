package com.zzanmat.tour.chat.mapper;

import com.zzanmat.tour.chat.dto.ChatMessage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ChatMapper {

    // 채팅 메시지 저장
    int save(@Param("userId") Long userId,
             @Param("content") String content);

    // 최근 채팅 메시지 조회
    List<ChatMessage> findRecent(@Param("limit") int limit);
}
