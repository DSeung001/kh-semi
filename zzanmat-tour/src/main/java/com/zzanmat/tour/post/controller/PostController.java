package com.zzanmat.tour.post.controller;

import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.post.dto.PostDto;
import com.zzanmat.tour.post.service.PostService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;

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
            @SessionAttribute(SessionConst.LOGIN_MEMBER) MemberDto loginMember
    ) {

        PostDto post = new PostDto();

        post.setUserId(loginMember.getId());
        post.setTitle(title);
        post.setContent(content);

        postService.save(post);

        return "redirect:/my-travel";
    }

    @GetMapping("/edit-post")
    public String editPost(
            @RequestParam Long postId,
            Model model
    ) {
        model.addAttribute("post", postService.findById(postId));

        return "post/edit-post"; // post 폴더 안의 edit-post.jsp 화면 실행
    }

    @PostMapping("/edit-post")
    public String updatePost(
            @RequestParam Long postId,
            @RequestParam String title,
            @RequestParam String content
    ) {
        PostDto post = new PostDto();

        post.setPostId(postId);
        post.setTitle(title);
        post.setContent(content);

        postService.update(post);

        return "redirect:/post-detail?postId=" + postId;
    }

    @PostMapping("/delete-post")
    public String deletePost(@RequestParam Long postId) {
        postService.deleteById(postId);

        return "redirect:/my-travel";
    }
}
