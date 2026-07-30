package com.zzanmat.tour.mission.dto;

import java.time.LocalDateTime;

import lombok.*;

//사용자의 진행상태 저장 클래스

@Getter
@Setter
@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class UserMissionDto {

    private Long userMissionId;

    private Long memberId;

    private Long userId;

    private Long missionId;

    private boolean completed;

    private String title;

    private String description;

    private String status;

    private boolean rewardReceived;

    private int rewardPoint;

    private int currentCount;
    private int progress;

    public Boolean getRewardReceived() {
        return this.rewardReceived;
    }

    public void setRewardReceived(Boolean rewardReceived) {
        this.rewardReceived = rewardReceived;
    }
    private LocalDateTime completedAt;
}