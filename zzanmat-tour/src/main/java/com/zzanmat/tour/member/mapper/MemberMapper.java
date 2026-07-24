package com.zzanmat.tour.member.mapper;

import com.zzanmat.tour.member.dto.MemberDto;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberMapper {

    //회원가입
    int insertMember(MemberDto memberDto);

}
