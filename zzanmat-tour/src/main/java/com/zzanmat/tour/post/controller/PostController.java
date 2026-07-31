package com.zzanmat.tour.post.controller;

import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.post.dto.PostDto;
import com.zzanmat.tour.post.service.PostService;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.ResponseBody;


import java.util.HashMap;
import java.util.Map;

@Controller
public class PostController {
    private final PostService postService;

    public PostController(PostService postService) {
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
            @RequestParam(defaultValue = "1") int page,
            Model model
    ) {
        int size = 9;
        int totalCount = postService.countALL();
        int totalPages = (int) Math.ceil((double) totalCount / size);

        if(page < 1){
            page = 1;
        }

        if(totalPages > 0 && page > totalPages) {
            page = totalPages;
        }

        model.addAttribute("posts", postService.findPage(sort, page, size));
        model.addAttribute("sort", sort);
        model.addAttribute("page", page);
        model.addAttribute("totalPages", totalPages);

        return "post/my-travel";
    }

    @PostMapping("/new-post")
    public String createPost(
            @RequestParam String title,
            @RequestParam String content,
            @RequestParam Long transportCost,
            @RequestParam Long foodCost,
            @RequestParam Long otherCost,
            @SessionAttribute(SessionConst.LOGIN_MEMBER) MemberDto loginMember
    ) {

        PostDto post = new PostDto();

        post.setUserId(loginMember.getId());
        post.setTitle(title);
        post.setContent(content);
        post.setTransportCost(transportCost);
        post.setFoodCost(foodCost);
        post.setOtherCost(otherCost);

        postService.save(post);

        return "redirect:/my-travel";
    }

    @GetMapping("/edit-post")
    public String editPost(
            @RequestParam Long postId,
            @SessionAttribute(SessionConst.LOGIN_MEMBER) MemberDto loginMember,
            Model model
    ) {
        PostDto post = postService.findById(postId);

        if(!post.getUserId().equals(loginMember.getId())){
            return "redirect:/post-detail?postId=" + postId;
        }

        model.addAttribute("post", post);

        return "post/edit-post";
    }

    @PostMapping("/edit-post")
    public String updatePost(
            @RequestParam Long postId,
            @RequestParam String title,
            @RequestParam String content,
            @RequestParam Long transportCost,
            @RequestParam Long foodCost,
            @RequestParam Long otherCost,
            @SessionAttribute(SessionConst.LOGIN_MEMBER) MemberDto login_Member
    ){
        PostDto savePost = postService.findById(postId);

        if(!savedPost.getUserID().equals(login_Member.getId())) {
            return "redirect:/post-detail?postId=" + postId;
        }

        PostDto post = new PostDto();

        post.setPostId(postId);
        post.setTitle(title);
        post.setContent(content);
        post.setTransportCost(transportCost);
        post.setFoodCost(foodCost);
        post.setOtherCost(otherCost);

        postService.update(post);

        return "redirect:/post-detail?postId=" + postId;
    }
    
    @PostMapping("/delete-post")
    public String deletePost(
            @RequestParam Long postId,
            @SessionAttribute(SessionConst.LOGIN_MEMBER) MemberDto loginMember
        ) {
            PostDto post = postService.findById(postId);

            if(!post.getUserId().equals(loginMember.getId())){
                return "redirect:/post-detail?postId=" + postId;
            }

            postService.deleteById(postId);
        return "redirect:/my-travel";
    }

    @GetMapping("/api/posts")
    @ResponseBody
    public Map<String, Object> getPostPage(
            @RequestParam(defaultValue = "latest") String sort,
            @RequestParam(defaultValue = "1") int page
    ) {
        int size = 9;
        int totalCount = postService.countALL();
        int totalPages = (int) Math.ceil((double) totalCount /size);

        if(page<1){
            page=1;
        }

        Map<String, Object> result = new HashMap<>();

        result.put("posts", postService.findPage(sort, page, size));
        result.put("page", page);
        result.put("totalPages", totalPages);
        result.put("hasNext", page < totalPages);

        return result;
    }
}
