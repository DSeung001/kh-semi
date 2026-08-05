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

    void save(CommentDto comment);

    int updateByIdAndUserId(CommentDto comment);

    int deleteByIdAndUserId(
            @Param("commentId") Long commentId,
            @Param("userId") Long userId
    );
}
