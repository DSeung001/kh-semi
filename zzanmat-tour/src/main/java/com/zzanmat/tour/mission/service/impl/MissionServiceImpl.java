package com.zzanmat.tour.mission.service.impl;

import org.springframework.transaction.annotation.Transactional;
import com.zzanmat.tour.mission.dto.UserMissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.dto.UserMissionDto;
import com.zzanmat.tour.mission.mapper.MissionMapper;
import com.zzanmat.tour.mission.service.MissionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.HashMap;
import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class MissionServiceImpl implements MissionService {

    private final MissionMapper missionMapper;

    @Override
    public UserMissionResponseDto getUserMissionProgress(Long missionId) {
        return UserMissionResponseDto.builder()
                .missionId(missionId)
                .status("IN_PROGRESS")
                .completedCount(0)
                .totalCount(4)
                .progressPercent(0.0)
                .build();
    }

    @Override
    public List<MissionResponseDto> getAllMissions() {
        return missionMapper.findAll();
    }

    @Override
    public void createMission(MissionDto mission) {
        missionMapper.save(mission);
    }

    @Override
    public void saveMission(MissionDto mission) {
        missionMapper.save(mission);
    }

    @Override
    public Map<String, Boolean> getUserChecklistStatus(Long userId, Long missionId) {
        Map<String, Boolean> statusMap = new HashMap<>();

        boolean hasTransitAuth = missionMapper.existsTransitAuth(userId);
        boolean hasLandmarkAuth = missionMapper.existsLandmarkAuth(userId);
        boolean hasMealAuth = missionMapper.existsMealAuth(userId);
        int postCount = missionMapper.countUserPosts(userId);
        boolean hasReviewAuth = (postCount > 0);

        statusMap.put("transit", hasTransitAuth);
        statusMap.put("landmark", hasLandmarkAuth);
        statusMap.put("meal", hasMealAuth);
        statusMap.put("review", hasReviewAuth);

        return statusMap;
    }

    @Override
    public void updateMission(MissionDto mission) {
        missionMapper.update(mission);
    }

    @Override
    public void deleteMission(Long missionId) {
        missionMapper.deleteById(missionId);
    }

    @Override
    public void createDefaultMissions(Long userId) {
        missionMapper.saveDefaultMissionsForUser(userId);
    }

    @Override
    public List<UserMissionDto> getUserMissions(Long userId) {
        return missionMapper.findUserMissionsByUserId(userId);
    }

    @Override
    public void updateStatus(UserMissionDto userMissionDto) {
        missionMapper.updateStatus(userMissionDto);
    }

    @Override
    @Transactional
    public UserMissionResponseDto completeMission(Long userId, Long missionId) {
        UserMissionDto userMissionDto = new UserMissionDto();
        userMissionDto.setMemberId(userId);
        userMissionDto.setMissionId(missionId);
        userMissionDto.setStatus("DONE");

        missionMapper.updateStatus(userMissionDto);

        List<UserMissionDto> userMissions = missionMapper.findUserMissionsByUserId(userId);
        UserMissionDto updated = userMissions.stream()
                .filter(m -> m.getMissionId().equals(missionId))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("해당 미션을 찾을 수 없습니다."));

        List<MissionResponseDto> allMissions = missionMapper.findAll();
        MissionResponseDto missionInfo = allMissions.stream()
                .filter(m -> m.getId().equals(missionId))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 미션 정보입니다."));

        // 보상 지급 중복 방지 체크
        if (updated.getRewardReceived() == null || !updated.getRewardReceived()) {
            missionMapper.addPointToUser(userId, missionInfo.getRewardPoint());
            missionMapper.updateRewardReceived(updated.getUserMissionId());

            log.info("미션 완료 보상 지급 성공: userId={}, missionId={}, rewardPoint={}",
                    userId, missionId, missionInfo.getRewardPoint());
        }

        int totalCount = userMissions.size();
        int completedCount = (int) userMissions.stream()
                .filter(m -> "DONE".equalsIgnoreCase(m.getStatus()) || "COMPLETED".equalsIgnoreCase(m.getStatus()) || (m.getCompletedAt() != null))
                .count();

        double progressPercent = 0.0;
        if (totalCount > 0) {
            progressPercent = ((double) completedCount / totalCount) * 100.0;
        }

        return UserMissionResponseDto.builder()
                .id(updated.getUserMissionId())
                .userMissionId(updated.getUserMissionId())
                .missionId(missionId)
                .status(updated.getStatus())
                .title(missionInfo.getTitle())
                .description(missionInfo.getDescription())
                .completedCount(completedCount)
                .totalCount(totalCount)
                .progressPercent(progressPercent)
                .build();
    }

    @Override
    @Transactional
    public void processMissionOnAction(Long userId, String triggerEvent, Long postId) {
        List<MissionResponseDto> missions = missionMapper.findByTriggerEvent(triggerEvent);
        if (missions == null || missions.isEmpty()) return;

        for (MissionResponseDto mission : missions) {
            int historyCount = missionMapper.existsHistory(userId, mission.getId(), postId);
            if (historyCount > 0) continue;

            UserMissionDto progress = missionMapper.findProgress(userId, mission.getId());
            if (progress != null && !"DONE".equals(progress.getStatus())) {
                int newCurrentCount = progress.getCurrentCount() + 1;
                int targetCount = mission.getTargetCount();
                int calculatedProgress = (int) Math.min(100, ((double) newCurrentCount / targetCount) * 100);

                String newStatus = "IN_PROGRESS";
                boolean isCompleted = false;

                if (newCurrentCount >= targetCount) {
                    newStatus = "DONE";
                    isCompleted = true;
                }

                missionMapper.updateProgress(
                        progress.getUserMissionId(),
                        newCurrentCount,
                        calculatedProgress,
                        newStatus,
                        isCompleted ? LocalDateTime.now() : null
                );

                if (isCompleted && (progress.getRewardReceived() == null || !progress.getRewardReceived())) {
                    missionMapper.addPointToUser(userId, mission.getRewardPoint());
                    missionMapper.updateRewardReceived(progress.getUserMissionId());
                }
            }
        }
    }

    @Override
    @Transactional
    public void acceptMission(Long userId, Long missionId) {
        UserMissionDto userMissionDto = new UserMissionDto();
        userMissionDto.setMemberId(userId);
        userMissionDto.setMissionId(missionId);
        userMissionDto.setStatus("IN_PROGRESS");
        missionMapper.updateStatus(userMissionDto);
    }

    @Override
    @Transactional
    public void processMissionCompletion(Long userMissionId, int rewardPoint) {
        UserMissionDto userMissionDto = new UserMissionDto();
        userMissionDto.setUserMissionId(userMissionId);
        userMissionDto.setStatus("DONE");
        missionMapper.updateStatus(userMissionDto);
    }
}