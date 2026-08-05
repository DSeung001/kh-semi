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

    MemberDto findById(String userId);

    MemberDto findByEmail(@Param("email") String email);

    MemberDto findByUserIdAndEmail(@Param("userId") String userId,
                                   @Param("email") String email);

    int updatePasswordByEmail(@Param("email") String email,
                              @Param("userPassword") String userPassword);

    int deleteByMemberId(@Param("userId") String userId);

}
