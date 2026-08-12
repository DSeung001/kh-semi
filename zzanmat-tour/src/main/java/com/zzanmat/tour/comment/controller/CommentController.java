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
    @ResponseBody
    public ApiResponse<CommentDto> createComment(
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

        comment.setNickname(loginMember.getNickname());
        comment.setLikeCount(0);
        comment.setLiked(false);

        missionService.recordEventProgress(
                loginMember.getId(),
                "CREATE_COMMENT",
                null)
        ;

        return ApiResponse.success(comment);
    }
    
    @PostMapping("/comments/update")
    @ResponseBody
    public ApiResponse<CommentDto> updateComment(
            CommentUpdateRequest request,
            @SessionAttribute(SessionConst.LOGIN_MEMBER)
            MemberDto loginMember
    ) {
        CommentDto comment = new CommentDto();

        comment.setCommentId(request.getCommentId());
        comment.setPostId(request.getPostId());
        comment.setUserId(loginMember.getId());
        comment.setContent(request.getContent());

        commentService.update(comment);

        return ApiResponse.success(comment);
    }

    @PostMapping("/comments/delete")
    @ResponseBody
    public ApiResponse<Long> deleteComment(
            CommentDeleteRequest request,
            @SessionAttribute(SessionConst.LOGIN_MEMBER)
            MemberDto loginMember
    ) {
        commentService.delete(
                request.getCommentId(),
                loginMember.getId()
        );

        return ApiResponse.success(request.getCommentId());
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
