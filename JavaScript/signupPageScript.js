const password = document.getElementById('password');
const repeatPassword = document.getElementById('repeatpassword');
const passwordError = document.getElementById('password-error');

function validatePassword() {
    if (password.value !== repeatPassword.value) {
        passwordError.innerHTML = 'Passwords do not match';
    } else {
        passwordError.innerHTML = '';
    }
}

repeatPassword.addEventListener('input', validatePassword);
