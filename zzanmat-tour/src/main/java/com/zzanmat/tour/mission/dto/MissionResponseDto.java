package com.zzanmat.tour.mission.dto;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;

public class MissionResponseDto {

    // 1. 전체 미션 조회용 DTO
    @Getter
    @Setter
    public static class Info {
        private Long missionId;
        private String title;
        private String description;
        private String missionType;
        private String triggerEvent;
        private int targetCount;
        private int rewardPoint;
        private String createdAt;
    }

    // 2. 유저별 미션 진행 상황 상세 조회용 DTO (Info 내부에서 독립시킴)
    @Getter
    @Setter
    public static class UserMissionDetail {
        private Long userMissionId;
        private Long missionId;
        private Long userId;
        private String title;
        private String description;
        private String status;
        private int targetCount;
        private int progressCount;
        private int rewardPoint;
        private boolean rewardReceived;
        private LocalDate startDate;
        private LocalDate endDate;
    }
}