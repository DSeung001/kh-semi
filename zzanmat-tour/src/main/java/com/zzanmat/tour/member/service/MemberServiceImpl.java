package com.zzanmat.tour.member.service;

import com.zzanmat.tour.common.util.FileUploadUtil;
import com.zzanmat.tour.common.util.SavedFile;
import com.zzanmat.tour.member.dto.MemberDto;
import com.zzanmat.tour.member.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClient;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

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

    @Value("${spring.security.oauth2.client.registration.naver.client-id}")
    private String naverClientId;

    @Value("${spring.security.oauth2.client.registration.naver.client-secret}")
    private String naverClientSecret;

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
        memberDto.setLoginType("LOCAL");
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
        memberDto.setLoginType("KAKAO");

        memberMapper.save(memberDto);

        // 4. DB에 저장된 회원 다시 조회
        return memberMapper.findByMemberId(kakaoId);
    }

    @Override
    public MemberDto naverJoin(String naverId, String nickname, String email) {

        // 1. 네이버 고유 ID로 기존 회원 조회
        MemberDto member = memberMapper.findByMemberId(naverId);

        // 2. 이미 가입된 네이버 회원이면 그대로 반환
        if (member != null) {
            return member;
        }

        // 3. 최초 로그인이라면 회원 데이터 생성
        MemberDto memberDto = new MemberDto();
        memberDto.setUserId(naverId);
        memberDto.setNickname(nickname);
        memberDto.setEmail(email);
        memberDto.setLoginType("NAVER");

        memberMapper.save(memberDto);

        // 4. 저장된 회원을 다시 조회
        return memberMapper.findByMemberId(naverId);
    }

    @Override
    public void unlinkKakao(String accessToken) {
        restClient.post().uri("https://kapi.kakao.com/v1/user/unlink")
                        .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken)
                        .retrieve()
                        .toBodilessEntity();
    }

    @Override
    public void unlinkNaver(String accessToken) {
        MultiValueMap<String, String> formData = new LinkedMultiValueMap<>();

        formData.add("grant_type", "delete");
        formData.add("client_id", naverClientId);
        formData.add("client_secret", naverClientSecret);
        formData.add("access_token", accessToken);
        formData.add("service_provider", "NAVER");

        Map<String, Object> response = restClient.post().uri("https://nid.naver.com/oauth2.0/token")
                                                    .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                                                    .body(formData)
                                                    .retrieve()
                                                    .body(Map.class);

        if (response == null || !"success".equals(response.get("result"))) {
            throw new IllegalStateException("네이버 연결 해제에 실패했습니다.");
        }
    }

    public boolean isFollowing(Long followerId, Long followeringId) {
        return memberMapper.countByFollowId(followerId, followeringId) > 0;
    }

    @Transactional
    public void follow(Long followerId, Long followingId) {

        if (followerId.equals(followingId)) {
            throw new IllegalArgumentException("자기 자신은 팔로우할 수 없습니다.");
        }

        if (isFollowing(followerId, followingId)) {
            return;
        }

        memberMapper.saveFollowe(followerId, followingId);
    }

    @Transactional
    public void unfollow(Long followerId, Long followingId) {

        if (followerId.equals(followingId)) {
            throw new IllegalArgumentException("자기 자신은 팔로우할 수 없습니다.");
        }

        memberMapper.deleteByFollow(followerId, followingId);
    }
}
