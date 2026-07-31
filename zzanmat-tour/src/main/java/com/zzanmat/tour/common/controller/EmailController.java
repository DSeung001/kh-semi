package com.zzanmat.tour.common.controller;

import com.zzanmat.tour.common.dto.ApiResponse;
import com.zzanmat.tour.common.dto.EmailSendRequest;
import com.zzanmat.tour.common.dto.EmailVerifyRequest;
import com.zzanmat.tour.common.service.EmailService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class EmailController {

    private static final long AUTH_CODE_VALIDITY_MILLIS = 3 * 60 * 1000L;

    private final EmailService emailService;

    @PostMapping("/email/send")
    public ApiResponse<Void> sendEmail(@RequestBody EmailSendRequest request, HttpSession session) {
        String email = request.getEmail();
        if (email == null || email.isBlank()) {
            throw new IllegalArgumentException("이메일을 입력해주세요.");
        }

        try {
            String authCode = emailService.sendVerificationEmail(email);
            session.setAttribute("authCode_" + email, authCode);
            session.setAttribute("authCodeExpiresAt_" + email,
                    System.currentTimeMillis() + AUTH_CODE_VALIDITY_MILLIS);

            return ApiResponse.success("인증번호가 성공적으로 전송되었습니다.", null);
        } catch (Exception e) {
            throw new IllegalStateException("메일 전송 중 오류가 발생했습니다.");
        }
    }

    @PostMapping("/email/verify")
    public ApiResponse<Boolean> verifyEmail(@RequestBody EmailVerifyRequest request, HttpSession session) {
        String email = request.getEmail();
        String authCode = request.getAuthCode();

        if (email == null || email.isBlank() || authCode == null || authCode.isBlank()) {
            throw new IllegalArgumentException("이메일과 인증번호를 입력해주세요.");
        }

        Long expiresAt = (Long) session.getAttribute("authCodeExpiresAt_" + email);
        if (expiresAt == null || System.currentTimeMillis() > expiresAt) {
            session.removeAttribute("authCode_" + email);
            session.removeAttribute("authCodeExpiresAt_" + email);
            return ApiResponse.fail("인증번호가 일치하지 않거나 만료되었습니다.");
        }

        boolean isValid = emailService.checkAuthCode(email, authCode);
        if (isValid) {
            session.removeAttribute("authCodeExpiresAt_" + email);
            return ApiResponse.success("success", true);
        }
        return ApiResponse.fail("인증번호가 일치하지 않거나 만료되었습니다.");
    }
}
