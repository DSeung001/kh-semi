package com.zzanmat.tour.common.controller;

import com.zzanmat.tour.common.service.EmailService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class EmailController {

    private final EmailService emailService;

    @PostMapping("/email/send")
    @ResponseBody
    public ResponseEntity<String> sendEmail(@RequestParam("email") String email, HttpSession session) {
        try {
            // 메일 전송 실행 (실제로는 여기서 생성된 authCode를 HttpSession 등에 email과 묶어서 저장해 둡니다)
            String authCode = emailService.sendVerificationEmail(email);

            // HttpSession에 인증코드와 이메일을 저장 (유효시간 등을 세션에 관리하거나 키값으로 구분)
            session.setAttribute("authCode", authCode);
            session.setAttribute("emailForAuth", email);

            // 세션 유지 시간 설정 (예: 3분 = 180초)
            session.setMaxInactiveInterval(180);

            return ResponseEntity.ok("인증번호가 성공적으로 전송되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("메일 전송 중 오류가 발생했습니다.");
        }
    }
}
