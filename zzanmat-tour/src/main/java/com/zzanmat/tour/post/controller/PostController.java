package com.zzanmat.tour.post.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import com.zzanmat.tour.post.service.PostService;
import org.springframework.ui.Model;
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
}
