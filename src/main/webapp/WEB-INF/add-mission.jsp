
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/theme.css">

<script src="<%= request.getContextPath() %>/js/theme.js"></script>
    <meta charset="UTF-8">
    <title>Add Mission - CodeQuest</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #101827;
            color: white;
            padding: 30px;
        }
        
        .navbar {
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    padding: 20px 7%;
		    margin: -30px -30px 30px;
		    border-bottom: 1px solid #334155;
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
            max-width: 650px;
            margin: auto;
            background: #1e293b;
            padding: 30px;
            border-radius: 12px;
        }

        input, textarea, select {
            box-sizing: border-box;
            width: 100%;
            padding: 12px;
            margin: 8px 0 16px;
            border-radius: 6px;
            border: 1px solid #64748b;
        }

        textarea {
            min-height: 100px;
            resize: vertical;
        }

        label {
            font-weight: bold;
        }

        button {
            background: #38bdf8;
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }

        .message {
            color: #fca5a5;
        }

        .success {
            color: #86efac;
        }

        a {
            color: #7dd3fc;
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

<div class="container">

    <h1>Add New Mission</h1>
    <p>Create a programming challenge for students.</p>

    <%
        String message = (String) request.getAttribute("message");
        Boolean success = (Boolean) request.getAttribute("success");

        if (message != null) {
    %>
        <p class="<%= Boolean.TRUE.equals(success) ? "success" : "message" %>">
            <%= message %>
        </p>
    <% } %>

    <form action="<%= request.getContextPath() %>/admin/add-mission"
          method="post">

        <label>Mission Title</label>
        <input type="text" name="title"
               placeholder="Example: Python Variables"
               maxlength="150" required>

        <label>Question / Description</label>
        <textarea name="description"
                  placeholder="Enter the mission question..."
                  required></textarea>

        <label>Category</label>
        <select name="category" required>
            <option value="">Select Category</option>
            <option value="Java">Java</option>
            <option value="SQL">SQL</option>
            <option value="DSA">DSA</option>
        </select>

        <label>Difficulty</label>
        <select name="difficulty" required>
            <option value="">Select Difficulty</option>
            <option value="Easy">Easy</option>
            <option value="Medium">Medium</option>
            <option value="Hard">Hard</option>
        </select>

        <h3>Answer Options</h3>

        <label>Option A</label>
        <input type="text" name="optionA" required>

        <label>Option B</label>
        <input type="text" name="optionB" required>

        <label>Option C</label>
        <input type="text" name="optionC" required>

        <label>Option D</label>
        <input type="text" name="optionD" required>

        <label>Correct Answer</label>
        <select name="correctAnswer" required>
            <option value="">Select Correct Answer</option>
            <option value="A">Option A</option>
            <option value="B">Option B</option>
            <option value="C">Option C</option>
            <option value="D">Option D</option>
        </select>

        <label>XP Reward</label>
        <input type="number" name="xpReward"
               min="1" max="1000" value="50" required>

        <button type="submit">Add Mission</button>

    </form>

</div>

</body>
</html>