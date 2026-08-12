package com.zzanmat.tour.post.controller;

import com.zzanmat.tour.comment.service.CommentService;
import com.zzanmat.tour.common.dto.ApiResponse;
import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.member.service.MemberService;
import com.zzanmat.tour.mission.service.MissionService;
import com.zzanmat.tour.post.dto.PostDto;
import com.zzanmat.tour.post.dto.PostUpdateRequest;
import com.zzanmat.tour.post.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.List;

@Controller
public class PostController {

    @Autowired
    private MemberService memberService;

    private final PostService postService;
    private final CommentService commentService;
    private final MissionService missionService;

    public PostController(
            PostService postService,
            CommentService commentService,
            MissionService missionService
    ) {
        this.postService = postService;
        this.commentService = commentService;
        this.missionService = missionService;
    }

    @GetMapping("/new-post")
    public String newPost(
            @RequestParam(required = false) Long missionId,
            Model model
    ) {
        model.addAttribute("missionId", missionId);
        return "post/new-post";
    }

    @GetMapping("/post-detail")
    public String postDetail(
            @RequestParam Long postId,
            @SessionAttribute(
                    value = SessionConst.LOGIN_MEMBER,
                    required = false
            ) MemberDto loginMember,
            Model model
    ) {
        postService.increaseViewCount(postId);

        PostDto post = postService.findById(postId);

        if (post == null) {
            return "redirect:/my-travel";
        }

        boolean isFollowing = false;
        boolean isOwnPost = false;

        if (loginMember != null) {
            isOwnPost = loginMember.getId().equals(post.getUserId());

            if (!isOwnPost) {
                isFollowing = memberService.isFollowing(loginMember.getId(), post.getUserId());
            }
        }

        model.addAttribute("post", post);
        model.addAttribute("isFollowing", isFollowing);
        model.addAttribute("isOwnPost", isOwnPost);
        model.addAttribute("likeCount", postService.countLikes(postId));

        boolean liked = loginMember != null
                && postService.isLiked(postId, loginMember.getId());
        model.addAttribute("liked", liked);

        Long loginUserId = loginMember == null ? null : loginMember.getId();
        model.addAttribute("comments", commentService.findByPostId(postId, loginUserId));

        return "post/post-detail";
    }

    @PostMapping("/post-like")
    @ResponseBody
    public ApiResponse<Map<String, Object>> toggleLike(
            @RequestParam Long postId,
            @SessionAttribute(SessionConst.LOGIN_MEMBER)
            MemberDto loginMember
    ) {
        boolean liked = postService.toggleLike(postId, loginMember.getId());
        if (liked) {
            missionService.recordEventProgress(loginMember.getId(), "LIKE", null);
        }

        Map<String, Object> result = new HashMap<>();

        result.put("liked", liked);
        result.put("likeCount", postService.countLikes(postId));

        return ApiResponse.success(result);
    }

    @GetMapping("/my-travel")
    public String myTravel(
            @RequestParam(defaultValue = "latest") String sort,
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(defaultValue = "1") int page,
            Model model
    ) {
        int size = 9;
        int totalCount = postService.countAll(keyword);
        int totalPages = (int) Math.ceil(
                (double) totalCount / size
        );

        if (page < 1) {
            page = 1;
        }

        if (totalPages > 0 && page > totalPages) {
            page = totalPages;
        }

        model.addAttribute(
                "posts",
                postService.findPage(
                        sort,
                        keyword,
                        page,
                        size
                )
        );
        model.addAttribute("sort", sort);
        model.addAttribute("keyword", keyword);
        model.addAttribute("page", page);
        model.addAttribute("totalPages", totalPages);

        return "post/my-travel";
    }

    // 우회 차단을 위한 서버용 텍스트 정화 메서드
    private String sanitizeText(String text) {
        if (text == null) return "";
        return text.toLowerCase()
                .replaceAll("[\\s\\p{Punct}]", "") // 공백 및 특수문자 제거
                .replace("@", "a")
                .replace("1", "i")
                .replace("3", "e")
                .replace("4", "a")
                .replace("0", "o");
    }

