package com.zzanmat.tour.comment.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface CommentLikeMapper {

    int countByCommentId(
            @Param("commentId") Long commentId
    );

    boolean existsByCommentIdAndUserId(
            @Param("commentId") Long commentId,
            @Param("userId") Long userId
    );

    void save(
            @Param("commentId") Long commentId,
            @Param("userId") Long userId,
            @Param("postId") Long postId
    );

    void deleteByCommentIdAndUserId(
            @Param("commentId") Long commentId,
            @Param("userId") Long userId
    );
}
