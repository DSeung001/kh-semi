package com.zzanmat.tour.common.util;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

public class CookieTokenUtils {
    // 서버만 알고 있는 비밀키 (application.properties 등에서 주입받아도 됩니다)
    private static final String SECRET_KEY = "ZzanmatTourSuperSecretKeyForCookieValidation!";

    // 1. 데이터에 서명을 붙여서 토큰 문자열 생성 (예: "userid:expireTime:signature")
    public static String createToken(String username, long expireTime) {
        String data = username + ":" + expireTime;
        String signature = hmacSha256(data, SECRET_KEY);
        return Base64.getUrlEncoder().encodeToString((data + ":" + signature).getBytes(StandardCharsets.UTF_8));
    }

    // 2. 토큰을 검증하고 아이디를 추출
    public static String validateAndGetUsername(String tokenCookie) {
        try {
            String decoded = new String(Base64.getUrlDecoder().decode(tokenCookie), StandardCharsets.UTF_8);
            String[] parts = decoded.split(":");
            if (parts.length != 3) return null;

            String username = parts[0];
            long expireTime = Long.parseLong(parts[1]);
            String signature = parts[2];

            // 만료 시간 체크
            if (System.currentTimeMillis() > expireTime) {
                return null; // 만료됨
            }

            // 서명 검증 (위변조 확인)
            String expectedSignature = hmacSha256(username + ":" + expireTime, SECRET_KEY);
            if (!expectedSignature.equals(signature)) {
                return null; // 조작된 쿠키
            }

            return username;
        } catch (Exception e) {
            return null; // 파싱 실패 또는 변조
        }
    }

    // HMAC SHA256 암호화 메서드
    private static String hmacSha256(String data, String secret) {
        try {
            Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
            SecretKeySpec secret_key = new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            sha256_HMAC.init(secret_key);
            byte[] hash = sha256_HMAC.doFinal(data.getBytes(StandardCharsets.UTF_8));
            return Base64.getUrlEncoder().withoutPadding().encodeToString(hash);
        } catch (Exception e) {
            throw new RuntimeException("Failed to calculate hmac-sha256", e);
        }
    }
}
