package com.zzanmat.tour.mission.controller;

import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.dto.UserMissionDto;
import com.zzanmat.tour.mission.service.MissionService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/mission")
@RequiredArgsConstructor
public class MissionViewController {

    private final MissionService missionService;
    private static final Long DEFAULT_USER_ID = 1L; // 테스트용 임시 유저 ID 상수화

    /**
     * [공통 유틸] 세션에서 유저 ID 추출 (없으면 기본값 반환)
     */
    private Long getUserId(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        return userId != null ? userId : DEFAULT_USER_ID;
    }

    /**
     * [공통 유틸] 뷰 페이지에 필요한 미션 목록 및 진행도 속성 바인딩
     */
    private void setMissionModelAttributes(Long userId, Model model) {
        List<MissionResponseDto> missions = missionService.getAllMissions();
        List<UserMissionDto> userMissions = missionService.getUserMissions(userId);

        int totalCount = missions.size();
        long completedCount = userMissions.stream()
                .filter(m -> m.isCompleted() || "DONE".equalsIgnoreCase(m.getStatus()) || "COMPLETED".equalsIgnoreCase(m.getStatus()))
                .count();

        double progressPercent = totalCount > 0 ? ((double) completedCount / totalCount) * 100.0 : 0.0;

        model.addAttribute("missions", missions);
        model.addAttribute("userMissions", userMissions);
        model.addAttribute("missionList", userMissions); // 기존 코드 호환용
        model.addAttribute("completedCount", completedCount);
        model.addAttribute("totalCount", totalCount > 0 ? totalCount : 4);
        model.addAttribute("progressPercent", Math.round(progressPercent));
    }

    // 1. 기본 미션 목록 페이지 (/mission 또는 /mission/list)
    @GetMapping({"", "/list"})
    public String missionPage(HttpSession session, Model model) {
        Long userId = getUserId(session);
        setMissionModelAttributes(userId, model);
        return "mission/mission";
    }

    // 2. 미션 상세/활성화 페이지 (/mission/active)
    @GetMapping("/active")
    public String missionActive(
            @RequestParam(required = false, defaultValue = "1") Long missionId,
            HttpSession session,
            Principal principal,
            Model model) {

        Long userId = getUserId(session);
        setMissionModelAttributes(userId, model);
        model.addAttribute("currentMissionId", missionId);

        return "mission/mission-active";
    }

    // 3. 미션 수락 처리
    @PostMapping("/accept")
    public String acceptMission(@RequestParam Long missionId, HttpSession session) {
        Long userId = getUserId(session);
        missionService.acceptMission(userId, missionId);
        return "redirect:/mission/active?missionId=" + missionId;
    }

    // 4. 미션 완료 및 포인트 적립 처리 (폼 전송 방식)
    @PostMapping("/complete")
    public String completeMission(@RequestParam("userMissionId") Long userMissionId,
                                  @RequestParam("rewardPoint") int rewardPoint) {
        missionService.processMissionCompletion(userMissionId, rewardPoint);
        return "redirect:/mission/active";
    }
}