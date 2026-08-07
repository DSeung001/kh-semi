package com.zzanmat.tour.mission.mapper;

import com.zzanmat.tour.mission.dto.MissionRequestDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

@Mapper
public interface MissionMapper {

    List<MissionResponseDto.Info> findAll();

    MissionResponseDto.Info findById(Long missionId);

    MissionResponseDto.UserMissionDetail findUserMissionByUserAndMission(
            @Param("userId") Long userId,
            @Param("missionId") Long missionId
    );

    void saveProgress(@Param("userId") Long userId, @Param("missionId") Long missionId);

    void updateProgressCounts(
            @Param("userMissionId") Long userMissionId,
            @Param("currentCount") int currentCount,
            @Param("progress") int progress,
            @Param("status") String status
    );

    void updateStatus(@Param("userMissionId") Long userMissionId, @Param("status") String status);

    void updateRewardReceived(@Param("userMissionId") Long userMissionId);

    int countAllMissions();

    int countProgressByStatus(@Param("status") String status);

    List<Map<String, Object>> sumPointsByDayLast14();

    void savePointHistory(
            @Param("userId") Long userId,
            @Param("missionId") Long missionId,
            @Param("rewardPoint") int rewardPoint,
            @Param("reason") String reason
    );

    void save(MissionRequestDto.SaveOrUpdate requestDto);

    void saveCreateHistory(MissionRequestDto.SaveOrUpdate requestDto);

    void saveUpdateHistory(Long id);

    void update(MissionRequestDto.SaveOrUpdate requestDto);

    void saveDeleteArchive(Long missionId);

    void deleteById(Long missionId);
}