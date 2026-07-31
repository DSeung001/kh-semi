package com.zzanmat.tour.mission.dto;

import java.time.LocalDateTime;
import lombok.*;

/**
 * 사용자의 미션 진행 상태 저장 DTO
 */
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

    private LocalDateTime completedAt;


    public Boolean getRewardReceived() {
        return this.rewardReceived;
    }

    public void setRewardReceived(Boolean rewardReceived) {
        if (rewardReceived != null) {
            this.rewardReceived = rewardReceived;
        }
    }

    // 💡 일부 서비스/매퍼에서 progressCount로 접근할 경우를 대비한 호환용 메서드
    public int getProgressCount() {
        return this.currentCount;
    }

    public void setProgressCount(int progressCount) {
        this.currentCount = progressCount;
    }
}