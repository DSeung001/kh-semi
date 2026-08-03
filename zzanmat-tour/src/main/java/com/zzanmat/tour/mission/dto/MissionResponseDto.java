package com.zzanmat.tour.mission.dto;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

public class MissionResponseDto {

    // 1. 일반 미션 정보 응답 (목록 조회 등)
    @Getter
    @Setter
    public static class Info {
        private Long id;
        private Long missionId;
        private String title;
        private String description;
        private String missionType;
        private String triggerEvent;
        private int targetCount;
        private int rewardPoint;
        private boolean autoComplete;
        private LocalDateTime createdAt;
    }

    // 2. 유저 미션 진행 상황 및 상세 응답
    @Getter
    @Setter
    public static class UserMissionDetail {
        private Long id;
        private Long missionId;
        private String status;
        private int progressCount;
        private int targetCount;
        private boolean rewardReceived;
        private LocalDateTime completedAt;
        private String title;
        private String description;
        private int rewardPoint;
    }
}