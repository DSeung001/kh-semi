package com.zzanmat.tour.shop.controller;

import com.zzanmat.tour.common.dto.ApiResponse;
import com.zzanmat.tour.common.util.SessionConst;
import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.shop.dto.ShopDto;
import com.zzanmat.tour.shop.service.ShopService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/shop")
public class ShopApiController {

    private final ShopService shopService;

    @GetMapping("/items")
    public ApiResponse<List<ShopDto.Item>> getItems() {
        return ApiResponse.success(shopService.getActiveItems());
    }

    @GetMapping("/my-coupons")
    public ApiResponse<List<ShopDto.Coupon>> getMyCoupons(
            @SessionAttribute(value = SessionConst.LOGIN_MEMBER, required = false) MemberDto loginMember
    ) {
        if (loginMember == null) {
            throw new IllegalArgumentException("로그인이 필요합니다.");
        }
        return ApiResponse.success(shopService.getMyCoupons(loginMember.getId()));
    }

    @GetMapping("/balance")
    public ApiResponse<Map<String, Integer>> getBalance(
            @SessionAttribute(value = SessionConst.LOGIN_MEMBER, required = false) MemberDto loginMember
    ) {
        if (loginMember == null) {
            throw new IllegalArgumentException("로그인이 필요합니다.");
        }
        return ApiResponse.success(Map.of("pointBalance", shopService.getPointBalance(loginMember.getId())));
    }

    @PostMapping("/purchase")
    public ApiResponse<ShopDto.PurchaseResult> purchase(
            @RequestParam Long itemId,
            @SessionAttribute(value = SessionConst.LOGIN_MEMBER, required = false) MemberDto loginMember
    ) {
        if (loginMember == null) {
            throw new IllegalArgumentException("로그인이 필요합니다.");
        }
        ShopDto.PurchaseResult result = shopService.purchase(loginMember.getId(), itemId);
        return ApiResponse.success("교환이 완료되었습니다.", result);
    }
}
