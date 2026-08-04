package com.zzanmat.tour.mission.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MissionRequestDto {

    private Long missionId;

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
    }
}