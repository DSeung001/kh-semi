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


    // 전체 미션 목록 조회

    List<MissionResponseDto> findAll();

    // 미션 등록

    void insertMission(MissionDto mission);


    // 미션 수정

    void updateMission(MissionDto mission);

    // 미션 삭제

    void deleteMission(Long missionId);


    // 회원가입 시 기본 미션 자동 생성

    void insertDefaultMissionsForUser(Long userId);

    // 특정 유저의 미션 진행 상태 목록 조회

    List<UserMissionDto> selectUserMissions(Long userId);


    // 미션 상태 업데이트 (완료 처리 등)

    void updateMissionStatus(UserMissionDto userMissionDto);

    // 특정 트리거 이벤트(게시글 작성 등)와 연관된 미션 목록 조회

    List<MissionResponseDto> findByTriggerEvent(@Param("triggerEvent") String triggerEvent);


    // 특정 액션에 대한 미션 이력 중복 여부 확인

    int existsHistory(@Param("userId") Long userId,
                      @Param("missionId") Long missionId,
                      @Param("postId") Long postId);


    // 특정 유저의 개별 미션 진행 상황 조회

    UserMissionDto findProgress(@Param("userId") Long userId,
                                @Param("missionId") Long missionId);


     // 미션 진행 횟수, 퍼센트, 상태, 완료일시 업데이트
    void updateProgress(@Param("userMissionId") Long userMissionId,
                        @Param("currentCount") int currentCount,
                        @Param("progress") int progress,
                        @Param("status") String status,
                        @Param("completedAt") LocalDateTime completedAt);

    // 미션 수행 히스토리 기록 추가

    void insertHistory(@Param("userId") Long userId,
                       @Param("missionId") Long missionId,
                       @Param("postId") Long postId,
                       @Param("actionType") String actionType);


     // 유저 포인트 증가 처리

    void addPointToUser(@Param("userId") Long userId,
                        @Param("point") int point);


    // 포인트 적립 이력(point_history) 추가

    void insertPointHistory(@Param("userId") Long userId,
                            @Param("missionId") Long missionId,
                            @Param("point") int point,
                            @Param("reason") String reason);


    // 미션 보상 수령 여부(reward_received) 플래그 업데이트

    void updateRewardReceived(@Param("userMissionId") Long userMissionId);

// 자동 인증 체크를 위해 추가한 메서드들

boolean existsTransitAuth(@Param("userId") Long userId);
boolean existsLandmarkAuth(@Param("userId") Long userId);
boolean existsMealAuth(@Param("userId") Long userId);
int countUserPosts(@Param("userId") Long userId);
}