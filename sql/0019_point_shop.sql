USE zad;
SET NAMES utf8mb4;

-- 포인트 상점 상품
CREATE TABLE IF NOT EXISTS shop_item (
    item_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '상품명',
    description TEXT COMMENT '상품 설명',
    category ENUM('GIFT_CARD', 'TRAVEL', 'FLIGHT', 'TRAIN') NOT NULL COMMENT '상품 카테고리',
    cost_point INT NOT NULL COMMENT '교환 필요 포인트',
    stock INT NULL COMMENT '재고 (NULL=무제한)',
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 교환한 쿠폰(유저 보유)
CREATE TABLE IF NOT EXISTS user_coupon (
    coupon_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    item_id BIGINT NOT NULL,
    coupon_code VARCHAR(40) NOT NULL,
    cost_point INT NOT NULL COMMENT '교환에 사용된 포인트',
    status ENUM('AVAILABLE', 'USED', 'EXPIRED') NOT NULL DEFAULT 'AVAILABLE',
    purchased_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_user_coupon_code (coupon_code),
    KEY idx_user_coupon_user (user_id),
    CONSTRAINT fk_user_coupon_user FOREIGN KEY (user_id) REFERENCES `USER`(ID) ON DELETE CASCADE,
    CONSTRAINT fk_user_coupon_item FOREIGN KEY (item_id) REFERENCES shop_item(item_id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 시드 상품
START TRANSACTION;

INSERT INTO shop_item (name, description, category, cost_point, stock, is_active)
SELECT * FROM (
    SELECT '올리브영 상품권 5천원' AS name,
           '올리브영 오프라인/온라인에서 사용 가능한 5,000원 상품권입니다.' AS description,
           'GIFT_CARD' AS category, 5000 AS cost_point, 100 AS stock, 1 AS is_active
    UNION ALL
    SELECT '올리브영 상품권 1만원',
           '올리브영에서 사용 가능한 10,000원 상품권입니다.',
           'GIFT_CARD', 10000, 80, 1
    UNION ALL
    SELECT '올리브영 상품권 3만원',
           '올리브영에서 사용 가능한 30,000원 상품권입니다.',
           'GIFT_CARD', 28000, 50, 1
    UNION ALL
    SELECT '여행 상품권 5만원',
           '국내 여행 예약에 사용 가능한 50,000원 상품권입니다.',
           'TRAVEL', 45000, 40, 1
    UNION ALL
    SELECT '여행 상품권 10만원',
           '국내 여행 예약에 사용 가능한 100,000원 상품권입니다.',
           'TRAVEL', 85000, 20, 1
    UNION ALL
    SELECT '국내선 비행기 할인권 1만원',
           '국내선 항공권 결제 시 10,000원 할인되는 쿠폰입니다.',
           'FLIGHT', 9000, 60, 1
    UNION ALL
    SELECT '국내선 비행기 할인권 3만원',
           '국내선 항공권 결제 시 30,000원 할인되는 쿠폰입니다.',
           'FLIGHT', 25000, 30, 1
    UNION ALL
    SELECT '기차 할인권 5천원',
           'KTX/SRT 등 기차 예매 시 5,000원 할인되는 쿠폰입니다.',
           'TRAIN', 4500, 100, 1
    UNION ALL
    SELECT '기차 할인권 1만원',
           'KTX/SRT 등 기차 예매 시 10,000원 할인되는 쿠폰입니다.',
           'TRAIN', 9000, 80, 1
) AS seed
WHERE NOT EXISTS (SELECT 1 FROM shop_item LIMIT 1);

COMMIT;
