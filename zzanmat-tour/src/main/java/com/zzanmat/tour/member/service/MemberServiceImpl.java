package com.zzanmat.tour.member.service;

import com.zzanmat.tour.common.util.FileUploadUtil;
import com.zzanmat.tour.common.util.SavedFile;
import com.zzanmat.tour.member.Exception.WithdrawnMemberException;
import com.zzanmat.tour.member.dto.FollowRelationDto;
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
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

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
        String nickname = memberDto.getNickname() == null ? "" : memberDto.getNickname().trim();

        // 아이디 중복검사
        if(isMemberIdCheck(memberDto.getUserId())){
            throw new IllegalArgumentException("이미 사용중인 아이디 입니다.");
        }
        if (nickname.isEmpty()) {
            throw new IllegalArgumentException("닉네임을 입력해주세요.");
        }
        if (isNicknameDuplicate(nickname)) {
            throw new IllegalArgumentException("이미 사용중인 닉네임입니다.");
        }
        memberDto.setNickname(nickname);

        validateProfileImage(profileImage);

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
        return memberMapper.countByUserId(userId) > 0;
    }

    @Override
    public boolean isNicknameDuplicate(String nickname) {
        return memberMapper.countByNickname(nickname) > 0;
    }

    @Override
    public boolean isEmailDuplicate(String email) {
        return memberMapper.countByEmail(email) > 0;
    }

    @Override
    public int countAllMembers() {
        return memberMapper.countAllMembers();
    }

    @Override
    public MemberDto login(String userId, String memberPwd) throws IllegalStateException{
        MemberDto member = memberMapper.findByUserId(userId);

        // member.getMemberPwd(); 암호화된 비밀번호
        // memberPwd 평문의 비밀번호
        // passwordEncoder.matches(평문, 암호문) -> 결과는 해당 평문과 암호문의 비교값 : true/false

        if(member == null || !passwordEncoder.matches(memberPwd, member.getUserPassword())){
            // 런타임 예외 -> 나중에는 각 예외별 에러코드를 분리해서 관리
            throw new IllegalStateException("아이디 또는 비밀번호가 일치하지 않습니다.");
        }else if (Boolean.TRUE.equals(member.getDeleted())) {
            // 비밀번호까지 일치한 탈퇴 회원
            throw new WithdrawnMemberException(member.getId());
        }

        return member;
    }

    @Override
    public boolean update(MemberDto memberDto, MultipartFile newprofileImage, String originProfileName) throws IOException {
        if (memberDto.getId() == null) {
            throw new IllegalArgumentException("수정할 회원 정보가 없습니다.");
        }

        String nickname = memberDto.getNickname() == null ? "" : memberDto.getNickname().trim();
        if (nickname.isEmpty()) {
            throw new IllegalArgumentException("닉네임을 입력해주세요.");
        }
        if (nickname.length() > 30) {
            throw new IllegalArgumentException("닉네임은 30자 이하로 입력해주세요.");
        }
        if (nickname.equals("탈퇴한 회원") || nickname.startsWith("탈퇴한 회원_")) {
            throw new IllegalArgumentException("사용할 수 없는 닉네임입니다.");
        }
        if (memberMapper.countByNicknameExcludingId(nickname, memberDto.getId()) > 0) {
            throw new IllegalArgumentException("이미 존재하는 닉네임입니다.");
        }
        memberDto.setNickname(nickname);

        //사용자가 새로운 프로필을 등록한다면 기존에 등록되어 있던 프로필 삭제 후
        //새로운 프로필 이미지 등록
        boolean hasNewImages = newprofileImage != null && !newprofileImage.isEmpty();
        if(hasNewImages){
            validateProfileImage(newprofileImage);

            fileUploadUtil.delete(originProfileName, profileUploadDir);

            SavedFile saved = fileUploadUtil.save(newprofileImage, profileUploadDir, "/uploads/profile");
            if(saved != null){
                memberDto.setProfile(saved.getPath());
            }
        }

        return memberMapper.update(memberDto) > 0;
    }

    private void validateProfileImage(MultipartFile profileImage) {
        if (profileImage == null || profileImage.isEmpty()) {
            return;
        }

        String originalFilename = profileImage.getOriginalFilename();
        String contentType = profileImage.getContentType();

        boolean validExtension = originalFilename != null && originalFilename.toLowerCase(Locale.ROOT).matches("^.*\\.(jpg|jpeg|png)$");

        boolean validContentType = "image/jpeg".equals(contentType) || "image/png".equals(contentType);

        if (!validExtension || !validContentType) {
            throw new IllegalArgumentException("JPG, JPEG, PNG 파일만 업로드할 수 있습니다.");
        }
    }

    @Override
    public MemberDto findDetailByUserId(String userId) {
        return memberMapper.findDetailByUserId(userId);
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
    public boolean resetPasswordByMemberId(Long memberId, String newPassword) {
        return memberMapper.updatePasswordByMemberId(memberId, passwordEncoder.encode(newPassword)) > 0;
    }

    @Override
    @Transactional
    public void withdraw(Long memberId) {
        String anonymousNickname = createAnonymousNickname();
        int updatedCount = memberMapper.deleteById(memberId, anonymousNickname);

        if (updatedCount == 0) {
            throw new IllegalStateException("탈퇴할 회원 정보를 찾을 수 없거나 이미 탈퇴한 회원입니다.");
        }
    }

    private String createAnonymousNickname() {
        String anonymousNickname;
        do {
            // 회원 PK 대신 무작위 값을 사용해 탈퇴 회원의 식별 정보와 가입 순서를 노출하지 않는다.
            String randomValue = UUID.randomUUID().toString()
                    .replace("-", "")
                    .substring(0, 8)
                    .toUpperCase(Locale.ROOT);
            anonymousNickname = "탈퇴한 회원_" + randomValue;
        } while (memberMapper.countByNickname(anonymousNickname) > 0);

        return anonymousNickname;
    }

    @Override
    @Transactional
    public MemberDto kakaoJoin(String kakaoId, String nickname) {

        // 1. 카카오 ID로 기존 회원 조회
        MemberDto member = memberMapper.findByUserId(kakaoId);

        // 2. 탈퇴 회원이면 카카오 인증 정보를 기준으로 계정을 복구
        if (member != null) {
            if (!"KAKAO".equals(member.getLoginType())) {
                throw new IllegalStateException("카카오 계정 정보가 기존 회원 유형과 일치하지 않습니다.");
            }
            if (Boolean.TRUE.equals(member.getDeleted())) {
                String restoredNickname = createAvailableSocialNickname(nickname, "KAKAO", kakaoId);
                int updatedCount = memberMapper.updateSocialMemberForRestore(
                        member.getId(), restoredNickname, null
                );
                if (updatedCount == 0) {
                    throw new IllegalStateException("카카오 계정을 복구하지 못했습니다.");
                }
                return memberMapper.findByUserId(kakaoId);
            }
            return member;
        }

        // 3. 처음 카카오 로그인한 회원이면 회원가입
        MemberDto memberDto = new MemberDto();
        memberDto.setUserId(kakaoId);
        memberDto.setNickname(createAvailableSocialNickname(nickname, "KAKAO", kakaoId));
        memberDto.setLoginType("KAKAO");

        memberMapper.save(memberDto);

        // 4. DB에 저장된 회원 다시 조회
        return memberMapper.findByUserId(kakaoId);
    }

    @Override
    @Transactional
    public MemberDto naverJoin(String naverId, String nickname, String email) {

        // 1. 네이버 고유 ID로 기존 회원 조회
        MemberDto member = memberMapper.findByUserId(naverId);

        // 2. 탈퇴 회원이면 네이버 인증 정보를 기준으로 계정을 복구
        if (member != null) {
            if (!"NAVER".equals(member.getLoginType())) {
                throw new IllegalStateException("네이버 계정 정보가 기존 회원 유형과 일치하지 않습니다.");
            }
            if (Boolean.TRUE.equals(member.getDeleted())) {
                String restoredNickname = createAvailableSocialNickname(nickname, "NAVER", naverId);
                int updatedCount = memberMapper.updateSocialMemberForRestore(
                        member.getId(), restoredNickname, email
                );
                if (updatedCount == 0) {
                    throw new IllegalStateException("네이버 계정을 복구하지 못했습니다.");
                }
                return memberMapper.findByUserId(naverId);
            }
            return member;
        }

        // 3. 최초 로그인이라면 회원 데이터 생성
        MemberDto memberDto = new MemberDto();
        memberDto.setUserId(naverId);
        memberDto.setNickname(createAvailableSocialNickname(nickname, "NAVER", naverId));
        memberDto.setEmail(email);
        memberDto.setLoginType("NAVER");

        memberMapper.save(memberDto);

        // 4. 저장된 회원을 다시 조회
        return memberMapper.findByUserId(naverId);
    }

    private String createAvailableSocialNickname(String nickname, String provider, String socialId) {
        String defaultNickname = provider.equals("KAKAO") ? "카카오회원" : "네이버회원";
        String baseNickname = nickname == null || nickname.isBlank()
                ? defaultNickname
                : nickname.trim();

        if (!isNicknameDuplicate(baseNickname)) {
            return baseNickname;
        }

        String compactSocialId = socialId.length() > 6
                ? socialId.substring(socialId.length() - 6)
                : socialId;
        String suffix = "_" + provider + "_" + compactSocialId;
        int maxBaseLength = Math.max(1, 50 - suffix.length());
        String truncatedBase = baseNickname.length() > maxBaseLength
                ? baseNickname.substring(0, maxBaseLength)
                : baseNickname;

        return truncatedBase + suffix;
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
        return memberMapper.countByFollowerIdAndFolloweringId(followerId, followeringId) > 0;
    }

    @Transactional
    public void follow(Long followerId, Long followingId) {

        if (followerId.equals(followingId)) {
            throw new IllegalArgumentException("자기 자신은 팔로우할 수 없습니다.");
        }

        if (memberMapper.countActiveById(followingId) == 0) {
            throw new IllegalArgumentException("탈퇴한 회원은 팔로우할 수 없습니다.");
        }

        if (isFollowing(followerId, followingId)) {
            return;
        }

        memberMapper.saveFollow(followerId, followingId);
    }

    @Transactional
    public void unfollow(Long followerId, Long followingId) {

        if (followerId.equals(followingId)) {
            throw new IllegalArgumentException("자기 자신은 팔로우할 수 없습니다.");
        }

        memberMapper.deleteByFollowerIdAndFolloweringId(followerId, followingId);
    }

    @Transactional
    public void restore(Long memberId) {
        int updatedCount = memberMapper.restore(memberId);

        if (updatedCount == 0) {
            throw new IllegalStateException("복구할 회원 정보를 찾을 수 없습니다.");
        }
    }

    @Override
    public void registerLoginSession(Long memberId, String loginSessionId) {
        if (memberMapper.updateLoginSessionId(memberId, loginSessionId) == 0) {
            throw new IllegalStateException("로그인 세션을 등록하지 못했습니다.");
        }
    }

    @Override
    public void clearLoginSession(Long memberId, String loginSessionId) {
        memberMapper.clearLoginSessionId(memberId, loginSessionId);
    }

    @Override
    public boolean isCurrentLoginSession(Long memberId, String loginSessionId) {
        return loginSessionId != null && memberMapper.countCurrentLoginSession(memberId, loginSessionId) > 0;
    }

    @Override
    public List<FollowRelationDto> getFollowRelations(String keyword, int page, int size) {
        String trimmedKeyword = keyword == null ? null : keyword.trim();
        int offset = (page - 1) * size;
        return memberMapper.findFollowRelations(trimmedKeyword, offset, size);
    }

    @Override
    public int countFollowRelations() {
        return memberMapper.countFollowRelations();
    }

    @Override
    public int countFollowRelationsByKeyword(String keyword) {
        String trimmedKeyword = keyword == null ? null : keyword.trim();
        return memberMapper.countFollowRelationsByKeyword(trimmedKeyword);
    }

    @Override
    public int countDistinctFollowers() {
        return memberMapper.countDistinctFollowers();
    }

    @Override
    public int countDistinctFollowingMembers() {
        return memberMapper.countDistinctFollowingMembers();
    }

}
