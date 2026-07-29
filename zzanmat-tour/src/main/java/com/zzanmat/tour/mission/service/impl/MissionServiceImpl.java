package com.zzanmat.tour.mission.service.impl;

import org.springframework.transaction.annotation.Transactional;
import com.zzanmat.tour.mission.dto.UserMissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.dto.UserMissionDto;
import com.zzanmat.tour.mission.mapper.MissionMapper;
import com.zzanmat.tour.mission.service.MissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MissionServiceImpl implements MissionService {

    private final MissionMapper missionMapper;

    @Override
    public SseEmitter subscribe(Long userId) {
        SseEmitter emitter = new SseEmitter(60L * 1000L * 30L);

        emitter.onCompletion(() -> {
        });
        emitter.onTimeout(() -> {
            emitter.complete();
        });
        emitter.onError((e) -> {
            emitter.complete();
        });

        return emitter;
    }

    @Override
    public List<MissionResponseDto> getAllMissions() {
        return missionMapper.findAll();
    }

    @Override
    public void insertMission(MissionDto mission) {
        missionMapper.insertMission(mission);
    }

    @Override
    public void updateMission(MissionDto mission) {
        missionMapper.updateMission(mission);
    }

    @Override
    public void deleteMission(Long missionId) {
        missionMapper.deleteMission(missionId);
    }

    @Override
    public void createDefaultMissions(Long userId) {
        missionMapper.insertDefaultMissionsForUser(userId);
    }

    @Override
    public List<UserMissionDto> getUserMissions(Long userId) {
        return missionMapper.selectUserMissions(userId);
    }

    @Override
    public void updateMissionStatus(UserMissionDto userMissionDto) {
        missionMapper.updateMissionStatus(userMissionDto);
    }

    @Override
    @Transactional
    public UserMissionResponseDto completeMission(Long userId, Long missionId) {
        // 1. 유저 미션 상태 업데이트 객체 생성 (setMemberId 사용!)
        UserMissionDto userMissionDto = new UserMissionDto();
        userMissionDto.setMemberId(userId); // 👈 setUserId가 아니라 setMemberId입니다!
        userMissionDto.setMissionId(missionId);

        // 2. MyBatis 쿼리를 이용해 DB 업데이트 수행
        missionMapper.updateMissionStatus(userMissionDto);

        // 3. 업데이트된 최신 사용자 미션 목록을 가져온 뒤, 방금 인증한 미션 객체 찾기
        List<UserMissionDto> userMissions = missionMapper.selectUserMissions(userId);
        UserMissionDto updated = userMissions.stream()
                .filter(m -> m.getMissionId().equals(missionId))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("해당 미션을 찾을 수 없습니다."));

        // 4. 미션의 상세 정보(title 등)를 가져오기 위해 전체 미션 목록 조회 후 매핑
        List<MissionResponseDto> allMissions = missionMapper.findAll();
        MissionResponseDto missionInfo = allMissions.stream()
                .filter(m -> m.getId().equals(missionId))
                .findFirst()
                .orElse(null);

        // 5. 프론트엔드로 전달할 DTO로 변환하여 반환
        UserMissionResponseDto responseDto = new UserMissionResponseDto();
        responseDto.setId(updated.getUserMissionId()); // DTO 필드명이 userMissionId이므로 여기도 맞춤

        if (missionInfo != null) {
            responseDto.setTitle(missionInfo.getTitle());
        }

        return responseDto;
    }
}