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

    private static final long AUTH_CODE_VALIDITY_MILLIS = 3 * 60 * 1000L;

    private final EmailService emailService;

    @PostMapping("/email/send")
    @ResponseBody
    public ResponseEntity<String> sendEmail(@RequestParam("email") String email, HttpSession session) {
        try {
            // 메일 전송 실행 (실제로는 여기서 생성된 authCode를 HttpSession 등에 email과 묶어서 저장해 둡니다)
            String authCode = emailService.sendVerificationEmail(email);

            // HttpSession에 인증코드와 이메일을 저장 (유효시간 등을 세션에 관리하거나 키값으로 구분)
            session.setAttribute("authCode_" + email, authCode);
            session.setAttribute("authCodeExpiresAt_" + email,
                    System.currentTimeMillis() + AUTH_CODE_VALIDITY_MILLIS);

            return ResponseEntity.ok("인증번호가 성공적으로 전송되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("메일 전송 중 오류가 발생했습니다.");
        }
    }

    @PostMapping("/email/verify")
    public ResponseEntity<String> verifyEmail(@RequestParam("email") String email,
                                              @RequestParam("authCode") String authCode,
                                              HttpSession session) {

        Long expiresAt = (Long) session.getAttribute("authCodeExpiresAt_" + email);
        if (expiresAt == null || System.currentTimeMillis() > expiresAt) {
            session.removeAttribute("authCode_" + email);
            session.removeAttribute("authCodeExpiresAt_" + email);
            return ResponseEntity.ok("fail");
        }

        // 1. 서버에 저장되어 있던(이전에 이메일 발송 시 보관한) 해당 이메일의 인증번호를 불러옵니다.
        // 보통 HttpSession, Redis, 혹은 별도의 인증 관리 서비스(Service)를 통해 가져옵니다.
        boolean isValid = emailService.checkAuthCode(email, authCode);

        // 2. 일치 여부에 따라 응답결과를 리턴합니다.
        if (isValid) {
            session.removeAttribute("authCodeExpiresAt_" + email);
            return ResponseEntity.ok("success"); // 성공 시 "success" 문자열 반환
        } else {
            return ResponseEntity.ok("fail");    // 실패 시 "fail" 문자열 반환
        }
    }
}
