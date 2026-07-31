package com.zzanmat.tour.mission.service;

import com.zzanmat.tour.mission.dto.UserMissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.dto.UserMissionDto;

import java.util.Map;
import java.util.List;

public interface MissionService {

    UserMissionResponseDto getUserMissionProgress(Long missionId);

    List<MissionResponseDto> getAllMissions();

    void createMission(MissionDto mission);

    void saveMission(MissionDto mission);

    Map<String, Boolean> getUserChecklistStatus(Long userId, Long missionId);

    void updateMission(MissionDto mission);

    void deleteMission(Long missionId);

    void createDefaultMissions(Long userId);

    List<UserMissionDto> getUserMissions(Long userId);

    void updateStatus(UserMissionDto userMissionDto);

    UserMissionResponseDto completeMission(Long userId, Long missionId);

    void processMissionOnAction(Long userId, String triggerEvent, Long postId);

    void acceptMission(Long userId, Long missionId);

    void processMissionCompletion(Long userMissionId, int rewardPoint);
}