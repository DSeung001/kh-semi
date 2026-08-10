package com.zzanmat.tour.member.dto;

import lombok.*;

import java.time.LocalDateTime;

@ToString
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class MemberDto {
    private Long id;
    private String userId;
    private String userPassword;
    private String email;
    private String nickname;
    private String bio;
    private String userName;
    private String profile;
    private String loginType;
    private Boolean deleted;
    private LocalDateTime deletedAt;
    private String loginSessionId;
    private String role;

    // 내 정보 페이지 팔로잉, 팔로워 개수 갖고올 떄 사용
    private int followerCount;
    private int followingCount;
}
