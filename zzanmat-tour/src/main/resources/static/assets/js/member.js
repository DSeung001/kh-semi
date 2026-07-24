/* 회원가입 화면 스크립트 */
const checkIdReult = document.querySelector("#checkUsernameDuplicateBtn"); //아이디 중복체크 버튼
const memberIdInput = document.querySelector("#signup-id"); //아이디 입력창
const checkIdResult = document.querySelector("#check-id-result"); //아이디 상태

//서버에 마지막으로 중복이 아님을 확인받은 아이디값
let checkedMemberId = null;
let checkedPwd = false;

/* 아이디 중복확인 */
checkIdReult.addEventListener("click",async function(){
    const memberId = memberIdInput.value.trim();
    // 아이디 표시하는 부분 체크
    /*if(memberId.length === 0) {
        checkIdResult.textContent = "아이디를 입력해주세요";
        checkIdResult.className = "form-tip form-tip-error";
        checkedMemberId = null;
        return;
    }*/

    try {
        // encodeURIComponent감싸주는 이유: 아이디에 &, =와같은 요청 url에 영향을 주는 것들을 제거해주는 용도
        const response = await fetch(`/member/checkId?memberId=${encodeURIComponent(memberId)}`,{
            method: "GET",
            headers: {"X-Request-With": "XMLHtttpRequest"}
        });

        // response.json() : json응답을 자바스크립트 객체로 변경
        const result = await response.json();
        const isDuplicate = result.data;

        checkIdResult.textContent = result.message;
        checkIdResult.className = isDuplicate ? "form-tip form-tip-error" : "form-tip form-tip-ok";

        checkedMemberId = isDuplicate ? null : memberId;
    } catch(err){
        checkIdResult.textContent = "중복확인 중 오류가 발생했습니다.";
        checkIdResult.className = "form-tip form-tip-error";
    }
})

/* 회원가입 폼 제출 */
const signupBtn = document.querySelector("#signupBtn");
signupBtn.addEventListener("submit", function (ev){
    /*if(!checkedMemberId){
        ev.preventDefault();
        alert("아이디 중복확인을 진행해주세요");
        return;
    }*/

    /*if(!checkedPwd){
        ev.preventDefault();
        alert("비밀번호가 일치하지 않습니다.");
        return;
    }*/
    // js에서의 검증은 UX관점일 뿐.
    // 우회가 얼마든지 가능하기 때문에 서버에서 재 검증이 필요하다.
    // (아이디 중복o, 비밀번호확인x)
})