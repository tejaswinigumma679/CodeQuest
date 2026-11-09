
(function () {

    // First use the theme supplied by the logged-in student's session.
    // Otherwise, use the previously saved browser preference.
    const serverTheme = document.documentElement.getAttribute("data-theme");

    const savedTheme = serverTheme ||
        localStorage.getItem("codequest-theme") ||
        "dark";

    function applyTheme(theme) {

        if (theme !== "dark" && theme !== "light") {
            theme = "dark";
        }

        document.documentElement.setAttribute("data-theme", theme);

        localStorage.setItem("codequest-theme", theme);

        updateButton();
    }

    function updateButton() {

        const button = document.getElementById("themeToggle");

        if (!button) return;

        const currentTheme =
            document.documentElement.getAttribute("data-theme");

        button.textContent =
            currentTheme === "dark" ? "☀️ Light Mode" : "🌙 Dark Mode";
    }

    // Make theme functions available to the Settings page.
    window.applyCodeQuestTheme = applyTheme;

    window.toggleTheme = function () {

        const currentTheme =
            document.documentElement.getAttribute("data-theme");

        const newTheme =
            currentTheme === "dark" ? "light" : "dark";

        applyTheme(newTheme);
    };

    // Apply theme when the page loads.
    applyTheme(savedTheme);

    document.addEventListener("DOMContentLoaded", updateButton);

})();