package com.zzanmat.tour.mission.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

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
            private Long id;                  // 수정 시 필요한 미션 PK
            private String title;             // 미션 제목
            private String description;       // 미션 설명
            private int rewardPoint;          // 보상 포인트
            private String missionType;       // 미션 유형 (POST, PHOTO 등)
            private String triggerEvent;      // 트리거 이벤트
            private int targetCount;          // 목표 횟수
            private Boolean autoComplete;     // 자동 완료 여부
            private String startAt;           // 시작 일시
            private String endAt;             // 종료 일시
        }
    }
