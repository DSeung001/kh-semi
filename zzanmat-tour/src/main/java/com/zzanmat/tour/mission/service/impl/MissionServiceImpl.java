package com.zzanmat.tour.mission.service.Impl;

import com.zzanmat.tour.mission.dto.MissionCheckResultDto;
import com.zzanmat.tour.mission.dto.MissionRequestDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.mapper.MissionMapper;
import com.zzanmat.tour.mission.service.MissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class MissionServiceImpl implements MissionService {

    private final MissionMapper missionMapper;

    @Override
    @Transactional
    public void startMissionForUser(Long userId, Long missionId, int durationDays) {
        LocalDate startDate = LocalDate.now();
        LocalDate endDate = startDate.plusDays(durationDays);

        // MyBatis Mapper를 통해 데이터 저장 (필요한 경우 Mapper에 insert 쿼리 추가 필요)
        missionMapper.saveSingleUserMission(userId, missionId, startDate, endDate);
    }

    @Override
    public MissionResponseDto.Info getMissionById(Long missionId) {
        List<MissionResponseDto.Info> allMissions = missionMapper.findAll();
        if (allMissions == null) return null;
        return allMissions.stream()
                .filter(m -> m.getMissionId().equals(missionId))
                .findFirst()
                .orElse(null);
    }

    @Override
    @Transactional
    public MissionCheckResultDto verifyAndCompleteByAction(Long userId, Long missionId) {
        int postCount = missionMapper.countUserPosts(userId);
        int currentProgress = (postCount > 0) ? 1 : 0;
        int targetCount = 1;

        Map<String, Object> missionInfo = missionMapper.findMissionInfoById(missionId);
        int rewardPoint = missionInfo != null ? ((Number) missionInfo.get("reward_point")).intValue() : 1000;

        Map<String, Object> userMission = missionMapper.findUserMission(userId, missionId);
        if (userMission == null) {
            LocalDate startDate = LocalDate.now();
            LocalDate endDate = startDate.plusDays(7);
            missionMapper.saveSingleUserMission(userId, missionId, startDate, endDate);
            userMission = missionMapper.findUserMission(userId, missionId);
        }

        Long userMissionId = ((Number) userMission.get("progressId")).longValue();
        String currentStatus = (String) userMission.get("status");

        boolean isJustCompleted = false;
        int percent = (currentProgress >= targetCount) ? 100 : 0;

        if (currentProgress >= targetCount && !"COMPLETED".equals(currentStatus)) {
            missionMapper.updateUserMissionStatus(userMissionId, "COMPLETED");
            missionMapper.updateRewardReceived(userMissionId);
            missionMapper.addPointToUser(userId, rewardPoint);
            missionMapper.savePointHistory(userId, missionId, rewardPoint, "MISSION_REWARD");

            currentStatus = "COMPLETED";
            isJustCompleted = true;
        }

        int totalPointBalance = missionMapper.getUserPointBalance(userId);

        return MissionCheckResultDto.builder()
                .missionId(missionId)
                .currentCount(currentProgress)
                .targetCount(targetCount)
                .percent(percent)
                .status(currentStatus)
                .isJustCompleted(isJustCompleted)
                .rewardPoint(rewardPoint)
                .totalPointBalance(totalPointBalance)
                .build();
    }

    @Override
    public List<MissionResponseDto.Info> getAllMissions() {
        return missionMapper.findAll();
    }

    @Override
    public List<MissionResponseDto.UserMissionDetail> getUserMissionProgressList(Long userId) {
        return missionMapper.findUserMissionsByUserId(userId);
    }

    @Override
    @Transactional
    public void acceptMission(Long userId, Long missionId) {
        var existing = missionMapper.findUserMissionByUserAndMission(userId, missionId);
        if (existing == null) {
            LocalDate startDate = LocalDate.now();
            LocalDate endDate = startDate.plusDays(7);
            missionMapper.saveSingleUserMission(userId, missionId, startDate, endDate);
        }
    }

    @Override
    public Map<String, Boolean> getUserChecklistStatus(Long userId, Long missionId) {
        Map<String, Boolean> checklist = new HashMap<>();
        boolean transit = missionMapper.existsTransitAuth(userId);
        boolean landmark = missionMapper.existsLandmarkAuth(userId);
        boolean meal = missionMapper.existsMealAuth(userId);

        checklist.put("transit", transit);
        checklist.put("landmark", landmark);
        checklist.put("meal", meal);
        return checklist;
    }

    @Override
    @Transactional
    public MissionResponseDto.UserMissionDetail completeMission(Long userId, Long missionId) {
        MissionResponseDto.UserMissionDetail userMission = missionMapper.findUserMissionByUserAndMission(userId, missionId);
        if (userMission == null) {
            LocalDate startDate = LocalDate.now();
            LocalDate endDate = startDate.plusDays(7);
            missionMapper.saveSingleUserMission(userId, missionId, startDate, endDate);
            userMission = missionMapper.findUserMissionByUserAndMission(userId, missionId);
        }

        if (userMission != null && userMission.getUserMissionId() != null) {
            missionMapper.updateUserMissionStatus(userMission.getUserMissionId(), "COMPLETED");
        }

        return missionMapper.findUserMissionByUserAndMission(userId, missionId);
    }

    @Override
    public void createMission(MissionRequestDto.SaveOrUpdate requestDto) {
        missionMapper.saveMission(requestDto);
    }

    @Override
    public void deleteMission(Long missionId) {
        missionMapper.deleteMissionById(missionId);
    }
}