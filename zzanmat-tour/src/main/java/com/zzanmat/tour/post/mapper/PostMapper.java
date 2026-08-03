package com.zzanmat.tour.post.mapper;

import com.zzanmat.tour.post.dto.PostDto;
import com.zzanmat.tour.post.dto.PostImageDto;
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

    List<PostImageDto> findImagesByPostId(
            @Param("postId") Long postId
    );

    void save(PostDto post);

    void increaseViewCount(@Param("postId") Long postId);

    void update(PostDto post);

    void deleteById(@Param("postId") Long postId);

    void saveImage(PostImageDto postImage);

    void savePostImage(
            @Param("postId") Long postId,
            @Param("uploadId") Long uploadId
    );

    void deletePostImage(
            @Param("postId") Long postId,
            @Param("uploadId") Long uploadId
    );

    void deleteImage(
            @Param("uploadId") Long uploadId
    );

    void updateImageOrder(
            @Param("uploadId") Long uploadId,
            @Param("imageOrder") int imageOrder
    );

    int countLikes(
            @Param("postId") Long postId
    );

    int countUserLike(
            @Param("postId") Long postId,
            @Param("userId") Long userId
    );

    void saveLike(
            @Param("postId") Long postId,
            @Param("userId") Long userId
    );

    void deleteLike(
            @Param("postId") Long postId,
            @Param("userId") Long userId
    );
}
