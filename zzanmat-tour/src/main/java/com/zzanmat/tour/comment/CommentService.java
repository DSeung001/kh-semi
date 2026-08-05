package com.zzanmat.tour.comment;

import com.zzanmat.tour.comment.dto.CommentDto;
import com.zzanmat.tour.comment.mapper.CommentMapper;
import com.zzanmat.tour.comment.mapper.CommentLikeMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CommentService {

    private final CommentMapper commentMapper;

    private final CommentLikeMapper commentLikeMapper;

    public CommentService(
            CommentMapper commentMapper,
            CommentLikeMapper commentLikeMapper
    ) {
        this.commentMapper = commentMapper;
        this.commentLikeMapper = commentLikeMapper;
    }

    public List<CommentDto> findByPostId(
            Long postId,
            Long loginUserId
    ) {
        return commentMapper.findByPostId(
                postId,
                loginUserId
        );
    }

    public void save(CommentDto comment) {
        String content = comment.getContent();

        if (content == null || content.isBlank()) {
            throw new IllegalArgumentException(
                    "댓글 내용을 입력해 주세요."
            );
        }

        if (content.length() > 300) {
            throw new IllegalArgumentException(
                    "댓글은 300자 이하로 입력해 주세요."
            );
        }

        comment.setContent(content.trim());
        commentMapper.save(comment);
    }

    public void update(CommentDto comment) {
        String content = comment.getContent();

        if (content == null || content.isBlank()) {
            throw new IllegalArgumentException(
                    "댓글 내용을 입력해 주세요."
            );
        }

        if (content.length() > 300) {
            throw new IllegalArgumentException(
                    "댓글은 300자 이하로 입력해 주세요."
            );
        }

        comment.setContent(content.trim());

        int updateCount =
                commentMapper.updateByIdAndUserId(comment);

        if (updateCount == 0) {
            throw new IllegalArgumentException(
                    "댓글을 수정할 권한이 없습니다."
            );
        }
    }

    public void delete(Long commentId, Long userId) {
        int deletedCount =
                commentMapper.deleteByIdAndUserId(commentId, userId);

        if (deletedCount == 0) {
            throw new IllegalArgumentException(
                    "댓글을 삭제할 권한이 없습니다."
            );
        }
    }

    public int countLikes(Long commentId) {
        return commentLikeMapper.countByCommentId(commentId);
    }

    public boolean isLiked(Long commentId, Long userId) {
        return commentLikeMapper.existsByCommentIdAndUserId(
                commentId,
                userId
        );
    }

    @Transactional
    public boolean toggleLike(
            Long commentId,
            Long userId,
            Long postId
    ) {
        boolean liked = isLiked(commentId, userId);

        if (liked) {
            commentLikeMapper.deleteByCommentIdAndUserId(
                    commentId,
                    userId
            );

            return false;
        }

        commentLikeMapper.save(
                commentId,
                userId,
                postId
        );

        return true;
    }
}
