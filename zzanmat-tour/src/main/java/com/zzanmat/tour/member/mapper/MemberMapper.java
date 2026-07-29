package com.zzanmat.tour.member.mapper;

import com.zzanmat.tour.member.dto.MemberDto;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberMapper {

    //회원가입
    int insertMember(MemberDto memberDto);

    //아이디 중복확인
    int countByMemberId(String userId);

    //아이디 존재유무 확인
    MemberDto selectByMemberId(String memberId);

    int updateUser(MemberDto memberDto);

    MemberDto selectUser(MemberDto memberDto);

    //회원탈퇴
    int deleteMember(String userId);

}