    @PostMapping("/new-post")
    public String createPost(
            @ModelAttribute PostDto post,
            @RequestParam(name = "imageFiles", required = false) List<MultipartFile> imageFiles,
            @RequestParam(required = false) Long missionId,
            @SessionAttribute(SessionConst.LOGIN_MEMBER) MemberDto loginMember,
            Model model
    ) throws IOException {

        // 1. 글자수 검증
        if (post.getContent() == null || post.getContent().trim().length() < 10) {
            model.addAttribute("errorMessage", "미션 인증을 위해 내용을 10자 이상 작성해주세요.");
            model.addAttribute("missionId", missionId);
            return "post/new-post"; // 검증 실패 시 폼으로 복귀
        }

        // 2. 비속어 및 도배 문자 필터링
        String cleanContent = sanitizeText(post.getContent());
        String cleanTitle = sanitizeText(post.getTitle());
        String[] badWords = {"시발", "fuck", "shit", "병신", "개새끼", "ㅅㅂ", "ㅂㅅ"}; // 필요한 비속어 목록

        for (String word : badWords) {
            String cleanWord = sanitizeText(word);
            if (cleanContent.contains(cleanWord) || cleanTitle.contains(cleanWord)) {
                model.addAttribute("errorMessage", "욕설이나 비속어, 도배 문자는 올릴 수 없습니다.");
                model.addAttribute("missionId", missionId);
                return "post/new-post"; // 차단 후 폼으로 복귀
            }
        }

        // 정상 저장 및 미션 처리...
        post.setUserId(loginMember.getId());
        postService.save(post, imageFiles);
        missionService.recordEventProgress(loginMember.getId(), "CREATE_POST", post);

        if (missionId != null) {
            return "redirect:/mission/active?missionId=" + missionId;
        }
        return "redirect:/my-travel";
    }



    @GetMapping("/edit-post")
    public String editPost(
            @RequestParam Long postId,
            @SessionAttribute(SessionConst.LOGIN_MEMBER) MemberDto loginMember,
            Model model
    ) {
        PostDto post = postService.findById(postId);

        if (!post.getUserId().equals(loginMember.getId())) {
            return "redirect:/post-detail?postId=" + postId;
        }

        model.addAttribute("post", post);

        return "post/edit-post";
    }

    @PostMapping("/edit-post")
    public String updatePost(
            PostUpdateRequest request,
            @SessionAttribute(SessionConst.LOGIN_MEMBER)
            MemberDto loginMember
    ) throws IOException {

        PostDto savedPost =
                postService.findById(request.getPostId());

        if (!savedPost.getUserId().equals(loginMember.getId())) {
            return "redirect:/post-detail?postId="
                    + request.getPostId();
        }

        PostDto post = new PostDto();

        post.setPostId(request.getPostId());
        post.setTitle(request.getTitle());
        post.setContent(request.getContent());
        post.setPlace(request.getPlace());
        post.setTransportCost(request.getTransportCost());
        post.setFoodCost(request.getFoodCost());
        post.setOtherCost(request.getOtherCost());

        postService.update(
                post,
                request.getDeleteImageIds(),
                request.getImageFiles()
        );

        return "redirect:/post-detail?postId="
                + request.getPostId();
    }

    @PostMapping("/delete-post")
    public String deletePost(@RequestParam Long postId,
                             @SessionAttribute(SessionConst.LOGIN_MEMBER) MemberDto loginMember) {
        PostDto post = postService.findById(postId);

        if (!post.getUserId().equals(loginMember.getId())) {
            return "redirect:/post-detail?postId=" + postId;
        }

        postService.deleteById(postId);
        return "redirect:/my-travel";
    }

    @GetMapping("/api/posts")
    @ResponseBody
    public ApiResponse<Map<String, Object>> getPostPage(
            @RequestParam(defaultValue = "latest") String sort,
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(defaultValue = "1") int page
    ) {
        int size = 9;
        int totalCount = postService.countAll(keyword);
        int totalPages = (int) Math.ceil(
                (double) totalCount / size
        );

        if (page < 1) {
            page = 1;
        }

        Map<String, Object> result = new HashMap<>();
        result.put(
                "posts",
                postService.findPage(
                        sort,
                        keyword,
                        page,
                        size
                )
        );
        result.put("page", page);
        result.put("totalPages", totalPages);
        result.put("hasNext", page < totalPages);

        return ApiResponse.success(result);
    }
}