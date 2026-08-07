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
const emailAuthCode = document.querySelector("#email-auth-section"); // 사용자가 입력한 6자리 번호
const emailAuthTimer = document.querySelector("#emailAuthTimer");
const emailAuthMessage = document.querySelector("#emailAuthMessage");
const loginForm = document.querySelector("#loginForm");
const savedIdInput = document.querySelector("#login-id");
const rememberCheck = document.querySelector("#save-check");
const nicknameInput = document.querySelector("#signup-nickname");
const nicknameValidationResult = document.querySelector("#nicknameValidationMessage");
const termsInput = document.querySelector("#terms");
const termsValidationResult = document.querySelector("#termsValidationMessage");
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
let emailTimerId = null;
let emailRemainingSeconds = 0;
//비밀번호 유효성 검사 통과 여부
let isPasswordValid = false;

function formatEmailAuthTime(seconds) {
    const minutes = String(Math.floor(seconds / 60)).padStart(2, "0");
    const remainingSeconds = String(seconds % 60).padStart(2, "0");
    return `${minutes}:${remainingSeconds}`;
}

function setEmailAuthMessage(message, isError = false) {
    if (!emailAuthMessage) {
        return;
    }

    emailAuthMessage.textContent = message;
    emailAuthMessage.className = `signup-message is-visible ${isError ? "is-error" : "is-success"}`;
}

function stopEmailAuthTimer() {
    clearInterval(emailTimerId);
    emailTimerId = null;
}

function startEmailAuthTimer() {
    stopEmailAuthTimer();
    emailRemainingSeconds = 180;
    emailAuthTimer.textContent = formatEmailAuthTime(emailRemainingSeconds);
    emailAuthTimer.classList.remove("is-expired");
    emailAuthCode.disabled = false;
    authConfirmBtn.disabled = false;
    emailAuthCode.value = "";
    emailAuthCode.focus();

    emailTimerId = setInterval(function () {
        emailRemainingSeconds -= 1;
        emailAuthTimer.textContent = formatEmailAuthTime(Math.max(emailRemainingSeconds, 0));

        if (emailRemainingSeconds <= 0) {
            stopEmailAuthTimer();
            emailAuthTimer.textContent = "만료";
            emailAuthTimer.classList.add("is-expired");
            emailAuthCode.disabled = true;
            authConfirmBtn.disabled = true;
            setEmailAuthMessage("인증 시간이 만료되었습니다. 다시 인증해주세요.", true);
        }
    }, 1000);
}

/* 아이디 중복확인 */
if(checkIdReult) {
    checkIdReult.addEventListener("click", async function () {
        const userId = userIdInput.value.trim();
        // 아이디 표시하는 부분 체크
        if (userId.length === 0) {
            checkIdResult.textContent = "아이디를 입력해주세요.";
            checkIdResult.className = "signup-message is-visible is-error";
            userIdInput.focus();
            checkedMemberId = null;
            return;
        }

        // 아이디 형식 검사를 통과한 경우에만 서버에 중복확인을 요청한다.
        if (!idRegex.test(userId)) {
            checkIdResult.textContent = "아이디는 영문과 숫자를 모두 포함해 8~20자로 입력해주세요.";
            checkIdResult.className = "signup-message is-visible is-error";
            userIdInput.focus();
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
            checkIdResult.className = isDuplicate
                ? "signup-message is-visible is-error"
                : "signup-message is-visible is-success";

            checkedMemberId = isDuplicate ? null : userId;
        } catch (err) {
            checkIdResult.textContent = "중복확인 중 오류가 발생했습니다.";
            checkIdResult.className = "signup-message is-visible is-error";
        }
    })
}

/* 아이디 입력값이 바뀌면 기존 중복확인 결과를 무효화 */
if(userIdInput) {
    userIdInput.addEventListener("input", function (ev) {
        if (checkedMemberId !== ev.target.value.trim()) {
            checkedMemberId = null;
            checkIdResult.textContent = "";
            checkIdResult.className = "signup-message";
        }
    });
}

