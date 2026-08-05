package com.zzanmat.tour.comment.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class CommentLikeResponse {

    private boolean liked;
    private int likeCount;
}
