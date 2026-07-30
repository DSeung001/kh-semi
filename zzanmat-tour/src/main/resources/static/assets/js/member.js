/* 회원가입, 프로필, 로그인 화면 스크립트 */
const profileImageInput = document.querySelector("#signup-profile-image"); //프로필 이미지 파일 태그
const profileImageInputUpdate = document.querySelector("#profile-image-inputUpdate"); //프로필 이미지 파일 태그
const checkIdReult = document.querySelector("#checkUsernameDuplicateBtn"); //아이디 중복체크 버튼
const userIdInput = document.querySelector("#signup-id"); //아이디 입력창
const checkIdResult = document.querySelector("#signupIdMessage"); //아이디 상태
const pwPassValidationResult = document.querySelector("#passwordValidationMessage"); // 비밀번호 유효성 검사 표시
const pwConfirmResult = document.querySelector("#passwordConfirmMessage"); // 비밀번호 일치여부 표시
const emailInput = document.querySelector("#signup-email"); // 이메일 입력창
const emailResult = document.querySelector("#signupEmailMessage"); // 이메일 상태
const profileForm = document.querySelector("#profileForm");
/*const withdrawBtn = document.querySelector("#withdrawBtn"); //*/

/* 유효성 검사 */
const idRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,20}$/; // 아이디
const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/; // 비밀번호: 영문, 숫자, 특수문자 포함 8자 이상
const emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/; // 이메일

//서버에 마지막으로 중복이 아님을 확인받은 아이디값
let checkedMemberId = null;
let checkedPwd = false;
//이메일 인증 성공 확인값
let isEmailVerified = false;

/* 아이디 중복확인 */
if(checkIdReult) {
    checkIdReult.addEventListener("click", async function () {
        const userId = userIdInput.value.trim();
        // 아이디 표시하는 부분 체크
        if (userId.length === 0) {
            checkIdResult.textContent = "아이디를 입력해주세요";
            checkIdResult.classList.add('is-visible');
            checkIdReult.focus();
            checkedMemberId = null;
            return;
        }

        try {
            // encodeURIComponent감싸주는 이유: 아이디에 &, =와같은 요청 url에 영향을 주는 것들을 제거해주는 용도
            const response = await fetch(`/member/checkId?userId=${encodeURIComponent(userId)}`, {
                method: "GET",
                headers: {"X-Request-With": "XMLHtttpRequest"}
            });

            // response.json() : json응답을 자바스크립트 객체로 변경
            const result = await response.json();
            const isDuplicate = result.data;

            checkIdResult.textContent = result.message;
            checkIdResult.className = isDuplicate ? "form-tip form-tip-error" : "form-tip form-tip-ok";

            checkedMemberId = isDuplicate ? null : userId;
        } catch (err) {
            checkIdResult.textContent = "중복확인 중 오류가 발생했습니다.";
            checkIdResult.className = "form-tip form-tip-error";
        }
    })
}

/* 아이디 유효성 검사 */
if(userIdInput) {
    userIdInput.addEventListener("focusout", function (ev) {
        if (!(idRegex.test(ev.target.value))) {
            checkIdResult.textContent = '아이디는 영문과 숫자를 모두 포함해 8~20자로 입력해주세요.';
            checkIdResult.classList.add('is-visible');
            checkedMemberId = null;
        } else {
            checkIdResult.textContent = '';
        }
    });
}

/* 회원가입 폼 제출 */
const signupBtn = document.querySelector("#signupBtn");
if(signupBtn) {
    signupBtn.addEventListener("submit", function (ev) {

        if (!checkedMemberId) {
            ev.preventDefault();
            alert("아이디 중복확인을 진행해주세요.");
            return;
        }

        if (!checkedPwd) {
            ev.preventDefault();
            alert("비밀번호가 일치하지 않습니다.");
            return;
        }

        if (!isEmailVerified){
            ev.preventDefault();
            alert("이메일 인증을 진행해주세요.");
            return;
        }
        // js에서의 검증은 UX관점일 뿐.
        // 우회가 얼마든지 가능하기 때문에 서버에서 재 검증이 필요하다.
        // (아이디 중복o, 비밀번호확인x)
    })
}

if(profileForm){
    profileForm.addEventListener("submit", function(ev){
        const submitter = ev.submitter;
        if(submitter.id === 'saveBtn'){
            if(!confirm('회원정보를 수정하시겠습니까?')){
                ev.preventDefault();
            }
        }
    });
}

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
if(pwInput) {
    pwInput.addEventListener("focusout", function (ev) {
        if (!(passwordRegex.test(ev.target.value))) {
            pwPassValidationResult.textContent = '영문, 숫자, 특수문자 포함 8자 이상 입력해주세요.';
            pwPassValidationResult.classList.add('is-visible');
            checkedPwd = false;
        } else {
            pwPassValidationResult.textContent = '';
        }
    });

    pwInput.addEventListener("input", validatePwdConfirm);
    pwConfirmInput.addEventListener("input", validatePwdConfirm);
}

