
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, java.util.Map" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    ArrayList<Map<String, Object>> leaderboard =
        (ArrayList<Map<String, Object>>) request.getAttribute("leaderboard");

    if (leaderboard == null) {
        leaderboard = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Leaderboard - CodeQuest</title>

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
		    border-bottom: 1px solid var(--border);
		    margin-bottom: 30px;
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
    
        .leaderboard-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 20px;
        }

        .leaderboard-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .leaderboard-header h1 {
            color: var(--accent);
            margin-bottom: 10px;
        }

        .leaderboard-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 25px;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th, td {
            padding: 16px;
            text-align: center;
            border-bottom: 1px solid var(--border);
        }

        th {
            color: var(--accent);
            font-size: 15px;
        }

        .rank {
            font-weight: bold;
            font-size: 18px;
        }

        .top-rank {
            font-size: 22px;
        }

        .current-user {
            background: var(--surface-hover);
            font-weight: bold;
        }

        .you-label {
            color: var(--accent);
            font-size: 12px;
            margin-left: 5px;
        }

        .xp {
            color: #16a34a;
            font-weight: bold;
        }

        .empty-message {
            text-align: center;
            padding: 25px;
            color: var(--muted);
        }

        @media(max-width: 600px) {
            th, td {
                padding: 11px 8px;
                font-size: 13px;
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

<div class="leaderboard-container">

    <div class="leaderboard-header">
        <h1>🏆 CodeQuest Leaderboard</h1>
        <p>Compete with other students and climb the rankings!</p>
    </div>

    <div class="leaderboard-card">

        <% if (leaderboard.isEmpty()) { %>

            <div class="empty-message">
                <h3>No students found.</h3>
                <p>Register students and start completing missions!</p>
            </div>

        <% } else { %>

            <table>
                <thead>
                    <tr>
                        <th>Rank</th>
                        <th>Student</th>
                        <th>Total XP</th>
                        <th>Level</th>
                    </tr>
                </thead>

                <tbody>

                <% for (Map<String, Object> student : leaderboard) {
                    int rank = (Integer) student.get("rank");
                    boolean currentUser =
                        Boolean.TRUE.equals(student.get("currentUser"));
                %>

                    <tr class="<%= currentUser ? "current-user" : "" %>">

                        <td class="rank">
                            <% if (rank == 1) { %>
                                <span class="top-rank">🥇</span>
                            <% } else if (rank == 2) { %>
                                <span class="top-rank">🥈</span>
                            <% } else if (rank == 3) { %>
                                <span class="top-rank">🥉</span>
                            <% } else { %>
                                #<%= rank %>
                            <% } %>
                        </td>

                        <td>
                            <%= student.get("username") %>

                            <% if (currentUser) { %>
                                <span class="you-label">(You)</span>
                            <% } %>
                        </td>

                        <td class="xp">
                            ⭐ <%= student.get("totalXp") %>
                        </td>

                        <td>
                            Level <%= student.get("playerLevel") %>
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