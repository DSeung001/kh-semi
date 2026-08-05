package com.zzanmat.tour.mission.service.impl;

import com.zzanmat.tour.mission.dto.MissionRequestDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.mapper.MissionMapper;
import com.zzanmat.tour.mission.service.MissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MissionServiceImpl implements MissionService {

    private static final String STATUS_DONE = "DONE";
    private static final String POINT_REASON_MISSION = "MISSION";

    private final MissionMapper missionMapper;

    @Override
    public List<MissionResponseDto.Info> getAllMissions() {
        return missionMapper.findAll();
    }

    @Override
    public MissionResponseDto.Info getMissionById(Long missionId) {
        return missionMapper.findById(missionId);
    }

    @Override
    public MissionResponseDto.Progress getUserMissionProgress(Long userId, Long missionId) {
        MissionResponseDto.Info mission = missionMapper.findById(missionId);
        if (mission == null) {
            throw new IllegalArgumentException("미션을 찾을 수 없습니다.");
        }

        MissionResponseDto.Progress progress = new MissionResponseDto.Progress();
        progress.setMissionId(mission.getMissionId());
        progress.setTitle(mission.getTitle());
        progress.setTargetCount(mission.getTargetCount());
        progress.setRewardPoint(mission.getRewardPoint());
        progress.setLoggedIn(userId != null);

        if (userId == null) {
            progress.setStatus(null);
            progress.setCurrentCount(0);
            progress.setPercent(0);
            progress.setRewardReceived(false);
            return progress;
        }

        MissionResponseDto.UserMissionDetail detail =
                missionMapper.findUserMissionByUserAndMission(userId, missionId);

        if (detail == null) {
            progress.setStatus(null);
            progress.setCurrentCount(0);
            progress.setPercent(0);
            progress.setRewardReceived(false);
            return progress;
        }

        int currentCount = detail.getCurrentCount();
        int targetCount = detail.getTargetCount() > 0 ? detail.getTargetCount() : 1;
        int percent = Math.min(100, (int) Math.round((currentCount * 100.0) / targetCount));
        if (detail.getProgress() > 0) {
            percent = detail.getProgress();
        }

        progress.setStatus(detail.getStatus());
        progress.setCurrentCount(currentCount);
        progress.setPercent(percent);
        progress.setRewardReceived(detail.isRewardReceived());
        return progress;
    }

    @Override
    @Transactional
    public void acceptMission(Long userId, Long missionId) {
        MissionResponseDto.Info mission = missionMapper.findById(missionId);
        if (mission == null) {
            throw new IllegalArgumentException("미션을 찾을 수 없습니다.");
        }

        MissionResponseDto.UserMissionDetail existing =
                missionMapper.findUserMissionByUserAndMission(userId, missionId);
        if (existing == null) {
            missionMapper.saveProgress(userId, missionId);
        }
    }

    @Override
    @Transactional
    public MissionResponseDto.UserMissionDetail completeMission(Long userId, Long missionId) {
        MissionResponseDto.Info mission = missionMapper.findById(missionId);
        if (mission == null) {
            throw new IllegalArgumentException("미션을 찾을 수 없습니다.");
        }

        MissionResponseDto.UserMissionDetail userMission =
                missionMapper.findUserMissionByUserAndMission(userId, missionId);
        if (userMission == null) {
            missionMapper.saveProgress(userId, missionId);
            userMission = missionMapper.findUserMissionByUserAndMission(userId, missionId);
        }

        if (userMission == null || userMission.getUserMissionId() == null) {
            throw new IllegalStateException("미션 진행 정보를 생성할 수 없습니다.");
        }

        if (!STATUS_DONE.equals(userMission.getStatus())) {
            missionMapper.updateStatus(userMission.getUserMissionId(), STATUS_DONE);
        }

        if (!userMission.isRewardReceived()) {
            missionMapper.updateRewardReceived(userMission.getUserMissionId());
            missionMapper.savePointHistory(
                    userId,
                    missionId,
                    mission.getRewardPoint(),
                    POINT_REASON_MISSION
            );
        }

        return missionMapper.findUserMissionByUserAndMission(userId, missionId);
    }

    @Override
    @Transactional
    public void createMission(MissionRequestDto.SaveOrUpdate requestDto) {
        missionMapper.save(requestDto);
    }

    @Override
    @Transactional
    public void updateMission(MissionRequestDto.SaveOrUpdate requestDto) {
        missionMapper.update(requestDto);
    }

    @Override
    @Transactional
    public void deleteMission(Long missionId) {
        missionMapper.deleteById(missionId);
    }
}
