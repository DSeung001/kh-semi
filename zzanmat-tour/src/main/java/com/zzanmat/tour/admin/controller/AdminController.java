package com.zzanmat.tour.admin.controller;

import com.zzanmat.tour.member.service.MemberService;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.service.MissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {

    private final MissionService missionService;
    private final MemberService memberService;

    @GetMapping({"", "/"})
    public String dashboard(Model model) {
        Map<String, Object> stats = missionService.getAdminDashboardStats();
        model.addAttribute("memberCount", memberService.countAllMembers());
        model.addAttribute("missionCount", stats.get("missionCount"));
        model.addAttribute("readyCount", stats.get("readyCount"));
        model.addAttribute("inProgressCount", stats.get("inProgressCount"));
        model.addAttribute("doneCount", stats.get("doneCount"));
        model.addAttribute("pointLabels", stats.get("pointLabels"));
        model.addAttribute("pointValues", stats.get("pointValues"));
        return "admin/dashboard";
    }

    @GetMapping("/missions")
    public String missionList(Model model) {
        List<MissionResponseDto.Info> missions = missionService.getAllMissions(null);
        model.addAttribute("missions", missions);

        return "admin/mission-list";
    }

    @GetMapping("/missions/new")
    public String missionNew() {
        return "admin/mission-form";
    }

    @GetMapping("/missions/edit")
    public String missionEdit(@RequestParam(required = false) Long missionId) {
        return "admin/mission-form";
    }
}
