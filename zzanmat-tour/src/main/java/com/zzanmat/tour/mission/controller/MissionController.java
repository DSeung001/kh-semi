package com.zzanmat.tour.mission.controller;

import com.zzanmat.tour.mission.dto.UserMissionResponseDto;
import com.zzanmat.tour.mission.service.MissionService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/mission")
@RequiredArgsConstructor
public class MissionController {

    private final MissionService missionService;

    // 1. 기본 미션 목록 페이지
    @GetMapping({"", "/list"})
    public String missionPage(HttpSession session, Model model) {
        addUserToModel(session, model);
        return "mission/mission";
    }

    // 2. 미션 상세/활성화 페이지
    @GetMapping("/active")
    public String missionActive(
            @RequestParam(required = false) Long missionId,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (missionId == null) {
            missionId = 1L;
        }

        Long userId = getLoginUserId(session);

        try {
            UserMissionResponseDto missionDto = missionService.getUserMissionProgress(missionId);
            Map<String, Boolean> checklistStatus = missionService.getUserChecklistStatus(userId, missionId);

            model.addAttribute("mission", missionDto);
            model.addAttribute("checklist", checklistStatus);
        } catch (Exception e) {
            log.error("미션 상세 정보를 불러오는 중 오류 발생: missionId={}", missionId, e);
            redirectAttributes.addFlashAttribute("errorMessage", "존재하지 않거나 불러올 수 없는 미션입니다.");
            return "redirect:/mission/list";
        }

        addUserToModel(session, model);
        return "mission/mission-active";
    }

    // 3. 미션 수락 처리용 메서드
    @PostMapping("/accept")
    public String acceptMission(
            @RequestParam Long missionId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Long userId = getLoginUserId(session);

        try {
            missionService.acceptMission(userId, missionId);
            redirectAttributes.addFlashAttribute("successMessage", "미션이 성공적으로 수락되었습니다!");
        } catch (Exception e) {
            log.error("미션 수락 실패: userId={}, missionId={}", userId, missionId, e);
            redirectAttributes.addFlashAttribute("errorMessage", "미션 수락 중 오류가 발생했습니다.");
        }

        return "redirect:/mission/active?missionId=" + missionId;
    }

    // 공통 유틸리티 메서드

    private Long getLoginUserId(HttpSession session) {
        Object sessionUser = session.getAttribute("loginUser");

        if (sessionUser != null) {
            if (sessionUser instanceof Long) {
                return (Long) sessionUser;
            }
            if (sessionUser instanceof Integer) {
                return ((Integer) sessionUser).longValue();
            }

            try {
                java.lang.reflect.Method getUserIdMethod;
                try {
                    getUserIdMethod = sessionUser.getClass().getMethod("getUserId");
                } catch (NoSuchMethodException e) {
                    getUserIdMethod = sessionUser.getClass().getMethod("getId");
                }
                Object idVal = getUserIdMethod.invoke(sessionUser);
                if (idVal != null) {
                    return Long.valueOf(idVal.toString());
                }
            } catch (Exception e) {
                log.warn("세션 유저 객체에서 ID를 추출하는 중 예외가 발생했습니다.", e);
            }
        }

        return 1L;
    }

    private void addUserToModel(HttpSession session, Model model) {
        Object sessionUser = session.getAttribute("loginUser");
        if (sessionUser != null) {
            model.addAttribute("loginUser", sessionUser);
        }
    }
}