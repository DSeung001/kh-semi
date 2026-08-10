package com.zzanmat.tour.shop.service;

import com.zzanmat.tour.shop.dto.ShopDto;

import java.util.List;

public interface ShopService {

    List<ShopDto.Item> getActiveItems();

    List<ShopDto.Coupon> getMyCoupons(Long userId);

    int getPointBalance(Long userId);

    ShopDto.PurchaseResult purchase(Long userId, Long itemId);
}
