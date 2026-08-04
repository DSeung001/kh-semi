package com.zzanmat.tour.post.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface PostLikeMapper {

    int countByPostId(
            @Param("postId") Long postId
    );

    boolean existsByPostIdAndUserId(
            @Param("postId") Long postId,
            @Param("userId") Long userId
    );

    void save(
            @Param("postId") Long postId,
            @Param("userId") Long userId
    );

    void deleteByPostIdAndUserId(
            @Param("postId") Long postId,
            @Param("userId") Long userId
    );
}
