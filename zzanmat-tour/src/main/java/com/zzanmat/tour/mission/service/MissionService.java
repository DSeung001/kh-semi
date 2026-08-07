package com.zzanmat.tour.mission.service;

import com.zzanmat.tour.mission.dto.MissionRequestDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.post.dto.PostDto;

import java.util.List;

public interface MissionService {

    List<MissionResponseDto.Info> getAllMissions(Long userId);

    MissionResponseDto.Info getMissionById(Long missionId, Long userId);

    MissionResponseDto.Progress getUserMissionProgress(Long userId, Long missionId);

    MissionResponseDto.UserMissionDetail completeMission(Long userId, Long missionId);

    void recordPostProgress(Long userId, Long missionId, PostDto post);

    int countAllMissions();

    void createMission(MissionRequestDto.SaveOrUpdate requestDto);

    void updateMission(MissionRequestDto.SaveOrUpdate requestDto);

    void deleteMission(Long missionId);
}
