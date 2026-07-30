package com.zzanmat.tour.mission.controller;

import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.service.MissionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;

@RestController
@RequestMapping("/api/mission")
@RequiredArgsConstructor
public class MissionController {

    private final MissionService missionService;

    @GetMapping
    public ResponseEntity<List<MissionResponseDto>> getAllMissions() {
        List<MissionResponseDto> missions = missionService.getAllMissions();
        return ResponseEntity.ok(missions);
    }

    @PostMapping
    public ResponseEntity<String> createMission(@RequestBody @Valid MissionDto missionDto) {
        missionService.insertMission(missionDto);
        return ResponseEntity.ok("Mission registered successfully!");
    }

    @GetMapping(value = "/subscribe/{userId}", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter subscribe(@PathVariable Long userId) {
        return missionService.subscribe(userId);  // 실시간 진행률 보냄
    }

    @DeleteMapping("/{missionId}")
    public ResponseEntity<String> removeMission(@PathVariable Long missionId) {
        missionService.deleteMission(missionId);
        return ResponseEntity.ok("Mission deleted successfully!");
    }
}