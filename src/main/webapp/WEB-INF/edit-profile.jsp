
<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         session="true" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String username = (String) request.getAttribute("username");
    String email = (String) request.getAttribute("email");
    String message = (String) request.getAttribute("message");

    String theme = (String) session.getAttribute("theme");

    if (!"light".equals(theme)) {
        theme = "dark";
    }
%>

<!DOCTYPE html>
<html lang="en"
      data-theme="<%= theme %>">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Edit Student Profile | CodeQuest</title>

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
		    color: #a78bfa;
		}

        .page-container {
            max-width: 650px;
            margin: 45px auto;
            padding: 20px;
        }

        .topbar {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 25px;
        }

        .dashboard-btn {
		    display: inline-block;
		    padding: 11px 18px;
		    background: #7c3aed;
		    color: #ffffff;
		    text-decoration: none;
		    border-radius: 8px;
		    font-size: 14px;
		    font-weight: bold;
		    transition: 0.2s;
		}
		
		.dashboard-btn:hover {
		    background: #6d28d9;
		    transform: translateY(-2px);
		}

        .edit-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 35px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.12);
        }

        h1 {
            margin-top: 0;
            margin-bottom: 10px;
        }

        .description {
            color: var(--muted);
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 22px;
        }

        label {
            display: block;
            margin-bottom: 9px;
            font-weight: 600;
        }

        input {
            width: 100%;
            padding: 13px;
            border: 1px solid var(--border);
            border-radius: 8px;
            background: var(--bg);
            color: var(--text);
            font-size: 15px;
        }

        input:focus {
            outline: 2px solid #8b5cf6;
            border-color: #8b5cf6;
        }

        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 30px;
        }

        .save-btn {
            padding: 12px 22px;
            background: #6d28d9;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
        }

        .save-btn:hover {
            background: #5b21b6;
        }

        .cancel-btn {
            padding: 12px 22px;
            background: var(--surface);
            color: var(--text);
            border: 1px solid var(--border);
            border-radius: 8px;
            text-decoration: none;
            font-size: 15px;
        }

        .error-message {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 8px;
            background: rgba(239, 68, 68, 0.12);
            color: #ef4444;
        }

        @media (max-width: 600px) {
            .edit-card {
                padding: 22px;
            }
        }
    </style>
</head>

<body>

<div class="navbar">
    <div class="logo">⚡ CodeQuest</div>
	    <a href="<%= request.getContextPath() %>/student/profile"
	           class="dashboard-btn">
	            ← Back to Profile
        </a>
</div>

<div class="page-container">

    <div class="edit-card">

        <h1>✏️ Edit Profile</h1>

        <p class="description">
            Update your student account information.
        </p>

        <% if (message != null) { %>

            <div class="error-message">
                <%= message %>
            </div>

        <% } %>

        <form action="<%= request.getContextPath() %>/student/edit-profile"
              method="post">

            <div class="form-group">

                <label for="username">Student Username</label>

                <input type="text"
                       id="username"
                       name="username"
                       value="<%= username == null ? "" : username %>"
                       maxlength="50"
                       required>

            </div>

            <div class="form-group">

                <label for="email">Email Address</label>

                <input type="email"
                       id="email"
                       name="email"
                       value="<%= email == null ? "" : email %>"
                       maxlength="100"
                       required>

            </div>

            <div class="button-group">

                <button type="submit" class="save-btn">
                    Save Changes
                </button>

                <a href="<%= request.getContextPath() %>/student/profile"
                   class="cancel-btn">
                    Cancel
                </a>

            </div>

        </form>

    </div>

</div>

</body>
</html>