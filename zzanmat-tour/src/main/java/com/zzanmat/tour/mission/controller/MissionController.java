package com.zzanmat.tour.mission.controller;

import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.mission.dto.MissionRequestDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
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
import org.springframework.web.bind.annotation.SessionAttribute;

import java.util.Collections;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Controller
@RequestMapping("/mission")
public class MissionController {

    private final MissionService missionService;

    @GetMapping({"", "/list"})
    public String missionPage(
            Model model,
            @SessionAttribute(value = SessionConst.LOGIN_MEMBER, required = false) MemberDto loginMember
    ) {
        Long userId = loginMember != null ? loginMember.getId() : null;
        try {
            List<MissionResponseDto.Info> missions = missionService.getAllMissions(userId);
            model.addAttribute("missions", missions != null ? missions : Collections.emptyList());
        } catch (Exception e) {
            log.error("미션 목록 조회 실패: {}", e.getMessage());
            model.addAttribute("missions", Collections.emptyList());
        }
        return "mission/mission";
    }

    @GetMapping("/active")
    public String missionActive(
            @RequestParam(required = false) Long missionId,
            Model model,
            @SessionAttribute(value = SessionConst.LOGIN_MEMBER, required = false) MemberDto loginMember
    ) {
        Long userId = loginMember != null ? loginMember.getId() : null;
        MissionResponseDto.Info mission = null;
        try {
            if (missionId != null) {
                mission = missionService.getMissionById(missionId, userId);
            }
            if (mission == null) {
                List<MissionResponseDto.Info> allMissions = missionService.getAllMissions(userId);
                if (allMissions != null && !allMissions.isEmpty()) {
                    mission = allMissions.stream()
                            .filter(MissionResponseDto.Info::isAvailable)
                            .findFirst()
                            .orElse(allMissions.get(0));
                }
            }
        } catch (Exception e) {
            log.error("미션 상세 조회 실패: {}", e.getMessage());
        }

        model.addAttribute("mission", mission);
        return "mission/mission-active";
    }

    @PostMapping({"/check-auth-and-post", "/check-auth", "/check-auth-and-move"})
    public String checkAuthAndPost(
            MissionRequestDto request,
            @SessionAttribute(value = SessionConst.LOGIN_MEMBER, required = false) MemberDto loginMember,
            HttpSession session
    ) {
        Long missionId = request.getMissionId();
        String redirectUrl = request.getRedirectUrl();
        String fallback = "/mission/active?missionId=" + missionId;

        if (loginMember == null) {
            session.setAttribute("redirectUrl",
                    (redirectUrl != null && !redirectUrl.isEmpty()) ? redirectUrl : fallback);
            return "redirect:/member/login";
        }

        return "redirect:/new-post?missionId=" + missionId;
    }
}
