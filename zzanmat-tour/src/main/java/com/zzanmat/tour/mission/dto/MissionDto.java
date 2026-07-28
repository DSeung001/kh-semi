package com.zzanmat.tour.mission.dto;

import java.time.LocalDateTime;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@NotNull
@NotBlank
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class MissionDto {

    private Long missionId;          // PK

    private String title;            // 미션 제목

    private String content;          // 미션 설명

    private Integer rewardPoint;     // 보상 포인트

    private String type;             // DAILY, REVIEW ...

    private String status;           // ACTIVE, INACTIVE

    private LocalDateTime startDate; // 시작일

    private LocalDateTime endDate;   // 종료일

    private LocalDateTime createdAt; // 등록일
}