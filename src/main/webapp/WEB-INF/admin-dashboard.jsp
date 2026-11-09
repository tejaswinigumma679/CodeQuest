<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         session="true" %>
<%
    String adminUsername = (String) session.getAttribute("adminUsername");

    if (adminUsername == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CodeQuest | Admin Dashboard</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/theme.css">

    <script src="<%= request.getContextPath() %>/js/theme.js"></script>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background: #0f172a;
            color: #f8fafc;
            min-height: 100vh;
        }

        .dashboard {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 250px;
            background: #111827;
            padding: 30px 20px;
            border-right: 1px solid #273449;
            display: flex;
            flex-direction: column;
        }

        .logo {
            font-size: 27px;
            font-weight: bold;
            color: #a78bfa;
            margin-bottom: 45px;
        }

        .logo span {
            margin-right: 8px;
        }

        .nav-title {
            color: #94a3b8;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin: 10px 0 15px;
        }

        .nav-link {
            display: block;
            padding: 14px;
            margin-bottom: 10px;
            border-radius: 10px;
            color: #cbd5e1;
            text-decoration: none;
            transition: 0.2s;
        }

        .nav-link:hover {
            background: #293449;
            color: #a78bfa;
        }

        .sidebar-bottom {
            margin-top: auto;
        }

        /* Main content */
        .main-content {
            flex: 1;
            padding: 40px;
            min-width: 0;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 35px;
        }

        .topbar h1 {
            font-size: 30px;
        }
		/* Admin profile dropdown */
		.profile-dropdown {
		    position: relative;
		}
		
		.admin-badge {
		    background: #312e81;
		    color: #c4b5fd;
		    padding: 12px 18px;
		    border: none;
		    border-radius: 25px;
		    font-size: 14px;
		    cursor: pointer;
		}
		
		.admin-badge:hover {
		    background: #4338a0;
		}
		
		.profile-menu {
		    display: none;
		    position: absolute;
		    top: calc(100% + 10px);
		    right: 0;
		    width: 210px;
		    background: #1e293b;
		    border: 1px solid #334155;
		    border-radius: 12px;
		    padding: 8px;
		    z-index: 1000;
		    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
		}
		
		.profile-dropdown.active .profile-menu {
		    display: block;
		}
		
		.profile-menu a,
		.profile-menu button {
		    display: block;
		    width: 100%;
		    padding: 12px;
		    color: #e2e8f0;
		    text-decoration: none;
		    text-align: left;
		    font-size: 14px;
		    background: transparent;
		    border: none;
		    border-radius: 8px;
		    cursor: pointer;
		}
		
		.profile-menu a:hover {
		    background: #293449;
		    color: #a78bfa;
		}
		
		.profile-menu .logout-option {
		    color: #f87171;
		    border-top: 1px solid #334155;
		    border-radius: 0 0 8px 8px;
		    margin-top: 5px;
		}
		
		.profile-menu .logout-option:hover {
		    background: rgba(239, 68, 68, 0.12);
		}

        /* Welcome section */
        .welcome-card {
            background: linear-gradient(120deg, #312e81, #6d28d9);
            padding: 35px;
            border-radius: 18px;
            margin-bottom: 30px;
        }

        .welcome-card h2 {
            font-size: 27px;
            margin-bottom: 12px;
        }

        .welcome-card p {
            color: #e0e7ff;
            line-height: 1.6;
        }

        .section-title {
            font-size: 22px;
            margin-bottom: 20px;
        }

        /* Management cards */
        .card-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 22px;
        }

        .management-card {
            background: #1e293b;
            border: 1px solid #334155;
            border-radius: 16px;
            padding: 28px;
            transition: transform 0.2s, border-color 0.2s;
        }

        .management-card:hover {
            transform: translateY(-4px);
            border-color: #8b5cf6;
        }

        .card-icon {
            font-size: 32px;
            margin-bottom: 18px;
        }

        .management-card h3 {
            font-size: 21px;
            margin-bottom: 12px;
        }

        .management-card p {
            color: #94a3b8;
            line-height: 1.6;
            min-height: 50px;
            margin-bottom: 22px;
        }

        .action-links {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .action-btn {
            display: inline-block;
            text-decoration: none;
            text-align: center;
            padding: 12px 17px;
            border-radius: 9px;
            color: white;
            font-weight: bold;
            font-size: 14px;
            background: linear-gradient(90deg, #7c3aed, #4f46e5);
            transition: 0.2s;
        }

        .action-btn:hover {
            opacity: 0.85;
            transform: translateY(-2px);
        }

        /* Logout */
        .logout-btn {
            width: 100%;
            padding: 13px;
            border: 1px solid #ef4444;
            border-radius: 10px;
            background: transparent;
            color: #f87171;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s;
        }

        .logout-btn:hover {
            background: #7f1d1d;
            color: white;
        }

        @media (max-width: 800px) {
            .sidebar {
                width: 200px;
            }

            .main-content {
                padding: 25px;
            }

            .card-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 550px) {
            .dashboard {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                padding: 18px;
            }

            .logo {
                margin-bottom: 20px;
            }

            .sidebar-bottom {
                margin-top: 15px;
            }

            .main-content {
                padding: 20px;
            }

            .topbar {
                align-items: flex-start;
                flex-direction: column;
            }

            .topbar h1 {
                font-size: 25px;
            }
        }
    </style>
</head>

<body>

<div class="dashboard">

    <!-- Sidebar -->
    <aside class="sidebar">

        <div class="logo">
            <span>⚡</span> CodeQuest
        </div>

        <div class="nav-title">Admin Menu</div>

        <a class="nav-link" href="<%= request.getContextPath() %>/admin/dashboard">
            🏠 Dashboard
        </a>

        <a class="nav-link" href="<%= request.getContextPath() %>/admin/add-mission">
            ➕ Add Mission
        </a>

        <a class="nav-link" href="<%= request.getContextPath() %>/admin/manage-missions">
            📚 Manage Missions
        </a>

        <a class="nav-link" href="<%= request.getContextPath() %>/admin/students">
            👨‍🎓 Manage Students
        </a>

    </aside>

    <!-- Main content -->
    <main class="main-content">

        <div class="topbar">
            <h1>Admin Dashboard</h1>

            <div class="profile-dropdown">
			
			    <button type="button"
			            class="admin-badge"
			            onclick="toggleAdminMenu()">
			        🛡️ <%= adminUsername %>
			    </button>
			
			    <div class="profile-menu">
			
			        <a href="<%= request.getContextPath() %>/admin/profile">
			            👤 Profile
			        </a>
			
			        <a href="<%= request.getContextPath() %>/admin/change-password">
					    🔐 Change Password
					</a>
			
			        <a href="<%= request.getContextPath() %>/admin/settings">
			            ⚙️ Settings
			        </a>
			
			        <form action="<%= request.getContextPath() %>/admin-logout"
			              method="post">
			            <button type="submit" class="logout-option">
			                🚪 Logout
			            </button>
			        </form>
			
			    </div>
			</div>
        </div>

        <!-- Welcome -->
        <section class="welcome-card">
            <h2>
                Welcome, <%= adminUsername %>! 👋
            </h2>

            <p>
                You are successfully logged in as an administrator.
                Manage programming missions and monitor student activity
                from one place.
            </p>
        </section>

        <h2 class="section-title">Management Center</h2>

        <div class="card-grid">

            <!-- Mission Management -->
            <section class="management-card">

                <div class="card-icon">🚀</div>

                <h3>Mission Management</h3>

                <p>
                    Create new programming challenges, update existing
                    missions, and manage the learning content for students.
                </p>

                <div class="action-links">

                    <a class="action-btn"
                       href="<%= request.getContextPath() %>/admin/add-mission">
                        + Add Mission
                    </a>

                    <a class="action-btn"
                       href="<%= request.getContextPath() %>/admin/manage-missions">
                        Manage Missions
                    </a>

                </div>

            </section>

            <!-- Student Management -->
            <section class="management-card">

                <div class="card-icon">🎓</div>

                <h3>Student Management</h3>

                <p>
                    View registered students, check their XP, levels,
                    and monitor their mission progress.
                </p>

                <div class="action-links">

                    <a class="action-btn"
                       href="<%= request.getContextPath() %>/admin/students">
                        Manage Students →
                    </a>

                </div>

            </section>

        </div>

    </main>

</div>

<script>
    function toggleAdminMenu() {
        document.querySelector(".profile-dropdown")
                .classList.toggle("active");
    }

    document.addEventListener("click", function(event) {
        const dropdown = document.querySelector(".profile-dropdown");

        if (dropdown && !dropdown.contains(event.target)) {
            dropdown.classList.remove("active");
        }
    });
</script>

</body>
</html>