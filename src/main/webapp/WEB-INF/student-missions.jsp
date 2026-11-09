
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    List<Map<String, Object>> missions =
        (List<Map<String, Object>>) request.getAttribute("missions");

    String username = (String) session.getAttribute("username");
%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/theme.css">

<script src="<%= request.getContextPath() %>/js/theme.js"></script>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Student Missions | CodeQuest</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Segoe UI', Arial, sans-serif;
    background: linear-gradient(135deg, #0f172a, #172554, #312e81);
    min-height: 100vh;
    color: white;
    padding: 30px 20px;
}

.container {
    max-width: 1100px;
    margin: auto;
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

.heading {
    margin-bottom: 25px;
}

.heading h1 {
    font-size: 30px;
    margin-bottom: 8px;
}

.heading p {
    color: #cbd5e1;
}

.mission-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(270px, 1fr));
    gap: 22px;
}

.mission-card {
    background: rgba(30, 41, 59, 0.95);
    border: 1px solid #475569;
    border-radius: 15px;
    padding: 23px;
    transition: 0.2s;
}

.mission-card:hover {
    transform: translateY(-5px);
    border-color: #a78bfa;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.25);
}

.mission-card h2 {
    font-size: 20px;
    margin-bottom: 12px;
    color: #c4b5fd;
}

.description {
    color: #cbd5e1;
    line-height: 1.6;
    margin-bottom: 20px;
    min-height: 50px;
}

.tags {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
    margin-bottom: 20px;
}

.tag {
    background: #334155;
    color: #e2e8f0;
    padding: 6px 11px;
    border-radius: 20px;
    font-size: 12px;
}

.xp {
    color: #facc15;
    font-weight: bold;
    margin-bottom: 18px;
}

.solve-btn {
    display: block;
    background: linear-gradient(90deg, #7c3aed, #4f46e5);
    color: white;
    text-align: center;
    text-decoration: none;
    padding: 12px;
    border-radius: 8px;
    font-weight: bold;
}

.empty {
    background: #1e293b;
    padding: 35px;
    border-radius: 12px;
    text-align: center;
    color: #cbd5e1;
}

.footer {
    text-align: center;
    color: #94a3b8;
    margin-top: 40px;
    font-size: 13px;
}

@media(max-width: 600px) {
    .heading h1 {
        font-size: 24px;
    }
}
</style>
</head>

<body>
<div class="container">

    <div class="navbar">
	    <div class="logo">⚡ CodeQuest</div>
	
	    <a href="<%= request.getContextPath() %>/dashboard"
	       class="dashboard-btn">
	        ← Back to Dashboard
	    </a>
	</div>

    <div class="heading">
        <h1>Available Missions 🚀</h1>
        <p>
            Welcome, <%= username %>!
            Choose a programming challenge and test your skills.
        </p>
    </div>

    <% if (missions == null || missions.isEmpty()) { %>

        <div class="empty">
            <h2>No missions available yet!</h2>
            <p>Please check again later.</p>
        </div>

    <% } else { %>

        <div class="mission-grid">

            <% for (Map<String, Object> mission : missions) { %>

                <div class="mission-card">

                    <h2><%= mission.get("title") %></h2>

                    <p class="description">
                        <%= mission.get("description") %>
                    </p>

                    <div class="tags">
                        <span class="tag">
                            <%= mission.get("category") %>
                        </span>

                        <span class="tag">
                            <%= mission.get("difficulty") %>
                        </span>
                    </div>

                    <div class="xp">
                        ⭐ <%= mission.get("xpReward") %> XP
                    </div>

                    <a class="solve-btn"
                       href="<%= request.getContextPath() %>/student/solve-mission?id=<%= mission.get("id") %>">
                        Solve Mission
                    </a>

                </div>

            <% } %>

        </div>

    <% } %>

    <div class="footer">
        © 2026 CodeQuest | Learn • Practice • Level Up
    </div>

</div>

</body>
</html>