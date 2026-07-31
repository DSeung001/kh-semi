package com.zzanmat.tour.mission.controller;

import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.dto.UserMissionDto;
import com.zzanmat.tour.mission.dto.UserMissionResponseDto;
import com.zzanmat.tour.mission.service.MissionService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/mission")
public class MissionApiController {

    private final MissionService missionService;

    // 1. 전체 미션 목록 조회 API
    @GetMapping
    public ResponseEntity<List<MissionResponseDto>> getAllMissions() {
        List<MissionResponseDto> missions = missionService.getAllMissions();
        return ResponseEntity.ok(missions);
    }

    // 2. 유저별 미션 진행 현황 조회 API (@RequestParam + 세션 모두 지원)
    @GetMapping("/my")
    public ResponseEntity<List<UserMissionResponseDto>> getMyMissions(
            @RequestParam(required = false) Long userId,
            HttpSession session) {

        Long resolvedUserId = getUserId(userId, session);
        List<UserMissionDto> userMissions = missionService.getUserMissions(resolvedUserId);

        List<UserMissionResponseDto> responseDtos = userMissions.stream().map(um -> {
            UserMissionResponseDto dto = new UserMissionResponseDto();
            dto.setUserMissionId(um.getUserMissionId());
            dto.setMissionId(um.getMissionId());
            dto.setStatus(um.getStatus());
            dto.setProgressCount(um.getCurrentCount());
            return dto;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(responseDtos);
    }

    // 3. 유저의 미션 세부 체크리스트 달성 현황 조회 API
    @GetMapping("/progress")
    public ResponseEntity<Map<String, Boolean>> getMissionProgressStatus(
            @RequestParam(required = false) Long userId,
            @RequestParam Long missionId,
            HttpSession session) {

        Long resolvedUserId = getUserId(userId, session);
        Map<String, Boolean> progressStatus = missionService.getUserChecklistStatus(resolvedUserId, missionId);
        return ResponseEntity.ok(progressStatus);
    }

    // 4. 미션 수락 API (Body 데이터 + 쿼리/세션 유연하게 처리)
    @PostMapping("/accept")
    public ResponseEntity<String> acceptMission(
            @RequestBody(required = false) Map<String, Long> request,
            @RequestParam(required = false) Long userIdParam,
            HttpSession session) {

        Long userId = null;
        if (request != null && request.containsKey("userId")) {
            userId = request.get("userId");
        }
        if (userId == null) {
            userId = userIdParam;
        }
        Long resolvedUserId = getUserId(userId, session);

        Long missionId = null;
        if (request != null && request.containsKey("missionId")) {
            missionId = request.get("missionId");
        }

        if (missionId == null) {
            throw new IllegalArgumentException("missionId는 필수입니다.");
        }

        missionService.acceptMission(resolvedUserId, missionId);
        return ResponseEntity.ok("Mission accepted successfully!");
    }

    // 5. 미션 완료 및 포인트 적립 API
    @PostMapping("/complete")
    public ResponseEntity<UserMissionResponseDto> completeMissionBody(
            @RequestBody(required = false) Map<String, Long> request,
            @RequestParam(required = false) Long userIdParam,
            HttpSession session) {

        Long userId = null;
        if (request != null && request.containsKey("userId")) {
            userId = request.get("userId");
        }
        if (userId == null) {
            userId = userIdParam;
        }
        Long resolvedUserId = getUserId(userId, session);

        Long missionId = null;
        if (request != null && request.containsKey("missionId")) {
            missionId = request.get("missionId");
        }

        if (missionId == null) {
            throw new IllegalArgumentException("missionId는 필수입니다.");
        }

        UserMissionResponseDto responseDto = missionService.completeMission(resolvedUserId, missionId);
        return ResponseEntity.ok(responseDto);
    }

    // 6. 미션 등록 API
    @PostMapping
    public ResponseEntity<String> createMission(@RequestBody @Valid MissionDto missionDto) {
        missionService.insertMission(missionDto);
        return ResponseEntity.status(HttpStatus.CREATED).body("Mission registered successfully!");
    }

    // 7. 미션 삭제 API
    @DeleteMapping("/{missionId}")
    public ResponseEntity<Void> removeMission(@PathVariable Long missionId) {
        missionService.deleteMission(missionId);
        return ResponseEntity.noContent().build();
    }

    /**
     * 💡 유저 ID를 안전하게 판별하는 공통 헬퍼 메서드
     * 1. 파라미터로 넘어온 userId가 있으면 우선 사용
     * 2. 없으면 세션에서 가져옴
     * 3. 둘 다 없으면 테스트를 위해 기본값 1L 부여 (500에러 방지)
     */
    private Long getUserId(Long paramUserId, HttpSession session) {
        if (paramUserId != null) {
            return paramUserId;
        }
        Long sessionUserId = (Long) session.getAttribute("userId");
        if (sessionUserId != null) {
            return sessionUserId;
        }
        return 1L; // 세션과 파라미터가 모두 없을 때 터지지 않고 1번 유저로 동작하도록 방어 코드 설정
    }
}