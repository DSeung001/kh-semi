package com.zzanmat.tour.mission.controller;

import com.zzanmat.tour.mission.dto.UserMissionResponseDto;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MissionViewController {

    @GetMapping("/mission")
    public String missionActive(
            @RequestParam(required = false) Long missionId,
            Model model) {

        if (missionId == null) {
            missionId = 1L;
        }

        UserMissionResponseDto dto = UserMissionResponseDto.builder()
                .userMissionId(1L)
                .missionId(missionId)
                .status("IN_PROGRESS")
                .completedCount(3)
                .totalCount(10)
                .progressPercent(30.0)
                .build();

        model.addAttribute("mission", dto);

        return "mission/mission";
    }
}