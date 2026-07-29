package com.zzanmat.tour.mission.dto;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class MissionResponseDto {
    private Long id;
    private String title;
    private String description;
    private String missionType;
    private String triggerEvent;
    private Integer targetCount;
    private Integer rewardPoint;
    private Boolean autoComplete;
    private LocalDateTime createdAt;
}