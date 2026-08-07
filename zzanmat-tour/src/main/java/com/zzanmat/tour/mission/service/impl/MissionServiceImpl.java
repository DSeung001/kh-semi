package com.zzanmat.tour.mission.service.impl;

import com.zzanmat.tour.mission.dto.MissionRequestDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.mapper.MissionMapper;
import com.zzanmat.tour.mission.service.MissionService;
import com.zzanmat.tour.post.dto.PostDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;

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
    private static final String DEFAULT_MISSION_TYPE = "POST";
    private static final String DEFAULT_TRIGGER_EVENT = "CREATE_POST";

    private final MissionMapper missionMapper;

    @Override
    public List<MissionResponseDto.Info> getAllMissions(Long userId) {
        List<MissionResponseDto.Info> missions = missionMapper.findAll();
        if (missions == null) {
            return List.of();
        }
        for (MissionResponseDto.Info mission : missions) {
            applyPeriodStatus(mission);
        }
        missions.sort(
                Comparator
                        .comparingInt((MissionResponseDto.Info m) -> periodSortOrder(m.getPeriodStatus()))
                        .thenComparing(
                                MissionResponseDto.Info::getEndAt,
                                Comparator.nullsLast(Comparator.reverseOrder())
                        )
                        .thenComparing(
                                MissionResponseDto.Info::getMissionId,
                                Comparator.nullsLast(Comparator.reverseOrder())
                        )
        );
        return missions;
    }

    @Override
    public MissionResponseDto.Info getMissionById(Long missionId, Long userId) {
        MissionResponseDto.Info mission = missionMapper.findById(missionId);
        if (mission == null) {
            return null;
        }
        applyPeriodStatus(mission);
        return mission;
    }

    @Override
    public MissionResponseDto.Progress getUserMissionProgress(Long userId, Long missionId) {
        MissionResponseDto.Info mission = missionMapper.findById(missionId);
        if (mission == null) {
            throw new IllegalArgumentException("미션을 찾을 수 없습니다.");
        }
        applyPeriodStatus(mission);

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
    public void recordPostProgress(Long userId, Long missionId, PostDto post) {
        if (userId == null || missionId == null || post == null) {
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

        if (!matchesMissionConditions(mission, post)) {
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
    public int countAllMissions() {
        return missionMapper.countAllMissions();
    }

    @Override
    public int getUserPointBalance(Long userId) {
        if (userId == null) {
            return 0;
        }
        return missionMapper.sumPointsByUserId(userId);
    }

    @Override
    @Transactional
    public void createMission(MissionRequestDto.SaveOrUpdate requestDto) {
        applyMissionDefaults(requestDto);
        validateMissionConditions(requestDto);
        missionMapper.save(requestDto);
    }

    @Override
    @Transactional
    public void updateMission(MissionRequestDto.SaveOrUpdate requestDto) {
        applyMissionDefaults(requestDto);
        validateMissionConditions(requestDto);
        missionMapper.update(requestDto);
    }

    @Override
    @Transactional
    public void deleteMission(Long missionId) {
        missionMapper.deleteById(missionId);
    }

    private void applyMissionDefaults(MissionRequestDto.SaveOrUpdate requestDto) {
        if (!StringUtils.hasText(requestDto.getMissionType())) {
            requestDto.setMissionType(DEFAULT_MISSION_TYPE);
        }
        if (!StringUtils.hasText(requestDto.getTriggerEvent())) {
            requestDto.setTriggerEvent(DEFAULT_TRIGGER_EVENT);
        }
    }

    private void validateMissionConditions(MissionRequestDto.SaveOrUpdate requestDto) {
        if (!StringUtils.hasText(requestDto.getPlaceKeyword())) {
            throw new IllegalArgumentException("장소 키워드를 입력해 주세요.");
        }
        requestDto.setPlaceKeyword(requestDto.getPlaceKeyword().trim());
        if (requestDto.getMaxTotalCost() == null || requestDto.getMaxTotalCost() < 0) {
            throw new IllegalArgumentException("총 경비 상한을 0 이상으로 입력해 주세요.");
        }
    }

    private boolean matchesMissionConditions(MissionResponseDto.Info mission, PostDto post) {
        String keyword = mission.getPlaceKeyword();
        String place = post.getPlace();
        if (!StringUtils.hasText(keyword) || !StringUtils.hasText(place)) {
            return false;
        }
        if (!place.contains(keyword.trim())) {
            return false;
        }

        long transport = post.getTransportCost() == null ? 0L : post.getTransportCost();
        long food = post.getFoodCost() == null ? 0L : post.getFoodCost();
        long other = post.getOtherCost() == null ? 0L : post.getOtherCost();
        long total = transport + food + other;
        Long maxTotalCost = mission.getMaxTotalCost();
        if (maxTotalCost == null) {
            return false;
        }
        return total <= maxTotalCost;
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

    private int periodSortOrder(String periodStatus) {
        if (PERIOD_ACTIVE.equals(periodStatus)) {
            return 0;
        }
        if (PERIOD_UPCOMING.equals(periodStatus)) {
            return 1;
        }
        return 2;
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
