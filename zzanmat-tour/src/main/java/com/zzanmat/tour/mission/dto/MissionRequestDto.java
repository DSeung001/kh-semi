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
        private Long id;
        private String title;
        private String description;
        private int rewardPoint;
        private String missionType;
        private String triggerEvent;
        private int targetCount;
        private String placeKeyword;
        private Long maxTotalCost;
        private String startAt;
        private String endAt;
    }
}
