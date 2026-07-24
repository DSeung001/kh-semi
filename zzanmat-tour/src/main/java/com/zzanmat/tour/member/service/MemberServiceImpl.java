package com.zzanmat.tour.member.service;

import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.member.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
public class MemberServiceImpl implements MemberService{

    /*@Autowired
    private PasswordEncoder passwordEncoder;*/

    @Autowired
    private MemberMapper memberMapper;

    @Override
    public void join(MemberDto memberDto) throws IOException {
        // 아이디 중복검사
        /*if(isMemberIdCheck(memberDto.getMemberId())){
            throw new IllegalStateException("이미 사용중인 아이디 입니다.");
        }*/

        //비밀번호는 항상 암호화해서 저장.
        /*String encodePwd = passwordEncoder.encode(memberDto.getMemberPwd());
        memberDto.setMemberPwd(encodePwd);*/

        //프로필 이미지를 업로드 했다면 디스크에 저장 후, 경로를 dto에 채워준다.
        /*SavedFile saved = fileUploadUtil.save(profileImage, profileUploadDir, "/uploads/profile");
        if(saved != null){
            memberDto.setProfile(saved.getPath());
        }*/

        memberMapper.insertMember(memberDto);
    }
}
