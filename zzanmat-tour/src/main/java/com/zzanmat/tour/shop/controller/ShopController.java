package com.zzanmat.tour.shop.controller;

import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.shop.dto.ShopDto;
import com.zzanmat.tour.shop.service.ShopService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Collections;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/shop")
public class ShopController {

    private final ShopService shopService;

    @GetMapping({"", "/list"})
    public String shopPage(
            Model model,
            @SessionAttribute(value = SessionConst.LOGIN_MEMBER, required = false) MemberDto loginMember
    ) {
        Long userId = loginMember != null ? loginMember.getId() : null;
        try {
            model.addAttribute("items", shopService.getActiveItems());
            model.addAttribute("myCoupons", shopService.getMyCoupons(userId));
            model.addAttribute("pointBalance", shopService.getPointBalance(userId));
        } catch (Exception e) {
            log.error("상점 조회 실패: {}", e.getMessage());
            model.addAttribute("items", Collections.emptyList());
            model.addAttribute("myCoupons", Collections.emptyList());
            model.addAttribute("pointBalance", 0);
        }
        return "shop/shop";
    }

    @PostMapping("/purchase")
    public String purchase(
            @RequestParam Long itemId,
            @SessionAttribute(value = SessionConst.LOGIN_MEMBER, required = false) MemberDto loginMember,
            RedirectAttributes redirectAttributes
    ) {
        if (loginMember == null) {
            return "redirect:/member/login";
        }

        try {
            ShopDto.PurchaseResult result = shopService.purchase(loginMember.getId(), itemId);
            redirectAttributes.addFlashAttribute(
                    "message",
                    result.getItemName() + " 교환 완료! 쿠폰코드: " + result.getCouponCode()
            );
        } catch (IllegalArgumentException | IllegalStateException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (Exception e) {
            log.error("쿠폰 교환 실패: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", "교환 중 오류가 발생했습니다.");
        }
        return "redirect:/shop";
    }
}
