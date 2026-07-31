package com.zzanmat.tour.mission.controller;

import com.zzanmat.tour.common.dto.ApiResponse;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.service.MissionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;

@RestController
@RequestMapping("/api/mission")
@RequiredArgsConstructor
public class MissionController {

    private final MissionService missionService;

    @GetMapping
    public ApiResponse<List<MissionResponseDto>> getAllMissions() {
        return ApiResponse.success(missionService.getAllMissions());
    }

    @PostMapping
    public ApiResponse<Void> createMission(@RequestBody @Valid MissionDto missionDto) {
        missionService.createMission(missionDto);
        return ApiResponse.success("Mission registered successfully!", null);
    }

    @GetMapping(value = "/subscribe/{userId}", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter subscribe(@PathVariable Long userId) {
        return missionService.subscribe(userId);  // 실시간 진행률 보냄
    }

    @DeleteMapping("/{missionId}")
    public ApiResponse<Void> removeMission(@PathVariable Long missionId) {
        missionService.deleteMission(missionId);
        return ApiResponse.success("Mission deleted successfully!", null);
    }
}
