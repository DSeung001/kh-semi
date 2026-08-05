package com.zzanmat.tour.comment.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
public class CommentDto {

    private Long commentId;
    private Long userId;
    private Long postId;
    private Long parentCommentId;
    private String content;
    private LocalDateTime createAt;
    private LocalDateTime updateAt;
    private String nickname;
    private int likeCount;
    private boolean liked;
}

