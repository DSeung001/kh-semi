package com.zzanmat.tour.mission.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MissionRequestDto {

    private Long missionId;
    private String redirectUrl;

    @Getter
    @Setter
    @ToString
    public static class Action {
        private Long missionId;
    }

    @Getter
    @Setter
    @ToString
    public static class SaveOrUpdate {
        private Long missionId;
        private String title;
        private String description;
        private String missionType;
        private String triggerEvent;
        private Integer targetCount;
        private Integer rewardPoint;
    }
}
