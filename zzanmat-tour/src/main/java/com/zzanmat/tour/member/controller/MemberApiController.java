package com.zzanmat.tour.member.controller;

import com.zzanmat.tour.common.dto.ApiResponse;
import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.member.dto.PasswordChangeRequest;
import com.zzanmat.tour.member.service.MemberService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

import java.util.regex.Pattern;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/member")
public class MemberApiController {

    private static final String PASSWORD_RESET_VERIFIED_MEMBER_ID = "passwordResetVerifiedMemberId";
    private static final String PASSWORD_RESET_VERIFIED_EXPIRES_AT = "passwordResetVerifiedExpiresAt";
    private static final Pattern PASSWORD_PATTERN = Pattern.compile(
            "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,}$"
    );

    private final MemberService memberService;

    @GetMapping("/check-id")
    public ApiResponse<Boolean> checkId(@RequestParam String userId) {
        boolean duplicate = memberService.isMemberIdCheck(userId);
        String message = duplicate ? "이미 사용중인 아이디 입니다." : "사용 가능한 아이디 입니다.";
        return ApiResponse.success(message, duplicate);
    }

    @GetMapping("/check-nickname")
    public ApiResponse<Boolean> checkNickname(@RequestParam String nickname) {
        String trimmedNickname = nickname.trim();
        if (trimmedNickname.isEmpty()) {
            throw new IllegalArgumentException("닉네임을 입력해주세요.");
        }

        boolean duplicate = memberService.isNicknameDuplicate(trimmedNickname);
        String message = duplicate ? "이미 사용중인 닉네임입니다." : "사용 가능한 닉네임입니다.";
        return ApiResponse.success(message, duplicate);
    }

    @PostMapping("/reset-password")
    public ApiResponse<Void> resetPassword(@RequestBody PasswordChangeRequest request,
                                           HttpSession session) {
        Long memberId = (Long) session.getAttribute(PASSWORD_RESET_VERIFIED_MEMBER_ID);
        Long expiresAt = (Long) session.getAttribute(PASSWORD_RESET_VERIFIED_EXPIRES_AT);
        String newPassword = request.getNewPassword();

        // 화면에서 전달되는 아이디·이메일은 조작할 수 있으므로 인증된 서버 세션의 회원 PK만 신뢰한다.
        if (memberId == null || expiresAt == null || System.currentTimeMillis() > expiresAt) {
            clearPasswordResetSession(session);
            throw new IllegalArgumentException("이메일 인증이 만료되었습니다. 다시 인증해주세요.");
        }
        if (newPassword == null || !PASSWORD_PATTERN.matcher(newPassword).matches()) {
            throw new IllegalArgumentException("비밀번호는 영문, 숫자, 특수문자를 포함해 8자 이상이어야 합니다.");
        }
        if (!memberService.resetPasswordByMemberId(memberId, newPassword)) {
            throw new IllegalArgumentException("가입 정보를 찾을 수 없습니다.");
        }

        // 성공한 재설정 권한은 재사용할 수 없도록 즉시 제거한다.
        clearPasswordResetSession(session);
        return ApiResponse.success("비밀번호가 변경되었습니다. 로그인해주세요.", null);
    }

    private void clearPasswordResetSession(HttpSession session) {
        session.removeAttribute(PASSWORD_RESET_VERIFIED_MEMBER_ID);
        session.removeAttribute(PASSWORD_RESET_VERIFIED_EXPIRES_AT);
        session.removeAttribute("verifiedEmailForPasswordReset");
        session.removeAttribute("verifiedEmailForPasswordResetExpiresAt");
    }

    @PostMapping("/follow/{followingId}")
    public ApiResponse<Boolean> follow(
            @PathVariable Long followingId,
            @SessionAttribute(value = SessionConst.LOGIN_MEMBER, required = false) MemberDto loginMember
    ) {
        if (loginMember == null) {
            throw new IllegalArgumentException("로그인이 필요합니다.");
        }

        memberService.follow(loginMember.getId(), followingId);
        return ApiResponse.success("팔로우했습니다.", true);
    }

    @DeleteMapping("/follow/{followingId}")
    public ApiResponse<Boolean> unfollow(
            @PathVariable Long followingId,
            @SessionAttribute(value = SessionConst.LOGIN_MEMBER, required = false) MemberDto loginMember
    ) {
        if (loginMember == null) {
            throw new IllegalArgumentException("로그인이 필요합니다.");
        }

        memberService.unfollow(loginMember.getId(), followingId);
        return ApiResponse.success("팔로우를 취소했습니다.", false);
    }
}
