package com.zzanmat.tour.mission.controller;

import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.mission.service.MissionService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.zzanmat.tour.mission.dto.MissionResponseDto;

import java.util.Collections;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Controller
@RequestMapping("/mission")
public class MissionController {

    private final MissionService missionService;

    // 1. 미션 목록 페이지 (실제 DB 조회)
    @GetMapping({"", "/list"})
    public String missionPage(Model model, HttpSession session) {
        Long userId = getLoginUserId(session);
        model.addAttribute("currentUserId", userId);

        try {
            List<MissionResponseDto.Info> missions = missionService.getAllMissions();
            model.addAttribute("missions", missions != null ? missions : Collections.emptyList());
        } catch (Exception e) {
            log.error("미션 목록 조회 실패: {}", e.getMessage());
            model.addAttribute("missions", Collections.emptyList());
        }
        return "mission/mission";
    }

    // 2. 미션 상세(active) 페이지 (하드코딩 제거, DB 내 첫 번째 미션 또는 요청된 ID 기반 동적 바인딩)
    @GetMapping("/active")
    public String missionActive(
            @RequestParam(required = false) Long missionId,
            HttpSession session,
            Model model) {

        Long userId = getLoginUserId(session);
        model.addAttribute("currentUserId", userId);

        MissionResponseDto.Info missionDto = null;
        try {
            List<MissionResponseDto.Info> allMissions = missionService.getAllMissions();

            if (allMissions != null && !allMissions.isEmpty()) {
                if (missionId != null) {
                    missionDto = allMissions.stream()
                            .filter(m -> m.getMissionId().equals(missionId))
                            .findFirst()
                            .orElse(allMissions.get(0));
                } else {
                    missionDto = allMissions.get(0);
                }
            }
        } catch (Exception e) {
            log.error("미션 상세 정보 조회 중 에러 발생: {}", e.getMessage());
        }

        model.addAttribute("mission", missionDto);
        return "mission/mission-active";
    }

    // 3. 미션 수락 처리 (DB 연동 및 비로그인 시 현재 페이지 복귀 주소 기억)
    @PostMapping("/accept")
    public String acceptMissionForm(
            @RequestParam("missionId") Long missionId,
            @RequestParam(value = "redirectUrl", required = false) String redirectUrl,
            HttpSession session) {

        Long userId = getLoginUserId(session);

        if (userId == null) {
            String destination = (redirectUrl != null && !redirectUrl.isEmpty())
                    ? redirectUrl
                    : "/mission/active?missionId=" + missionId;
            session.setAttribute("redirectUrl", destination);
            return "redirect:/member/login";
        }

        try {
            missionService.acceptMission(userId, missionId);
        } catch (Exception e) {
            log.warn("미션 수락 처리 중 예외 발생 (이미 수락됨 등): {}", e.getMessage());
        }

        return "redirect:" + (redirectUrl != null ? redirectUrl : "/mission/active?missionId=" + missionId);
    }

    // 4. 인증 게시물 작성 전 로그인 검증 및 미션 페이지 복귀 주소 세션 저장
    @PostMapping({"/check-auth-and-post", "/check-auth", "/check-auth-and-move"})
    public String checkAuthAndPost(
            @RequestParam("missionId") String missionId,
            @RequestParam(value = "redirectUrl", required = false) String redirectUrl,
            HttpSession session) {

        Long userId = getLoginUserId(session);

        if (userId == null) {
            String destination = (redirectUrl != null && !redirectUrl.isEmpty())
                    ? redirectUrl
                    : "/mission/active?missionId=" + missionId;
            session.setAttribute("redirectUrl", destination);
            return "redirect:/member/login";
        }

        return "redirect:/new-post?missionId=" + missionId;
    }

    // 세션으로부터 실제 유저 식별자(PK)를 안전하게 추출하는 공통 메서드
    private Long getLoginUserId(HttpSession session) {
        if (session == null) return null;

        Object memberObj = session.getAttribute(SessionConst.LOGIN_MEMBER);
        if (memberObj == null) memberObj = session.getAttribute("loginUser");
        if (memberObj == null) memberObj = session.getAttribute("loginMember");

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
        } catch (Exception ignored) {}

        return null;
    }
}