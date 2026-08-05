package com.zzanmat.tour.mission.controller;

import com.zzanmat.tour.common.dto.ApiResponse;
import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.mission.dto.MissionRequestDto;
import com.zzanmat.tour.mission.dto.MissionResponseDto;
import com.zzanmat.tour.mission.service.MissionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/mission")
public class MissionApiController {

    private final MissionService missionService;

    @GetMapping
    public ApiResponse<List<MissionResponseDto.Info>> getAllMissions(
            @SessionAttribute(value = SessionConst.LOGIN_MEMBER, required = false) MemberDto loginMember
    ) {
        Long userId = loginMember != null ? loginMember.getId() : null;
        return ApiResponse.success(missionService.getAllMissions(userId));
    }

    @GetMapping("/progress")
    public ApiResponse<MissionResponseDto.Progress> getMissionProgress(
            @RequestParam Long missionId,
            @SessionAttribute(value = SessionConst.LOGIN_MEMBER, required = false) MemberDto loginMember
    ) {
        Long userId = loginMember != null ? loginMember.getId() : null;
        MissionResponseDto.Progress progress = missionService.getUserMissionProgress(userId, missionId);
        return ApiResponse.success(progress);
    }

    @PostMapping("/complete")
    public ApiResponse<MissionResponseDto.UserMissionDetail> completeMission(
            @RequestBody @Valid MissionRequestDto.Action requestDto,
            @SessionAttribute(value = SessionConst.LOGIN_MEMBER, required = false) MemberDto loginMember
    ) {
        if (loginMember == null) {
            throw new IllegalArgumentException("로그인이 필요합니다.");
        }
        MissionResponseDto.UserMissionDetail response =
                missionService.completeMission(loginMember.getId(), requestDto.getMissionId());
        return ApiResponse.success(response);
    }
}
