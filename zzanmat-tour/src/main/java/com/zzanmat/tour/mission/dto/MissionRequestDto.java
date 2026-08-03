package com.zzanmat.tour.mission.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

public class MissionRequestDto {

    // 미션 수락 및 완료 요청용 Action DTO 추가
    @Getter
    @Setter
    public static class Action {
        @NotNull(message = "미션 ID는 필수입니다.")
        private Long missionId;
        }

    // 미션 생성 및 수정 요청 데이터
    @Getter
    @Setter
    public static class SaveOrUpdate {
        private String title;
        private String description;
        private String missionType;
        private String triggerEvent;
        private int targetCount;
        private int rewardPoint;
        private boolean autoComplete;
    }
}