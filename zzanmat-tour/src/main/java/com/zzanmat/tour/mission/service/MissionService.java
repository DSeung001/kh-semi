package com.zzanmat.tour.mission.service;

import com.zzanmat.tour.mission.dto.UserMissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.dto.UserMissionDto;
import java.util.List;

public interface MissionService {

    UserMissionResponseDto completeMission(Long userId, Long missionId);

    List<MissionResponseDto> getAllMissions();

    void insertMission(MissionDto mission);

    void updateMission(MissionDto mission);

    void processMissionCompletion(Long userMissionId, int rewardPoint);

    void deleteMission(Long missionId);

    void createDefaultMissions(Long userId);

    List<UserMissionDto> getUserMissions(Long userId);

    void updateMissionStatus(UserMissionDto userMissionDto);

    void processMissionOnAction(Long userId, String triggerEvent, Long postId);

    void acceptMission(Long userId, Long missionId);
}