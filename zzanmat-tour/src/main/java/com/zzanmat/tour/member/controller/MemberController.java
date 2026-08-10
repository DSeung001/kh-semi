package com.zzanmat.tour.member.controller;

import com.zzanmat.tour.common.util.CookieTokenUtils;
import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.member.Exception.WithdrawnMemberException;
import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.member.service.MemberService;
import com.zzanmat.tour.mission.service.MissionService;
import com.zzanmat.tour.post.service.PostService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.annotation.RegisteredOAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.util.Map;

@Controller
@RequestMapping("/member")
@Slf4j
public class MemberController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private PostService postService;

    @Autowired
    private MissionService missionService;

    // 회원가입
    @PostMapping("/signup")
    public String signup(MemberDto memberDto,
                         @RequestParam(required = false) MultipartFile profileImage,
                         RedirectAttributes redirectAttributes){
        try {
            memberService.join(memberDto, profileImage);
        } catch (IOException | IllegalArgumentException e) {

            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/member/signup";
        }

        redirectAttributes.addFlashAttribute("joinSuccess", true);
        return "redirect:/member/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String userId,
                        @RequestParam String userPassword,
                        @RequestParam(required = false) String redirectURL,
                        @RequestParam(required = false) boolean rememberMe,
                        RedirectAttributes redirectAttributes,
                        HttpServletResponse response,
                        HttpSession session){
        try {
            MemberDto member = memberService.login(userId, userPassword);

            //로그인 성공 -> 세션에 로그인 정보 저장
            if (member != null) {
                memberService.registerLoginSession(member.getId(), session.getId());
                member.setLoginSessionId(session.getId());
                session.setAttribute(SessionConst.LOGIN_MEMBER, member);

                // 2. 자동 로그인 체크 시
                if (rememberMe) {
                    long expireTime = System.currentTimeMillis() + (7L * 24 * 60 * 60 * 1000); // 7일 뒤

                    // 아이디와 만료시간이 포함되고 위변조가 불가능한 토큰 생성
                    String secureToken = CookieTokenUtils.createToken(member.getUserId(), expireTime);

                    Cookie cookie = new Cookie("autoLoginToken", secureToken);
                    cookie.setPath("/");
                    cookie.setMaxAge(7 * 24 * 60 * 60); // 7일
                    cookie.setHttpOnly(true); // 자바스크립트 탈취 방지
                    response.addCookie(cookie);
                }
            }
        } catch(IllegalStateException e){
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/member/login";
        } catch (WithdrawnMemberException e) {
            session.setAttribute("RESTORE_MEMBER_ID", e.getMemberId());
            session.setAttribute("RESTORE_EXPIRES_AT",System.currentTimeMillis() + 5 * 60 * 1000);
            redirectAttributes.addFlashAttribute("withdrawnMember",true);
            return "redirect:/member/login";
        }

        if(redirectURL != null && !redirectURL.isBlank()){
            return "redirect:" + redirectURL;
        }

        return "redirect:/";
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response){
        HttpSession session = request.getSession(false);
        if(session != null){
            MemberDto loginMember = (MemberDto) session.getAttribute(SessionConst.LOGIN_MEMBER);
            if (loginMember != null) {
                memberService.clearLoginSession(loginMember.getId(), session.getId());
            }
            session.invalidate(); //세션자체를 만료

            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("autoLoginToken".equals(cookie.getName())) {
                        cookie.setValue(null);
                        cookie.setPath("/");
                        cookie.setMaxAge(0); // 쿠키 만료 소멸
                        response.addCookie(cookie);
                        break;
                    }
                }
            }
        }

        return "redirect:/";
    }

    @PostMapping("/update")
    public String update(MemberDto memberDto
                        ,@RequestParam(required = false) MultipartFile profileImage
                        ,String originProfileName
                        ,Model model
                        ,RedirectAttributes redirectAttributes){
        try {
            memberService.update(memberDto, profileImage, originProfileName);

            // 리다이렉트 시점에 일회성으로 메시지 전달
            redirectAttributes.addFlashAttribute("message", "회원 정보가 성공적으로 수정되었습니다.");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/member/profile";
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "프로필 이미지 업로드 중 오류가 발생했습니다.");
            return "redirect:/member/profile";
        }
        return "redirect:/member/profile";
    }

    // 카카오 탈퇴하기
    @PostMapping("/withdraw/kakao")
    public String withdrawKakao(@RegisteredOAuth2AuthorizedClient("kakao") OAuth2AuthorizedClient authorizedClient,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        MemberDto loginMember = (MemberDto) session.getAttribute(SessionConst.LOGIN_MEMBER);

        if (loginMember == null) {
            return "redirect:/member/login";
        }

        MemberDto memberInfo = memberService.findDetailByUserId(loginMember.getUserId());

        if (memberInfo == null || !"KAKAO".equals(memberInfo.getLoginType())) {
            redirectAttributes.addFlashAttribute("withdrawError","잘못된 회원 탈퇴 요청입니다.");
            return "redirect:/member/profile";
        }

        try {
            if (authorizedClient == null || authorizedClient.getAccessToken() == null) {
                throw new IllegalStateException("카카오 인증 정보가 없습니다.");
            }
            String accessToken = authorizedClient.getAccessToken().getTokenValue();

            // 카카오 연결 해제
            memberService.unlinkKakao(accessToken);

            // 카카오 연결 해제 성공 후 DB 회원 삭제
            memberService.withdraw(loginMember.getId());
            session.invalidate();
            redirectAttributes.addFlashAttribute("message","회원 탈퇴가 완료되었습니다. 그동안 짠맛투어를 이용해 주셔서 감사합니다.");

            return "redirect:/";

        } catch (Exception e) {
            log.error("카카오 회원 탈퇴 처리 실패: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("withdrawError","카카오 연결 해제 중 오류가 발생해 탈퇴를 완료하지 못했습니다.");
            return "redirect:/member/profile";
        }
    }

    // 네이버 회원 탈퇴
    @PostMapping("/withdraw/naver")
    public String withdrawNaver(@RegisteredOAuth2AuthorizedClient("naver") OAuth2AuthorizedClient authorizedClient,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        MemberDto loginMember = (MemberDto) session.getAttribute(SessionConst.LOGIN_MEMBER);

        if (loginMember == null) {
            return "redirect:/member/login";
        }

        // 세션 DTO에는 loginType이 없을 수 있으므로 DB에서 다시 조회
        MemberDto memberInfo = memberService.findDetailByUserId(loginMember.getUserId());

        if (memberInfo == null || !"NAVER".equals(memberInfo.getLoginType())) {
            redirectAttributes.addFlashAttribute("withdrawError","잘못된 네이버 회원 탈퇴 요청입니다.");
            return "redirect:/member/profile";
        }

        try {
            if (authorizedClient == null || authorizedClient.getAccessToken() == null) {
                throw new IllegalStateException("네이버 인증 정보가 없습니다.");
            }
            String accessToken = authorizedClient.getAccessToken().getTokenValue();

            // 네이버 연결 해제
            memberService.unlinkNaver(accessToken);

            // DB 회원 삭제
            memberService.withdraw(loginMember.getId());
            session.invalidate();
            redirectAttributes.addFlashAttribute("message","회원 탈퇴가 완료되었습니다. 그동안 짠맛투어를 이용해 주셔서 감사합니다.");

            return "redirect:/";

        } catch (Exception e) {
            log.error("네이버 회원 탈퇴 처리 실패: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("withdrawError","네이버 연결 해제 중 오류가 발생해 탈퇴를 완료하지 못했습니다.");

            return "redirect:/member/profile";
        }
    }

    // 일반 회원 탈퇴
    @PostMapping("/withdraw/general")
    public String withdrawGeneral(HttpSession session,
                                  HttpServletResponse response,
                                  RedirectAttributes redirectAttributes) {

        MemberDto loginMember = (MemberDto) session.getAttribute(SessionConst.LOGIN_MEMBER);

        if (loginMember == null) {
            return "redirect:/member/login";
        }

        // 세션 정보가 오래되었을 수 있으므로 DB에서 최신 로그인 유형을 확인한다.
        MemberDto memberInfo = memberService.findDetailByUserId(loginMember.getUserId());

        if (memberInfo == null || !"LOCAL".equals(memberInfo.getLoginType())) {
            redirectAttributes.addFlashAttribute("withdrawError","잘못된 회원 탈퇴 요청입니다.");
            return "redirect:/member/profile";
        }

        try {
            memberService.withdraw(loginMember.getId());
            expireAutoLoginCookie(response);
            session.invalidate();
            redirectAttributes.addFlashAttribute("message","회원 탈퇴가 완료되었습니다. 그동안 짠맛투어를 이용해 주셔서 감사합니다.");

            return "redirect:/";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("withdrawError","회원 탈퇴 처리 중 오류가 발생했습니다.");
            return "redirect:/member/profile";
        }
    }

    private void expireAutoLoginCookie(HttpServletResponse response) {
        Cookie cookie = new Cookie("autoLoginToken", "");
        cookie.setPath("/");
        cookie.setMaxAge(0);
        cookie.setHttpOnly(true);
        response.addCookie(cookie);
    }

    // 페이지 이동
    @GetMapping("/forgot-password")
    public String forgotPassword(){
        return "member/forgot-password";
    }

    @GetMapping("/login")
    public String login(HttpServletRequest request){
        if (isLoggedIn(request)) {
            return "redirect:/";
        }
        return "member/login";
    }

    @GetMapping("/profile")
    public String profile(HttpServletRequest request, Model model){
        HttpSession session = request.getSession(false);
        MemberDto memberDto = (MemberDto) session.getAttribute(SessionConst.LOGIN_MEMBER);
        MemberDto memberInfo = memberService.findDetailByUserId(memberDto.getUserId());
        int userPostCnt = postService.countByUserPost(memberDto.getId());
        int pointBalance = missionService.getUserPointBalance(memberDto.getId());

        model.addAttribute("userInfo", memberInfo);
        model.addAttribute("userPostCnt", userPostCnt);
        model.addAttribute("pointBalance", pointBalance);
        return "member/profile";
    }

    @GetMapping("/signup")
    public String signupForm(HttpServletRequest request){
        if (isLoggedIn(request)) {
            return "redirect:/";
        }
        return "member/signup";
    }

    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute(SessionConst.LOGIN_MEMBER) != null;
    }

    @GetMapping("/oauth2-login")
    public String oauth2LoginSuccess(OAuth2AuthenticationToken authentication, HttpSession session, RedirectAttributes redirectAttributes) {
        if (authentication == null) {
            redirectAttributes.addFlashAttribute("error","소셜 로그인 정보를 가져오지 못했습니다.");
            return "redirect:/member/login";
        }

        String registrationId = authentication.getAuthorizedClientRegistrationId();
        OAuth2User oAuth2User = authentication.getPrincipal();

        try {
            MemberDto member;

            if ("kakao".equals(registrationId)) {
                member = processKakaoLogin(oAuth2User);
            } else if ("naver".equals(registrationId)) {
                member = processNaverLogin(oAuth2User);
            } else {
                redirectAttributes.addFlashAttribute("error","지원하지 않는 소셜 로그인입니다.");
                return "redirect:/member/login";
            }

            if (member == null) {
                redirectAttributes.addFlashAttribute("error","소셜 회원 정보 처리 중 오류가 발생했습니다.");
                return "redirect:/member/login";
            }

            memberService.registerLoginSession(member.getId(), session.getId());
            member.setLoginSessionId(session.getId());
            session.setAttribute(SessionConst.LOGIN_MEMBER, member);
            return "redirect:/";
        } catch (Exception e) {
            log.error("소셜 로그인 처리 실패 - registrationId: {}, message: {}", registrationId, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error","소셜 로그인 처리 중 오류가 발생했습니다.");
            return "redirect:/member/login";
        }
    }

    @SuppressWarnings("unchecked")
    private MemberDto processKakaoLogin(OAuth2User oAuth2User) {

        Map<String, Object> attributes = oAuth2User.getAttributes();
        Object idValue = attributes.get("id");
        Map<String, Object> properties = (Map<String, Object>) attributes.get("properties");

        if (idValue == null || properties == null) {
            throw new IllegalStateException("카카오 필수 회원 정보가 없습니다.");
        }

        String kakaoId = String.valueOf(idValue);
        String nickname = properties.get("nickname") != null ? String.valueOf(properties.get("nickname")) : "카카오회원";

        return memberService.kakaoJoin(kakaoId, nickname);
    }

    @SuppressWarnings("unchecked")
    private MemberDto processNaverLogin(OAuth2User oAuth2User) {

        Map<String, Object> attributes = oAuth2User.getAttributes();
        Map<String, Object> response = (Map<String, Object>) attributes.get("response");

        if (response == null || response.get("id") == null) {
            throw new IllegalStateException("네이버 필수 회원 정보를 가져오지 못했습니다.");
        }

        String naverId = String.valueOf(response.get("id"));
        String nickname = response.get("nickname") != null ? String.valueOf(response.get("nickname")) : "네이버회원";
        String email = response.get("email") != null ? String.valueOf(response.get("email")): null;

        return memberService.naverJoin(naverId, nickname, email);
    }

    @PostMapping("/restore")
    public String restore(HttpSession session, RedirectAttributes redirectAttributes) {
        Long memberId = (Long) session.getAttribute("RESTORE_MEMBER_ID");
        Long expiresAt = (Long) session.getAttribute("RESTORE_EXPIRES_AT");

        if (memberId == null || expiresAt == null || System.currentTimeMillis() > expiresAt) {
            session.removeAttribute("RESTORE_MEMBER_ID");
            session.removeAttribute("RESTORE_EXPIRES_AT");
            redirectAttributes.addFlashAttribute("error","복구 인증이 만료되었습니다. 다시 로그인해주세요.");
            return "redirect:/member/login";
        }

        try {
            memberService.restore(memberId);
            redirectAttributes.addFlashAttribute("restoreSuccess", "계정이 복구되었습니다. 다시 로그인해주세요.");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } finally {
            session.removeAttribute("RESTORE_MEMBER_ID");
            session.removeAttribute("RESTORE_EXPIRES_AT");
        }

        return "redirect:/member/login";
    }
}
