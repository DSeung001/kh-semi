package com.zzanmat.tour.mission.mapper;

import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.dto.UserMissionDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface MissionMapper {

    List<MissionResponseDto> findAll();

    void insertMission(MissionDto mission);
    void updateMission(MissionDto mission);
    void deleteMission(Long missionId);
    void insertDefaultMissionsForUser(Long userId);
    List<UserMissionDto> selectUserMissions(Long userId);
    void updateMissionStatus(UserMissionDto userMissionDto);

    // ⭐️ 이 메서드가 빠져 있어서 에러가 난 것입니다! 아래 메서드들을 추가해 주세요.
    List<MissionResponseDto> findByTriggerEvent(@Param("triggerEvent") String triggerEvent);

    int existsHistory(@Param("userId") Long userId, @Param("missionId") Long missionId, @Param("postId") Long postId);

    UserMissionDto findProgress(@Param("userId") Long userId, @Param("missionId") Long missionId);

    void updateProgress(@Param("userMissionId") Long userMissionId,
                        @Param("currentCount") int currentCount,
                        @Param("progress") int progress,
                        @Param("status") String status,
                        @Param("completedAt") LocalDateTime completedAt);

    void insertHistory(@Param("userId") Long userId,
                       @Param("missionId") Long missionId,
                       @Param("postId") Long postId,
                       @Param("actionType") String actionType);

    void addPointToUser(@Param("userId") Long userId, @Param("point") int point);

    void insertPointHistory(@Param("userId") Long userId,
                            @Param("missionId") Long missionId,
                            @Param("point") int point,
                            @Param("reason") String reason);

    void updateRewardReceived(@Param("userMissionId") Long userMissionId);
}
