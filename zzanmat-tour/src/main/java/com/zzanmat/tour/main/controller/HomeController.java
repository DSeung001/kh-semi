package com.zzanmat.tour.main.controller;

import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.post.dto.PostDto;
import com.zzanmat.tour.post.service.PostService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.SessionAttribute;

import java.util.List;

@Controller
public class HomeController {

    private final PostService postService;

    public HomeController(PostService postService) {
        this.postService = postService;
    }

    @GetMapping({"/", "/home"})
    public String home(
            @SessionAttribute(
                    value = SessionConst.LOGIN_MEMBER,
                    required = false
            ) MemberDto loginMember,
            Model model
    ) {
        List<PostDto> latestPosts = postService.findPage(
                "latest",
                null,
                1,
                6
        );

        for (PostDto post : latestPosts) {
            boolean liked = loginMember != null
                    && postService.isLiked(
                    post.getPostId(),
                    loginMember.getId()
            );

            post.setLiked(liked);
        }

        model.addAttribute("latestPosts", latestPosts);

        return "main/index";
    }

    @GetMapping("/terms")
    public String terms() {
        return "legal/terms";
    }

    @GetMapping("/privacy")
    public String privacy() {
        return "legal/privacy";
    }

}
