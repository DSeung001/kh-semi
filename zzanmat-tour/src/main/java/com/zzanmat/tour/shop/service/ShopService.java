package com.zzanmat.tour.shop.service;

import com.zzanmat.tour.shop.dto.ShopDto;

import java.util.List;

public interface ShopService {

    List<ShopDto.Item> getActiveItems();

    List<ShopDto.Item> getAllItems();

    ShopDto.Item getItemById(Long itemId);

    void createItem(ShopDto.SaveOrUpdate request);

    void updateItem(ShopDto.SaveOrUpdate request);

    void deactivateItem(Long itemId);

    List<ShopDto.Coupon> getMyCoupons(Long userId);

    int getPointBalance(Long userId);

    ShopDto.PurchaseResult purchase(Long userId, Long itemId);
}
