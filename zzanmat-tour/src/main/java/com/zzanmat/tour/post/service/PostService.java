package com.zzanmat.tour.post.service;

import com.zzanmat.tour.common.util.FileUploadUtil;
import com.zzanmat.tour.common.util.SavedFile;
import com.zzanmat.tour.post.dto.PostDto;
import com.zzanmat.tour.post.dto.PostImageDto;
import com.zzanmat.tour.post.mapper.PostMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@Service
public class PostService {

    private static final int MAX_IMAGE_COUNT = 5;

    private final PostMapper postMapper;
    private final FileUploadUtil fileUploadUtil;

    @Value("${file.upload-dir.post}")
    private String postUploadDir;

    public PostService(
            PostMapper postMapper,
            FileUploadUtil fileUploadUtil
    ) {
        this.postMapper = postMapper;
        this.fileUploadUtil = fileUploadUtil;
    }

    public List<PostDto> findAll(String sort) {
        return postMapper.findAll(sort);
    }

    public PostDto findById(Long postId) {
        PostDto post = postMapper.findById(postId);

        if (post == null) {
            return null;
        }

        List<PostImageDto> images =
                postMapper.findImagesByPostId(postId);

        post.setImages(images);

        return post;
    }

    @Transactional(rollbackFor = Exception.class)
    public void save(
            PostDto post,
            List<MultipartFile> imageFiles
    ) throws IOException {
        long imageCount = imageFiles == null
                ? 0
                : imageFiles.stream()
                        .filter(file -> !file.isEmpty())
                                .count();

        if (imageCount > MAX_IMAGE_COUNT) {
            throw new IllegalArgumentException(
                    "이미지는 최대 5장까지 등록할 수 있습니다."
            );
        }

        postMapper.save(post);

        if (imageFiles == null) {
            return;
        }

        int imageOrder = 1;

        for (MultipartFile imageFile : imageFiles) {
            if(imageFile.isEmpty()) {
                continue;
            }

            String contentType = imageFile.getContentType();

            if (!"image/jpeg".equals(contentType)
                && !"image/png".equals(contentType)) {
                throw new IllegalArgumentException(
                        "JPG 또는 PNG 이미지만 등록할 수 있습니다."
                );
            }

            SavedFile savedFile = fileUploadUtil.save(
                    imageFile,
                    postUploadDir,
                    "/uploads/post"
            );

            PostImageDto postImage = new PostImageDto();
            postImage.setPostId(post.getPostId());
            postImage.setOriginName(savedFile.getOriginalName());
            postImage.setUploadPath(savedFile.getPath());
            postImage.setImageOrder(imageOrder);

            postMapper.saveImage(postImage);
            postMapper.savePostImage(
                    post.getPostId(),
                    postImage.getUploadId()
            );

            imageOrder++;
        }

    }
    public void increaseViewCount(Long postId){
        postMapper.increaseViewCount(postId);
    }
    public void update(PostDto post) {
        postMapper.update(post);
    }
    public void deleteById(Long postId) {
        postMapper.deleteById(postId);
    }

    public List<PostDto> findPage(String sort, int page, int size) {
        int offset = (page - 1) * size;
        return postMapper.findPage(sort, offset, size);
    }

    public int countAll() {
        return postMapper.countAll();
    }
}
