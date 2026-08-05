package com.zzanmat.tour.mission.service;

import com.zzanmat.tour.mission.dto.MissionRequestDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;

import java.util.List;

public interface MissionService {

    List<MissionResponseDto.Info> getAllMissions();

    MissionResponseDto.Info getMissionById(Long missionId);

    MissionResponseDto.Progress getUserMissionProgress(Long userId, Long missionId);

    void acceptMission(Long userId, Long missionId);

    MissionResponseDto.UserMissionDetail completeMission(Long userId, Long missionId);

    void createMission(MissionRequestDto.SaveOrUpdate requestDto);

    void updateMission(MissionRequestDto.SaveOrUpdate requestDto);

    void deleteMission(Long missionId);
}
