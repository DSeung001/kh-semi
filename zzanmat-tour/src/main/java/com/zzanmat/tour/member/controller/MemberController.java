package com.zzanmat.tour.member.controller;

import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.member.service.MemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;

@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private MemberService memberService;

    // 회원가입
    @PostMapping("/signup")
    public String signup(MemberDto memberDto){
        try {
            memberService.join(memberDto);
        } catch (IOException e) {
            // RedirectAttributes.addFlashAttribute
            // 리다이렉트 후 딱 한번 다음 요청에서만 살아있는 데이터
            //redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/member/join";
        }

        //redirectAttributes.addFlashAttribute("joinSuccess", true);
        return "redirect:/member/login";
    }

    /*@GetMapping("/checkId")
    @ResponseBody
    public ApiResponse<Boolean> checkId(@RequestParam String memberId){
        boolean duplicate = memberService.isMemberIdCheck(memberId);
        String message = duplicate ? "이미 사용중인 아이디 입니다." : "사용 가능한 아이디 입니다.";
        return ApiResponse.success(message, duplicate);
    }*/

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
    public String profile(){
        return "member/profile";
    }

    @GetMapping("/signup")
    public String signupForm(){
        return "member/signup";
    }

}
