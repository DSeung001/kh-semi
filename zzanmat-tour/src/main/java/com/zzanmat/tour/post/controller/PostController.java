package com.zzanmat.tour.post.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PostController {

    @GetMapping("/new-post")
    public String newPost() {
        //log.debug("ZzanmatTour home view requested");
        return "post/new-post";
    }
    @GetMapping("/post-detail")
    public String postDetail() {
        return "post/post-detail";
    }

    @GetMapping("/my-travel")
    public String myTravel(){
        return "post/my-travel";
    }
}
