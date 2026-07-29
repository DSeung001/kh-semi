package com.zzanmat.tour.mission.controller;

import com.zzanmat.tour.mission.dto.UserMissionResponseDto;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/mission")
public class MissionViewController {

    // 1. 기본 미션 목록 페이지 (/mission 또는 /mission/list 로 접속)
    @GetMapping({"", "/list"})
    public String missionPage() {
        return "mission/mission"; // src/main/webapp/WEB-INF/views/mission/mission.jsp
    }

    // 2. 미션 상세/활성화 페이지 (/mission/active?missionId=1 로 접속)
    @GetMapping("/active")
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

        return "mission/mission-active"; // src/main/webapp/WEB-INF/views/mission/mission-active.jsp
    }

    // 3. 미션 수락 처리용 메서드 (/mission/accept)
    @PostMapping("/accept")
    public String acceptMission(@RequestParam Long missionId) {
        // TODO: 미션 수락 비즈니스 로직(DB 저장 등) 처리 영역

        // 처리가 끝난 후 활성화 페이지로 안전하게 리다이렉트
        return "redirect:/mission/active?missionId=" + missionId;
    }
}