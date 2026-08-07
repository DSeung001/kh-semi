package com.zzanmat.tour.admin.controller;

import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.service.MissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {

    private final MissionService missionService;

    @GetMapping({"", "/"})
    public String dashboard() {
        return "admin/dashboard";
    }

    @GetMapping("/missions")
    public String missionList(Model model) { //2. Model 매개변수 추가
        // 3. DB에서 전체 미션 목록을 가져와서 모델에 담습니다.
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