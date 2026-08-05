package com.zzanmat.tour.mission.mapper;

import com.zzanmat.tour.mission.dto.MissionRequestDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MissionMapper {

    List<MissionResponseDto.Info> findAll();

    MissionResponseDto.Info findById(@Param("missionId") Long missionId);

    MissionResponseDto.UserMissionDetail findUserMissionByUserAndMission(
            @Param("userId") Long userId,
            @Param("missionId") Long missionId
    );

    void saveProgress(
            @Param("userId") Long userId,
            @Param("missionId") Long missionId
    );

    void updateStatus(
            @Param("userMissionId") Long userMissionId,
            @Param("status") String status
    );

    void updateRewardReceived(@Param("userMissionId") Long userMissionId);

    void savePointHistory(
            @Param("userId") Long userId,
            @Param("missionId") Long missionId,
            @Param("rewardPoint") int rewardPoint,
            @Param("reason") String reason
    );

    void save(MissionRequestDto.SaveOrUpdate requestDto);

    void update(MissionRequestDto.SaveOrUpdate requestDto);

    void deleteById(@Param("missionId") Long missionId);
}
