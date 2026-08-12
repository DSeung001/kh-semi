package com.zzanmat.tour.member.service;

import com.zzanmat.tour.member.dto.FollowRelationDto;
import com.zzanmat.tour.member.dto.MemberDto;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface MemberService {

    void join(MemberDto memberDto, MultipartFile profileImage) throws IOException;

    boolean isMemberIdCheck(String userId);

    boolean isNicknameDuplicate(String nickname);

    boolean isEmailDuplicate(String email);

    int countAllMembers();

    MemberDto login(String userId, String userPassword) throws IllegalStateException;

    boolean update(MemberDto memberDto, MultipartFile profileImage, String originProfileName) throws IOException;

    MemberDto findDetailByUserId(String userId);

    MemberDto findByEmail(String email);

    MemberDto findByUserIdAndEmail(String userId, String email);

    boolean resetPasswordByMemberId(Long memberId, String newPassword);

    void withdraw(Long memberId);

    MemberDto kakaoJoin(String kakaoId, String nickname);

    MemberDto naverJoin(String naverId, String nickname, String email);

    void unlinkKakao(String accessToken);

    void unlinkNaver(String accessToken);

    boolean isFollowing(Long followerId, Long followeringId);

    void follow(Long followerId, Long followingId);

    void unfollow(Long followerId, Long followingId);

    void restore(Long memberId);

    void registerLoginSession(Long memberId, String loginSessionId);

    void clearLoginSession(Long memberId, String loginSessionId);

    boolean isCurrentLoginSession(Long memberId, String loginSessionId);

    List<FollowRelationDto> getFollowRelations(String keyword, int page, int size);

    int countFollowRelations();

    int countFollowRelationsByKeyword(String keyword);

    int countDistinctFollowers();

    int countDistinctFollowingMembers();
}
