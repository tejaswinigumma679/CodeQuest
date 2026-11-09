
<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         session="true" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    String theme = (String) session.getAttribute("adminTheme");

    if (!"light".equals(theme)) {
        theme = "dark";
    }

    String updated = request.getParameter("updated");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en"
      data-theme="<%= theme %>">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>CodeQuest | Admin Settings</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/theme.css">

    <script src="<%= request.getContextPath() %>/js/theme.js"></script>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            padding: 35px 20px;
            font-family: 'Segoe UI', Arial, sans-serif;
            background: var(--bg) !important;
            color: var(--text) !important;
        }
        
       .navbar {
		    padding: 20px 7%;
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    border-bottom: 1px solid var(--border);
		    margin: -35px -20px 30px;
		}
		
		.logo {
		    font-size: 24px;
		    font-weight: bold;
		    color: #a78bfa;
		}
		
		.dashboard-btn {
		    display: inline-block;
		    padding: 14px 22px;
		    background: #7c3aed;
		    color: #ffffff;
		    text-decoration: none;
		    border-radius: 10px;
		    font-size: 18px;
		    font-weight: bold;
		    transition: 0.2s;
		}
		
		.dashboard-btn:hover {
		    background: #6d28d9;
		    transform: translateY(-2px);
		}

        .container {
            max-width: 850px;
            margin: auto;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }

        .brand {
            color: #a78bfa;
            font-size: 25px;
            font-weight: 800;
        }

        .back-link {
            color: #a78bfa;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
        }

        .back-link:hover {
            color: #8b5cf6;
        }

        .heading {
            margin-bottom: 25px;
        }

        .heading h1 {
            font-size: 30px;
            margin-bottom: 8px;
        }

        .heading p {
            color: var(--muted);
            font-size: 14px;
        }

        .settings-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 17px;
            padding: 28px;
            margin-bottom: 20px;
        }

        .settings-card h2 {
            font-size: 19px;
            margin-top: 0;
        }

        .settings-card > p {
            color: var(--muted);
            font-size: 13px;
            line-height: 1.6;
        }

        .theme-options {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 18px;
            margin-top: 22px;
        }

        .theme-option {
            display: block;
            position: relative;
            cursor: pointer;
        }

        .theme-option input {
            position: absolute;
            opacity: 0;
        }

        .theme-preview {
            border: 2px solid var(--border);
            border-radius: 13px;
            padding: 18px;
            transition: .2s;
        }

        .theme-option input:checked + .theme-preview {
            border-color: #8b5cf6;
            box-shadow: 0 0 0 3px #8b5cf633;
        }

        .theme-preview:hover {
            border-color: #8b5cf6;
        }

        .theme-option input:focus-visible + .theme-preview {
            outline: 2px solid #8b5cf6;
            outline-offset: 3px;
        }

        .dark-preview {
            background: #101226;
            color: white;
        }

        .light-preview {
            background: #f1f5f9;
            color: #0f172a;
        }

        .preview-window {
            height: 65px;
            border-radius: 8px;
            margin: 14px 0;
            padding: 10px;
            display: flex;
            gap: 8px;
        }

        .dark-preview .preview-window {
            background: #252947;
        }

        .light-preview .preview-window {
            background: white;
        }

        .preview-sidebar {
            width: 25%;
            border-radius: 5px;
            background: #8b5cf6;
        }

        .preview-content {
            flex: 1;
            border-radius: 5px;
            background: #8b5cf644;
        }

        .theme-name {
            font-size: 15px;
            font-weight: bold;
        }

        .theme-description {
            font-size: 11px;
            opacity: .75;
            margin-top: 5px;
        }

        .save-btn {
            background: linear-gradient(90deg, #6d3be8, #9333ea);
            color: white;
            border: none;
            border-radius: 9px;
            padding: 13px 25px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 22px;
        }

        .save-btn:hover {
            opacity: .9;
        }

        .message {
            padding: 12px;
            border-radius: 8px;
            background: #14532d;
            color: #bbf7d0;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .error {
            background: #7f1d1d;
            color: #fecaca;
        }

        @media (max-width: 550px) {
            .theme-options {
                grid-template-columns: 1fr;
            }

            .settings-card {
                padding: 20px;
            }
        }
    </style>
</head>

<body>

<div class="container">

    <div class="navbar">
	    <div class="logo">⚡ CodeQuest</div>
	
	    <a href="<%= request.getContextPath() %>/admin/dashboard"
	       class="dashboard-btn">
	        ← Back to Dashboard
	    </a>
	</div>

    <section class="heading">

        <h1>⚙️ Admin Settings</h1>

        <p>Customize your CodeQuest administrator experience.</p>

    </section>

    <% if ("success".equals(updated)) { %>

        <div class="message">
            ✓ Your theme preference has been saved successfully!
        </div>

    <% } %>

    <% if ("invalid".equals(error) || "failed".equals(error)) { %>

        <div class="message error">
            Unable to save your theme preference. Please try again.
        </div>

    <% } %>

    <form action="<%= request.getContextPath() %>/admin/settings"
          method="post">

        <section class="settings-card">

            <h2>🎨 Appearance</h2>

            <p>
                Choose how your CodeQuest admin dashboard looks.
                Your selection will be saved to your administrator account
                and applied across admin pages.
            </p>

            <div class="theme-options">

                <label class="theme-option">

                    <input type="radio"
                           name="theme"
                           value="dark"
                           <%= "dark".equals(theme) ? "checked" : "" %>>

                    <div class="theme-preview dark-preview">

                        <div class="theme-name">🌙 Dark Mode</div>

                        <div class="preview-window">
                            <div class="preview-sidebar"></div>
                            <div class="preview-content"></div>
                        </div>

                        <div class="theme-description">
                            A comfortable dark appearance.
                        </div>

                    </div>

                </label>

                <label class="theme-option">

                    <input type="radio"
                           name="theme"
                           value="light"
                           <%= "light".equals(theme) ? "checked" : "" %>>

                    <div class="theme-preview light-preview">

                        <div class="theme-name">☀️ Light Mode</div>

                        <div class="preview-window">
                            <div class="preview-sidebar"></div>
                            <div class="preview-content"></div>
                        </div>

                        <div class="theme-description">
                            A clean and bright appearance.
                        </div>

                    </div>

                </label>

            </div>

            <button type="submit" class="save-btn">
                Save Preferences
            </button>

        </section>

    </form>

</div>

</body>
</html>