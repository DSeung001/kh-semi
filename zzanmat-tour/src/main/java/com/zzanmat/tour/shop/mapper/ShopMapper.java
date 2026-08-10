package com.zzanmat.tour.shop.mapper;

import com.zzanmat.tour.shop.dto.ShopDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ShopMapper {

    List<ShopDto.Item> findActiveItems();

    ShopDto.Item findByIdForUpdate(@Param("itemId") Long itemId);

    int decreaseStock(@Param("itemId") Long itemId);

    void insertUserCoupon(ShopDto.Coupon coupon);

    List<ShopDto.Coupon> findCouponsByUserId(@Param("userId") Long userId);

    void savePurchasePointHistory(
            @Param("userId") Long userId,
            @Param("point") int point,
            @Param("reason") String reason
    );
}
