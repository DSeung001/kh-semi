package com.zzanmat.tour.mission.controller;

import com.zzanmat.tour.mission.dto.UserMissionResponseDto;
import com.zzanmat.tour.mission.service.MissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
public class MissionController {

    private final MissionService missionService;

    // --- 화면(View) 반환 및 페이지 관련 메서드들만 유지 ---

    @GetMapping({"/mission", "/mission/list"})
    public String missionPage() {
        return "mission/mission";
    }

    @GetMapping("/mission/active")
    public String missionActive(
            @RequestParam(required = false, defaultValue = "1") Long missionId,
            Model model) {

        UserMissionResponseDto dto = UserMissionResponseDto.builder()
                .userMissionId(1L)
                .missionId(missionId)
                .status("IN_PROGRESS")
                .completedCount(3)
                .totalCount(10)
                .progressPercent(30.0)
                .build();

        model.addAttribute("mission", dto);

        return "mission/mission-active";
    }

    @PostMapping("/mission/accept")
    public String acceptMission(@RequestParam Long missionId) {
        // 미션 수락 비즈니스 로직(DB 저장 등) 처리 영역
        return "redirect:/mission/active?missionId=" + missionId;
    }
}