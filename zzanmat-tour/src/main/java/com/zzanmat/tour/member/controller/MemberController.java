package com.zzanmat.tour.member.controller;

import com.zzanmat.tour.common.dto.ApiResponse;
import com.zzanmat.tour.common.util.CookieTokenUtils;
import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.member.service.MemberService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
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
public class MemberController {

    @Autowired
    private MemberService memberService;

    // 회원가입
    @PostMapping("/signup")
    public String signup(MemberDto memberDto,
                         @RequestParam(required = false) MultipartFile profileImage,
                         RedirectAttributes redirectAttributes){
        try {
            memberService.join(memberDto, profileImage);
        } catch (IOException e) {
//             RedirectAttributes.addFlashAttribute
            // 리다이렉트 후 딱 한번 다음 요청에서만 살아있는 데이터

            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/member/signup";
        }

        redirectAttributes.addFlashAttribute("joinSuccess", true);
        return "redirect:/member/login";
    }

    @GetMapping("/checkId")
    @ResponseBody
    public ApiResponse<Boolean> checkId(@RequestParam String userId) {
        boolean duplicate = memberService.isMemberIdCheck(userId);
        String message = duplicate ? "이미 사용중인 아이디 입니다." : "사용 가능한 아이디 입니다.";
        return ApiResponse.success(message, duplicate);
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
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "프로필 이미지 업로드 중 오류가 발생했습니다.");
            return "redirect:/member/profile";
        }
        return "redirect:/member/profile";
    }

    // 탈퇴하기
    @PostMapping("/withdraw")
    public String withdraw(HttpSession session){
        MemberDto loginMember = (MemberDto) session.getAttribute(SessionConst.LOGIN_MEMBER);
        memberService.withdraw(loginMember.getUserId());

        session.invalidate();
        return "redirect:/";
    }

    // 페이지 이동
    @GetMapping("/forgot-password")
    public String forgotPassword(){
        return "member/forgot-password";
    }

    @GetMapping("/login")
    public String login(){
        return "member/login";
    }

    @GetMapping("/profile")
    public String profile(HttpServletRequest request, Model model){
        HttpSession session = request.getSession(false);
        MemberDto memberDto = (MemberDto) session.getAttribute(SessionConst.LOGIN_MEMBER);
        MemberDto memberInfo = memberService.findById(memberDto.getUserId());
        model.addAttribute("userInfo", memberInfo);
        return "member/profile";
    }

    @GetMapping("/signup")
    public String signupForm(){
        return "member/signup";
    }

    @GetMapping("/kakao-login")
    @ResponseBody
    public String loginSuccess(@AuthenticationPrincipal OAuth2User oAuth2User) {

        String kakaoId = oAuth2User.getName();

        Map<String, Object> properties = (Map<String, Object>) oAuth2User.getAttributes().get("properties");

        String nickname = (String) properties.get("nickname");

        if (oAuth2User == null) {
            return "로그인 정보가 없습니다.";
        }

        return "카카오 로그인 성공";
    }
}
