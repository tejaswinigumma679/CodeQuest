
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/theme.css">

<script src="<%= request.getContextPath() %>/js/theme.js"></script>
    <meta charset="UTF-8">
    <title>Manage Missions - CodeQuest</title>

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
		    border-bottom: 1px solid #334155;
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

        .container {
            max-width: 1000px;
            margin: auto;
        }

        .mission {
            background: #1e293b;
            padding: 20px;
            margin: 15px 0;
            border-radius: 10px;
        }

        .meta {
            color: #94a3b8;
        }

        a {
            display: inline-block;
            background: #38bdf8;
            color: #101827;
            padding: 10px 15px;
            margin: 8px 8px 8px 0;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
        }

        .empty {
            background: #1e293b;
            padding: 20px;
            border-radius: 10px;
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

<%
    String deleted = request.getParameter("deleted");
    String error = request.getParameter("error");

    if ("success".equals(deleted)) {
%>
    <p style="color:green;">
        Mission deleted successfully!
    </p>
<%
    }

    if ("has_submissions".equals(error)) {
%>
    <p style="color:red;">
        This mission cannot be deleted because students have already submitted answers.
    </p>
<%
    }

    if ("notfound".equals(error)) {
%>
    <p style="color:red;">Mission not found.</p>
<%
    }

    if ("invalidid".equals(error)) {
%>
    <p style="color:red;">Invalid mission ID.</p>
<%
    }
%>

<div class="container">

    <h1>Manage Missions</h1>
    <p>View all programming missions created in CodeQuest.</p>

    <a href="<%= request.getContextPath() %>/admin/add-mission">
        Add New Mission
    </a>

    <hr>

    <%
        List<Map<String, Object>> missions =
            (List<Map<String, Object>>) request.getAttribute("missions");

        if (missions == null || missions.isEmpty()) {
    %>

        <div class="empty">
            <h3>No missions found.</h3>
            <p>Add your first programming mission.</p>
        </div>

    <%
        } else {
            for (Map<String, Object> mission : missions) {
    %>

        <div class="mission">

            <h2>
                <%= mission.get("title") %>
            </h2>

            <p>
                <%= mission.get("description") %>
            </p>

            <p class="meta">
                Category: <%= mission.get("category") %>
                |
                Difficulty: <%= mission.get("difficulty") %>
                |
                XP: <%= mission.get("xpReward") %>
            </p>

            <p class="meta">
                Mission ID: <%= mission.get("id") %>
            </p>
            
            <a href="<%= request.getContextPath() %>/admin/edit-mission?id=<%= mission.get("id") %>">
                Edit Mission
            </a>
            
            <form action="<%= request.getContextPath() %>/admin/delete-mission"
                  method="post"
                  onsubmit="return confirm('Are you sure you want to delete this mission?');">

                <input type="hidden" name="id"
                       value="<%= mission.get("id") %>">

                <button type="submit"
                        style="background-color:#dc2626;
	                    color:white;
	                    padding:8px 15px;
	                    border:none;
	                    border-radius:6px;
	                    cursor:pointer;">
                    Delete Mission
                </button>

            </form>

        </div>

    <%
            }
        }
    %>

</div>

</body>
</html>