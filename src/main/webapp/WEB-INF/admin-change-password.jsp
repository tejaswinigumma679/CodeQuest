<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         session="true" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    String theme = "light".equals(session.getAttribute("adminTheme"))
            ? "light" : "dark";

    String error = request.getParameter("error");
    String message = null;

    if ("empty".equals(error)) {
        message = "Please fill in all password fields.";
    } else if ("length".equals(error)) {
        message = "New password must contain at least 8 characters.";
    } else if ("mismatch".equals(error)) {
        message = "New password and confirmation do not match.";
    } else if ("current".equals(error)) {
        message = "Your current password is incorrect.";
    } else if ("failed".equals(error)) {
        message = "Password change failed. Please try again.";
    }
%>

<!DOCTYPE html>
<html lang="en" data-theme="<%= theme %>">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Change Password | CodeQuest</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/theme.css">

    <script defer
            src="<%= request.getContextPath() %>/js/theme.js"></script>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: Arial, sans-serif;
            background: var(--bg);
            color: var(--text);
        }

        .navbar {
            padding: 20px 7%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border);
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            color: var(--accent);
        }

        .back-link {
            color: white;
            text-decoration: none;
            background: #7c3aed;
            padding: 11px 18px;
            border-radius: 8px;
            font-weight: bold;
            transition: 0.2s;
        }

        .back-link:hover {
            background: #6d28d9;
            transform: translateY(-2px);
        }

        .container {
            max-width: 550px;
            margin: 55px auto;
            padding: 20px;
        }

        .form-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 18px;
            padding: 35px;
        }

        .icon {
            font-size: 42px;
            margin-bottom: 15px;
        }

        h1 {
            margin-top: 0;
        }

        .subtitle {
            color: var(--muted);
            margin-bottom: 28px;
            line-height: 1.6;
        }

        label {
            display: block;
            color: var(--accent);
            font-weight: bold;
            margin: 18px 0 8px;
        }

        input {
            width: 100%;
            padding: 14px;
            border: 1px solid var(--border);
            border-radius: 9px;
            background: var(--input-bg);
            color: var(--text);
            font-size: 15px;
        }

        input:focus {
            outline: 2px solid var(--accent);
        }

        .message {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 8px;
            background: rgba(239, 68, 68, 0.12);
            color: #ef4444;
            border: 1px solid rgba(239, 68, 68, 0.3);
        }

        .validation-message {
            color: #ef4444;
            font-weight: bold;
            margin-top: 15px;
            display: none;
        }

        .submit-button {
            width: 100%;
            margin-top: 25px;
            padding: 14px;
            border: none;
            border-radius: 9px;
            background: var(--accent);
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s;
        }

        .submit-button:hover {
            background: var(--accent-hover);
        }

        @media(max-width: 600px) {
            .container {
                margin: 25px auto;
            }

            .form-card {
                padding: 23px;
            }

            .navbar {
                padding: 18px 5%;
            }
        }
    </style>
</head>

<body>

    <div class="navbar">
        <div class="logo">⚡ CodeQuest</div>

        <a class="back-link"
           href="<%= request.getContextPath() %>/admin/dashboard">
            ← Back to Dashboard
        </a>
    </div>

    <div class="container">

        <div class="form-card">

            <div class="icon">🔐</div>

            <h1>Change Password</h1>

            <p class="subtitle">
                Update your password to keep your CodeQuest administrator
                account secure.
            </p>

            <% if (message != null) { %>
                <div class="message">
                    <%= message %>
                </div>
            <% } %>

            <form method="post"
                  action="<%= request.getContextPath() %>/admin/change-password"
                  id="passwordForm"
                  onsubmit="return validatePasswords()">

                <label for="currentPassword">Current Password</label>

                <input type="password"
                       id="currentPassword"
                       name="currentPassword"
                       autocomplete="current-password"
                       required>

                <label for="newPassword">New Password</label>

                <input type="password"
                       id="newPassword"
                       name="newPassword"
                       minlength="8"
                       autocomplete="new-password"
                       required>

                <label for="confirmPassword">Confirm New Password</label>

                <input type="password"
                       id="confirmPassword"
                       name="confirmPassword"
                       minlength="8"
                       autocomplete="new-password"
                       required>

                <p id="validationMessage"
                   class="validation-message"></p>

                <button type="submit" class="submit-button">
                    🔒 Update Password
                </button>

            </form>

        </div>
    </div>

    <script>
        function validatePasswords() {

            const current =
                document.getElementById("currentPassword").value;

            const newPassword =
                document.getElementById("newPassword").value;

            const confirmPassword =
                document.getElementById("confirmPassword").value;

            const message =
                document.getElementById("validationMessage");

            message.style.display = "none";

            if (!current || !newPassword || !confirmPassword) {
                message.textContent =
                    "Please fill in all password fields.";
                message.style.display = "block";
                return false;
            }

            if (newPassword.length < 8) {
                message.textContent =
                    "New password must contain at least 8 characters.";
                message.style.display = "block";
                return false;
            }

            if (newPassword !== confirmPassword) {
                message.textContent =
                    "New password and confirmation do not match.";
                message.style.display = "block";
                return false;
            }

            return true;
        }
    </script>

</body>
</html>