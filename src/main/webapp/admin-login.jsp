
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>CodeQuest | Admin Login</title>

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
            padding: 30px 20px;
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

        .login-container {
            width: 100%;
            max-width: 430px;
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

        .login-box {
            width: 100%;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 18px;
            padding: 38px 35px;
            box-shadow: 0 15px 45px rgba(0, 0, 0, 0.25);
        }

        .admin-icon {
            width: 70px;
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            border-radius: 18px;
            background: rgba(139, 92, 246, 0.15);
            font-size: 34px;
        }

        .login-box h2 {
            text-align: center;
            color: var(--text);
            font-size: 27px;
            margin-bottom: 10px;
        }

        .description {
            text-align: center;
            color: var(--muted);
            font-size: 14px;
            margin-bottom: 28px;
            line-height: 1.6;
        }

        .form-group {
            margin-bottom: 19px;
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
            padding: 14px;
            border-radius: 9px;
            border: 1px solid var(--border);
            background: var(--input-bg);
            color: var(--text);
            font-size: 15px;
            outline: none;
        }

        .form-group input:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.15);
        }

        .form-group input::placeholder {
            color: var(--muted);
        }

        .login-btn {
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

        .login-btn:hover {
            background: var(--accent-hover);
            transform: translateY(-2px);
        }

        .message {
            background: rgba(239, 68, 68, 0.12);
            color: #ef4444;
            border: 1px solid rgba(239, 68, 68, 0.3);
            padding: 11px;
            border-radius: 8px;
            margin-bottom: 18px;
            text-align: center;
            font-size: 14px;
        }

        .back-link {
		    text-align: center;
		    margin-top: 25px;
		    color: var(--text);
		    font-size: 15px;
		}
		
		.back-link a {
		    color: var(--accent);
		    text-decoration: none;
		    font-weight: 600;
		}
		
		.back-link a:hover {
		    text-decoration: underline;
		}
		
        .security-note {
            text-align: center;
            color: var(--muted);
            font-size: 12px;
            margin-top: 24px;
        }

        @media (max-width: 480px) {
            .login-box {
                padding: 30px 22px;
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

    <!-- Theme Toggle -->
    <button type="button"
            class="theme-toggle"
            id="themeToggle"
            onclick="toggleTheme()">
        ☀️ Light Mode
    </button>

    <div class="login-container">

        <!-- Branding -->
        <div class="brand">
            <h1>⚡ Code<span>Quest</span></h1>
            <p>Learn. Code. Conquer.</p>
        </div>

        <!-- Login Card -->
        <div class="login-box">

            <div class="admin-icon">🛡️</div>

            <h2>Admin Login</h2>

            <p class="description">
                Welcome back, Administrator!
                Sign in to manage programming missions
                and student activities.
            </p>

            <%
                String message =
                    (String) request.getAttribute("message");

                if (message != null) {
            %>

                <p class="message"><%= message %></p>

            <% } %>

            <form action="<%= request.getContextPath() %>/admin-login"
                  method="post">

                <div class="form-group">
                    <label for="username">Username or Email</label>

                    <input type="text"
                           id="username"
                           name="username"
                           placeholder="Enter your username or email"
                           autocomplete="username"
                           required>
                </div>

                <div class="form-group">
                    <label for="password">Admin Password</label>

                    <input type="password"
                           id="password"
                           name="password"
                           placeholder="Enter your password"
                           autocomplete="current-password"
                           required>
                </div>

                <button type="submit" class="login-btn">
                    Sign In to Admin Dashboard
                </button>

            </form>
            
            <div class="back-link">
			    <p>
			        Are you a student?
			        <a href="<%= request.getContextPath() %>/login.jsp">
			            Student Login
			        </a>
			    </p>
			</div>

        </div>

        <p class="security-note">
            🔒 Secure Administrator Access | CodeQuest
        </p>

    </div>

</body>
</html>