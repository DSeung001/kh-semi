package com.travelgram.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.Map;

@Slf4j
@Controller
public class PageController {
    private static final Map<String, String> TITLES = Map.ofEntries(
        Map.entry("travelgram", "여행 둘러보기"), Map.entry("chat", "실시간 채팅"),
        Map.entry("tag", "여행 태그"), Map.entry("mission", "Mission Possible"),
        Map.entry("mission-active", "진행 중인 미션"), Map.entry("profile", "내 프로필"),
        Map.entry("new-post", "새 게시물"), Map.entry("post-detail", "게시물 상세"),
        Map.entry("feed-text", "여행 이야기"), Map.entry("login", "로그인"),
        Map.entry("signup", "회원가입"), Map.entry("forgot-password", "비밀번호 찾기")
    );

    @GetMapping("/{page:travelgram|chat|tag|mission|mission-active|profile|new-post|post-detail|feed-text|login|signup|forgot-password}")
    public String page(@PathVariable String page, Model model) {
        log.debug("Travelgram JSP page requested: {}", page);
        model.addAttribute("pageKey", page);
        model.addAttribute("pageTitle", TITLES.get(page));
        return "page";
    }
}
