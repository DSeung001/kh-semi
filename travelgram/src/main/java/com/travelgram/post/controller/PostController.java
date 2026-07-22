package com.travelgram.post.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PostController {

    @GetMapping("/new-post")
    public String newPost() {
        //log.debug("Travelgram home view requested");
        return "post/new-post";
    }
    @GetMapping("/post-detail")
    public String postDetail() {
        return "post/post-detail";
    }

    @GetMapping("/travelgram")
    public String travelgram(){
        return "post/travelgram";
    }
}
