package com.zzanmat.tour.comment.controller;

import com.zzanmat.tour.comment.service.CommentService;
import com.zzanmat.tour.comment.dto.*;
import com.zzanmat.tour.common.dto.ApiResponse;
import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.mission.service.MissionService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

@Controller
public class CommentController {

    private final CommentService commentService;
    private final MissionService missionService;

    public CommentController(CommentService commentService, MissionService missionService) {
        this.commentService = commentService;
        this.missionService = missionService;
    }

    @PostMapping("/comments")
    public String createComment(
            CommentCreateRequest request,
            @SessionAttribute(SessionConst.LOGIN_MEMBER)
            MemberDto loginMember
    ) {
        CommentDto comment = new CommentDto();

        comment.setPostId(request.getPostId());
        comment.setParentCommentId(request.getParentCommentId());
        comment.setUserId(loginMember.getId());
        comment.setContent(request.getContent());

        commentService.save(comment);
        missionService.recordEventProgress(loginMember.getId(), "CREATE_COMMENT", null);

        return "redirect:/post-detail?postId="
                + request.getPostId()
                + "#comments";
    }
    
    @PostMapping("/comments/update")
    public String updateComment(
            CommentUpdateRequest request,
            @SessionAttribute(SessionConst.LOGIN_MEMBER)
            MemberDto loginMember
    ) {
        CommentDto comment = new CommentDto();

        comment.setCommentId(request.getCommentId());
        comment.setUserId(loginMember.getId());
        comment.setContent(request.getContent());

        commentService.update(comment);

        return "redirect:/post-detail?postId="
                + request.getPostId()
                + "#comments";
    }

    @PostMapping("/comments/delete")
    public String deleteComment(
            CommentDeleteRequest request,
            @SessionAttribute(SessionConst.LOGIN_MEMBER)
            MemberDto loginMember
    ) {
        commentService.delete(
                request.getCommentId(),
                loginMember.getId()
        );

        return "redirect:/post-detail?postId="
                + request.getPostId()
                + "#comments";
    }

    @PostMapping("/comment-like")
    @ResponseBody
    public ApiResponse<CommentLikeResponse> toggleCommentLike(
            CommentLikeRequest request,
            @SessionAttribute(SessionConst.LOGIN_MEMBER)
            MemberDto loginMember
    ) {
        boolean liked = commentService.toggleLike(
                request.getCommentId(),
                loginMember.getId(),
                request.getPostId()
        );

        if (liked) {
            missionService.recordEventProgress(loginMember.getId(), "LIKE", null);
        }

        int likeCount = commentService.countLikes(
                request.getCommentId()
        );

        CommentLikeResponse response =
                new CommentLikeResponse(liked, likeCount);

        return ApiResponse.success(response);
    }
}
