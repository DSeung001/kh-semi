package com.zzanmat.tour.mission.service;

import com.zzanmat.tour.mission.dto.MissionRequestDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;

import java.util.List;
import java.util.Map;

public interface MissionService {


    List<MissionResponseDto.Info> getAllMissions(Long userId);

    MissionResponseDto.Info getMissionById(Long missionId, Long userId);

    MissionResponseDto.Progress getUserMissionProgress(Long userId, Long missionId);

    MissionResponseDto.UserMissionDetail completeMission(Long userId, Long missionId);

    void recordPostProgress(Long userId, Long missionId);

    Map<String, Object> getAdminDashboardStats();

    void createMission(MissionRequestDto.SaveOrUpdate requestDto);

    void updateMission(MissionRequestDto.SaveOrUpdate requestDto);

    void deleteMission(Long missionId);
}
