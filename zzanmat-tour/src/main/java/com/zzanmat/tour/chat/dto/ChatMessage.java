package com.zzanmat.tour.chat.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ChatMessage {
    private Long chatId;
    private Long userId;
    private String sender;
    private String content;
    private String imageUrl;
    private String time;
}
