package com.zzanmat.tour.chat;

import com.zzanmat.tour.chat.dto.ChatMessage;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

@Controller
public class ChatWsController {

    private static final DateTimeFormatter TIME_FORMAT = DateTimeFormatter.ofPattern("HH:mm");

    @MessageMapping("/chat.send")
    @SendTo("/topic/public")
    public ChatMessage send(ChatMessage message) {
        if (message == null || !StringUtils.hasText(message.getContent())) {
            return null;
        }

        String sender = StringUtils.hasText(message.getSender())
                ? message.getSender().trim()
                : "익명";
        String content = message.getContent().trim();

        return new ChatMessage(sender, content, LocalTime.now().format(TIME_FORMAT));
    }
}
