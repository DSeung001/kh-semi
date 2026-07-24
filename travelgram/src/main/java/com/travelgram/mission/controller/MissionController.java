package com.travelgram.mission.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MissionController {

    @GetMapping("/mission")
    public String mission(){
        return "mission/mission";
    }

    @GetMapping("/mission-active")
    public String missionActive(){
        return "mission/mission-active";
    }

}
