
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    Map<String, Object> mission =
        (Map<String, Object>) request.getAttribute("mission");

    Boolean alreadyAttempted =
        (Boolean) request.getAttribute("alreadyAttempted");

    boolean attempted =
        alreadyAttempted != null && alreadyAttempted;

    String resultMessage =
        (String) request.getAttribute("resultMessage");

    String resultType =
        (String) request.getAttribute("resultType");

    if (mission == null) {
        response.sendRedirect(
            request.getContextPath() + "/student/missions"
        );
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/theme.css">

<script src="<%= request.getContextPath() %>/js/theme.js"></script>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Solve Mission | CodeQuest</title>

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/theme.css">

<script src="<%= request.getContextPath() %>/js/theme.js"></script>

<style>

body {
    font-family: 'Segoe UI', Arial, sans-serif;
    min-height: 100vh;
    padding: 30px 18px;
}

.container {
    max-width: 750px;
    margin: auto;
}

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

.theme-toggle {
    padding: 10px 15px;
    border-radius: 8px;
    border: 1px solid var(--border);
    background: var(--surface);
    color: var(--text);
    text-decoration: none;
    cursor: pointer;
}

.mission-card {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 17px;
    padding: 30px;
}

.category {
    color: #a78bfa;
    font-size: 13px;
    font-weight: bold;
    margin-bottom: 12px;
}

h1 {
    font-size: 27px;
    margin-bottom: 15px;
}

.description {
    color: var(--muted);
    line-height: 1.7;
    margin-bottom: 25px;
}

.question-label {
    font-weight: bold;
    margin-bottom: 15px;
}

.option {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 14px;
    margin-bottom: 12px;
    border: 1px solid var(--border);
    border-radius: 10px;
    background: var(--bg);
    cursor: pointer;
}

.option:hover {
    border-color: var(--accent);
}

.option input {
    width: auto;
    accent-color: var(--accent);
}

.option-text {
    color: var(--text);
}

.submit-btn {
    width: 100%;
    padding: 14px;
    margin-top: 18px;
    border: none;
    border-radius: 9px;
    background: linear-gradient(90deg, #7c3aed, #4f46e5);
    color: white;
    font-weight: bold;
    font-size: 15px;
    cursor: pointer;
}

.submit-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

.result {
    padding: 15px;
    border-radius: 9px;
    margin-bottom: 22px;
    font-weight: 600;
}

.success {
    background: #14532d;
    color: #bbf7d0;
}

.danger {
    background: #7f1d1d;
    color: #fecaca;
}

.warning {
    background: #713f12;
    color: #fef08a;
}

.reward {
    color: #facc15;
    margin-top: 15px;
    font-weight: bold;
}

.xp-total {
    margin-top: 12px;
    color: var(--muted);
}

.footer {
    text-align: center;
    margin-top: 25px;
    color: var(--muted);
    font-size: 13px;
}

@media(max-width: 600px) {
    .mission-card {
        padding: 20px;
    }

    h1 {
        font-size: 22px;
    }
}

</style>
</head>

<body>

<div class="container">

    <div class="navbar">
	    <div class="logo">⚡ CodeQuest</div>
	
	    <a href="<%= request.getContextPath() %>/student/missions"
	       class="dashboard-btn">
	        ← Back to Missions
	    </a>
	</div>

    <div class="mission-card">

        <div class="category">
            <%= mission.get("category") %> |
            <%= mission.get("difficulty") %>
        </div>

        <h1><%= mission.get("title") %></h1>

        <p class="description">
            <%= mission.get("description") %>
        </p>

        <p class="question-label">
            Select the correct answer:
        </p>

        <% if (resultMessage != null) { %>

            <div class="result <%= resultType %>">
                <%= resultMessage %>
            </div>

            <% if (Boolean.TRUE.equals(
                    request.getAttribute("isCorrect"))) { %>

                <p class="reward">
                    ⭐ You earned
                    <%= request.getAttribute("earnedXp") %> XP!
                </p>

            <% } %>

            <% if (request.getAttribute("totalXp") != null) { %>

                <p class="xp-total">
                    Your total XP:
                    <strong>
                        <%= request.getAttribute("totalXp") %>
                    </strong>
                </p>

            <% } %>

        <% } else if (attempted) { %>

            <div class="result warning">
                You have already attempted this mission.
                You cannot submit another answer.
            </div>

        <% } %>

        <form action="<%= request.getContextPath() %>/student/solve-mission"
              method="post">

            <input type="hidden" name="id"
                   value="<%= mission.get("id") %>">

            <label class="option">
                <input type="radio" name="answer" value="A"
                       <%= attempted ? "disabled" : "required" %>>

                <span class="option-text">
                    A. <%= mission.get("optionA") %>
                </span>
            </label>

            <label class="option">
                <input type="radio" name="answer" value="B"
                       <%= attempted ? "disabled" : "required" %>>

                <span class="option-text">
                    B. <%= mission.get("optionB") %>
                </span>
            </label>

            <label class="option">
                <input type="radio" name="answer" value="C"
                       <%= attempted ? "disabled" : "required" %>>

                <span class="option-text">
                    C. <%= mission.get("optionC") %>
                </span>
            </label>

            <label class="option">
                <input type="radio" name="answer" value="D"
                       <%= attempted ? "disabled" : "required" %>>

                <span class="option-text">
                    D. <%= mission.get("optionD") %>
                </span>
            </label>

            <button type="submit"
                    class="submit-btn"
                    <%= attempted ? "disabled" : "" %>>
                Submit Answer
            </button>

        </form>

        <p class="reward">
            ⭐ Mission Reward:
            <%= mission.get("xpReward") %> XP
        </p>

    </div>

    <div class="footer">
        CodeQuest | Learn • Practice • Level Up
    </div>

</div>

</body>
</html>