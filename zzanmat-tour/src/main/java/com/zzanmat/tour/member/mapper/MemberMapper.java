package com.zzanmat.tour.member.mapper;

import com.zzanmat.tour.member.dto.MemberDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MemberMapper {

    int save(MemberDto memberDto);

    int countByMemberId(@Param("userId") String userId);

    MemberDto findByMemberId(@Param("userId") String userId);

    int update(MemberDto memberDto);

    MemberDto findById(MemberDto memberDto);

    int deleteByMemberId(@Param("userId") String userId);

}
