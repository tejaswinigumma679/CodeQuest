
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>CodeQuest | Student Registration</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/theme.css">

    <script src="<%= request.getContextPath() %>/js/theme.js"></script>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 35px 20px;
            font-family: Arial, sans-serif;
            background:
                radial-gradient(circle at top left, #312e81, transparent 40%),
                radial-gradient(circle at bottom right, #581c87, transparent 40%),
                var(--bg) !important;
        }

        .theme-toggle {
            position: fixed;
            top: 22px;
            right: 25px;
            width: auto !important;
            z-index: 10;
        }

        .auth-container {
            width: 100%;
            max-width: 460px;
        }

        .brand {
            text-align: center;
            margin-bottom: 25px;
        }

        .brand h1 {
            color: var(--text);
            font-size: 34px;
            margin-bottom: 8px;
        }

        .brand h1 span {
            color: var(--accent);
        }

        .brand p {
            color: var(--muted);
            font-size: 14px;
        }

        .auth-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 18px;
            padding: 35px;
            box-shadow: 0 15px 45px rgba(0,0,0,0.25);
        }

        .auth-icon {
            width: 70px;
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 18px;
            border-radius: 18px;
            background: rgba(139,92,246,0.15);
            font-size: 34px;
        }

        .auth-card h2 {
            text-align: center;
            color: var(--text);
            font-size: 27px;
            margin-bottom: 10px;
        }

        .description {
            text-align: center;
            color: var(--muted);
            font-size: 14px;
            margin-bottom: 25px;
            line-height: 1.6;
        }

        .form-group {
            margin-bottom: 17px;
        }

        .form-group label {
            display: block;
            color: var(--text);
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .form-group input {
            width: 100%;
            padding: 13px;
            border-radius: 9px;
            border: 1px solid var(--border);
            background: var(--input-bg);
            color: var(--text);
            font-size: 15px;
            outline: none;
        }

        .form-group input:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(139,92,246,0.15);
        }

        .form-group input::placeholder {
            color: var(--muted);
        }

        .submit-btn {
            width: 100%;
            padding: 14px;
            margin-top: 8px;
            border: none;
            border-radius: 9px;
            background: var(--accent);
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s;
        }

        .submit-btn:hover {
            background: var(--accent-hover);
            transform: translateY(-2px);
        }

        .message, .success {
            padding: 11px;
            border-radius: 8px;
            margin-bottom: 18px;
            text-align: center;
            font-size: 14px;
        }

        .message {
            background: rgba(239,68,68,0.12);
            color: #ef4444;
            border: 1px solid rgba(239,68,68,0.3);
        }

        .success {
            background: rgba(34,197,94,0.12);
            color: #16a34a;
            border: 1px solid rgba(34,197,94,0.3);
        }

        .links {
            text-align: center;
            margin-top: 23px;
        }

        .links p {
            color: var(--muted);
            font-size: 14px;
        }

        .links a {
            color: var(--accent);
            text-decoration: none;
            font-weight: 600;
        }

        .links a:hover {
            text-decoration: underline;
        }

        .security-note {
            text-align: center;
            color: var(--muted);
            font-size: 12px;
            margin-top: 24px;
        }

        @media(max-width: 480px) {
            .auth-card {
                padding: 28px 22px;
            }

            .brand h1 {
                font-size: 29px;
            }

            .theme-toggle {
                top: 12px;
                right: 12px;
            }
        }
    </style>
</head>

<body>

<button type="button"
        class="theme-toggle"
        id="themeToggle"
        onclick="toggleTheme()">
    ☀️ Light Mode
</button>

<div class="auth-container">

    <div class="brand">
        <h1>⚡ Code<span>Quest</span></h1>
        <p>Learn. Code. Conquer.</p>
    </div>

    <div class="auth-card">

        <div class="auth-icon">🚀</div>

        <h2>Join CodeQuest</h2>

        <p class="description">
            Create your student account and begin your
            programming adventure. Solve missions, earn XP
            and level up your skills!
        </p>

        <% if (request.getAttribute("message") != null) { %>

            <p class="<%= Boolean.TRUE.equals(
                    request.getAttribute("success"))
                    ? "success" : "message" %>">
                <%= request.getAttribute("message") %>
            </p>

        <% } %>

        <form action="<%= request.getContextPath() %>/register"
              method="post">

            <div class="form-group">
                <label for="username">Username</label>

                <input type="text"
                       id="username"
                       name="username"
                       maxlength="50"
                       placeholder="Choose a username"
                       autocomplete="username"
                       required>
            </div>

            <div class="form-group">
                <label for="email">Email Address</label>

                <input type="email"
                       id="email"
                       name="email"
                       maxlength="100"
                       placeholder="Enter your email address"
                       autocomplete="email"
                       required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>

                <input type="password"
                       id="password"
                       name="password"
                       minlength="8"
                       placeholder="Create a password"
                       autocomplete="new-password"
                       required>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>

                <input type="password"
                       id="confirmPassword"
                       name="confirmPassword"
                       minlength="8"
                       placeholder="Re-enter your password"
                       autocomplete="new-password"
                       required>
            </div>

            <button type="submit" class="submit-btn">
                Create My Account
            </button>

        </form>

        <div class="links">
            <p>
                Already registered?
                <a href="<%= request.getContextPath() %>/login.jsp">
                    Login here
                </a>
            </p>
        </div>

    </div>

    <p class="security-note">
        🔒 Your coding journey starts here!
    </p>

</div>

</body>
</html>