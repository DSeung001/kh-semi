package com.zzanmat.tour.mission.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.zzanmat.tour.mission.dto.UserMissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.dto.UserMissionDto;
import com.zzanmat.tour.mission.mapper.MissionMapper;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class MissionServiceImpl implements MissionService {

    private final MissionMapper missionMapper;

    @Override
    public List<MissionResponseDto> getAllMissions() {
        return missionMapper.findAll();
    }

    @Override
    public void insertMission(MissionDto mission) {
        missionMapper.insertMission(mission);
    }

    @Override
    public void updateMission(MissionDto mission) {
        missionMapper.updateMission(mission);
    }

    @Override
    public void deleteMission(Long missionId) {
        missionMapper.deleteMission(missionId);
    }

    @Override
    public void createDefaultMissions(Long userId) {
        missionMapper.insertDefaultMissionsForUser(userId);
    }

    @Override
    public List<UserMissionDto> getUserMissions(Long userId) {
        return missionMapper.selectUserMissions(userId);
    }

    @Override
    public void updateMissionStatus(UserMissionDto userMissionDto) {
        missionMapper.updateMissionStatus(userMissionDto);
    }

    /**
     * 사용자가 미션 완료 버튼을 클릭했을 때 실행되는 핵심 메서드 (포인트 지급 및 상태 변경 통합)
     */
    @Override
    @Transactional
    public UserMissionResponseDto completeMission(Long userId, Long missionId) {
        // 1. 유저의 전체 미션 목록 조회
        List<UserMissionDto> userMissions = missionMapper.selectUserMissions(userId);

        // 2. 대상 미션 찾기
        UserMissionDto targetMission = userMissions.stream()
                .filter(m -> m.getMissionId().equals(missionId))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("해당 미션을 찾을 수 없습니다."));

        // 이미 완료된 미션인지 체크
        if ("DONE".equalsIgnoreCase(targetMission.getStatus())) {
            throw new IllegalStateException("이미 완료된 미션입니다.");
        }

        // 3. 전체 미션 정의 정보에서 보상 포인트 가져오기
        List<MissionResponseDto> allMissions = missionMapper.findAll();
        MissionResponseDto missionInfo = allMissions.stream()
                .filter(m -> m.getId().equals(missionId))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 미션 정보입니다."));

        // 4. 미션 상태 'DONE' 및 완료일시 업데이트
        targetMission.setStatus("DONE");
        // 필요에 따라 progress나 completedAt 세팅 메서드가 있다면 호출
        missionMapper.updateMissionStatus(targetMission);

        // 5. 보상 포인트 지급 및 이력 기록 (중복 지급 방지 체크)
        if (targetMission.getRewardReceived() == null || !targetMission.getRewardReceived()) {
            // 유저 포인트 증가
            missionMapper.addPointToUser(userId, missionInfo.getRewardPoint());
            // 포인트 이력 추가
            missionMapper.insertPointHistory(userId, missionId, missionInfo.getRewardPoint(), "MISSION");
            // 보상 지급 완료 플래그 업데이트
            missionMapper.updateRewardReceived(targetMission.getUserMissionId());

            log.info("미션 완료 및 보상 지급 성공: userId={}, missionId={}, rewardPoint={}",
                    userId, missionId, missionInfo.getRewardPoint());
        }

        // 6. 갱신된 최신 미션 목록 다시 조회하여 전체 진척도 계산
        List<UserMissionDto> refreshedMissions = missionMapper.selectUserMissions(userId);
        int totalCount = refreshedMissions.size();
        int completedCount = (int) refreshedMissions.stream()
                .filter(m -> "DONE".equalsIgnoreCase(m.getStatus()) || "COMPLETED".equalsIgnoreCase(m.getStatus()) || (m.getCompletedAt() != null))
                .count();

        double progressPercent = 0.0;
        if (totalCount > 0) {
            progressPercent = ((double) completedCount / totalCount) * 100.0;
        }

        // 최신 유저 정보(포인트 포함)를 반영하기 위한 반환 DTO 빌드
        return UserMissionResponseDto.builder()
                .id(targetMission.getUserMissionId())
                .userMissionId(targetMission.getUserMissionId())
                .missionId(missionId)
                .status("DONE")
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

        if (missions == null || missions.isEmpty()) {
            return;
        }

        for (MissionResponseDto mission : missions) {
            int historyCount = missionMapper.existsHistory(userId, mission.getId(), postId);
            if (historyCount > 0) {
                continue;
            }

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

                missionMapper.insertHistory(userId, mission.getId(), postId, triggerEvent);

                if (isCompleted && (progress.getRewardReceived() == null || !progress.getRewardReceived())) {
                    missionMapper.addPointToUser(userId, mission.getRewardPoint());
                    missionMapper.insertPointHistory(userId, mission.getId(), mission.getRewardPoint(), "MISSION");
                    missionMapper.updateRewardReceived(progress.getUserMissionId());

                    log.info("미션 완료 보상 지급 완료: userId={}, missionId={}, rewardPoint={}",
                            userId, mission.getId(), mission.getRewardPoint());
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

        missionMapper.updateMissionStatus(userMissionDto);
    }

    @Override
    @Transactional
    public void processMissionCompletion(Long userMissionId, int rewardPoint) {
        UserMissionDto userMissionDto = new UserMissionDto();
        userMissionDto.setUserMissionId(userMissionId);
        userMissionDto.setStatus("DONE");

        missionMapper.updateMissionStatus(userMissionDto);
    }
}