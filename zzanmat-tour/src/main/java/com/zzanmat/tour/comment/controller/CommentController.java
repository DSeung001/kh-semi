package com.zzanmat.tour.comment.controller;

import com.zzanmat.tour.comment.CommentService;
import com.zzanmat.tour.comment.dto.CommentCreateRequest;
import com.zzanmat.tour.comment.dto.CommentDeleteRequest;
import com.zzanmat.tour.comment.dto.CommentUpdateRequest;
import com.zzanmat.tour.comment.dto.CommentDto;
import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.member.dto.MemberDto;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.SessionAttribute;

@Controller
public class CommentController {

    private final CommentService commentService;

    public CommentController(CommentService commentService) {
        this.commentService = commentService;
    }

    @PostMapping("/comments")
    public String createComment(
            CommentCreateRequest request,
            @SessionAttribute(SessionConst.LOGIN_MEMBER)
            MemberDto loginMember
    ) {
        CommentDto comment = new CommentDto();

        comment.setPostId(request.getPostId());
        comment.setUserId(loginMember.getId());
        comment.setContent(request.getContent());

        commentService.save(comment);

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


}
