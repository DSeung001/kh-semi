package com.zzanmat.tour.mission.service;

import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;
import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.dto.MissionImageDto;
import com.zzanmat.tour.mission.dto.MissionPostDto;
import com.zzanmat.tour.mission.dto.UserMissionDto;
import com.zzanmat.tour.mission.dto.UserMissionResponseDto;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;

public interface MissionService {

    UserMissionResponseDto processMissionAuthAndPush(MissionPostDto postDto, List<MultipartFile> files);

    SseEmitter subscribe(Long userId);

    void insertMission(MissionDto mission);

    void updateMission(MissionDto mission);

    void deleteMission(Long missionId);

    void insertMissionImgaes(List<MissionImageDto> images);

    void createDefaultMissions(Long userId);

    List<UserMissionDto> getUserMissions(Long userId);

    void updateMissionStatus(UserMissionDto userMissionDto);

    void processMissionAuth(MissionPostDto postDto, List<MultipartFile> files);
}