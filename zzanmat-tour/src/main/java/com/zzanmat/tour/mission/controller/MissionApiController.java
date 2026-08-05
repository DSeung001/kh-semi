package com.zzanmat.tour.mission.controller;

import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.mission.service.MissionService;
import com.zzanmat.tour.common.dto.ApiResponse;
import com.zzanmat.tour.mission.dto.*;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/mission")
public class MissionApiController {

    private final MissionService missionService;

    // 1. 전체 미션 목록 조회 (실제 DB 연동 및 동적 리스트 반환)
    @GetMapping
    public ApiResponse<List<MissionResponseDto.Info>> getAllMissions() {
        List<MissionResponseDto.Info> missions = missionService.getAllMissions();
        return ApiResponse.success(missions);
    }

    // 2. 실시간 체크리스트 상태 조회 (하드코딩 제거, 완벽한 동적 파싱 및 DB 연동)
    @GetMapping("/progress")
    public ResponseEntity<?> getMissionProgressStatus(
            @RequestParam("missionId") String rawMissionId,
            HttpSession session) {

        Long userId = getUserId(session);

        // 미션 ID 동적 파싱 검증 (비정상 값 유입 방어)
        Long parsedMissionId;
        try {
            String cleanId = rawMissionId.replaceAll("[^0-9]", "");
            if (cleanId.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "유효하지 않은 미션 ID입니다."));
            }
            parsedMissionId = Long.valueOf(cleanId);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "미션 ID 파싱 중 오류가 발생했습니다."));
        }

        // 로그인 상태가 아닐 경우 기본 안내용 빈 체크리스트 구조 동적 반환
        if (userId == null) {
            Map<String, Boolean> defaultChecklist = new LinkedHashMap<>();
            defaultChecklist.put("1단계: 현장 위치 체크인", false);
            defaultChecklist.put("2단계: 필수 해시태그 인증샷 등록", false);
            defaultChecklist.put("3단계: 방문 후기 텍스트 작성 완료", false);
            return ResponseEntity.ok(Map.of("success", true, "data", defaultChecklist, "isLoggedIn", false));
        }

        try {
            // 실제 DB 서비스와 연동하여 해당 유저의 미션별 체크리스트 완료 상태를 동적으로 조회
            Map<String, Boolean> checklistStatus = missionService.getUserChecklistStatus(userId, parsedMissionId);

            if (checklistStatus == null) {
                checklistStatus = new LinkedHashMap<>();
            }

            return ResponseEntity.ok(Map.of("success", true, "data", checklistStatus, "isLoggedIn", true));
        } catch (Exception e) {
            log.error("미션 진행 상황 조회 중 DB 에러 발생 (userId: {}, missionId: {}): {}", userId, parsedMissionId, e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    // 3. 미션 완료 처리 (실제 DB 연동)
    @PostMapping("/complete")
    public ApiResponse<MissionResponseDto.UserMissionDetail> completeMission(
            @RequestBody @Valid MissionRequestDto.Action requestDto,
            HttpSession session) {

        Long userId = getUserId(session);
        if (userId == null) {
            throw new IllegalArgumentException("로그인이 필요합니다.");
        }

        MissionResponseDto.UserMissionDetail response = missionService.completeMission(userId, requestDto.getMissionId());
        return ApiResponse.success(response);
    }

    // 세션으로부터 실제 로그인된 유저의 PK를 동적으로 추출하는 공통 메서드
    private Long getUserId(HttpSession session) {
        if (session == null) return null;
        Object memberObj = session.getAttribute(SessionConst.LOGIN_MEMBER);
        if (memberObj == null) memberObj = session.getAttribute("loginUser");
        if (memberObj == null) memberObj = session.getAttribute("loginMember");

        if (memberObj instanceof Long) return (Long) memberObj;
        if (memberObj instanceof Integer) return ((Integer) memberObj).longValue();
        if (memberObj instanceof String) {
            try { return Long.parseLong((String) memberObj); } catch (NumberFormatException ignored) {}
        }
        try {
            java.lang.reflect.Method getIdMethod = memberObj.getClass().getMethod("getId");
            Object idVal = getIdMethod.invoke(memberObj);
            if (idVal instanceof Long) return (Long) idVal;
            if (idVal instanceof Integer) return ((Integer) idVal).longValue();
        } catch (Exception ignored) {}
        return null;
    }
}