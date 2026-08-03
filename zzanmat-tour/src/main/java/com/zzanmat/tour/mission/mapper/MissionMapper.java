package com.zzanmat.tour.mission.mapper;

import com.zzanmat.tour.mission.dto.MissionRequestDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MissionMapper {

    List<MissionResponseDto.Info> findAll();

    List<MissionResponseDto.UserMissionDetail> findUserMissionsByUserId(@Param("userId") Long userId);

    MissionResponseDto.UserMissionDetail findUserMissionByUserAndMission(@Param("userId") Long userId, @Param("missionId") Long missionId);

    void updateUserMissionStatus(@Param("userMissionId") Long userMissionId, @Param("status") String status);

    void saveSingleUserMission(@Param("userId") Long userId, @Param("missionId") Long missionId);

    boolean existsTransitAuth(@Param("userId") Long userId);

    boolean existsLandmarkAuth(@Param("userId") Long userId);

    boolean existsMealAuth(@Param("userId") Long userId);

    int countUserPosts(@Param("userId") Long userId);

    void addPointToUser(@Param("userId") Long userId, @Param("rewardPoint") int rewardPoint);

    void savePointHistory(@Param("userId") Long userId, @Param("missionId") Long missionId, @Param("rewardPoint") int rewardPoint, @Param("type") String type);

    void updateRewardReceived(@Param("userMissionId") Long userMissionId);

    void saveMission(MissionRequestDto.SaveOrUpdate requestDto);

    void deleteMissionById(@Param("id") Long missionId);
}