package com.zzanmat.tour.mission.service.impl;

import com.zzanmat.tour.mission.dto.MissionRequestDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.mapper.MissionMapper;
import com.zzanmat.tour.mission.service.MissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MissionServiceImpl implements MissionService {

    private static final String STATUS_READY = "READY";
    private static final String STATUS_IN_PROGRESS = "IN_PROGRESS";
    private static final String STATUS_DONE = "DONE";
    private static final String POINT_REASON_MISSION = "MISSION";
    private static final String PERIOD_ACTIVE = "ACTIVE";
    private static final String PERIOD_EXPIRED = "EXPIRED";
    private static final String PERIOD_UPCOMING = "UPCOMING";

    private final MissionMapper missionMapper;

    @Override
    @Transactional
    public List<MissionResponseDto.Info> getAllMissions(Long userId) {
        List<MissionResponseDto.Info> missions = missionMapper.findAll();
        if (missions == null) {
            return List.of();
        }
        for (MissionResponseDto.Info mission : missions) {
            applyPeriodStatus(mission);
            if (userId != null && mission.isAvailable()) {
                ensureInProgress(userId, mission.getMissionId());
            }
        }
        return missions;
    }

    @Override
    @Transactional
    public MissionResponseDto.Info getMissionById(Long missionId, Long userId) {
        MissionResponseDto.Info mission = missionMapper.findById(missionId);
        if (mission == null) {
            return null;
        }
        applyPeriodStatus(mission);
        if (userId != null && mission.isAvailable()) {
            ensureInProgress(userId, missionId);
        }
        return mission;
    }

    @Override
    @Transactional
    public MissionResponseDto.Progress getUserMissionProgress(Long userId, Long missionId) {
        MissionResponseDto.Info mission = missionMapper.findById(missionId);
        if (mission == null) {
            throw new IllegalArgumentException("미션을 찾을 수 없습니다.");
        }
        applyPeriodStatus(mission);

        if (userId != null && mission.isAvailable()) {
            ensureInProgress(userId, missionId);
        }

        MissionResponseDto.Progress progress = new MissionResponseDto.Progress();
        progress.setMissionId(mission.getMissionId());
        progress.setTitle(mission.getTitle());
        progress.setTargetCount(mission.getTargetCount());
        progress.setRewardPoint(mission.getRewardPoint());
        progress.setLoggedIn(userId != null);
        progress.setStartAt(mission.getStartAt());
        progress.setEndAt(mission.getEndAt());
        progress.setPeriodStatus(mission.getPeriodStatus());
        progress.setAvailable(mission.isAvailable());

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
        int targetCount = mission.getTargetCount() > 0 ? mission.getTargetCount() : 1;
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
    public MissionResponseDto.UserMissionDetail completeMission(Long userId, Long missionId) {
        MissionResponseDto.Info mission = missionMapper.findById(missionId);
        if (mission == null) {
            throw new IllegalArgumentException("미션을 찾을 수 없습니다.");
        }
        applyPeriodStatus(mission);
        if (!mission.isAvailable()) {
            throw new IllegalArgumentException("지금은 수행할 수 없는 미션입니다.");
        }

        ensureInProgress(userId, missionId);

        MissionResponseDto.UserMissionDetail userMission =
                missionMapper.findUserMissionByUserAndMission(userId, missionId);

        if (userMission == null || userMission.getUserMissionId() == null) {
            throw new IllegalStateException("미션 진행 정보를 생성할 수 없습니다.");
        }

        int targetCount = mission.getTargetCount() > 0 ? mission.getTargetCount() : 1;
        if (userMission.getCurrentCount() < targetCount) {
            throw new IllegalStateException("미션 목표를 아직 달성하지 않았습니다.");
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
    public void recordPostProgress(Long userId, Long missionId) {
        if (userId == null || missionId == null) {
            return;
        }

        MissionResponseDto.Info mission = missionMapper.findById(missionId);
        if (mission == null) {
            return;
        }
        applyPeriodStatus(mission);
        if (!mission.isAvailable()) {
            return;
        }

        ensureInProgress(userId, missionId);

        MissionResponseDto.UserMissionDetail detail =
                missionMapper.findUserMissionByUserAndMission(userId, missionId);
        if (detail == null || detail.getUserMissionId() == null) {
            return;
        }
        if (STATUS_DONE.equals(detail.getStatus())) {
            return;
        }

        int targetCount = mission.getTargetCount() > 0 ? mission.getTargetCount() : 1;
        int newCount = detail.getCurrentCount() + 1;
        int percent = Math.min(100, (int) Math.round((newCount * 100.0) / targetCount));

        missionMapper.updateProgressCounts(
                detail.getUserMissionId(),
                newCount,
                percent,
                STATUS_IN_PROGRESS
        );
    }

    @Override
    public Map<String, Object> getAdminDashboardStats() {
        int readyCount = missionMapper.countProgressByStatus(STATUS_READY);
        int inProgressCount = missionMapper.countProgressByStatus(STATUS_IN_PROGRESS);
        int doneCount = missionMapper.countProgressByStatus(STATUS_DONE);

        Map<String, Object> stats = new HashMap<>();
        stats.put("missionCount", missionMapper.countAllMissions());
        stats.put("readyCount", readyCount);
        stats.put("inProgressCount", inProgressCount);
        stats.put("doneCount", doneCount);

        Map<LocalDate, Long> pointByDay = new HashMap<>();
        List<Map<String, Object>> rows = missionMapper.sumPointsByDayLast14();
        if (rows != null) {
            for (Map<String, Object> row : rows) {
                Object dayObj = row.get("day");
                Object totalObj = row.get("total_point");
                if (dayObj == null) {
                    continue;
                }
                LocalDate day = dayObj instanceof LocalDate
                        ? (LocalDate) dayObj
                        : LocalDate.parse(dayObj.toString().substring(0, 10));
                long total = totalObj == null ? 0L : ((Number) totalObj).longValue();
                pointByDay.put(day, total);
            }
        }

        List<String> pointLabels = new ArrayList<>();
        List<Long> pointValues = new ArrayList<>();
        DateTimeFormatter labelFmt = DateTimeFormatter.ofPattern("M/d");
        LocalDate today = LocalDate.now();
        for (int i = 13; i >= 0; i--) {
            LocalDate day = today.minusDays(i);
            pointLabels.add(day.format(labelFmt));
            pointValues.add(pointByDay.getOrDefault(day, 0L));
        }
        stats.put("pointLabels", pointLabels);
        stats.put("pointValues", pointValues);
        return stats;
    }

    @Override
    @Transactional
    public void createMission(MissionRequestDto.SaveOrUpdate requestDto) {
        missionMapper.save(requestDto);
        missionMapper.saveCreateHistory(requestDto);
    }

    @Override
    @Transactional
    public void updateMission(MissionRequestDto.SaveOrUpdate requestDto) {
        missionMapper.saveUpdateHistory(requestDto.getId());
        missionMapper.update(requestDto);
    }

    @Override
    @Transactional
    public void deleteMission(Long missionId) {
        missionMapper.saveDeleteArchive(missionId);
        missionMapper.deleteById(missionId);
    }

    private void ensureInProgress(Long userId, Long missionId) {
        MissionResponseDto.UserMissionDetail existing =
                missionMapper.findUserMissionByUserAndMission(userId, missionId);
        if (existing == null) {
            missionMapper.saveProgress(userId, missionId);
            return;
        }
        if (STATUS_READY.equals(existing.getStatus())) {
            missionMapper.updateStatus(existing.getUserMissionId(), STATUS_IN_PROGRESS);
        }
    }

    private void applyPeriodStatus(MissionResponseDto.Info mission) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime startAt = mission.getStartAt();
        LocalDateTime endAt = mission.getEndAt();

        if (startAt != null && now.isBefore(startAt)) {
            mission.setPeriodStatus(PERIOD_UPCOMING);
            mission.setAvailable(false);
            return;
        }
        if (endAt != null && now.isAfter(endAt)) {
            mission.setPeriodStatus(PERIOD_EXPIRED);
            mission.setAvailable(false);
            return;
        }
        mission.setPeriodStatus(PERIOD_ACTIVE);
        mission.setAvailable(true);
    }
}
