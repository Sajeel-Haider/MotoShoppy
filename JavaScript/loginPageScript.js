function togglePasswordVisibility() {
    const passwordField = document.getElementById('password');
    const showHideBtn = document.querySelector('.show-hide-btn');
    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        showHideBtn.textContent = 'Hide';
    } else {
        passwordField.type = 'password';
        showHideBtn.textContent = 'Show';
    }
}
