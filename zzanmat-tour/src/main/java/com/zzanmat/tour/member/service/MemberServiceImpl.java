package com.zzanmat.tour.member.service;

import com.zzanmat.tour.common.util.FileUploadUtil;
import com.zzanmat.tour.common.util.SavedFile;
import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.member.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
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

    private final RestClient restClient = RestClient.create();

    @Override
    public void join(MemberDto memberDto, MultipartFile profileImage) throws IOException {
        // 아이디 중복검사
        if(isMemberIdCheck(memberDto.getUserId())){
            throw new IllegalStateException("이미 사용중인 아이디 입니다.");
        }

        //비밀번호는 항상 암호화해서 저장.
        String encodePwd = passwordEncoder.encode(memberDto.getUserPassword());
        memberDto.setUserPassword(encodePwd);

        //프로필 이미지를 업로드 했다면 디스크에 저장 후, 경로를 dto에 채워준다.
        SavedFile saved = fileUploadUtil.save(profileImage, profileUploadDir, "/uploads/profile");
        if(saved != null){
            memberDto.setProfile(saved.getPath());
        }

        memberMapper.save(memberDto);
    }

    @Override
    public boolean isMemberIdCheck(String userId) {
        return memberMapper.countByMemberId(userId) > 0;
    }

    @Override
    public MemberDto login(String memberId, String memberPwd) throws IllegalStateException{
        MemberDto member = memberMapper.findByMemberId(memberId);

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
    public boolean update(MemberDto memberDto, MultipartFile newprofileImage, String originProfileName) throws IOException {

        //사용자가 새로운 프로필을 등록한다면 기존에 등록되어 있던 프로필 삭제 후
        //새로운 프로필 이미지 등록
        boolean hasNewImages = newprofileImage != null && !newprofileImage.isEmpty();
        if(hasNewImages){
            fileUploadUtil.delete(originProfileName, profileUploadDir);

            SavedFile saved = fileUploadUtil.save(newprofileImage, profileUploadDir, "/uploads/profile");
            if(saved != null){
                memberDto.setProfile(saved.getPath());
            }
        }

        return memberMapper.update(memberDto) > 0;
    }

    @Override
    public MemberDto findById(String userId) {
        return memberMapper.findById(userId);
    }

    @Override
    public MemberDto findByEmail(String email) {
        return memberMapper.findByEmail(email);
    }

    @Override
    public MemberDto findByUserIdAndEmail(String userId, String email) {
        return memberMapper.findByUserIdAndEmail(userId, email);
    }

    @Override
    public boolean resetPasswordByEmail(String email, String newPassword) {
        return memberMapper.updatePasswordByEmail(email, passwordEncoder.encode(newPassword)) > 0;
    }

    @Override
    public void withdraw(String userId) {
        memberMapper.deleteByMemberId(userId);
    }

    @Override
    public MemberDto kakaoJoin(String kakaoId, String nickname) {

        // 1. 카카오 ID로 기존 회원 조회
        MemberDto member = memberMapper.findByMemberId(kakaoId);

        // 2. 이미 가입한 회원이면 그대로 반환
        if (member != null) {
            return member;
        }

        // 3. 처음 카카오 로그인한 회원이면 회원가입
        MemberDto memberDto = new MemberDto();
        memberDto.setUserId(kakaoId);
        memberDto.setNickname(nickname);

        memberMapper.save(memberDto);

        // 4. DB에 저장된 회원 다시 조회
        return memberMapper.findByMemberId(kakaoId);
    }

    @Override
    public void unlink(String accessToken) {
        restClient.post().uri("https://kapi.kakao.com/v1/user/unlink")
                        .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken)
                        .retrieve()
                        .toBodilessEntity();
    }
}
