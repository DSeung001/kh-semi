package com.zzanmat.tour.mission.controller;

import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.service.MissionService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@Controller
@RequestMapping("/mission")
public class MissionController {

    private final MissionService missionService;

    // 1. 미션 목록 화면 페이지
    @GetMapping({"", "/list"})
    public String missionPage() {
        return "mission/mission";
    }

    // 2. 미션 상세(active) 페이지 진입 (완전한 동적 세션 유저 바인딩)

    @GetMapping("/active")
    public String missionActive(
            @RequestParam(required = false) Long missionId,
            HttpSession session,
            Model model) {

        // 세션에서 실제 로그인된 회원 번호를 동적으로 추출
        Long userId = getLoginUserId(session);

        // 화면에 현재 로그인된 유저 ID 전달 (프론트/JSP 동적 렌더링용)
        model.addAttribute("currentUserId", userId);

        MissionResponseDto.Info missionDto = null;

        // 1. 전달받은 missionId가 있다면 해당 미션 조회, 없으면 전체 목록 중 첫 번째 미션 동적 조회
        try {
            if (missionId != null) {
                missionDto = missionService.getMissionById(missionId);
            }

            if (missionDto == null) {
                List<MissionResponseDto.Info> allMissions = missionService.getAllMissions();
                if (allMissions != null && !allMissions.isEmpty()) {
                    missionDto = allMissions.get(0);
                }
            }
        } catch (Exception e) {
            log.error("미션 정보 동적 조회 중 에러 발생: {}", e.getMessage());
        }

        model.addAttribute("mission", missionDto);

        // 2. 로그인된 유저가 있는 경우에만 해당 유저의 실시간 미션 진행 상황 동적 조회
        try {
            if (userId != null) {
                List<MissionResponseDto.UserMissionDetail> userMissions = missionService.getUserMissionProgressList(userId);
                model.addAttribute("userMissions", userMissions != null ? userMissions : Collections.emptyList());
            } else {
                model.addAttribute("userMissions", Collections.emptyList());
            }
        } catch (Exception e) {
            log.error("유저 미션 진행 상황 동적 조회 실패: {}", e.getMessage());
            model.addAttribute("userMissions", Collections.emptyList());
        }

        return "mission/mission-active";
    }


    // 💡 비동기 통신용 REST API 엔드포인트


    // 3. 미션 전체 목록 조회 API
    @ResponseBody
    @GetMapping("/api/list")
    public ResponseEntity<?> getMissionList() {
        try {
            List<MissionResponseDto.Info> allMissions = missionService.getAllMissions();
            return ResponseEntity.ok(allMissions != null ? allMissions : Collections.emptyList());
        } catch (Exception e) {
            log.error("미션 목록 조회 실패: {}", e.getMessage());
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // 4. 미션 체크리스트 상태 조회 API (미참여 시 자동 수락 처리 후 조회)
    @ResponseBody
    @GetMapping("/api/progress")
    public ResponseEntity<?> getMissionProgress(
            @RequestParam("missionId") String rawMissionId,
            HttpSession session) {

        Long userId = getLoginUserId(session);
        if (userId == null) {
            return ResponseEntity.status(401).body("LOGIN_REQUIRED");
        }

        try {
            Long missionId = Long.valueOf(rawMissionId.trim().split("[:?#]")[0].replaceAll("[^0-9]", ""));

            //사용자가 이 미션을 아직 수락하지 않았다면 자동으로 수락 처리
            try {
                missionService.acceptMission(userId, missionId);
            } catch (Exception ignored) {
                // 이미 수락했거나 중복 참여인 경우 무시하고 진행
            }

            // 안전하게 체크리스트 상태 조회

            Map<String, Boolean> checklist = missionService.getUserChecklistStatus(userId, missionId);
            return ResponseEntity.ok(checklist != null ? checklist : Collections.emptyMap());

        } catch (Exception e) {
            log.error("체크리스트 조회 및 자동 참여 실패: {}", e.getMessage());
            return ResponseEntity.ok(Collections.emptyMap());
        }
    }

    // 5. 미션 수락 API

    @ResponseBody
    @PostMapping("/api/accept")
    public ResponseEntity<?> acceptMission(
            @RequestBody Map<String, Long> requestBody,
            HttpSession session) {

        Long userId = getLoginUserId(session);
        if (userId == null) {
            return ResponseEntity.status(401).body("LOGIN_REQUIRED");
        }

        Long missionId = requestBody.get("missionId");
        if (missionId == null) {
            return ResponseEntity.badRequest().body("미션 ID가 누락되었습니다.");
        }

        try {
            missionService.acceptMission(userId, missionId);
            return ResponseEntity.ok(Collections.singletonMap("success", true));
        } catch (Exception e) {
            log.error("미션 수락 실패: {}", e.getMessage());
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // 6. 미션 완료 API

    @ResponseBody
    @PostMapping("/api/complete")
    public ResponseEntity<?> completeMission(
            @RequestBody Map<String, Long> requestBody,
            HttpSession session) {

        Long userId = getLoginUserId(session);
        if (userId == null) {
            return ResponseEntity.status(401).body("LOGIN_REQUIRED");
        }

        Long missionId = requestBody.get("missionId");
        if (missionId == null) {
            return ResponseEntity.badRequest().body("미션 ID가 누락되었습니다.");
        }

        try {
            MissionResponseDto.UserMissionDetail result = missionService.completeMission(userId, missionId);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            log.error("미션 완료 실패: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Collections.singletonMap("message", e.getMessage()));
        }
    }

     //세션에서 로그인 유저 PK를 안전하게 추출하는 공통 메서드 (Long / Integer 타입 모두 호환)

    private Long getLoginUserId(HttpSession session) {
        if (session == null) {
            return null;
        }
        Object memberObj = session.getAttribute(SessionConst.LOGIN_MEMBER);
        if (memberObj instanceof Long) {
            return (Long) memberObj;
        } else if (memberObj instanceof Integer) {
            return ((Integer) memberObj).longValue();
        }
        return null;
    }
}