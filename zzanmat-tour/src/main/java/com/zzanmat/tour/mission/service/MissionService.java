package com.zzanmat.tour.mission.service;

import java.util.Map;
import com.zzanmat.tour.mission.dto.UserMissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.dto.UserMissionDto;

import java.util.List;

public interface MissionService {


    UserMissionResponseDto completeMission(Long userId, Long missionId);

    // 전체 미션 목록 조회

    List<MissionResponseDto> getAllMissions();

    //새로운 미션 등록

    void createMission(MissionDto mission);


    // 미션 정보 수정

    void updateMission(MissionDto mission);


    // 폼 전송 방식 또는 개별 ID 기반 미션 완료 처리

    void processMissionCompletion(Long userMissionId, int rewardPoint);

    // 미션 삭제

    void deleteMission(Long missionId);

    // 유저 최초 가입 시 기본 미션 생성 및 부여

    void createDefaultMissions(Long userId);

    // 특정 유저의 미션 진행 상태 목록 조회

    List<UserMissionDto> getUserMissions(Long userId);


    // 미션 진행 상태 개별 업데이트

    void updateMissionStatus(UserMissionDto userMissionDto);

    // 특정 행동(게시글 작성 등) 발생 시 연관된 자동 미션 진행 처리

    void processMissionOnAction(Long userId, String triggerEvent, Long postId);


    // 미션 수락 처리 (진행 중 상태로 변경)

    void acceptMission(Long userId, Long missionId);


    Map<String, Boolean> getUserChecklistStatus(Long userId, Long missionId);
}