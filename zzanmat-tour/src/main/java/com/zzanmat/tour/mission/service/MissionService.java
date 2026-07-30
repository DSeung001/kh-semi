package com.zzanmat.tour.mission.service;

import com.zzanmat.tour.mission.dto.UserMissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;
import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.dto.UserMissionDto;
import java.util.List;

public interface MissionService {


    UserMissionResponseDto completeMission(Long userId, Long missionId);

    List<MissionResponseDto> getAllMissions();

    SseEmitter subscribe(Long userId);

    void createMission(MissionDto mission);

    void updateMission(MissionDto mission);

    void deleteMission(Long missionId);


    void createDefaultMissions(Long userId);

    List<UserMissionDto> getUserMissions(Long userId);

    void updateMissionStatus(UserMissionDto userMissionDto);
}
