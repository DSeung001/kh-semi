package com.zzanmat.tour.mission.controller;

import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.dto.UserMissionResponseDto;
import com.zzanmat.tour.mission.service.MissionService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/mission")
public class MissionApiController {

    private final MissionService missionService;

    // 1. 미션 완료 및 인증 처리 API (/api/mission/complete/{missionId})
    @PostMapping("/complete/{missionId}")
    public ResponseEntity<UserMissionResponseDto> completeMission(@PathVariable Long missionId, HttpSession session) {
        // 세션에서 로그인된 유저 ID 가져오기 (없으면 테스트용 1L 사용)
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            userId = 1L; // 테스트용 임시 유저 ID 처리
        }

        UserMissionResponseDto responseDto = missionService.completeMission(userId, missionId);
        return ResponseEntity.ok(responseDto);
    }

    // 2. 전체 미션 목록 조회 API (/api/mission)
    @GetMapping
    public ResponseEntity<List<MissionResponseDto>> getAllMissions() {
        List<MissionResponseDto> missions = missionService.getAllMissions();
        return ResponseEntity.ok(missions);
    }

    // 3. 미션 등록 API (/api/mission)
    @PostMapping
    public ResponseEntity<String> createMission(@RequestBody @Valid MissionDto missionDto) {
        missionService.insertMission(missionDto);
        return ResponseEntity.ok("Mission registered successfully!");
    }

    // 4. 미션 삭제 API (/api/mission/{missionId})
    @DeleteMapping("/{missionId}")
    public ResponseEntity<String> removeMission(@PathVariable Long missionId) {
        missionService.deleteMission(missionId);
        return ResponseEntity.ok("Mission deleted successfully!");
    }
}