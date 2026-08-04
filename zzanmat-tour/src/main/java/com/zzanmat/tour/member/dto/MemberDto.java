package com.zzanmat.tour.member.dto;

import lombok.*;

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
}
