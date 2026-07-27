package com.zzanmat.tour.post.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class PostDto {
    private Long postId;
    private Long userId;
    private String title;
    private String content;
    private Integer viewCount;
    private LocalDateTime createAt;
    private Boolean isBlock;
}
