package com.zzanmat.tour.mission.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MissionImageDto {
    private Long missionImageId; // 이미지 고유 번호 (PK)
    private Long missionId;      // 미션 고유 번호 (FK)

    private String originName;   // 사용자가 업로드한 원본 파일명
    private String savedName;    // 서버에 저장되는 고유한 파일명 (중복 방지용)
    private String filePath;     // 서버 내 파일 저장 경로
}