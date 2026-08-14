package com.zzanmat.tour.admin.controller;

import com.zzanmat.tour.comment.service.CommentService;
import com.zzanmat.tour.member.dto.FollowRelationDto;
import com.zzanmat.tour.member.service.MemberService;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.service.MissionService;
import com.zzanmat.tour.post.service.PostService;
import com.zzanmat.tour.shop.dto.ShopDto;
import com.zzanmat.tour.shop.service.ShopService;
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
    private final ShopService shopService;

    @GetMapping({"", "/"})
    public String dashboard(Model model) {
        model.addAttribute("memberCount", memberService.countAllMembers());
        model.addAttribute("postCount", postService.countAll(""));
        model.addAttribute("commentCount", commentService.countAll());
        model.addAttribute("missionCount", missionService.countActiveMissions());

        Map<LocalDate, Long> postByDay = toDayCountMap(postService.countPostsByDayLast14());
        Map<LocalDate, Long> commentByDay = toDayCountMap(commentService.countCommentsByDayLast14());
        Map<LocalDate, Long> pointEarnedByDay = toDayCountMap(missionService.sumEarnedPointsByDayLast14());
        Map<LocalDate, Long> pointUsedByDay = toDayCountMap(missionService.sumUsedPointsByDayLast14());

        List<String> activityLabels = new ArrayList<>();
        List<Long> postValues = new ArrayList<>();
        List<Long> commentValues = new ArrayList<>();
        List<Long> pointEarnedValues = new ArrayList<>();
        List<Long> pointUsedValues = new ArrayList<>();
        DateTimeFormatter labelFmt = DateTimeFormatter.ofPattern("M/d");
        LocalDate today = LocalDate.now();
        for (int i = 13; i >= 0; i--) {
            LocalDate day = today.minusDays(i);
            activityLabels.add(day.format(labelFmt));
            postValues.add(postByDay.getOrDefault(day, 0L));
            commentValues.add(commentByDay.getOrDefault(day, 0L));
            pointEarnedValues.add(pointEarnedByDay.getOrDefault(day, 0L));
            pointUsedValues.add(pointUsedByDay.getOrDefault(day, 0L));
        }
        model.addAttribute("activityLabels", activityLabels);
        model.addAttribute("postDailyCounts", postValues);
        model.addAttribute("commentDailyCounts", commentValues);
        model.addAttribute("pointEarnedDailyCounts", pointEarnedValues);
        model.addAttribute("pointUsedDailyCounts", pointUsedValues);
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

    @GetMapping("/shop")
    public String shopList(Model model) {
        List<ShopDto.Item> items = shopService.getAllItems();
        model.addAttribute("items", items);
        return "admin/shop-list";
    }

    @GetMapping("/shop/new")
    public String shopNew() {
        return "admin/shop-form";
    }

    @GetMapping("/shop/edit")
    public String shopEdit(@RequestParam(required = false) Long itemId) {
        return "admin/shop-form";
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

    @GetMapping("/following")
    public String followingList(@RequestParam(required = false) String keyword,
                                @RequestParam(defaultValue = "1") int page,
                                Model model) {
        final int pageSize = 20;
        final int pageGroupSize = 5;

        page = Math.max(page, 1);
        int filteredCount = memberService.countFollowRelationsByKeyword(keyword);
        int totalPages = (int) Math.ceil((double) filteredCount / pageSize);

        if (totalPages > 0 && page > totalPages) {
            page = totalPages;
        }

        List<FollowRelationDto> followRelations = memberService.getFollowRelations(keyword, page, pageSize);
        int startPage = ((page - 1) / pageGroupSize) * pageGroupSize + 1;
        int endPage = Math.min(startPage + pageGroupSize - 1, totalPages);

        model.addAttribute("keyword", keyword);
        model.addAttribute("followRelations", followRelations);
        model.addAttribute("filteredCount", filteredCount);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("totalFollowRelations", memberService.countFollowRelations());
        model.addAttribute("distinctFollowerCount", memberService.countDistinctFollowers());
        model.addAttribute("distinctFollowingCount", memberService.countDistinctFollowingMembers());
        return "admin/following-list";
    }
}