/* 회원가입 폼 제출 */
const signupBtn = document.querySelector("#signupBtn");
if(signupBtn) {
    signupBtn.addEventListener("submit", function (ev) {
        const userId = userIdInput.value.trim();
        const password = pwInput.value;
        const passwordConfirm = pwConfirmInput.value;
        const email = emailInput.value.trim();
        const nickname = nicknameInput.value.trim();

        const setResult = function (element, message, isValid) {
            element.textContent = message;
            element.className = `${element.classList.contains("signup-message") ? "signup-message" : "form-message"} is-visible ${isValid ? "is-success" : "is-error"}`;
        };

        const stopValidation = function (element, message, focusTarget) {
            ev.preventDefault();
            setResult(element, message, false);
            focusTarget.focus();
        };

        // 이전 제출 시도에서 표시된 결과를 지운 뒤 앞 항목부터 순서대로 검사한다.
        [checkIdResult, pwPassValidationResult, pwConfirmResult, emailResult,
            nicknameValidationResult, termsValidationResult].forEach(function (element) {
            element.textContent = "";
            element.className = element.classList.contains("signup-message")
                ? "signup-message"
                : "form-message";
        });

        const isIdFormatValid = idRegex.test(userId);
        const isIdChecked = isIdFormatValid && checkedMemberId === userId;
        if (!isIdFormatValid) {
            stopValidation(checkIdResult, "아이디는 영문과 숫자를 모두 포함해 8~20자로 입력해주세요.", userIdInput);
            return;
        }
        if (!isIdChecked) {
            stopValidation(checkIdResult, "아이디 중복확인을 진행해주세요.", checkIdReult);
            return;
        }
        setResult(checkIdResult, "사용 가능한 아이디입니다.", true);

        const isEmailFormatValid = emailRegex.test(email);
        if (!isEmailFormatValid) {
            stopValidation(emailResult, "올바른 이메일 형식을 입력해주세요.", emailInput);
            return;
        }
        if (!isEmailVerified) {
            stopValidation(emailResult, "이메일 인증을 진행해주세요.", sendCodeBtn);
            return;
        }
        setResult(emailResult, "이메일 인증이 완료되었습니다.", true);

        isPasswordValid = passwordRegex.test(password);
        if (!isPasswordValid) {
            stopValidation(pwPassValidationResult, "영문, 숫자, 특수문자를 포함해 8자 이상 입력해주세요.", pwInput);
            return;
        }
        setResult(pwPassValidationResult, "사용 가능한 비밀번호입니다.", true);

        checkedPwd = password.length > 0 && password === passwordConfirm;
        if (!checkedPwd) {
            stopValidation(pwConfirmResult, "비밀번호가 일치하지 않습니다.", pwConfirmInput);
            return;
        }
        setResult(pwConfirmResult, "비밀번호가 일치합니다.", true);

        const isNicknameValid = nickname.length > 0;
        if (!isNicknameValid) {
            stopValidation(nicknameValidationResult, "닉네임을 입력해주세요.", nicknameInput);
            return;
        }
        setResult(nicknameValidationResult, "사용 가능한 닉네임입니다.", true);

        const isTermsValid = termsInput.checked;
        if (!isTermsValid) {
            stopValidation(termsValidationResult, "이용약관과 개인정보처리방침에 동의해주세요.", termsInput);
            return;
        }
        setResult(termsValidationResult, "약관에 동의하셨습니다.", true);
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

    pwConfirmResult.textContent = "";
    pwConfirmResult.className = "form-message";
}

/* 비밀번호 유효성 검사 */
if(pwInput) {
    pwInput.addEventListener("input", function (ev) {
        isPasswordValid = passwordRegex.test(ev.target.value);
        pwPassValidationResult.textContent = "";
        pwPassValidationResult.className = "form-message";
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

        // JPG, JPEG, PNG 파일만 허용
        const allowedTypes = ["image/jpeg", "image/png"];
        const allowedExtensions = /\.(jpg|jpeg|png)$/i;

        if (!allowedTypes.includes(file.type) || !allowedExtensions.test(file.name)) {
            alert("JPG, JPEG, PNG 파일만 업로드할 수 있습니다.");
            ev.target.value = "";

            const profilePreview = document.querySelector("#profile-preview");
            // const profilePlaceholder = document.querySelector("#profile-preview-placeholder");

            if (profilePreview) {
                profilePreview.removeAttribute("src");
                profilePreview.style.display = "none";
            }

            // if (profilePlaceholder) {
            //     profilePlaceholder.style.display = "";
            // }

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

            // const profilePlaceholder = document.querySelector("#profile-preview-placeholder");
            // profilePlaceholder.style.display = "none";
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

        // 내 정보 페이지에서도 JPG, JPEG, PNG 파일만 허용
        const allowedTypes = ["image/jpeg", "image/png"];
        const allowedExtensions = /\.(jpg|jpeg|png)$/i;

        if (!allowedTypes.includes(file.type) || !allowedExtensions.test(file.name)) {
            alert("JPG, JPEG, PNG 파일만 업로드할 수 있습니다.");
            ev.target.value = "";
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
    emailInput.addEventListener("input", function () {
        emailResult.textContent = "";
        emailResult.className = "signup-message";
        // 인증번호를 발송한 뒤 이메일을 바꾸면 기존 인증 상태를 사용할 수 없습니다.
        if (emailTimerId || isEmailVerified) {
            stopEmailAuthTimer();
            isEmailVerified = false;
            emailAuthCode.value = "";
            emailAuthCode.disabled = true;
            authConfirmBtn.disabled = true;
            emailAuthTimer.textContent = "03:00";
            emailAuthTimer.classList.remove("is-expired");
            setEmailAuthMessage("이메일이 변경되었습니다. 인증번호를 다시 발송해주세요.", true);
        }
    });
}

// 인증번호 요청
const sendCodeBtn = document.querySelector("#sendCodeBtn");
if(sendCodeBtn){
    sendCodeBtn.addEventListener("click", function(){
        const email = emailInput.value.trim();
        const authDiv = document.querySelector(".input-group.auth-email");
        if(!emailRegex.test(email)) {
            emailResult.textContent = "올바른 이메일 형식을 입력해주세요.";
            emailResult.className = "signup-message is-visible is-error";
            emailInput.focus();
            return;
        }

        emailResult.textContent = "";
        emailResult.className = "signup-message";

        sendCodeBtn.disabled = true;

        // 서버로 이메일 전송 요청 (Ajax)
        fetch('/email/send', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email: email })
        })
            .then(response => response.json())
            .then(result => {
                if (!result.success) {
                    // 중복 이메일 등은 서버 오류가 아닌 입력값 검증 결과입니다.
                    emailResult.textContent = result.message || "인증번호를 발송할 수 없습니다.";
                    emailResult.className = "signup-message is-visible";
                    return;
                }
                authDiv.classList.add("is-visible");
                isEmailVerified = false;
                emailResult.textContent = "";
                emailResult.className = "signup-message";
                setEmailAuthMessage((result.message || "인증번호가 성공적으로 전송되었습니다.") + " 3분 안에 인증번호를 입력해주세요.");
                startEmailAuthTimer();
            })
            .catch(error => {
                console.error('Error:', error);
                setEmailAuthMessage(error.message || "인증번호 발송 중 오류가 발생했습니다.", true);
            })
            .finally(() => {
                sendCodeBtn.disabled = false;
            });
    });
}

// 인증번호 확인
const authConfirmBtn = document.querySelector("#authConfirmBtn");

if(authConfirmBtn){
    authConfirmBtn.addEventListener("click", function(){
        const email = emailInput.value.trim();
        const authCode = emailAuthCode.value.trim(); // 사용자가 입력한 6자리 번호

        if (emailRemainingSeconds <= 0) {
            setEmailAuthMessage("인증 시간이 만료되었습니다. 다시 인증해주세요.", true);
            return;
        }

        if(!/^\d{6}$/.test(authCode)) {
            setEmailAuthMessage("인증번호 6자리를 입력해주세요.", true);
            return;
        }

        // 서버로 이메일과 인증번호를 함께 보내서 검증 요청
        fetch('/email/verify', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email: email, authCode: authCode })
        })
            .then(response => response.json())
            .then(result => {
                if(result.success) {
                    stopEmailAuthTimer();
                    emailAuthTimer.textContent = "완료";
                    elementDisabled();
                    isEmailVerified = true;
                    setEmailAuthMessage("이메일 인증이 완료되었습니다.");
                } else {
                    setEmailAuthMessage(result.message || "인증번호가 일치하지 않거나 만료되었습니다.", true);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                setEmailAuthMessage("인증번호 확인 중 오류가 발생했습니다.", true);
            });
    });
}

// 이메일 인증은 1회만 처리하고 다시 인증하지 않도록 처리
function elementDisabled(){
    // disabled 상태의 input은 회원가입 요청에 포함되지 않으므로 읽기 전용으로 처리
    emailInput.readOnly = true;
    emailAuthCode.disabled = true;
    authConfirmBtn.disabled = true;
    sendCodeBtn.disabled = true;
}

if (emailAuthCode) {
    emailAuthCode.addEventListener("input", function () {
        this.value = this.value.replace(/\D/g, "").slice(0, 6);
    });
}

if (loginForm && savedIdInput && rememberCheck) {
    // 1. 쿠키에 저장된 아이디가 있다면 가져와서 input에 넣고 체크박스 켜기
    const savedId = getCookie("savedId");
    if (savedId) {
        savedIdInput.value = savedId;
        rememberCheck.checked = true;
    }

    // 2. 로그인 폼을 제출할 때(로그인 버튼 누를 때) 처리
    loginForm.addEventListener("submit", function () {
        if (rememberCheck.checked) {
            // 체크되어 있으면 쿠키에 아이디 저장 (유효기간 7일 설정)
            setCookie("savedId", savedIdInput.value, 7);
        } else {
            // 체크 해제되어 있으면 쿠키 삭제
            deleteCookie("savedId");
        }
    });
}

// --- 쿠키 유틸리티 함수들 ---

// 쿠키 설정 함수 (이름, 값, 만료일수)
function setCookie(cookieName, value, exDays) {
    const exDate = new Date();
    exDate.setDate(exDate.getDate() + exDays);
    const cookieValue = encodeURIComponent(value) + (exDays == null ? "" : "; expires=" + exDate.toUTCString()) + "; path=/";
    document.cookie = cookieName + "=" + cookieValue;
}

// 쿠키 가져오는 함수
function getCookie(cookieName) {
    const cookies = document.cookie.split(';');
    for (let i = 0; i < cookies.length; i++) {
        let cookie = cookies[i].trim();
        if (cookie.indexOf(cookieName + "=") === 0) {
            return decodeURIComponent(cookie.substring(cookieName.length + 1, cookie.length));
        }
    }
    return "";
}

// 쿠키 삭제 함수 (만료일을 과거로 설정)
function deleteCookie(cookieName) {
    setCookie(cookieName, "", -1);
}

/* 계정찾기 이메일 인증: 회원가입과 동일한 이메일 API와 3분 제한을 사용합니다. */
const accountEmailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

function formatAccountAuthTime(seconds) {
    const minutes = String(Math.floor(seconds / 60)).padStart(2, "0");
    const remaining = String(seconds % 60).padStart(2, "0");
    return `${minutes}:${remaining}`;
}

document.querySelectorAll("[data-email-verification]").forEach((container) => {
    const accountEmailInput = container.querySelector("[data-email-input]");
    const accountUserIdInput = container.querySelector("[data-user-id]");
    const accountSendButton = container.querySelector("[data-send-code]");
    const accountAuthArea = container.querySelector("[data-auth-area]");
    const accountAuthCodeInput = container.querySelector("[data-auth-code]");
    const accountVerifyButton = container.querySelector("[data-verify-code]");
    const accountTimerElement = container.querySelector("[data-auth-timer]");
    const accountMessageElement = container.querySelector("[data-auth-message]");
    const accountForm = container.closest("form");
    const accountSendUrl = container.dataset.sendUrl || "/email/send";

    let accountTimerId = null;
    let accountRemainingSeconds = 0;
    let accountIsVerified = false;

    const setAccountMessage = (message, isError = false) => {
        accountMessageElement.textContent = message;
        accountMessageElement.className = isError
            ? "form-message mt-2 mb-0 is-visible is-error"
            : "form-message mt-2 mb-0 is-visible is-success";
    };

    const stopAccountTimer = () => {
        clearInterval(accountTimerId);
        accountTimerId = null;
    };

    const resetAccountVerification = () => {
        stopAccountTimer();
        accountRemainingSeconds = 0;
        accountIsVerified = false;
        accountAuthCodeInput.value = "";
        accountAuthCodeInput.disabled = true;
        accountVerifyButton.disabled = true;
        accountTimerElement.textContent = "03:00";
        accountTimerElement.classList.remove("is-expired");
        accountForm.querySelectorAll("[data-password-field]").forEach((field) => {
            field.disabled = true;
        });
    };

    const startAccountTimer = () => {
        stopAccountTimer();
        accountRemainingSeconds = 180;
        accountAuthCodeInput.value = "";
        accountAuthCodeInput.disabled = false;
        accountVerifyButton.disabled = false;
        accountTimerElement.textContent = formatAccountAuthTime(accountRemainingSeconds);
        accountTimerElement.classList.remove("is-expired");
        accountAuthCodeInput.focus();

        accountTimerId = setInterval(() => {
            accountRemainingSeconds -= 1;
            accountTimerElement.textContent = formatAccountAuthTime(Math.max(accountRemainingSeconds, 0));

            if (accountRemainingSeconds <= 0) {
                stopAccountTimer();
                accountTimerElement.textContent = "만료";
                accountTimerElement.classList.add("is-expired");
                accountAuthCodeInput.disabled = true;
                accountVerifyButton.disabled = true;
                setAccountMessage("인증 시간이 만료되었습니다. 다시 인증해주세요.", true);
            }
        }, 1000);
    };

    accountEmailInput.addEventListener("input", () => {
        if (accountTimerId || accountIsVerified) {
            resetAccountVerification();
            setAccountMessage("이메일이 변경되었습니다. 인증번호를 다시 발송해주세요.", true);
        }
    });

    if (accountUserIdInput) {
        accountUserIdInput.addEventListener("input", () => {
            if (accountTimerId || accountIsVerified) {
                resetAccountVerification();
                setAccountMessage("아이디가 변경되었습니다. 인증번호를 다시 발송해주세요.", true);
            }
        });
    }

    accountAuthCodeInput.addEventListener("input", () => {
        accountAuthCodeInput.value = accountAuthCodeInput.value.replace(/\D/g, "").slice(0, 6);
    });

    accountSendButton.addEventListener("click", async () => {
        const email = accountEmailInput.value.trim();
        if (!accountEmailRegex.test(email)) {
            setAccountMessage("올바른 이메일 형식을 입력해주세요.", true);
            return;
        }

        if (accountUserIdInput && !accountUserIdInput.value.trim()) {
            setAccountMessage("아이디를 입력해주세요.", true);
            return;
        }

        accountSendButton.disabled = true;
        try {
            const response = await fetch(accountSendUrl, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    email,
                    userId: accountUserIdInput ? accountUserIdInput.value.trim() : null
                })
            });
            const result = await response.json();
            if (!response.ok || !result.success) {
                throw new Error(result.message || "인증번호 발송에 실패했습니다.");
            }

            accountAuthArea.classList.add("is-visible");
            setAccountMessage(`${result.message} 3분 안에 인증번호를 입력해주세요.`);
            startAccountTimer();
        } catch (error) {
            setAccountMessage(error.message || "인증번호 발송 중 오류가 발생했습니다.", true);
        } finally {
            accountSendButton.disabled = false;
        }
    });

    accountVerifyButton.addEventListener("click", async () => {
        const email = accountEmailInput.value.trim();
        const authCode = accountAuthCodeInput.value.trim();
        if (accountRemainingSeconds <= 0) {
            setAccountMessage("인증 시간이 만료되었습니다. 다시 인증해주세요.", true);
            return;
        }
        if (!/^\d{6}$/.test(authCode)) {
            setAccountMessage("인증번호 6자리를 입력해주세요.", true);
            return;
        }

        accountVerifyButton.disabled = true;
        try {
            const response = await fetch("/email/verify", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ email, authCode })
            });
            const result = await response.json();
            if (!response.ok || !result.success) {
                throw new Error(result.message || "인증번호가 일치하지 않거나 만료되었습니다.");
            }

            stopAccountTimer();
            accountIsVerified = true;
            accountTimerElement.textContent = "완료";
            accountAuthCodeInput.disabled = true;
            accountEmailInput.disabled = true;
            accountSendButton.disabled = true;
            setAccountMessage("이메일 인증이 완료되었습니다.");
            accountForm.querySelectorAll("[data-password-field]").forEach((field) => {
                field.disabled = false;
            });
        } catch (error) {
            accountVerifyButton.disabled = false;
            setAccountMessage(error.message || "인증번호 확인 중 오류가 발생했습니다.", true);
        }
    });
});

