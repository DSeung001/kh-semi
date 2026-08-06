package com.zzanmat.tour.chat.mapper;

import com.zzanmat.tour.chat.dto.ChatImageDto;
import com.zzanmat.tour.chat.dto.ChatMessage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ChatMapper {

    int save(ChatMessage message);

    void saveImage(ChatImageDto image);

    void saveTalkImage(
            @Param("chatId") Long chatId,
            @Param("uploadId") Long uploadId
    );

    List<ChatMessage> findRecent(@Param("limit") int limit);
}
