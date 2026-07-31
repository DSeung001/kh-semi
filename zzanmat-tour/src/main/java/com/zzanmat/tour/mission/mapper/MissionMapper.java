package com.zzanmat.tour.mission.mapper;

import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.dto.UserMissionDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MissionMapper {

    List<MissionResponseDto> findAll();

    void save(MissionDto mission);

    void update(MissionDto mission);

    void deleteById(@Param("id") Long missionId);

    void saveDefaultMissionsForUser(@Param("userId") Long userId);

    List<UserMissionDto> findUserMissionsByUserId(@Param("userId") Long userId);

    void updateStatus(UserMissionDto userMissionDto);
}
