package com.zzanmat.tour.shop.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

public class ShopDto {

    @Getter
    @Setter
    public static class Item {
        private Long itemId;
        private String name;
        private String description;
        private String category;
        private int costPoint;
        private Integer stock;
        private boolean active;
        private LocalDateTime createdAt;

        public boolean isSoldOut() {
            return stock != null && stock <= 0;
        }

        public String getCategoryLabel() {
            if (category == null) {
                return "기타";
            }
            return switch (category) {
                case "GIFT_CARD" -> "상품권";
                case "TRAVEL" -> "여행";
                case "FLIGHT" -> "항공";
                case "TRAIN" -> "기차";
                default -> "기타";
            };
        }
    }

    @Getter
    @Setter
    public static class Coupon {
        private Long couponId;
        private Long userId;
        private Long itemId;
        private String itemName;
        private String category;
        private String couponCode;
        private int costPoint;
        private String status;
        private LocalDateTime purchasedAt;

        public String getCategoryLabel() {
            if (category == null) {
                return "기타";
            }
            return switch (category) {
                case "GIFT_CARD" -> "상품권";
                case "TRAVEL" -> "여행";
                case "FLIGHT" -> "항공";
                case "TRAIN" -> "기차";
                default -> "기타";
            };
        }

        public String getStatusLabel() {
            if (status == null) {
                return "";
            }
            return switch (status) {
                case "AVAILABLE" -> "사용 가능";
                case "USED" -> "사용 완료";
                case "EXPIRED" -> "만료";
                default -> status;
            };
        }
    }

    @Getter
    @Setter
    public static class PurchaseResult {
        private Long couponId;
        private String couponCode;
        private String itemName;
        private int costPoint;
        private int remainPoint;
    }
}
