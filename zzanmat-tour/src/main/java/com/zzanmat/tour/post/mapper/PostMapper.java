package com.zzanmat.tour.post.mapper;

import com.zzanmat.tour.post.dto.PostDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface PostMapper {
    List<PostDto> findAll(@Param("sort") String sort);
    PostDto findById(@Param("postId") Long postId);
    void save(PostDto post);
    void increaseViewCount(@Param("postId") Long postID);
}
