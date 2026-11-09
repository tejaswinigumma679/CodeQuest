
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%!
    private String escapeHtml(Object value) {
        if (value == null) return "";

        return value.toString()
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#x27;");
    }
%>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String username = escapeHtml(session.getAttribute("username"));
    Object xp = session.getAttribute("totalXp");
    Object level = session.getAttribute("playerLevel");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CodeQuest | Dashboard</title>

<link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
<script src="<%= request.getContextPath() %>/js/theme.js"></script>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: 'Segoe UI', Arial, sans-serif;
    background: #090b18 !important;
    color: #ffffff !important;
}

.dashboard-layout {
    display: flex;
    min-height: 100vh;
}

/* SIDEBAR */

.sidebar {
    width: 245px;
    background: #111326;
    border-right: 1px solid #252843;
    padding: 30px 18px;
    display: flex;
    flex-direction: column;
    flex-shrink: 0;
}

.logo {
    font-size: 25px;
    font-weight: 800;
    color: #a78bfa;
    margin: 0 0 45px 10px;
}

.logo span {
    color: white;
}

.sidebar-label {
    color: #737995;
    font-size: 11px;
    font-weight: bold;
    letter-spacing: 2px;
    margin: 0 0 15px 12px;
}

.nav-link {
    display: flex;
    align-items: center;
    gap: 13px;
    padding: 14px 15px;
    margin-bottom: 9px;
    border-radius: 10px;
    color: #aeb3ca;
    text-decoration: none;
    font-size: 14px;
    transition: .25s;
}

