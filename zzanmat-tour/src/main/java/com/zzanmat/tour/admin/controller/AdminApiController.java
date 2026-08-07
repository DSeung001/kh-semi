package com.zzanmat.tour.admin.controller;

import com.zzanmat.tour.mission.dto.MissionRequestDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.service.MissionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/admin")
public class AdminApiController {

    private final MissionService missionService;

    // 미션 단건 조회 (GET)

    @GetMapping("/missions/{id}")
    public ResponseEntity<MissionResponseDto.Info> getMissionApi(@PathVariable("id") Long id) {
        try {
            MissionResponseDto.Info mission = missionService.getMissionById(id, null);
            return ResponseEntity.ok(mission);
        } catch (Exception e) {
            log.error("관리자 미션 단건 조회 실패: {}", e.getMessage());
            return ResponseEntity.notFound().build();
        }
    }

    // 미션 등록 (POST)

    @PostMapping("/missions")
    public ResponseEntity<?> createMission(@RequestBody MissionRequestDto.SaveOrUpdate requestDto) {
        try {
            missionService.createMission(requestDto);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "미션이 성공적으로 등록되었습니다."
            ));
        } catch (Exception e) {
            log.error("미션 등록 실패: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "미션 등록에 실패했습니다: " + e.getMessage()
            ));
        }
    }

    // 미션 수정 (PUT)
    @PutMapping("/missions/{id}")
    public ResponseEntity<?> updateMission(@PathVariable Long id, @RequestBody MissionRequestDto.SaveOrUpdate requestDto) {
        try {
            requestDto.setId(id);
            missionService.updateMission(requestDto);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "미션이 성공적으로 수정되었습니다."
            ));
        } catch (Exception e) {
            log.error("미션 수정 실패: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "미션 수정에 실패했습니다: " + e.getMessage()
            ));
        }
    }

    // 미션 삭제 (DELETE)
    @DeleteMapping("/missions/{id}")
    public ResponseEntity<?> deleteMission(@PathVariable Long id) {
        try {
            missionService.deleteMission(id);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "미션이 삭제되었습니다."
            ));
        } catch (Exception e) {
            log.error("미션 삭제 실패: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "message", "미션 삭제에 실패했습니다: " + e.getMessage()
            ));
        }
    }
}

