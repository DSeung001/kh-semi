package com.zzanmat.tour.common.service;

import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.messaging.MessagingException;
import org.springframework.stereotype.Service;

import java.util.Random;

@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String username;

    public String sendVerificationEmail(String toEmail) throws MessagingException, jakarta.mail.MessagingException {
        // 1. 6자리 랜덤 인증번호 생성
        String authCode = generateAuthCode();

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
}
