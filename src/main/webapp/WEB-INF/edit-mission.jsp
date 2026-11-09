
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    Map<String, Object> mission =
        (Map<String, Object>) request.getAttribute("mission");

    if (mission == null) {
        response.sendRedirect(request.getContextPath() + "/admin/manage-missions");
        return;
    }

    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/theme.css">

<script src="<%= request.getContextPath() %>/js/theme.js"></script>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Edit Mission | CodeQuest</title>

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
    color: #f8fafc;
    padding: 40px 18px;
}

.container {
    max-width: 760px;
    margin: auto;
}

.header {
    text-align: center;
    margin-bottom: 28px;
}

.logo {
    font-size: 30px;
    font-weight: 800;
    color: #a78bfa;
    margin-bottom: 10px;
}

.header h1 {
    font-size: 28px;
    margin-bottom: 8px;
}

.header p {
    color: #cbd5e1;
    font-size: 14px;
}

.form-card {
    background: rgba(30, 41, 59, 0.95);
    border: 1px solid #475569;
    border-radius: 18px;
    padding: 32px;
    box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
}

.section-title {
    font-size: 18px;
    color: #c4b5fd;
    margin: 22px 0 16px;
    padding-bottom: 10px;
    border-bottom: 1px solid #475569;
}

.section-title:first-child {
    margin-top: 0;
}

.form-group {
    margin-bottom: 18px;
}

label {
    display: block;
    margin-bottom: 8px;
    font-size: 14px;
    font-weight: 600;
    color: #e2e8f0;
}

input, textarea, select {
    width: 100%;
    padding: 12px 14px;
    border: 1px solid #475569;
    border-radius: 9px;
    background: #0f172a;
    color: #f8fafc;
    font-size: 14px;
    outline: none;
    transition: 0.2s;
}

input:focus, textarea:focus, select:focus {
    border-color: #a78bfa;
    box-shadow: 0 0 0 3px rgba(167, 139, 250, 0.15);
}

textarea {
    min-height: 100px;
    resize: vertical;
}

input::placeholder, textarea::placeholder {
    color: #94a3b8;
}

.grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 18px;
}

.error {
    background: #7f1d1d;
    color: #fecaca;
    border: 1px solid #ef4444;
    padding: 12px;
    border-radius: 8px;
    margin-bottom: 20px;
}

.button-group {
    display: flex;
    gap: 14px;
    margin-top: 28px;
}

button, .back-btn {
    flex: 1;
    padding: 13px;
    border: none;
    border-radius: 9px;
    font-size: 15px;
    font-weight: 700;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    transition: 0.2s;
}

.update-btn {
    background: linear-gradient(90deg, #7c3aed, #4f46e5);
    color: white;
}

.update-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 20px rgba(124, 58, 237, 0.35);
}

.back-btn {
    background: #334155;
    color: #e2e8f0;
}

.back-btn:hover {
    background: #475569;
}

.footer {
    text-align: center;
    color: #94a3b8;
    margin-top: 22px;
    font-size: 12px;
}

@media (max-width: 600px) {
    .form-card {
        padding: 22px 17px;
    }

    .grid {
        grid-template-columns: 1fr;
        gap: 0;
    }

    .button-group {
        flex-direction: column;
    }

    .header h1 {
        font-size: 23px;
    }
}
</style>
</head>

<body>

<div class="container">

    <div class="header">
        <div class="logo">⚡ CodeQuest</div>
        <h1>Edit Mission</h1>
        <p>Update your programming challenge details</p>
    </div>

    <div class="form-card">

        <% if (errorMessage != null) { %>
            <div class="error"><%= errorMessage %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/admin/edit-mission"
              method="post">

            <input type="hidden" name="id"
                   value="<%= mission.get("id") %>">

            <h3 class="section-title">📝 Mission Information</h3>

            <div class="form-group">
                <label>Mission Title</label>
                <input type="text" name="title"
                       value="<%= mission.get("title") %>" required>
            </div>

            <div class="form-group">
                <label>Description</label>
                <textarea name="description" required><%= mission.get("description") %></textarea>
            </div>

            <div class="grid">

                <div class="form-group">
                    <label>Category</label>
                    <select name="category" required>
                        <option value="Java" <%= "Java".equals(mission.get("category")) ? "selected" : "" %>>Java</option>
                        <option value="SQL" <%= "SQL".equals(mission.get("category")) ? "selected" : "" %>>SQL</option>
                        <option value="DSA" <%= "DSA".equals(mission.get("category")) ? "selected" : "" %>>DSA</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Difficulty</label>
                    <select name="difficulty" required>
                        <option value="Easy" <%= "Easy".equals(mission.get("difficulty")) ? "selected" : "" %>>Easy</option>
                        <option value="Medium" <%= "Medium".equals(mission.get("difficulty")) ? "selected" : "" %>>Medium</option>
                        <option value="Hard" <%= "Hard".equals(mission.get("difficulty")) ? "selected" : "" %>>Hard</option>
                    </select>
                </div>

            </div>

            <h3 class="section-title">🎯 Multiple Choice Options</h3>

            <div class="grid">

                <div class="form-group">
                    <label>Option A</label>
                    <input type="text" name="optionA"
                           value="<%= mission.get("optionA") %>" required>
                </div>

                <div class="form-group">
                    <label>Option B</label>
                    <input type="text" name="optionB"
                           value="<%= mission.get("optionB") %>" required>
                </div>

                <div class="form-group">
                    <label>Option C</label>
                    <input type="text" name="optionC"
                           value="<%= mission.get("optionC") %>" required>
                </div>

                <div class="form-group">
                    <label>Option D</label>
                    <input type="text" name="optionD"
                           value="<%= mission.get("optionD") %>" required>
                </div>

            </div>

            <h3 class="section-title">🏆 Answer & Rewards</h3>

            <div class="grid">

                <div class="form-group">
                    <label>Correct Answer</label>
                    <select name="correctAnswer" required>
                        <option value="A" <%= "A".equals(mission.get("correctAnswer")) ? "selected" : "" %>>Option A</option>
                        <option value="B" <%= "B".equals(mission.get("correctAnswer")) ? "selected" : "" %>>Option B</option>
                        <option value="C" <%= "C".equals(mission.get("correctAnswer")) ? "selected" : "" %>>Option C</option>
                        <option value="D" <%= "D".equals(mission.get("correctAnswer")) ? "selected" : "" %>>Option D</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>XP Reward</label>
                    <input type="number" name="xpReward"
                           min="1" max="1000"
                           value="<%= mission.get("xpReward") %>" required>
                </div>

            </div>

            <div class="button-group">
                <button type="submit" class="update-btn">
                    💾 Update Mission
                </button>

                <a class="back-btn"
                   href="<%= request.getContextPath() %>/admin/manage-missions">
                    ← Back
                </a>
            </div>

        </form>
    </div>

    <div class="footer">
        © 2026 CodeQuest | Learn • Practice • Level Up
    </div>

</div>

</body>
</html>