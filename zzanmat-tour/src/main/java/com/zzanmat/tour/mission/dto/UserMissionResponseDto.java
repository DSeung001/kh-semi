package com.zzanmat.tour.mission.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor  // 기본 생성자 생성
@AllArgsConstructor //모든 필드를 포함한 생성자 생성
@Builder  // (객체 조립 편리화)
public class UserMissionResponseDto {

    private Long id;
    private String title;
    private String description;
    private Long userMissionId; // 유저 미션 매핑 ID
    private Long missionId;     // 미션 ID
    private String status;      // 미션 상태 (예: "COMPLETED", "IN_PROGRESS")
    private int completedCount; // 현재 완료한 미션 총 개수 (예: 3)
    private int totalCount;     // 전체 미션 총 개수 (예: 10)
    private double progressPercent; // 실시간 프로그레스 퍼센트 (예: 30.0%)
}