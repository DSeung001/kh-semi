package com.zzanmat.tour.member.dto;

import lombok.*;

@ToString
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class MemberDto {
    private String userId;
    private String userPassword;
    private String email;
    private String nickname;
}
