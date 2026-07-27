package com.zzanmat.tour.mission.mapper;

import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.dto.MissionImageDto;
import com.zzanmat.tour.mission.dto.UserMissionDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface MissionMapper {
    void insertMission(MissionDto mission);

    void updateMission(MissionDto mission);

    void deleteMission(Long missionId);

    void insertMissionImages(List<MissionImageDto> images);

    void insertDefaultMissionsForUser(Long userId);

    List<UserMissionDto> selectUserMissions(Long userId);

    void updateMissionStatus(UserMissionDto userMissionDto);
}