/* 회원가입 페이지 프로필 이미지 미리보기 */
if(profileImageInput) {
    profileImageInput.addEventListener("change", function (ev) {
        //업로드한 파일중 첫번째 요소를 가져옴
        const file = ev.target.files[0];
        if (!file) {
            return;
        }

        // FileReader - 아직 서버에 업로드하지 않은, 사용자 PC에 있는 파일을
        // 브라우저 메모리에 올리기위해 base64라는 문자열로 만들어주는 js객체
        // base64로 변경해야 img태그의 src속성에 넣어 사용이 가능
        const reader = new FileReader();
        reader.onload = function (ev) {
            const profilePreview = document.querySelector("#profile-preview");
            profilePreview.src = ev.target.result;
            profilePreview.style.display = "block";

            const profilePlaceholder = document.querySelector("#profile-preview-placeholder");
            profilePlaceholder.style.display = "none";
        }

        // 업로드한 파일을 base64방식의 데이터URL로 변경.
        reader.readAsDataURL(file);
    })
}

/* 내정보 페이지 프로필 이미지 미리보기 */
if(profileImageInputUpdate) {
    profileImageInputUpdate.addEventListener("change", function (ev) {
        //업로드한 파일중 첫번째 요소를 가져옴
        const file = ev.target.files[0];
        if (!file) {
            return;
        }

        // FileReader - 아직 서버에 업로드하지 않은, 사용자 PC에 있는 파일을
        // 브라우저 메모리에 올리기위해 base64라는 문자열로 만들어주는 js객체
        // base64로 변경해야 img태그의 src속성에 넣어 사용이 가능
        const reader = new FileReader();
        reader.onload = function (ev) {
            const profilePreview = document.querySelector("#my-profile");
            profilePreview.src = ev.target.result;
            // profilePreview.style.display = "block";

            // const profilePlaceholder = document.querySelector("#profile-preview-placeholder");
            // profilePlaceholder.style.display = "none";
        }

        // 업로드한 파일을 base64방식의 데이터URL로 변경.
        reader.readAsDataURL(file);
    })
}

/* 이메일 유효성 검사 */
if(emailInput) {
    emailInput.addEventListener("focusout", function (ev) {
        if (!(emailRegex.test(ev.target.value))) {
            emailResult.textContent = '올바른 이메일 형식을 입력해주세요.';
            emailResult.classList.add('is-visible');
            checkedPwd = false;
        } else {
            emailResult.textContent = '';
        }
    });
}

// 인증번호 요청
const sendCodeBtn = document.querySelector("#sendCodeBtn");
if(sendCodeBtn){
    sendCodeBtn.addEventListener("click", function(){
        const email = document.querySelector("#signup-email").value;
        const authDiv = document.querySelector(".input-group.auth-email");
        if(!email) {
            alert("이메일을 입력해주세요.");
            return;
        }

        // 서버로 이메일 전송 요청 (Ajax)
        fetch('/email/send?email=' + encodeURIComponent(email), {
            method: 'POST'
        })
            .then(response => response.text())
            .then(result => {
                alert(result); // "인증번호가 성공적으로 전송되었습니다."

                // TODO: 인증번호 입력 칸을 화면에 보여주는 로직 추가
                authDiv.classList.add("is-visible");
            })
            .catch(error => {
                console.error('Error:', error);
                alert("오류가 발생했습니다.");
            });
    });
}

// 인증번호 확인
const authConfirmBtn = document.querySelector("#authConfirmBtn");

if(authConfirmBtn){
    authConfirmBtn.addEventListener("click", function(){
        const email = document.querySelector("#signup-email").value;
        const authCode = document.querySelector("#email-auth-section").value; // 사용자가 입력한 6자리 번호

        if(!authCode) {
            alert("인증번호 6자리를 입력해주세요.");
            return;
        }

        // 서버로 이메일과 인증번호를 함께 보내서 검증 요청
        fetch('/email/verify?email=' + encodeURIComponent(email) + '&authCode=' + encodeURIComponent(authCode), {
            method: 'POST'
        })
            .then(response => response.text())
            .then(result => {
                // 서버에서 반환된 결과에 따른 처리 (예: "인증성공", "인증실패" 등)
                if(result === "success") {
                    alert("인증이 완료되었습니다.");
                    isEmailVerified = true;
                    // TODO: 회원가입 버튼 활성화 또는 인증 완료 상태 표시
                } else {
                    alert("인증번호가 일치하지 않거나 만료되었습니다.");
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert("오류가 발생했습니다.");
            });
    });
}