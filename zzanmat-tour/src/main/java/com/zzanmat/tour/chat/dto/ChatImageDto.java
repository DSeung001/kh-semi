package com.zzanmat.tour.chat.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ChatImageDto {
    private Long uploadId;
    private String originName;
    private String uploadPath;
    private Integer imageOrder;
}