.nav-link:hover,
.nav-link.active {
    background: linear-gradient(90deg, #6d3be8, #5531b8);
    color: white;
    box-shadow: 0 5px 20px #713ce955;
}

.nav-icon {
    font-size: 19px;
}

.sidebar-bottom {
    margin-top: auto;
    padding-top: 25px;
}

.sidebar-note {
    background: #1c1b38;
    border: 1px solid #38315e;
    border-radius: 13px;
    padding: 16px;
    color: #bcb5e8;
    font-size: 12px;
    line-height: 1.6;
}

/* MAIN CONTENT */

.main-content {
    flex: 1;
    min-width: 0;
    padding: 30px 38px;
    background:
        radial-gradient(ellipse at 85% 5%, #35205b55, transparent 35%),
        #090b18;
}

.topbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
    margin-bottom: 32px;
}

.page-heading h2 {
    margin: 0;
    font-size: 25px;
}

.page-heading p {
    margin: 7px 0 0;
    color: #858ba7;
    font-size: 13px;
}

.topbar-right {
    display: flex;
    align-items: center;
    gap: 15px;
}

.user-profile {
    display: flex;
    align-items: center;
    gap: 10px;
    background: #171a30;
    border: 1px solid #292d4c;
    border-radius: 12px;
    padding: 8px 14px;
}

.avatar {
    width: 36px;
    height: 36px;
    border-radius: 10px;
    display: grid;
    place-items: center;
    background: linear-gradient(135deg, #8b5cf6, #4f46e5);
    font-weight: bold;
}

.user-name {
    font-size: 13px;
    font-weight: bold;
}

/* WELCOME BANNER */

.hero {
    position: relative;
    overflow: hidden;
    padding: 35px;
    border-radius: 20px;
    background: linear-gradient(115deg, #4925a5, #7439ce 55%, #9a4de0);
    margin-bottom: 25px;
    box-shadow: 0 12px 35px #713ce933;
}

.hero::after {
    content: "⚡";
    position: absolute;
    right: 55px;
    top: 15px;
    font-size: 130px;
    opacity: .13;
    transform: rotate(12deg);
}

.hero-label {
    font-size: 11px;
    letter-spacing: 2px;
    font-weight: bold;
    color: #e3d8ff;
}

.hero h1 {
    font-size: 32px;
    margin: 13px 0;
    color: white !important;
    overflow-wrap: anywhere;
}

.hero p {
    max-width: 550px;
    color: #eee6ff !important;
    line-height: 1.7;
    font-size: 14px;
    margin-bottom: 0;
}

/* STAT CARDS */

.stats-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 20px;
    margin-bottom: 35px;
}

.stat-card {
    background: #15182b;
    border: 1px solid #292d49;
    border-radius: 16px;
    padding: 23px;
    display: flex;
    align-items: center;
    gap: 18px;
    transition: .25s;
}

.stat-card:hover {
    transform: translateY(-4px);
    border-color: #8154e8;
}

.stat-icon {
    width: 55px;
    height: 55px;
    display: grid;
    place-items: center;
    border-radius: 15px;
    font-size: 27px;
    background: #33245a;
}

.stat-card:nth-child(2) .stat-icon {
    background: #49351d;
}

.stat-info h3 {
    font-size: 12px;
    color: #9298b1 !important;
    margin: 0 0 8px;
    font-weight: normal;
}

.stat-value {
    color: white !important;
    font-size: 27px;
    font-weight: 800;
    margin: 0;
}

/* FEATURE CARDS */

.section-title {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin: 35px 0 18px;
}

.section-title h2 {
    font-size: 19px;
    margin: 0;
    color: white !important;
}

.section-title span {
    color: #8d93ae;
    font-size: 12px;
}

.feature-grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 20px;
}

.feature-card {
    background: #15182b;
    border: 1px solid #292d49;
    border-radius: 17px;
    padding: 24px;
    transition: .3s;
    min-width: 0;
}

.feature-card:hover {
    transform: translateY(-6px);
    border-color: #8655ee;
    box-shadow: 0 12px 30px #713ce922;
}

.feature-icon {
    width: 52px;
    height: 52px;
    border-radius: 14px;
    display: grid;
    place-items: center;
    font-size: 26px;
    margin-bottom: 20px;
}

.missions-icon {
    background: #34265f;
}

.progress-icon {
    background: #173f42;
}

.leaderboard-icon {
    background: #4b351e;
}

.feature-card h3 {
    font-size: 17px;
    color: white !important;
    margin: 0 0 11px;
}

.feature-card p {
    font-size: 13px;
    line-height: 1.7;
    color: #9298b1 !important;
    min-height: 65px;
    margin-bottom: 20px;
}

.feature-link {
    display: inline-block;
    text-decoration: none;
    color: #b69aff;
    font-size: 13px;
    font-weight: bold;
}

.feature-link:hover {
    color: white;
}

.logout-area {
    margin-top: 35px;
    padding-top: 22px;
    border-top: 1px solid #252843;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
}

.logout-area p {
    color: #737995;
    font-size: 12px;
}

.logout-btn {
    background: #301b2c;
    color: #ff8eaa;
    border: 1px solid #71304d;
    border-radius: 9px;
    padding: 11px 22px;
    cursor: pointer;
    font-weight: bold;
    transition: .2s;
}

.logout-btn:hover {
    background: #a52a4c;
    color: white;
}

/* THEME OVERRIDES */

html[data-theme="light"] body {
    background: #f1f5f9 !important;
    color: #0f172a !important;
}

html[data-theme="light"] .main-content {
    background: #f1f5f9;
}

html[data-theme="light"] .sidebar {
    background: #ffffff;
    border-color: #e2e8f0;
}

html[data-theme="light"] .logo span,
html[data-theme="light"] .section-title h2,
html[data-theme="light"] .feature-card h3,
html[data-theme="light"] .stat-value {
    color: #0f172a !important;
}

html[data-theme="light"] .feature-card,
html[data-theme="light"] .stat-card,
html[data-theme="light"] .user-profile {
    background: #ffffff;
    border-color: #e2e8f0;
}

html[data-theme="light"] .user-name {
    color: #0f172a;
}

html[data-theme="light"] .feature-card p,
html[data-theme="light"] .stat-info h3 {
    color: #64748b !important;
}

html[data-theme="light"] .sidebar-note {
    background: #f1edff;
    color: #59418d;
}

html[data-theme="light"] .logout-area {
    border-color: #e2e8f0;
}

/* RESPONSIVE */

@media (max-width: 950px) {
    .sidebar {
        width: 200px;
    }

    .main-content {
        padding: 25px 22px;
    }

    .feature-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}

@media (max-width: 650px) {
    .dashboard-layout {
        flex-direction: column;
    }

    .sidebar {
        width: 100%;
        padding: 17px;
    }

    .logo {
        margin: 0 0 17px;
    }

    .sidebar-label,
    .sidebar-bottom {
        display: none;
    }

    .sidebar nav {
        display: flex;
        overflow-x: auto;
        gap: 7px;
    }

    .nav-link {
        white-space: nowrap;
        margin: 0;
        padding: 11px;
    }

    .main-content {
        padding: 22px 15px;
    }

    .hero {
        padding: 25px;
    }

    .hero h1 {
        font-size: 25px;
    }

    .stats-grid,
    .feature-grid {
        grid-template-columns: 1fr;
    }
}

.user-profile {
    transition: .2s;
}

.user-profile:hover {
    border-color: #8b5cf6;
    transform: translateY(-2px);
}

.profile-dropdown {
    position: relative;
}

.user-profile {
    display: flex;
    align-items: center;
    gap: 10px;
    border: none;
    cursor: pointer;
    color: var(--text);
}

.profile-menu {
    display: none;
    position: absolute;
    top: calc(100% + 12px);
    right: 0;
    width: 190px;
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 12px;
    padding: 8px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.2);
    z-index: 1000;
}

