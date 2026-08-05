package com.zzanmat.tour.mission.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

public class MissionResponseDto {

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
        private LocalDateTime startAt;
        private LocalDateTime endAt;
        private String createdAt;
        /** ACTIVE | EXPIRED | UPCOMING */
        private String periodStatus;
        private boolean available;
    }

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
        private int currentCount;
        private int progress;
        private int rewardPoint;
        private boolean rewardReceived;
    }

    @Getter
    @Setter
    public static class Progress {
        private Long missionId;
        private String title;
        private String status;
        private int currentCount;
        private int targetCount;
        private int percent;
        private int rewardPoint;
        private boolean rewardReceived;
        private boolean loggedIn;
        private LocalDateTime startAt;
        private LocalDateTime endAt;
        private String periodStatus;
        private boolean available;
    }
}
