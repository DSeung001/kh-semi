package com.zzanmat.tour.post.mapper;

import com.zzanmat.tour.post.dto.PostDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface PostMapper {
    List<PostDto> findAll(@Param("sort") String sort);
    List<PostDto> findPage(
            @Param("sort") String sort,
            @Param("offset") int offset,
            @Param("size") int size
    );

    int countAll();
    
    PostDto findById(@Param("postId") Long postId);
    void save(PostDto post);
    void increaseViewCount(@Param("postId") Long postId);
    void update(PostDto post);
    void deleteById(@Param("postId") Long postId);
}
