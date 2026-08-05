package com.zzanmat.tour.mission.mapper;

import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionRequestDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Mapper
public interface MissionMapper {

    // 1. 전체 미션 조회
    List<MissionResponseDto.Info> findAll();

    // 2. 유저별 미션 진행 상황 목록 조회
    List<MissionResponseDto.UserMissionDetail> findUserMissionsByUserId(@Param("userId") Long userId);

    // 3. 유저와 미션 ID로 개별 미션 진행 상황 조회
    MissionResponseDto.UserMissionDetail findUserMissionByUserAndMission(
            @Param("userId") Long userId,
            @Param("missionId") Long missionId
    );

    Map<String, Object> findUserMission(
            @Param("userId") Long userId,
            @Param("missionId") Long missionId
    );

    // 4. 미션 기본 정보 조회
    Map<String, Object> findMissionInfoById(@Param("missionId") Long missionId);

    // 5. mission_progress 테이블에 유저 미션 수락(생성) 저장
    void saveSingleUserMission(
            @Param("userId") Long userId,
            @Param("missionId") Long missionId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate
    );

    // 6. 상태 및 진행도 업데이트
    void updateUserMissionStatus(
            @Param("userMissionId") Long userMissionId,
            @Param("status") String status
    );

    void updateRewardReceived(@Param("userMissionId") Long userMissionId);

    // 7. 시스템 인증 관련 체크 메서드 예시
    boolean existsTransitAuth(@Param("userId") Long userId);

    boolean existsLandmarkAuth(@Param("userId") Long userId);

    boolean existsMealAuth(@Param("userId") Long userId);

    int countUserPosts(@Param("userId") Long userId);

    // 8. 포인트 및 마이페이지 연동 관련
    void addPointToUser(
            @Param("userId") Long userId,
            @Param("rewardPoint") int rewardPoint
    );

    void savePointHistory(
            @Param("userId") Long userId,
            @Param("missionId") Long missionId,
            @Param("rewardPoint") int rewardPoint,
            @Param("type") String type
    );

    int getUserPointBalance(@Param("userId") Long userId);

    // 9. 관리자용 미션 등록/삭제
    void saveMission(MissionRequestDto.SaveOrUpdate requestDto);

    void deleteMissionById(@Param("missionId") Long missionId);
}