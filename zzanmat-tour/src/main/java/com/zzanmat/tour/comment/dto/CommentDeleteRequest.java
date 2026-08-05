package com.zzanmat.tour.comment.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class CommentDeleteRequest {

    private Long commentId;
    private Long postId;
}
