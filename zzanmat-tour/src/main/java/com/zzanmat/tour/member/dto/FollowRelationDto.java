package com.zzanmat.tour.member.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FollowRelationDto {
    private String followerUserId;
    private String followerNickname;
    private String followingUserId;
    private String followingNickname;
}
