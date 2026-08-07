package com.zzanmat.tour.mission.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MissionProgressDto {
    private Long id;           // 미션 진행 고유 ID (PK)
    private Long userId;       // 사용자 ID (FK)
    private Long missionId;    // 미션 ID (FK)
    private int currentCount;  // 현재 수행 횟수
    private int progress;      // 진행률 (%) 또는 점수
    private String status;     // 상태 (READY, IN_PROGRESS, DONE 등)
}