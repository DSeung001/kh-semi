package com.zzanmat.tour.member.service;

import com.zzanmat.tour.common.util.FileUploadUtil;
import com.zzanmat.tour.common.util.SavedFile;
import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.member.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
public class MemberServiceImpl implements MemberService{

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private MemberMapper memberMapper;

    @Autowired
    private FileUploadUtil fileUploadUtil;

    @Value("${file.upload-dir.profile}")
    private String profileUploadDir;

    @Override
    public void join(MemberDto memberDto, MultipartFile profileImage) throws IOException {
        // 아이디 중복검사
        if(isMemberIdCheck(memberDto.getUserId())){
            throw new IllegalStateException("이미 사용중인 아이디 입니다.");
        }

        //비밀번호는 항상 암호화해서 저장.
        String encodePwd = passwordEncoder.encode(memberDto.getUserPassword());
        System.out.println(encodePwd);
        memberDto.setUserPassword(encodePwd);

        //프로필 이미지를 업로드 했다면 디스크에 저장 후, 경로를 dto에 채워준다.
        SavedFile saved = fileUploadUtil.save(profileImage, profileUploadDir, "/uploads/profile");
        if(saved != null){
            memberDto.setProfile(saved.getPath());
        }

        memberMapper.insertMember(memberDto);
    }

    @Override
    public boolean isMemberIdCheck(String userId) {
        return memberMapper.countByMemberId(userId) > 0;
    }

    @Override
    public MemberDto login(String memberId, String memberPwd) throws IllegalStateException{
        MemberDto member = memberMapper.selectByMemberId(memberId);

        // member.getMemberPwd(); 암호화된 비밀번호
        // memberPwd 평문의 비밀번호
        // passwordEncoder.matches(평문, 암호문) -> 결과는 해당 평문과 암호문의 비교값 : true/false

        if(member == null || !passwordEncoder.matches(memberPwd, member.getUserPassword())){
            // 런타임 예외 -> 나중에는 각 예외별 에러코드를 분리해서 관리
            throw new IllegalStateException("아이디 또는 비밀번호가 일치하지 않습니다.");
        }

        return member;
    }

    @Override
    public boolean update(MemberDto memberDto) {
        return memberMapper.memberUpdate(memberDto) > 0;
    }

    @Override
    public MemberDto selectUser(MemberDto memberDto) {
        return memberMapper.selectUser(memberDto);
    }

    @Override
    public void withdraw(String userId) {
        memberMapper.deleteMember(userId);
    }
}
