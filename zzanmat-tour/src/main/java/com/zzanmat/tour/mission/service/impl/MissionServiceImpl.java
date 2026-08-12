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
import java.util.ArrayList;
import java.util.Comparator;
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
    private static final String DEFAULT_MISSION_TYPE = "POST";
    private static final String DEFAULT_TRIGGER_EVENT = "CREATE_POST";
    private static final String TRIGGER_CREATE_POST = "CREATE_POST";
    private static final String TYPE_POST = "POST";
    private static final String TYPE_COMMENT = "COMMENT";
    private static final String TYPE_LIKE = "LIKE";
    private static final String TYPE_CHAT = "CHAT";
    private static final String TRIGGER_CREATE_COMMENT = "CREATE_COMMENT";
    private static final String TRIGGER_LIKE = "LIKE";
    private static final String TRIGGER_OPEN_CHAT = "OPEN_CHAT";

    private final MissionMapper missionMapper;

    @Override
    public List<MissionResponseDto.Info> getAllMissions(Long userId) {
        List<MissionResponseDto.Info> found = missionMapper.findAll();
        List<MissionResponseDto.Info> missions = found == null
                ? new ArrayList<>()
                : new ArrayList<>(found);
        Map<Long, String> userStatuses = loadUserStatuses(userId);
        for (MissionResponseDto.Info mission : missions) {
            applyPeriodStatus(mission);
            if (mission.getMissionId() != null) {
                mission.setUserStatus(userStatuses.get(mission.getMissionId()));
            }
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
        if (userId != null) {
            MissionResponseDto.UserMissionDetail detail =
                    missionMapper.findUserMissionByUserAndMission(userId, missionId);
            if (detail != null) {
                mission.setUserStatus(detail.getStatus());
            }
        }
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

        grantMissionRewardIfNeeded(userId, missionId, mission, userMission);

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
        if (!TRIGGER_CREATE_POST.equals(mission.getTriggerEvent())) {
            return;
        }
        if (!matchesMissionConditions(mission, post)) {
            return;
        }

        applyProgressOnce(userId, mission);
    }

    @Override
    @Transactional
    public void recordEventProgress(Long userId, String triggerEvent, PostDto post) {
        if (userId == null || !StringUtils.hasText(triggerEvent)) {
            return;
        }

        List<MissionResponseDto.Info> missions = missionMapper.findAll();
        if (missions == null || missions.isEmpty()) {
            return;
        }

        for (MissionResponseDto.Info mission : missions) {
            applyPeriodStatus(mission);
            if (!mission.isAvailable()) {
                continue;
            }
            if (!triggerEvent.equals(mission.getTriggerEvent())) {
                continue;
            }
            if (!matchesMissionConditions(mission, post)) {
                continue;
            }
            applyProgressOnce(userId, mission);
        }
    }

    private void applyProgressOnce(Long userId, MissionResponseDto.Info mission) {
        Long missionId = mission.getMissionId();
        if (missionId == null) {
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
        boolean completed = newCount >= targetCount;

        missionMapper.updateProgressCounts(
                detail.getUserMissionId(),
                newCount,
                percent,
                completed ? STATUS_DONE : STATUS_IN_PROGRESS
        );

        if (completed) {
            detail.setStatus(STATUS_DONE);
            detail.setCurrentCount(newCount);
            detail.setProgress(percent);
            grantMissionRewardIfNeeded(userId, missionId, mission, detail);
        }
    }

    @Override
    public int countAllMissions() {
        return missionMapper.countAllMissions();
    }

    @Override
    public int countActiveMissions() {
        return missionMapper.countActiveMissions();
    }

    @Override
    public int getUserPointBalance(Long userId) {
        if (userId == null) {
            return 0;
        }
        return missionMapper.sumPointsByUserId(userId);
    }

    @Override
    public List<Map<String, Object>> sumPointsByDayLast14() {
        List<Map<String, Object>> rows = missionMapper.sumPointsByDayLast14();
        return rows != null ? rows : List.of();
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
        normalizeTypeTriggerPair(requestDto);
    }

    private void normalizeTypeTriggerPair(MissionRequestDto.SaveOrUpdate requestDto) {
        String type = requestDto.getMissionType().trim().toUpperCase();
        String trigger = requestDto.getTriggerEvent().trim().toUpperCase();

        if (TYPE_POST.equals(type) || TRIGGER_CREATE_POST.equals(trigger)) {
            requestDto.setMissionType(TYPE_POST);
            requestDto.setTriggerEvent(TRIGGER_CREATE_POST);
            return;
        }
        if (TYPE_COMMENT.equals(type) || TRIGGER_CREATE_COMMENT.equals(trigger)) {
            requestDto.setMissionType(TYPE_COMMENT);
            requestDto.setTriggerEvent(TRIGGER_CREATE_COMMENT);
            return;
        }
        if (TYPE_LIKE.equals(type) || TRIGGER_LIKE.equals(trigger)) {
            requestDto.setMissionType(TYPE_LIKE);
            requestDto.setTriggerEvent(TRIGGER_LIKE);
            return;
        }
        if (TYPE_CHAT.equals(type) || TRIGGER_OPEN_CHAT.equals(trigger)) {
            requestDto.setMissionType(TYPE_CHAT);
            requestDto.setTriggerEvent(TRIGGER_OPEN_CHAT);
            return;
        }
        throw new IllegalArgumentException("지원하지 않는 미션 방식입니다.");
    }

    private void validateMissionConditions(MissionRequestDto.SaveOrUpdate requestDto) {
        String missionType = requestDto.getMissionType();

        if (!TYPE_POST.equals(missionType)) {
            requestDto.setPlaceKeyword("");
            requestDto.setMaxTotalCost(0L);
            return;
        }

        String placeKeyword = StringUtils.hasText(requestDto.getPlaceKeyword())
                ? requestDto.getPlaceKeyword().trim()
                : "";
        requestDto.setPlaceKeyword(placeKeyword);

        Long maxTotalCost = requestDto.getMaxTotalCost();
        if (maxTotalCost == null || maxTotalCost < 0) {
            maxTotalCost = 0L;
        }
        requestDto.setMaxTotalCost(maxTotalCost);

        boolean hasPlace = StringUtils.hasText(placeKeyword);
        boolean hasCost = maxTotalCost > 0;
        if (!hasPlace && !hasCost) {
            throw new IllegalArgumentException("포스트 미션은 장소 키워드 또는 총 경비 상한 중 하나 이상 입력해 주세요.");
        }
    }

    private boolean matchesMissionConditions(MissionResponseDto.Info mission, PostDto post) {
        if (!TRIGGER_CREATE_POST.equals(mission.getTriggerEvent())
                && !TYPE_POST.equals(mission.getMissionType())) {
            return true;
        }

        if (post == null) {
            return false;
        }

        String keyword = mission.getPlaceKeyword();
        boolean hasPlaceCondition = StringUtils.hasText(keyword);
        Long maxTotalCost = mission.getMaxTotalCost();
        boolean hasCostCondition = maxTotalCost != null && maxTotalCost > 0;

        // 장소/경비 조건이 없으면 게시글 작성만으로 인정 (시드 POST 미션 등)
        if (!hasPlaceCondition && !hasCostCondition) {
            return true;
        }

        if (hasPlaceCondition) {
            String place = post.getPlace();
            if (!StringUtils.hasText(place) || !place.contains(keyword.trim())) {
                return false;
            }
        }

        if (hasCostCondition) {
            long transport = post.getTransportCost() == null ? 0L : post.getTransportCost();
            long food = post.getFoodCost() == null ? 0L : post.getFoodCost();
            long other = post.getOtherCost() == null ? 0L : post.getOtherCost();
            long total = transport + food + other;
            if (total > maxTotalCost) {
                return false;
            }
        }

        return true;
    }

    private void grantMissionRewardIfNeeded(
            Long userId,
            Long missionId,
            MissionResponseDto.Info mission,
            MissionResponseDto.UserMissionDetail userMission
    ) {
        if (userMission == null || userMission.getUserMissionId() == null) {
            return;
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

    private Map<Long, String> loadUserStatuses(Long userId) {
        if (userId == null) {
            return Map.of();
        }
        List<Map<String, Object>> rows = missionMapper.findUserStatusesByUserId(userId);
        if (rows == null || rows.isEmpty()) {
            return Map.of();
        }
        Map<Long, String> statuses = new HashMap<>();
        for (Map<String, Object> row : rows) {
            Object missionId = firstNonNull(row, "missionId", "MISSIONID", "mission_id");
            Object status = firstNonNull(row, "status", "STATUS");
            if (missionId == null || status == null) {
                continue;
            }
            statuses.put(((Number) missionId).longValue(), String.valueOf(status));
        }
        return statuses;
    }

    private static Object firstNonNull(Map<String, Object> row, String... keys) {
        for (String key : keys) {
            if (row.containsKey(key) && row.get(key) != null) {
                return row.get(key);
            }
        }
        return null;
    }
}