/* 아이디 찾기: 가입 이메일을 조회한 뒤, 아이디를 해당 이메일로 발송합니다. */
const findIdForm = document.querySelector("#forgot-id");
const findIdEmailInput = document.querySelector("#find-id-email");
const findIdMessage = document.querySelector("#findIdMessage");

if (findIdForm && findIdEmailInput && findIdMessage) {
    findIdForm.addEventListener("submit", async (event) => {
        event.preventDefault();

        const email = findIdEmailInput.value.trim();
        if (!accountEmailRegex.test(email)) {
            findIdMessage.textContent = "올바른 이메일 형식을 입력해주세요.";
            findIdMessage.className = "form-message mt-2 mb-0 is-visible is-error";
            return;
        }

        const submitButton = findIdForm.querySelector("button[type='submit']");
        submitButton.disabled = true;

        try {
            const response = await fetch("/email/find-id", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ email })
            });
            const result = await response.json();

            findIdMessage.textContent = result.message;
            findIdMessage.className = result.success
                ? "form-message mt-2 mb-0 is-visible is-success"
                : "form-message mt-2 mb-0 is-visible is-error";
        } catch (error) {
            findIdMessage.textContent = "아이디 찾기 요청 중 오류가 발생했습니다.";
            findIdMessage.className = "form-message mt-2 mb-0 is-visible is-error";
        } finally {
            submitButton.disabled = false;
        }
    });
}

