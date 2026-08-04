package com.zzanmat.tour.mission.controller;

import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.mission.service.MissionService;
import com.zzanmat.tour.common.dto.ApiResponse;
import com.zzanmat.tour.mission.dto.*;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.Enumeration;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/mission")
public class MissionApiController {

    private final MissionService missionService;

    // 1. 전체 미션 목록 조회 API (로그인 불필요)
    @GetMapping
    public ApiResponse<List<MissionResponseDto.Info>> getAllMissions() {
        return ApiResponse.success(missionService.getAllMissions());
    }

    // 2. 내 미션 목록 조회 API
    @GetMapping("/my")
    public ApiResponse<List<MissionResponseDto.UserMissionDetail>> getMyMissions(HttpSession session) {
        Long userId = getUserId(session);
        if (userId == null) {
            throw new IllegalArgumentException("로그인이 필요합니다.");
        }
        return ApiResponse.success(missionService.getUserMissionProgressList(userId));
    }

    // 3. 프로그레스바 데이터 조회 API
    @GetMapping("/my/progress-bars")
    public ApiResponse<List<MissionProgressResponse>> getMyMissionProgressBars(HttpSession session) {
        Long userId = getUserId(session);
        if (userId == null) {
            throw new IllegalArgumentException("로그인이 필요합니다.");
        }

        List<MissionResponseDto.UserMissionDetail> userMissions = missionService.getUserMissionProgressList(userId);

        List<MissionProgressResponse> responseList = userMissions.stream().map(m -> {
            int target = m.getTargetCount() == 0 ? 1 : m.getTargetCount();
            int current = Math.min(m.getProgressCount(), target);
            int percent = (int) (((double) current / target) * 100);

            return new MissionProgressResponse(
                    m.getMissionId(),
                    m.getTitle(),
                    m.getStatus(),
                    current,
                    target,
                    percent,
                    m.isRewardReceived()
            );
        }).collect(Collectors.toList());

        return ApiResponse.success(responseList);
    }

    // 4. 체크리스트 상태 조회 API (정상 파싱 로직 적용)
    @GetMapping("/progress")
    public ApiResponse<Map<String, Boolean>> getMissionProgressStatus(
            @RequestParam("missionId") String rawMissionId,
            HttpSession session) {

        Long userId = getUserId(session);
        if (userId == null) {
            throw new IllegalArgumentException("로그인이 필요합니다.");
        }

        // '1:1' 또는 '1' 형태로 들어와도 첫 번째 숫자만 안전하게 파싱
        Long parsedMissionId;
        try {
            parsedMissionId = Long.valueOf(rawMissionId.split(":")[0]);
        } catch (Exception e) {
            throw new IllegalArgumentException("유효하지 않은 미션 ID 형식입니다.");
        }

        Map<String, Boolean> checklistStatus = missionService.getUserChecklistStatus(userId, parsedMissionId);
        return ApiResponse.success(checklistStatus);
    }

    // 5. 미션 수락 API
    @PostMapping("/accept")
    public ApiResponse<Void> acceptMission(
            @RequestBody @Valid MissionRequestDto.Action requestDto,
            HttpSession session) {

        Long userId = getUserId(session);
        log.info("미션 수락 요청 - resolved userId: {}, missionId: {}", userId, requestDto.getMissionId());

        if (userId == null) {
            log.warn("미션 수락 실패: 로그인되지 않은 사용자");
            throw new IllegalArgumentException("로그인이 필요합니다.");
        }

        missionService.acceptMission(userId, requestDto.getMissionId());
        return ApiResponse.success(null);
    }

    // 6. 미션 완료 API
    @PostMapping("/complete")
    public ApiResponse<MissionResponseDto.UserMissionDetail> completeMission(
            @RequestBody @Valid MissionRequestDto.Action requestDto,
            HttpSession session) {

        Long userId = getUserId(session);
        if (userId == null) {
            log.warn("미션 완료 실패: 로그인되지 않은 사용자");
            throw new IllegalArgumentException("로그인이 필요합니다.");
        }

        MissionResponseDto.UserMissionDetail response = missionService.completeMission(userId, requestDto.getMissionId());
        return ApiResponse.success(response);
    }

    // 7. 관리자용 미션 생성 API
    @PostMapping
    public ApiResponse<Void> createMission(@RequestBody @Valid MissionRequestDto.SaveOrUpdate requestDto) {
        missionService.createMission(requestDto);
        return ApiResponse.success(null);
    }

    // 8. 관리자용 미션 삭제 API
    @DeleteMapping("/{missionId}")
    public ApiResponse<Void> removeMission(@PathVariable Long missionId) {
        missionService.deleteMission(missionId);
        return ApiResponse.success(null);
    }

    // 9. 액션 검증 및 완료 처리 API (중복 코드 및 오탈자 수정 완료)
    @PostMapping("/verify-action")
    public ApiResponse<MissionCheckResultDto> verifyActionMission(
            @RequestBody Map<String, Long> request,
            HttpSession session) {

        Long userId = getUserId(session);
        if (userId == null) {
            throw new IllegalArgumentException("로그인이 필요합니다.");
        }

        Long missionId = request.get("missionId");
        if (missionId == null) {
            throw new IllegalArgumentException("미션 ID가 전달되지 않았습니다.");
        }

        MissionCheckResultDto result = missionService.verifyAndCompleteByAction(userId, missionId);
        return ApiResponse.success(result);
    }

    // 10. 로그인 세션 저장 방식을 모두 수용하는 안전한 유저 ID 추출 메서드
    private Long getUserId(HttpSession session) {
        if (session == null) {
            log.warn("세션 객체가 null입니다.");
            return null;
        }

        Object memberObj = session.getAttribute(SessionConst.LOGIN_MEMBER);
        if (memberObj == null) memberObj = session.getAttribute("loginUser");
        if (memberObj == null) memberObj = session.getAttribute("loginMember");
        if (memberObj == null) memberObj = session.getAttribute("user");
        if (memberObj == null) memberObj = session.getAttribute("member");

        if (memberObj == null) {
            return null;
        }

        if (memberObj instanceof Long) {
            return (Long) memberObj;
        } else if (memberObj instanceof Integer) {
            return ((Integer) memberObj).longValue();
        } else if (memberObj instanceof String) {
            try {
                return Long.parseLong((String) memberObj);
            } catch (NumberFormatException ignored) {}
        }

        try {
            java.lang.reflect.Method getIdMethod = memberObj.getClass().getMethod("getId");
            Object idVal = getIdMethod.invoke(memberObj);
            if (idVal instanceof Long) return (Long) idVal;
            if (idVal instanceof Integer) return ((Integer) idVal).longValue();
        } catch (Exception e) {
            log.warn("세션 객체로부터 유저 ID를 리플렉션으로 추출하는 데 실패했습니다: {}", e.getMessage());
        }

        return null;
    }

    @lombok.Getter
    @lombok.AllArgsConstructor
    public static class MissionProgressResponse {
        private Long missionId;
        private String title;
        private String status;
        private int currentCount;
        private int targetCount;
        private int percent;
        private boolean rewardReceived;
    }
}