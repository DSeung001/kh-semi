package com.zzanmat.tour.mission.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class MissionCheckResultDto {

    private Long missionId;         // 미션 ID
    private int currentCount;       // 현재 달성 횟수 (예: 1)
    private int targetCount;        // 목표 횟수 (예: 1)
    private int percent;            // 프로그레스바 달성률 (0 ~ 100)
    private String status;          // 미션 상태 ('IN_PROGRESS', 'COMPLETED' 등)
    private boolean isJustCompleted;// 이번 요청으로 방금 미션이 완료되었는지 여부 (true/false)
    private int rewardPoint;        // 지급된 보상 포인트 (예: 1000)
    private int totalPointBalance;  // 마이페이지에 반영된 유저의 총 포인트 잔액
}