.profile-dropdown.active .profile-menu {
    display: block;
}

.profile-menu a {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 12px;
    color: var(--text);
    text-decoration: none;
    border-radius: 8px;
    font-size: 14px;
}

.profile-menu a:hover {
    background: var(--surface-hover);
    color: var(--accent);
}

.profile-menu .logout-option {
    color: #ef4444;
    border-top: 1px solid var(--border);
    margin-top: 5px;
    padding-top: 14px;
}

.profile-menu .logout-option:hover {
    background: rgba(239, 68, 68, 0.12);
    color: #ef4444;
}

.dropdown-logout-form {
    margin: 0;
    padding: 0;
}

.profile-menu .logout-option {
    width: 100%;
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 12px;
    margin-top: 5px;
    background: transparent;
    border: none;
    border-top: 1px solid var(--border);
    border-radius: 0 0 8px 8px;
    color: #ef4444;
    font-size: 14px;
    text-align: left;
    cursor: pointer;
}

.profile-menu .logout-option:hover {
    background: rgba(239, 68, 68, 0.12);
}
</style>
</head>

<body>

<div class="dashboard-layout">

    <!-- SIDEBAR -->
    <aside class="sidebar">

        <div class="logo">⚡ Code<span>Quest</span></div>

        <div class="sidebar-label">MAIN MENU</div>

        <nav>
            <a class="nav-link active"
               href="<%= request.getContextPath() %>/dashboard">
                <span class="nav-icon">⌂</span> Dashboard
            </a>

            <a class="nav-link"
               href="<%= request.getContextPath() %>/student/missions">
                <span class="nav-icon">🎯</span> Missions
            </a>

            <a class="nav-link"
               href="<%= request.getContextPath() %>/student/progress">
                <span class="nav-icon">📊</span> My Progress
            </a>

            <a class="nav-link"
               href="<%= request.getContextPath() %>/student/leaderboard">
                <span class="nav-icon">🏆</span> Leaderboard
            </a>
            
        </nav>

        <div class="sidebar-bottom">
            <div class="sidebar-note">
                💡 Keep learning, keep practicing and level up your coding skills!
            </div>
        </div>

    </aside>

    <!-- MAIN DASHBOARD -->
    <main class="main-content">

        <header class="topbar">

            <div class="page-heading">
                <h2>Dashboard</h2>
                <p>Your personal coding arena</p>
            </div>

            <div class="topbar-right">

                <div class="profile-dropdown">

				    <button type="button"
				            class="user-profile"
				            onclick="toggleProfileMenu()">
				
				        <div class="avatar">👤</div>
				
				        <div class="user-name"><%= username %></div>
				
				    </button>
				
				    <div class="profile-menu" id="profileMenu">
				
				        <a href="<%= request.getContextPath() %>/student/profile">
						    <span>👤</span>
						    Profile
						</a>
				
				        <a href="<%= request.getContextPath() %>/student/change-password">
						    <span>🔐</span>
						    Change Password
						</a>
						
						<a href="<%= request.getContextPath() %>/student/settings">
						    <span>⚙️</span>
						    Settings
						</a>
						
						<form action="<%= request.getContextPath() %>/logout"
						      method="post"
						      class="dropdown-logout-form">
						
						    <button type="submit" class="logout-option">
						        <span>🚪</span>
						        Logout
						    </button>
						
						</form>
				
				    </div>
				
				</div>

            </div>

        </header>

        <!-- WELCOME -->
        <section class="hero">

            <div class="hero-label">WELCOME BACK, CODER!</div>

            <h1>Hello, <%= username %> 👋</h1>

            <p>
                Ready to take on a new challenge?
                Complete programming missions, earn XP,
                improve your skills and become a coding champion!
            </p>

        </section>

        <!-- STATISTICS -->
        <section class="stats-grid">

            <div class="stat-card">

                <div class="stat-icon">⭐</div>

                <div class="stat-info">
                    <h3>TOTAL EXPERIENCE POINTS</h3>
                    <p class="stat-value">
                        <%= xp == null ? 0 : xp %> XP
                    </p>
                </div>

            </div>

            <div class="stat-card">

                <div class="stat-icon">🏆</div>

                <div class="stat-info">
                    <h3>CURRENT PLAYER LEVEL</h3>
                    <p class="stat-value">
                        Level <%= level == null ? 1 : level %>
                    </p>
                </div>

            </div>

        </section>

        <!-- FEATURES -->
        <div class="section-title">
            <h2>🚀 Your Learning Arena</h2>
            <span>Choose your next challenge</span>
        </div>

        <section class="feature-grid">

            <div class="feature-card">

                <div class="feature-icon missions-icon">🎯</div>

                <h3>Programming Missions</h3>

                <p>
                    Solve Java, SQL and DSA challenges.
                    Complete missions and collect XP rewards.
                </p>

                <a class="feature-link"
                   href="<%= request.getContextPath() %>/student/missions">
                    Explore Missions →
                </a>

            </div>

            <div class="feature-card">

                <div class="feature-icon progress-icon">📊</div>

                <h3>My Progress</h3>

                <p>
                    Monitor your XP, completed missions,
                    accuracy and overall learning journey.
                </p>

                <a class="feature-link"
                   href="<%= request.getContextPath() %>/student/progress">
                    View Progress →
                </a>

            </div>

            <div class="feature-card">

                <div class="feature-icon leaderboard-icon">🏆</div>

                <h3>Leaderboard</h3>

                <p>
                    Check your ranking, compare XP
                    and compete with fellow student coders.
                </p>

                <a class="feature-link"
                   href="<%= request.getContextPath() %>/student/leaderboard">
                    View Rankings →
                </a>

            </div>

        </section>

        <!-- FOOTER -->
        <footer class="logout-area">

            <p>© CodeQuest — Learn. Practice. Compete. Level Up.</p>

        </footer>

    </main>

</div>

<script>
function toggleProfileMenu() {
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