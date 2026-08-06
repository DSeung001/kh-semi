package com.zzanmat.tour.post.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

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

    private Long transportCost;
    private Long foodCost;
    private Long otherCost;

    private List<PostImageDto> images;
    private String thumbnailPath;

    private String authorNickname; // 사용자 닉네임
    private String authorProfile; // 사용자 프로필
}
