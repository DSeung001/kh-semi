package com.zzanmat.tour.member.Exception;

public class WithdrawnMemberException extends RuntimeException {

    private final Long memberId;

    public WithdrawnMemberException(Long memberId) {
        super("탈퇴한 회원입니다.");
        this.memberId = memberId;
    }

    public Long getMemberId() {
        return memberId;
    }

}
