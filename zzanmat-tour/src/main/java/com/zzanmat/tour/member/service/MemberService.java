package com.zzanmat.tour.member.service;

import com.zzanmat.tour.member.dto.MemberDto;

import java.io.IOException;

public interface MemberService {

    void join(MemberDto memberDto) throws IOException;

    boolean isMemberIdCheck(String userId);

    MemberDto login(String userId, String userPassword) throws IllegalStateException;
}
