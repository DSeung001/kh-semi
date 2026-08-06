package com.zzanmat.tour.comment.mapper;

import com.zzanmat.tour.comment.dto.CommentDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CommentMapper {

    List<CommentDto> findByPostId(
            @Param("postId") Long postId,
            @Param("loginUserId") Long loginUserId
    );

    boolean existsRootByIdAndPostId(
            @Param("commentId") Long commentId,
            @Param("postId") Long postId
    );

    void save(CommentDto comment);

    int updateByIdAndUserId(CommentDto comment);

    int updateDeleteByIdAndUserId(
            @Param("commentId") Long commentId,
            @Param("userId") Long userId
    );
}
