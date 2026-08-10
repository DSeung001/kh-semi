package com.zzanmat.tour.shop.service.impl;

import com.zzanmat.tour.mission.mapper.MissionMapper;
import com.zzanmat.tour.shop.dto.ShopDto;
import com.zzanmat.tour.shop.mapper.ShopMapper;
import com.zzanmat.tour.shop.service.ShopService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.security.SecureRandom;
import java.util.Collections;
import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class ShopServiceImpl implements ShopService {

    private static final String POINT_REASON_PURCHASE = "PURCHASE";
    private static final String COUPON_ALPHABET = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final Set<String> ALLOWED_CATEGORIES = Set.of(
            "GIFT_CARD", "TRAVEL", "FLIGHT", "TRAIN"
    );

    private final ShopMapper shopMapper;
    private final MissionMapper missionMapper;

    @Override
    @Transactional(readOnly = true)
    public List<ShopDto.Item> getActiveItems() {
        List<ShopDto.Item> items = shopMapper.findActiveItems();
        return items != null ? items : Collections.emptyList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<ShopDto.Item> getAllItems() {
        List<ShopDto.Item> items = shopMapper.findAllItems();
        return items != null ? items : Collections.emptyList();
    }

    @Override
    @Transactional(readOnly = true)
    public ShopDto.Item getItemById(Long itemId) {
        if (itemId == null) {
            throw new IllegalArgumentException("상품 ID가 필요합니다.");
        }
        ShopDto.Item item = shopMapper.findItemById(itemId);
        if (item == null) {
            throw new IllegalArgumentException("상품을 찾을 수 없습니다.");
        }
        return item;
    }

    @Override
    @Transactional
    public void createItem(ShopDto.SaveOrUpdate request) {
        normalizeAndValidate(request);
        if (request.getActive() == null) {
            request.setActive(true);
        }
        shopMapper.saveItem(request);
    }

    @Override
    @Transactional
    public void updateItem(ShopDto.SaveOrUpdate request) {
        if (request == null || request.getItemId() == null) {
            throw new IllegalArgumentException("상품 ID가 필요합니다.");
        }
        normalizeAndValidate(request);
        if (request.getActive() == null) {
            request.setActive(true);
        }
        int updated = shopMapper.updateItem(request);
        if (updated != 1) {
            throw new IllegalArgumentException("상품을 찾을 수 없습니다.");
        }
    }

    @Override
    @Transactional
    public void deactivateItem(Long itemId) {
        if (itemId == null) {
            throw new IllegalArgumentException("상품 ID가 필요합니다.");
        }
        int updated = shopMapper.deactivateItem(itemId);
        if (updated != 1) {
            throw new IllegalArgumentException("상품을 찾을 수 없습니다.");
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<ShopDto.Coupon> getMyCoupons(Long userId) {
        if (userId == null) {
            return Collections.emptyList();
        }
        List<ShopDto.Coupon> coupons = shopMapper.findCouponsByUserId(userId);
        return coupons != null ? coupons : Collections.emptyList();
    }

    @Override
    @Transactional(readOnly = true)
    public int getPointBalance(Long userId) {
        if (userId == null) {
            return 0;
        }
        return missionMapper.sumPointsByUserId(userId);
    }

    @Override
    @Transactional
    public ShopDto.PurchaseResult purchase(Long userId, Long itemId) {
        if (userId == null) {
            throw new IllegalArgumentException("로그인이 필요합니다.");
        }
        if (itemId == null) {
            throw new IllegalArgumentException("상품을 선택해 주세요.");
        }

        ShopDto.Item item = shopMapper.findByIdForUpdate(itemId);
        if (item == null || !item.isActive()) {
            throw new IllegalArgumentException("판매 중인 상품이 아닙니다.");
        }
        if (item.isSoldOut()) {
            throw new IllegalStateException("재고가 소진된 상품입니다.");
        }

        int balance = missionMapper.sumPointsByUserId(userId);
        if (balance < item.getCostPoint()) {
            throw new IllegalStateException("포인트가 부족합니다. (보유 " + balance + "P)");
        }

        if (item.getStock() != null) {
            int updated = shopMapper.decreaseStock(itemId);
            if (updated != 1) {
                throw new IllegalStateException("재고가 소진된 상품입니다.");
            }
        }

        String couponCode = generateCouponCode();
        ShopDto.Coupon coupon = new ShopDto.Coupon();
        coupon.setUserId(userId);
        coupon.setItemId(itemId);
        coupon.setCouponCode(couponCode);
        coupon.setCostPoint(item.getCostPoint());
        shopMapper.insertUserCoupon(coupon);
        shopMapper.savePurchasePointHistory(userId, -item.getCostPoint(), POINT_REASON_PURCHASE);

        ShopDto.PurchaseResult result = new ShopDto.PurchaseResult();
        result.setCouponId(coupon.getCouponId());
        result.setCouponCode(couponCode);
        result.setItemName(item.getName());
        result.setCostPoint(item.getCostPoint());
        result.setRemainPoint(balance - item.getCostPoint());
        return result;
    }

    private void normalizeAndValidate(ShopDto.SaveOrUpdate request) {
        if (request == null) {
            throw new IllegalArgumentException("상품 정보가 필요합니다.");
        }
        if (!StringUtils.hasText(request.getName())) {
            throw new IllegalArgumentException("상품명을 입력해 주세요.");
        }
        request.setName(request.getName().trim());

        if (request.getDescription() != null) {
            request.setDescription(request.getDescription().trim());
        }

        if (!StringUtils.hasText(request.getCategory())) {
            throw new IllegalArgumentException("카테고리를 선택해 주세요.");
        }
        String category = request.getCategory().trim().toUpperCase();
        if (!ALLOWED_CATEGORIES.contains(category)) {
            throw new IllegalArgumentException("지원하지 않는 카테고리입니다.");
        }
        request.setCategory(category);

        if (request.getCostPoint() == null || request.getCostPoint() < 0) {
            throw new IllegalArgumentException("필요 포인트는 0 이상이어야 합니다.");
        }
        if (request.getStock() != null && request.getStock() < 0) {
            throw new IllegalArgumentException("재고는 0 이상이거나 비워 두세요(무제한).");
        }
    }

    private String generateCouponCode() {
        StringBuilder sb = new StringBuilder("ZT-");
        for (int i = 0; i < 12; i++) {
            if (i > 0 && i % 4 == 0) {
                sb.append('-');
            }
            sb.append(COUPON_ALPHABET.charAt(RANDOM.nextInt(COUPON_ALPHABET.length())));
        }
        return sb.toString();
    }
}
