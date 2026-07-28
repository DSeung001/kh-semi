package com.zzanmat.tour.post.controller;

import com.zzanmat.tour.post.dto.PostDto;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import com.zzanmat.tour.post.service.PostService;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class PostController {
    private final PostService postService;

    public PostController(PostService postService){
        this.postService = postService;
    }

    @GetMapping("/new-post")
    public String newPost() {
        //log.debug("ZzanmatTour home view requested");
        return "post/new-post";
    }
    @GetMapping("/post-detail")
    public String postDetail(
            @RequestParam Long postId,
            Model model
    ) {
        postService.increaseViewCount(postId);
        model.addAttribute("post", postService.findById(postId));
        return "post/post-detail";
    }

    @GetMapping("/my-travel")
    public String myTravel(
            @RequestParam(defaultValue = "latest") String sort,
            Model model
    ){
        model.addAttribute("posts", postService.findAll(sort));
        model.addAttribute("sort", sort);
        return "post/my-travel";
    }
    @PostMapping("/new-post")
    public String createPost(
            @RequestParam String title,
            @RequestParam String content
    ){
        PostDto post = new PostDto();

        post.setUserId(1L);
        post.setTitle(title);
        post.setContent(content);

        postService.save(post);

        return "redirect:/my-travel";
    }

}
