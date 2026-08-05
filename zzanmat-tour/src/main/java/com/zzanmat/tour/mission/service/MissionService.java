package com.zzanmat.tour.mission.service;

import com.zzanmat.tour.mission.dto.MissionCheckResultDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionRequestDto;

import java.util.List;
import java.util.Map;

public interface MissionService {

    // 유저 미션 시작 및 기간 설정
    void startMissionForUser(Long userId, Long missionId, int durationDays);

    // 1. 단건 미션 조회
    MissionResponseDto.Info getMissionById(Long missionId);

    // 2. 전체 미션 목록 조회
    List<MissionResponseDto.Info> getAllMissions();

    // 3. 유저의 미션 진행 상황 목록 조회
    List<MissionResponseDto.UserMissionDetail> getUserMissionProgressList(Long userId);

    // 4. 미션 수락 처리
    void acceptMission(Long userId, Long missionId);

    // 5. 체크리스트 상태 조회
    Map<String, Boolean> getUserChecklistStatus(Long userId, Long missionId);

    // 6. 미션 완료 처리
    MissionResponseDto.UserMissionDetail completeMission(Long userId, Long missionId);

    // 관리자용 메서드 선언
    void createMission(MissionRequestDto.SaveOrUpdate requestDto);

    void deleteMission(Long missionId);

    // 액션 기반 미션 검증 및 완료 처리
    MissionCheckResultDto verifyAndCompleteByAction(Long userId, Long missionId);
}