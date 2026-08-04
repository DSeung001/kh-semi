package com.zzanmat.tour.mission.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

public class MissionResponseDto {

    @Getter
    @Setter
    @ToString
    public static class Info {
        private Long missionId;
        private String title;
        private String description;
    }

    @Getter
    @Setter
    @ToString
    public static class UserMissionDetail {
        private Long userMissionId;
        private Long missionId;
        private String title;
        private String status;
        private int targetCount;
        private int progressCount;
        private boolean rewardReceived;
    }
}