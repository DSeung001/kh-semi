/* 회원가입, 프로필, 로그인 화면 스크립트 */
const checkIdReult = document.querySelector("#checkUsernameDuplicateBtn"); //아이디 중복체크 버튼
const userIdInput = document.querySelector("#signup-id"); //아이디 입력창
const checkIdResult = document.querySelector("#signupIdMessage"); //아이디 상태
const pwPassValidationResult = document.querySelector("#passwordValidationMessage"); // 비밀번호 유효성 검사 표시
const pwConfirmResult = document.querySelector("#passwordConfirmMessage"); // 비밀번호 일치여부 표시
/*const withdrawBtn = document.querySelector("#withdrawBtn"); //*/

/* 유효성 검사 */
const idRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,20}$/; //
const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/; // 비밀번호: 영문, 숫자, 특수문자 포함 8자 이상

//서버에 마지막으로 중복이 아님을 확인받은 아이디값
let checkedMemberId = null;
let checkedPwd = false;

/*window.onload = function() {
    const successMessage = "${joinSuccess}";

    if (successMessage) {
        alert('회원가입이 완료되었습니다. 로그인 해주세요.');
    }else{
        alert('회원가입이 정상적으로 되지 않았습니다. \n 다시 회원가입 해주세요.')
    }
}*/

/* 아이디 중복확인 */
checkIdReult.addEventListener("click",async function(){
    const userId = userIdInput.value.trim();
    // 아이디 표시하는 부분 체크
    if(userId.length === 0) {
        checkIdResult.textContent = "아이디를 입력해주세요";
        checkIdResult.classList.add('is-visible');
        checkIdReult.focus();
        checkedMemberId = null;
        return;
    }

    try {
        // encodeURIComponent감싸주는 이유: 아이디에 &, =와같은 요청 url에 영향을 주는 것들을 제거해주는 용도
        const response = await fetch(`/member/checkId?userId=${encodeURIComponent(userId)}`,{
            method: "GET",
            headers: {"X-Request-With": "XMLHtttpRequest"}
        });

        // response.json() : json응답을 자바스크립트 객체로 변경
        const result = await response.json();
        const isDuplicate = result.data;

        checkIdResult.textContent = result.message;
        checkIdResult.className = isDuplicate ? "form-tip form-tip-error" : "form-tip form-tip-ok";

        checkedMemberId = isDuplicate ? null : userId;
    } catch(err){
        checkIdResult.textContent = "중복확인 중 오류가 발생했습니다.";
        checkIdResult.className = "form-tip form-tip-error";
    }
})

/* 아이디 유효성 검사 */
userIdInput.addEventListener("focusout", function (ev) {
    if (!(idRegex.test(ev.target.value))) {
        checkIdResult.textContent = '아이디는 영문과 숫자를 모두 포함해 8~20자로 입력해주세요.';
        checkIdResult.classList.add('is-visible');
        checkedMemberId = null;
    }else{
        checkIdResult.textContent = '';
    }
});

/* 회원가입 폼 제출 */
const signupBtn = document.querySelector("#signupBtn");
signupBtn.addEventListener("submit", function (ev){

    if(!checkedMemberId){
        ev.preventDefault();
        alert("아이디 중복확인을 진행해주세요");
        return;
    }

    if(!checkedPwd){
        ev.preventDefault();
        alert("비밀번호가 일치하지 않습니다.");
        return;
    }
    // js에서의 검증은 UX관점일 뿐.
    // 우회가 얼마든지 가능하기 때문에 서버에서 재 검증이 필요하다.
    // (아이디 중복o, 비밀번호확인x)
})

/* 비밀번호 확인 */
const pwInput = document.querySelector("#signup-password"); //비밀번호 입력창
const pwConfirmInput = document.querySelector("#signup-password2"); //비밀번호 입력창

function validatePwdConfirm(){
    //비밀번호 확인창이 비어있다면 검사x
    if(!pwConfirmInput.value.trim()){
        pwConfirmResult.textContent = "";
        checkedPwd = false;
        return;
    }

    //회원가입 버튼 클릭시에 비밀번호가 체크되었는지 확인하는 부분
    checkedPwd = pwInput.value === pwConfirmInput.value;

    pwConfirmResult.textContent = checkedPwd ? "비밀번호가 일치합니다" : "비밀번호가 일치하지 않습니다";
    pwConfirmResult.className = checkedPwd ? "form-message is-visible is-success" : "form-message is-visible is-erro";
}

/* 비밀번호 유효성 검사 */
pwInput.addEventListener("focusout", function (ev) {
    if (!(passwordRegex.test(ev.target.value))) {
        pwPassValidationResult.textContent = '영문, 숫자, 특수문자 포함 8자 이상 입력해주세요.';
        pwPassValidationResult.classList.add('is-visible');
        checkedPwd = false;
    }else{
        pwPassValidationResult.textContent = '';
    }
});

pwInput.addEventListener("input", validatePwdConfirm);
pwConfirmInput.addEventListener("input", validatePwdConfirm);