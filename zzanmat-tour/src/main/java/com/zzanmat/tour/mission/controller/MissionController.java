package com.zzanmat.tour.mission.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.zzanmat.tour.mission.dto.MissionDto;
import com.zzanmat.tour.mission.dto.MissionPostDto;
import com.zzanmat.tour.mission.service.MissionService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;

@RestController
@RequestMapping("/api/missions")
@RequiredArgsConstructor
public class MissionController {

    private final MissionService missionService;

    // 💡 서버 정상 작동 확인용 GET 테스트 메서드 (클래스 내부로 이동)
    @GetMapping("/test")
    public String serverTest() {
        return "서버와 컨트롤러가 정상 동작 중입니다!";
    }

    // 1. 미션 등록 요청 처리 (JSON 데이터 전송)
    @PostMapping
    public String createMission(@RequestBody MissionDto missionDto) {
        missionService.insertMission(missionDto);
        return "Mission registered successfully!";
    }

    // 2. 미션 인증 처리 (JSON 텍스트 데이터 + 멀티파트 파일 동시 전송)
    @PutMapping
    public ResponseEntity<String> createMissionAuth(
            @RequestPart("PostDto") MissionPostDto postDto,
            @RequestParam(value = "files", required = false) List<MultipartFile> files) {

        missionService.processMissionAuth(postDto, files);
        return ResponseEntity.ok("미션 인증이 완료 되었습니다!");
    }

    // 3. 미션 삭제 요청 처리 (Path 파라미터 활용)
    @DeleteMapping("/{missionId}")
    public String removeMission(@PathVariable Long missionId) {
        missionService.deleteMission(missionId);
        return "Mission deleted successfully!";
    }
}