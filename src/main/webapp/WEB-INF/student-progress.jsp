
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, java.util.Map, java.sql.Timestamp" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String username = (String) request.getAttribute("username");

    Integer totalXp = (Integer) request.getAttribute("totalXp");
    Integer playerLevel = (Integer) request.getAttribute("playerLevel");
    Integer totalMissions = (Integer) request.getAttribute("totalMissions");
    Integer correctAnswers = (Integer) request.getAttribute("correctAnswers");
    Integer incorrectAnswers = (Integer) request.getAttribute("incorrectAnswers");

    if (totalXp == null) totalXp = 0;
    if (playerLevel == null) playerLevel = 1;
    if (totalMissions == null) totalMissions = 0;
    if (correctAnswers == null) correctAnswers = 0;
    if (incorrectAnswers == null) incorrectAnswers = 0;

    ArrayList<Map<String, Object>> history =
        (ArrayList<Map<String, Object>>) request.getAttribute("history");

    if (history == null) {
        history = new ArrayList<>();
    }

    int accuracy = totalMissions == 0 ? 0 :
        (correctAnswers * 100 / totalMissions);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>My Progress - CodeQuest</title>

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
    	
        .progress-container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 20px;
        }

        .progress-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .progress-header h1 {
            margin-bottom: 10px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 25px;
            text-align: center;
        }

        .stat-card h3 {
            color: var(--muted);
            font-size: 15px;
            margin-bottom: 12px;
        }

        .stat-card .number {
            font-size: 30px;
            font-weight: bold;
            color: var(--accent);
        }

        .history-section {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 25px;
            overflow-x: auto;
        }

        .history-section h2 {
            margin-top: 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 13px;
            text-align: left;
            border-bottom: 1px solid var(--border);
        }

        th {
            color: var(--accent);
        }

        .correct {
            color: #16a34a;
            font-weight: bold;
        }

        .incorrect {
            color: #ef4444;
            font-weight: bold;
        }

        .accuracy {
            margin-top: 20px;
            font-size: 17px;
            font-weight: bold;
        }

        @media(max-width: 700px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media(max-width: 450px) {
            .stats-grid {
                grid-template-columns: 1fr;
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

<div class="progress-container">

    <div class="progress-header">
        <h1>My Learning Progress 📊</h1>
        <p>Welcome, <strong><%= username %></strong>!</p>
        <p>Track your CodeQuest learning journey.</p>
    </div>

    <div class="stats-grid">

        <div class="stat-card">
            <h3>Total XP</h3>
            <div class="number"><%= totalXp %> ⭐</div>
        </div>

        <div class="stat-card">
            <h3>Current Level</h3>
            <div class="number"><%= playerLevel %> 🏆</div>
        </div>

        <div class="stat-card">
            <h3>Completed Missions</h3>
            <div class="number"><%= totalMissions %> 🎯</div>
        </div>

        <div class="stat-card">
            <h3>Correct Answers</h3>
            <div class="number"><%= correctAnswers %> ✅</div>
        </div>

        <div class="stat-card">
            <h3>Incorrect Answers</h3>
            <div class="number"><%= incorrectAnswers %> ❌</div>
        </div>

        <div class="stat-card">
            <h3>Accuracy</h3>
            <div class="number"><%= accuracy %>%</div>
        </div>

    </div>

    <div class="history-section">

        <h2>Mission History 📚</h2>

        <% if (history.isEmpty()) { %>

            <p>You haven't attempted any missions yet.</p>

        <% } else { %>

            <table>
                <thead>
                    <tr>
                        <th>Mission</th>
                        <th>Category</th>
                        <th>Difficulty</th>
                        <th>Your Answer</th>
                        <th>Result</th>
                        <th>XP Reward</th>
                        <th>Completed At</th>
                    </tr>
                </thead>

                <tbody>

                <% for (Map<String, Object> item : history) { %>

                    <tr>
                        <td><%= item.get("title") %></td>

                        <td><%= item.get("category") %></td>

                        <td><%= item.get("difficulty") %></td>

                        <td><%= item.get("answer") %></td>

                        <td>
                            <% if (Boolean.TRUE.equals(item.get("correct"))) { %>
                                <span class="correct">Correct</span>
                            <% } else { %>
                                <span class="incorrect">Incorrect</span>
                            <% } %>
                        </td>

                        <td>
                            <% if (Boolean.TRUE.equals(item.get("correct"))) { %>
                                +<%= item.get("xpReward") %> XP
                            <% } else { %>
                                0 XP
                            <% } %>
                        </td>

                        <td>
                            <%= item.get("completedAt") %>
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