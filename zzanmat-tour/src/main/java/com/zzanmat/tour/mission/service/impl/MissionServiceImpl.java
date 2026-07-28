package com.zzanmat.tour.mission.service.impl;

import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.dto.MissionImageDto;
import com.zzanmat.tour.mission.dto.MissionPostDto;
import com.zzanmat.tour.mission.dto.UserMissionDto;
import com.zzanmat.tour.mission.dto.UserMissionResponseDto;
import com.zzanmat.tour.mission.mapper.MissionMapper;
import com.zzanmat.tour.mission.service.MissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MissionServiceImpl implements MissionService {

    private final MissionMapper missionMapper;

    @Override
    public SseEmitter subscribe(Long userId) {

        SseEmitter emitter = new SseEmitter(60L * 1000L * 30L);

        // 3. 연결 종료, 타임아웃, 에러 발생 시 메모리 누수 방지를 위한 제거 로직 작성
        emitter.onCompletion(() -> {
            // emitterMap.remove(userId);
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
    public void insertMissionImgaes(List<MissionImageDto> images) {
        missionMapper.insertMissionImages(images);
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
    public void processMissionAuth(MissionPostDto postDto, List<MultipartFile> files) {

    }
    @Override
    public UserMissionResponseDto processMissionAuthAndPush(MissionPostDto postDto, List<MultipartFile> files) {
        // 1. 미션 인증 처리 로직 구현
        // 2. 파일 업로드 처리
        // 3. SSE를 통한 실시간 푸시 전송 로직 등

        return new UserMissionResponseDto();   // 임시로 빈 객체 생성 후 반환 (에러 방지용)
    }
}