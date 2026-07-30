package com.zzanmat.tour.common.service;

import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.messaging.MessagingException;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.Random;

@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String username;

    @Value("${app.mail.mode:local}")
    private String mailMode; // 설정된 메일 모드 가져오기

    public String sendVerificationEmail(String toEmail) throws MessagingException, jakarta.mail.MessagingException {

        // 1. 6자리 랜덤 인증번호 생성
        String authCode = generateAuthCode();

        // 만약 모드가 'local'이라면 메일을 안 보내고 콘솔에 출력
        if ("local".equals(mailMode)) {
            System.out.println("========================================");
            System.out.println("[LOCAL MODE] 메일 전송 대신 인증번호를 출력합니다.");
            System.out.println("받는 사람: " + toEmail);
            System.out.println("인증번호: " + authCode);
            System.out.println("========================================");
            return authCode;
        }
        
        // 2. 이메일 메시지 작성
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

        helper.setFrom(username);
        helper.setTo(toEmail);
        helper.setSubject("짠맛투어 회원가입 이메일 인증번호");
        helper.setText("안녕하세요. 요청하신 인증번호는 <b>[" + authCode + "]</b> 입니다.", true);

        // 3. 네이버 메일 서버를 통해 전송
        mailSender.send(message);

        return authCode;
    }

    private String generateAuthCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000);
        return String.valueOf(code);
    }

    // (참고) 이전에 이메일로 인증번호를 전송할 때, 세션이나 저장소에 아래와 같이 저장했다고 가정합니다.
    /*
    public void sendAuthCode(HttpSession session, String email) {
        String authCode = generateRandomCode(); // 6자리 난수 생성 로직

        // 세션에 이메일과 인증번호를 저장 (유효시간 설정을 위해 별도 DTO나 Redis를 쓰기도 함)
        session.setAttribute("authCode_" + email, authCode);
        session.setMaxInactiveInterval(180); // 예: 3분 동안 유효

        // 메일 발송 로직...
    }
    */

    /**
     * 사용자가 입력한 인증번호를 검증하는 서비스 메서드
     * @param email 사용자의 이메일
     * @param authCode 사용자가 입력한 6자리 번호
     * @return 일치 여부 (true/false)
     */
    public boolean checkAuthCode(String email, String authCode) {
        // 1. 요청을 처리하기 위한 HttpSession 객체를 가져옵니다.
        // (Spring에서는 RequestContextHolder를 통해 컨트롤러가 아닌 곳에서도 세션에 접근할 수 있습니다.)
        ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
        HttpSession session = attr.getRequest().getSession();

        // 2. 이전에 서버(세션)에 저장해 둔 진짜 인증번호를 꺼냅니다.
        String savedAuthCode = (String) session.getAttribute("authCode_" + email);

        // 3. 저장된 번호가 아예 없거나(만료됨 등), 사용자가 입력한 값과 다르면 검증 실패
        if (savedAuthCode == null || !savedAuthCode.equals(authCode)) {
            return false;
        }

        // 4. 인증에 성공했다면, 보안 및 중복 사용 방지를 위해 세션에 저장했던 인증번호는 제거합니다.
        session.removeAttribute("authCode_" + email);

        // 5. 검증 성공 처리
        return true;
    }
}
