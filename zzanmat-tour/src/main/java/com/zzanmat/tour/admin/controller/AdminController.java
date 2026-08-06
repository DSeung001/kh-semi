package com.zzanmat.tour.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @GetMapping({"", "/"})
    public String dashboard() {
        return "admin/dashboard";
    }

    @GetMapping("/missions")
    public String missionList() {
        return "admin/mission-list";
    }

    @GetMapping("/missions/new")
    public String missionNew() {
        return "admin/mission-form";
    }

    @GetMapping("/missions/edit")
    public String missionEdit(@RequestParam(required = false) Long missionId) {
        return "admin/mission-form";
    }
}
