package com.zzanmat.tour.mission.dto;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MissionPostDto {

    private Long postId;     //게시글 고유 번호 (pk, 자동생성 )

    private Long userMissionId;  // 어떤 유저의 미션인지 연결하는 외래키 (fk)

    private Long userId;     // 작성자 회원 번호

    private String title;   // 인증글 제목
    private String content;  // 인증글 내용
    private String createdAt; // 작성일시
}
