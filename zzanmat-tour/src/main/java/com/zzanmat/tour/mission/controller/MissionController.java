package com.zzanmat.tour.mission.controller;

import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.dto.MissionPostDto;
import com.zzanmat.tour.mission.dto.UserMissionResponseDto;
import com.zzanmat.tour.mission.service.MissionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;

@RestController
@RequestMapping("/mission")
@RequiredArgsConstructor
public class MissionController {

    private final MissionService missionService;

    @PostMapping
    public ResponseEntity<String> createMission(@RequestBody @Valid MissionDto missionDto) {
        missionService.insertMission(missionDto);
        return ResponseEntity.ok("Mission registered successfully!");
    }

    @GetMapping(value = "/subscribe/{userId}", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter subscribe(@PathVariable Long userId) {
        return missionService.subscribe(userId);  // 실시간 진행률 보냄
    }

    @PostMapping("/auth")
    public ResponseEntity<UserMissionResponseDto> createMissionAuth(
            @RequestPart("postDto") @Valid MissionPostDto postDto,
            @RequestPart(value = "files", required = false) List<MultipartFile> files) {

        UserMissionResponseDto progressDto = missionService.processMissionAuthAndPush(postDto, files);
        return ResponseEntity.ok(progressDto);
    }

    @DeleteMapping("/{missionId}")
    public ResponseEntity<String> removeMission(@PathVariable Long missionId) {
        missionService.deleteMission(missionId);
        return ResponseEntity.ok("Mission deleted successfully!");
    }
}