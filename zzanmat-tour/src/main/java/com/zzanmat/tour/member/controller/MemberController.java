package com.zzanmat.tour.member.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MemberController {

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
    public String signup(){
        return "member/signup";
    }
}
