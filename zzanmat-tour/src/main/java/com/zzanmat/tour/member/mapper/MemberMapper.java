package com.zzanmat.tour.member.mapper;

import com.zzanmat.tour.member.dto.FollowRelationDto;
import com.zzanmat.tour.member.dto.MemberDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;


@Mapper
public interface MemberMapper {

    int save(MemberDto memberDto);

    int countByUserId(@Param("userId") String userId);

    int countByNickname(@Param("nickname") String nickname);

    int countByNicknameExcludingId(@Param("nickname") String nickname,
                                   @Param("memberId") Long memberId);

    int countByEmail(@Param("email") String email);

    int countAllMembers();

    MemberDto findByUserId(@Param("userId") String userId);

    int update(MemberDto memberDto);

    MemberDto findDetailByUserId(@Param("userId") String userId);

    MemberDto findByEmail(@Param("email") String email);

    MemberDto findByUserIdAndEmail(@Param("userId") String userId, @Param("email") String email);

    int updatePasswordByMemberId(@Param("memberId") Long memberId,
                                 @Param("userPassword") String userPassword);

    int deleteById(@Param("memberId") Long memberId,
                   @Param("anonymousNickname") String anonymousNickname);

    int countByFollowerIdAndFolloweringId(@Param("followerId") Long followerId, @Param("followeringId") Long followeringId);

    int countActiveById(@Param("memberId") Long memberId);

    int saveFollow(@Param("followerId") Long followerId, @Param("followeringId") Long followeringId);

    int deleteByFollowerIdAndFolloweringId(@Param("followerId") Long followerId, @Param("followeringId") Long followeringId);

    int restore(@Param("memberId") Long memberId);

    int updateSocialMemberForRestore(@Param("memberId") Long memberId,
                                     @Param("nickname") String nickname,
                                     @Param("email") String email);

    int updateLoginSessionId(@Param("memberId") Long memberId, @Param("loginSessionId") String loginSessionId);

    int clearLoginSessionId(@Param("memberId") Long memberId, @Param("loginSessionId") String loginSessionId);

    int countCurrentLoginSession(@Param("memberId") Long memberId, @Param("loginSessionId") String loginSessionId);

    List<FollowRelationDto> findFollowRelations(@Param("keyword") String keyword,
                                                @Param("offset") int offset,
                                                @Param("size") int size);

    int countFollowRelations();

    int countFollowRelationsByKeyword(@Param("keyword") String keyword);

    int countDistinctFollowers();

    int countDistinctFollowingMembers();
}
