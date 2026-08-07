package com.zzanmat.tour.member.service;

import com.zzanmat.tour.member.dto.MemberDto;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface MemberService {

    void join(MemberDto memberDto, MultipartFile profileImage) throws IOException;

    boolean isMemberIdCheck(String userId);

    int countAllMembers();

    MemberDto login(String userId, String userPassword) throws IllegalStateException;

    boolean update(MemberDto memberDto, MultipartFile profileImage, String originProfileName) throws IOException;

    MemberDto findById(String userId);

    MemberDto findByEmail(String email);

    MemberDto findByUserIdAndEmail(String userId, String email);

    boolean resetPasswordByEmail(String email, String newPassword);

    void withdraw(String userId);

    MemberDto kakaoJoin(String kakaoId, String nickname);

    MemberDto naverJoin(String naverId, String nickname, String email);

    void unlinkKakao(String accessToken);

    void unlinkNaver(String accessToken);

    boolean isFollowing(Long followerId, Long followeringId);

    void follow(Long followerId, Long followingId);

    void unfollow(Long followerId, Long followingId);
}
