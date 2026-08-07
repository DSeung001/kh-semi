package com.zzanmat.tour.admin.controller;

import com.zzanmat.tour.comment.service.CommentService;
import com.zzanmat.tour.member.service.MemberService;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.service.MissionService;
import com.zzanmat.tour.post.service.PostService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {

    private final MissionService missionService;
    private final MemberService memberService;
    private final PostService postService;
    private final CommentService commentService;

    @GetMapping({"", "/"})
    public String dashboard(Model model) {
        model.addAttribute("memberCount", memberService.countAllMembers());
        model.addAttribute("postCount", postService.countAll(""));
        model.addAttribute("commentCount", commentService.countAll());
        model.addAttribute("missionCount", missionService.countAllMissions());

        Map<LocalDate, Long> postByDay = toDayCountMap(postService.countPostsByDayLast14());
        Map<LocalDate, Long> commentByDay = toDayCountMap(commentService.countCommentsByDayLast14());

        List<String> activityLabels = new ArrayList<>();
        List<Long> postValues = new ArrayList<>();
        List<Long> commentValues = new ArrayList<>();
        DateTimeFormatter labelFmt = DateTimeFormatter.ofPattern("M/d");
        LocalDate today = LocalDate.now();
        for (int i = 13; i >= 0; i--) {
            LocalDate day = today.minusDays(i);
            activityLabels.add(day.format(labelFmt));
            postValues.add(postByDay.getOrDefault(day, 0L));
            commentValues.add(commentByDay.getOrDefault(day, 0L));
        }
        model.addAttribute("activityLabels", activityLabels);
        model.addAttribute("postDailyCounts", postValues);
        model.addAttribute("commentDailyCounts", commentValues);
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

    private Map<LocalDate, Long> toDayCountMap(List<Map<String, Object>> rows) {
        Map<LocalDate, Long> result = new HashMap<>();
        if (rows == null) {
            return result;
        }
        for (Map<String, Object> row : rows) {
            Object dayObj = row.get("day");
            Object cntObj = row.get("cnt");
            if (dayObj == null) {
                continue;
            }
            LocalDate day = dayObj instanceof LocalDate
                    ? (LocalDate) dayObj
                    : LocalDate.parse(dayObj.toString().substring(0, 10));
            long cnt = cntObj == null ? 0L : ((Number) cntObj).longValue();
            result.put(day, cnt);
        }
        return result;
    }
}
