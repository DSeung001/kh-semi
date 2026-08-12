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

    // 우회 차단을 위한 서버용 텍스트 정화 메서드
    private String sanitizeText(String text) {
        if (text == null) return "";
        return text.toLowerCase()
                .replaceAll("[\\s\\p{Punct}]", "") // 공백 및 특수문자 제거
                .replace("@", "a")
                .replace("1", "i")
                .replace("3", "e")
                .replace("4", "a")
                .replace("0", "o")
                .replace("5", "s")
                .replace("7", "t");
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


    @PostMapping("/new-post")
    public String createPost(
            PostDto post,
            @RequestParam(
                    name = "imageFiles",
                    required = false
            ) List<MultipartFile> imageFiles,
            @RequestParam(required = false) Long missionId,
            @SessionAttribute(SessionConst.LOGIN_MEMBER)
            MemberDto loginMember,
            Model model
    ) throws IOException {

        String title = post.getTitle() != null ? post.getTitle() : "";
        String content = post.getContent() != null ? post.getContent() : "";

        // 1. 글자수 검증 (10자 미만 차단)
        if (content.trim().length() < 10) {
            model.addAttribute("errorMessage", "미션 인증을 위해 내용을 10자 이상 작성해주세요.");
            model.addAttribute("missionId", missionId);
            return "post/new-post";
        }

        // 2. 자음/모음만 도배된 경우 차단 (예: ㅋㅋㅋ, ㅠㅠㅠ)
        if (content.matches("^[ㄱ-ㅎㅏ-ㅣ\\s]+$")) {
            model.addAttribute("errorMessage", "자음이나 모음만으로는 작성할 수 없습니다.");
            model.addAttribute("missionId", missionId);
            return "post/new-post";
        }

        // 3. 무작위 키보드 난타/테러 문자열 차단 (한글이나 숫자가 전혀 없고, 알파벳과 특수문자만 무분별하게 10자 이상 연속된 경우)
        // 예: djfdg;jffhjhe;fhwf 처럼 의미 없는 난타 테러 방지
        String strippedContent = content.replaceAll("[\\s\\p{Punct}]", ""); // 공백 및 특수문자 제거
        boolean hasKoreanOrNumber = strippedContent.matches(".*[ㄱ-힣0-9].*");
        boolean isOnlyRandomAlpha = strippedContent.matches("^[a-zA-Z]{10,}$");

        if (!hasKoreanOrNumber && isOnlyRandomAlpha) {
            model.addAttribute("errorMessage", "의미 없는 무작위 문자열이나 테러성 글은 등록할 수 없습니다.");
            model.addAttribute("missionId", missionId);
            return "post/new-post";
        }

        // 4. 한·영 비속어 및 우회 욕설 필터링
        String cleanContent = sanitizeText(content);
        String cleanTitle = sanitizeText(title);

        String[] badWords = {
                "시발", "욕설", "병신", "개새끼", "ㅅㅂ", "ㅂㅅ", "지랄", "미친", "새끼", "꺼져",
                "fuck", "shit", "bitch", "asshole", "motherfucker", "bastard", "crap", "stfu"
        };

        for (String word : badWords) {
            String cleanWord = sanitizeText(word);
            if (cleanContent.contains(cleanWord) || cleanTitle.contains(cleanWord)) {
                model.addAttribute("errorMessage", "욕설, 비속어 또는 부적절한 내용은 올릴 수 없습니다.");
                model.addAttribute("missionId", missionId);
                return "post/new-post";
            }
        }

        // 5. 정상 저장 처리
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