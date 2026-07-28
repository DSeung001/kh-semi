package com.zzanmat.tour.post.service;

import com.zzanmat.tour.post.dto.PostDto;
import com.zzanmat.tour.post.mapper.PostMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PostService {
    private final PostMapper postMapper;

    public PostService(PostMapper postMapper) {
        this.postMapper = postMapper;
    }

    public List<PostDto> findAll(String sort) {
        return postMapper.findAll(sort);
    }

    public PostDto findById(Long postId) {
        return postMapper.findById(postId);
    }
    public void save(PostDto post){
        postMapper.save(post);
    }
    public void increaseViewCount(Long postId){
        postMapper.increaseViewCount(postId);
    }
}
