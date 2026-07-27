package com.zzanmat.tour.mission.service.impl;

import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.dto.MissionImageDto;
import com.zzanmat.tour.mission.dto.MissionPostDto;
import com.zzanmat.tour.mission.dto.UserMissionDto;
import com.zzanmat.tour.mission.mapper.MissionMapper;
import com.zzanmat.tour.mission.service.MissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MissionServiceImpl implements MissionService {

    private final MissionMapper missionMapper;

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
}