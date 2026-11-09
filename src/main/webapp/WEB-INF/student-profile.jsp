<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         session="true" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp");
        return;
    }

    Integer studentId = (Integer) request.getAttribute("studentId");
    String username = (String) request.getAttribute("username");
    String email = (String) request.getAttribute("email");
    java.sql.Timestamp createdAt =
        (java.sql.Timestamp) request.getAttribute("createdAt");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Profile | CodeQuest</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/theme.css">

    <script src="<%= request.getContextPath() %>/js/theme.js"></script>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
		    margin: 0;
		    padding: 0 20px 35px;
		    font-family: Arial, sans-serif;
		    background: #0f172a;
		    color: #f8fafc;
		}

		.navbar {
		    padding: 20px 7%;
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    border-bottom: 1px solid #334155;
		}
		
		.logo {
		    font-size: 24px;
		    font-weight: bold;
		    color: #a78bfa;
		}

        .profile-container {
            max-width: 750px;
            margin: 35px auto;
        }

        .profile-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .profile-header h1 {
            color: #a78bfa;
            margin-bottom: 10px;
        }

        .profile-card {
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 18px;
            padding: 35px;
        }

        .avatar {
            width: 85px;
            height: 85px;
            margin: 0 auto 20px;
            border-radius: 50%;
            background: linear-gradient(135deg, #7c3aed, #4f46e5);
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 38px;
        }

        .profile-name {
            text-align: center;
            font-size: 25px;
            margin-bottom: 30px;
        }

        .detail {
            padding: 17px 5px;
            border-bottom: 1px solid #334155;
        }

        .detail-label {
            display: block;
            color: #a78bfa;
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 8px;
        }

        .detail-value {
            color: #f8fafc;
            font-size: 16px;
            overflow-wrap: anywhere;
        }

        .actions {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            display: inline-block;
            padding: 13px 22px;
            border-radius: 9px;
            text-decoration: none;
            font-weight: bold;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }

        .edit-btn {
            color: white;
            background: linear-gradient(90deg, #7c3aed, #4f46e5);
        }

        .btn:hover {
            opacity: 0.85;
        }

        .profile-topbar {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 20px;
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
        @media(max-width: 500px) {
            .profile-card {
                padding: 22px;
            }
        }
    </style>
</head>

<body>

<div class="navbar">
    <div class="logo">⚡ CodeQuest</div>

	    <a href="<%= request.getContextPath() %>/dashboard"
	           class="dashboard-btn">
	            ← Back to Dashboard
        </a>
</div>

<div class="profile-container">

    <div class="profile-header">
        <h1>⚡ Student Profile</h1>
        <p>View and manage your student information.</p>
    </div>

    <div class="profile-card">

        <div class="avatar">👤</div>

        <h2 class="profile-name">
            <%= username %>
        </h2>

        <div class="detail">
            <span class="detail-label">Student ID</span>
            <span class="detail-value"><%= studentId %></span>
        </div>

        <div class="detail">
            <span class="detail-label">Username</span>
            <span class="detail-value"><%= username %></span>
        </div>

        <div class="detail">
            <span class="detail-label">Email Address</span>
            <span class="detail-value">
                <%= email == null ? "Not provided" : email %>
            </span>
        </div>

        <div class="detail">
            <span class="detail-label">Account Created</span>
            <span class="detail-value">
                <%= createdAt == null ? "Not available" : createdAt %>
            </span>
        </div>

        <div class="actions">
            <a href="<%= request.getContextPath() %>/student/edit-profile"
               class="btn edit-btn">
                ✏️ Edit Profile
            </a>
        </div>

    </div>
</div>

</body>
</html>