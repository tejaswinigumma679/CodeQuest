
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, java.util.Map" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }

    ArrayList<Map<String, Object>> students =
        (ArrayList<Map<String, Object>>) request.getAttribute("students");

    if (students == null) {
        students = new ArrayList<>();
    }

    String search = (String) request.getAttribute("search");
    if (search == null) {
        search = "";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Student Management - CodeQuest</title>

    <link rel="stylesheet"
        href="<%= request.getContextPath() %>/css/theme.css">

    <script
        src="<%= request.getContextPath() %>/js/theme.js"></script>

    <style>
    	.navbar {
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    padding: 20px 7%;
		    margin-bottom: 30px;
		    border-bottom: 1px solid var(--border);
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

        .students-container {
            max-width: 1250px;
            margin: 40px auto;
            padding: 20px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .page-header h1 {
            color: var(--accent);
        }

        .students-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 25px;
            overflow-x: auto;
        }

        .search-form {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .search-form input {
            flex: 1;
            min-width: 0;
            padding: 12px;
            border-radius: 8px;
        }

        .search-form button {
            padding: 12px 20px;
            background: var(--accent);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 950px;
        }

        th, td {
            padding: 14px 12px;
            text-align: center;
            border-bottom: 1px solid var(--border);
        }

        th {
            color: var(--accent);
            white-space: nowrap;
        }

        td {
            color: var(--text);
        }

        .xp {
            color: #16a34a;
            font-weight: bold;
        }

        .empty-message {
            text-align: center;
            padding: 30px;
            color: var(--muted);
        }

        .back-button {
            display: inline-block;
            margin-top: 25px;
            padding: 11px 20px;
            background: var(--accent);
            color: white;
            text-decoration: none;
            border-radius: 8px;
        }

        @media(max-width: 600px) {
            .students-container {
                padding: 12px;
            }

            .students-card {
                padding: 15px;
            }
        }
    </style>
</head>

<body>

<div class="navbar">
    <div class="logo">⚡ CodeQuest</div>

    <a href="<%= request.getContextPath() %>/admin/dashboard"
       class="dashboard-btn">
        ← Back to Dashboard
    </a>
</div>

<div class="students-container">

    <div class="page-header">
        <h1>👨‍🎓 Student Management</h1>
        <p>View and manage registered CodeQuest students.</p>
    </div>

	<%
	    String deleted = request.getParameter("deleted");
	    String error = request.getParameter("error");
	%>
	
	<% if ("success".equals(deleted)) { %>
	    <p style="color: #16a34a; text-align: center; font-weight: bold;">
	        Student account deleted successfully!
	    </p>
	<% } %>
	
	<% if ("invalid".equals(error)) { %>
	    <p style="color: #ef4444; text-align: center;">
	        Invalid student ID.
	    </p>
	<% } else if ("notfound".equals(error)) { %>
	    <p style="color: #ef4444; text-align: center;">
	        Student account not found.
	    </p>
	<% } %>

    <div class="students-card">

        <form class="search-form"
              action="<%= request.getContextPath() %>/admin/students"
              method="get">

            <input type="text"
                   name="search"
                   placeholder="Search by username or email..."
                   value="<%= search %>">

            <button type="submit">Search</button>
        </form>

        <% if (students.isEmpty()) { %>

            <div class="empty-message">
                <h3>No students found.</h3>
                <p>Try another search or check registered student accounts.</p>
            </div>

        <% } else { %>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Total XP</th>
                        <th>Level</th>
                        <th>Missions Attempted</th>
                        <th>Correct Answers</th>
                        <th>Registered At</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>

                <% for (Map<String, Object> student : students) { %>

                    <tr>
                        <td><%= student.get("id") %></td>

                        <td><%= student.get("username") %></td>

                        <td><%= student.get("email") %></td>

                        <td class="xp">
                            ⭐ <%= student.get("totalXp") %>
                        </td>

                        <td>
                            Level <%= student.get("playerLevel") %>
                        </td>

                        <td>
                            <%= student.get("missionsAttempted") %>
                        </td>

                        <td>
                            <%= student.get("correctAnswers") %>
                        </td>

                        <td>
                            <%= student.get("createdAt") %>
                        </td>
						<td>
						    <form action="<%= request.getContextPath() %>/admin/delete-student"
						          method="post"
						          onsubmit="return confirm('Are you sure you want to permanently delete this student and their mission history?');">
						
						        <input type="hidden"
						               name="studentId"
						               value="<%= student.get("id") %>">
						
						        <button type="submit"
						                style="background:#dc2626; color:white; border:none;
						                       padding:9px 15px; border-radius:7px; cursor:pointer;">
						            Delete
						        </button>
						
						    </form>
						</td>
                        
                    </tr>

                <% } %>

                </tbody>
            </table>

        <% } %>

    </div>

</div>

</body>
</html>