/* 비밀번호 찾기: 인증번호 확인에 성공한 이메일만 같은 세션에서 비밀번호를 변경할 수 있습니다. */
const resetPasswordBtn = document.querySelector("#resetPasswordBtn");
const resetPasswordMessage = document.querySelector("#resetPasswordMessage");
const resetPasswordEmailInput = document.querySelector("#find-password-email");

if (resetPasswordBtn && resetPasswordMessage && resetPasswordEmailInput && pwInput && pwConfirmInput) {
    resetPasswordBtn.addEventListener("click", async () => {
        const newPassword = pwInput.value;
        const confirmPassword = pwConfirmInput.value;

        if (!passwordRegex.test(newPassword)) {
            resetPasswordMessage.textContent = "비밀번호는 영문, 숫자, 특수문자를 포함해 8자 이상이어야 합니다.";
            resetPasswordMessage.className = "form-message mt-2 mb-0 is-visible is-error";
            return;
        }
        if (newPassword !== confirmPassword) {
            resetPasswordMessage.textContent = "새 비밀번호가 일치하지 않습니다.";
            resetPasswordMessage.className = "form-message mt-2 mb-0 is-visible is-error";
            return;
        }

        resetPasswordBtn.disabled = true;
        try {
            const response = await fetch("/member/reset-password", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    email: resetPasswordEmailInput.value.trim(),
                    newPassword
                })
            });
            const result = await response.json();
            resetPasswordMessage.textContent = result.message;
            resetPasswordMessage.className = result.success
                ? "form-message mt-2 mb-0 is-visible is-success"
                : "form-message mt-2 mb-0 is-visible is-error";

            if (result.success) {
                window.setTimeout(() => {
                    window.location.href = "/member/login";
                }, 1500);
            } else {
                resetPasswordBtn.disabled = false;
            }
        } catch (error) {
            resetPasswordMessage.textContent = "비밀번호 변경 중 오류가 발생했습니다.";
            resetPasswordMessage.className = "form-message mt-2 mb-0 is-visible is-error";
            resetPasswordBtn.disabled = false;
        }
    });
}
