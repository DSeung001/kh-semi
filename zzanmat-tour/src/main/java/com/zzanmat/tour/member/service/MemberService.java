package com.zzanmat.tour.member.service;

import com.zzanmat.tour.member.dto.MemberDto;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface MemberService {

    void join(MemberDto memberDto, MultipartFile profileImage) throws IOException;

    boolean isMemberIdCheck(String userId);

    MemberDto login(String userId, String userPassword) throws IllegalStateException;

    boolean updateUser(MemberDto memberDto, MultipartFile profileImage, String originProfileName) throws IOException;

    MemberDto selectUser(MemberDto memberDto);

    void withdraw(String userId);
}
