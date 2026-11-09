
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>About CodeQuest | Learn. Code. Conquer.</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/theme.css">

    <script src="<%= request.getContextPath() %>/js/theme.js"></script>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 7%;
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            position: sticky;
            top: 0;
            z-index: 100;
            gap: 20px;
            flex-wrap: wrap;
        }

        .logo {
            font-size: 26px;
            font-weight: bold;
            color: var(--accent);
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .nav-links a {
            color: var(--text);
            text-decoration: none;
            font-weight: 600;
        }

        .nav-links a:hover {
            color: var(--accent);
        }

        .nav-links .register-btn {
            background: var(--accent);
            color: white;
            padding: 10px 16px;
            border-radius: 8px;
        }

        .hero {
            text-align: center;
            padding: 100px 20px;
            background:
                linear-gradient(135deg, #312e81, #6d28d9, #9333ea);
            color: white;
        }

        .hero h1 {
            font-size: 52px;
            color: white;
            margin-bottom: 15px;
        }

        .hero p {
            color: #f3e8ff;
            font-size: 19px;
            max-width: 750px;
            margin: 0 auto 30px;
        }

        .hero-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .hero-buttons a {
            text-decoration: none;
            padding: 13px 24px;
            border-radius: 8px;
            font-weight: bold;
        }

        .primary-btn {
            background: white;
            color: #6d28d9;
        }

        .secondary-btn {
            border: 2px solid white;
            color: white;
        }

        .section {
            padding: 65px 8%;
            text-align: center;
        }

        .section h2 {
            font-size: 32px;
            margin-bottom: 15px;
        }

        .section-intro {
            max-width: 750px;
            margin: 0 auto 35px;
            color: var(--muted);
        }

        .about-content {
            max-width: 900px;
            margin: auto;
            color: var(--muted);
            font-size: 17px;
        }

        .features {
            background: var(--surface);
        }

        .card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 22px;
            margin-top: 35px;
        }

        .feature-card {
            background: var(--bg);
            border: 1px solid var(--border);
            padding: 25px;
            border-radius: 14px;
            text-align: left;
            transition: transform 0.2s;
        }

        .feature-card:hover {
            transform: translateY(-5px);
        }

        .feature-card .emoji {
            font-size: 35px;
            margin-bottom: 12px;
        }

        .feature-card h3 {
            margin-bottom: 10px;
        }

        .feature-card p {
            color: var(--muted);
        }

        .steps {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 18px;
            margin-top: 35px;
        }

        .step-card {
            background: var(--surface);
            border: 1px solid var(--border);
            padding: 22px 15px;
            border-radius: 12px;
        }

        .step-number {
            background: var(--accent);
            color: white;
            width: 38px;
            height: 38px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 12px;
            font-weight: bold;
        }

        .categories {
            background: var(--surface);
        }

        .category-card {
            padding: 28px;
            border-radius: 12px;
            border: 1px solid var(--border);
            background: var(--bg);
            font-size: 20px;
            font-weight: bold;
        }

        .cta {
            background: linear-gradient(135deg, #4c1d95, #7e22ce);
            color: white;
            padding: 65px 20px;
            text-align: center;
        }

        .cta h2 {
            color: white;
            font-size: 32px;
            margin-bottom: 12px;
        }

        .cta p {
            color: #f3e8ff;
            margin-bottom: 25px;
        }

        .cta a {
            display: inline-block;
            background: white;
            color: #6d28d9;
            padding: 13px 25px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
        }

        footer {
            text-align: center;
            padding: 25px;
            background: var(--surface);
            color: var(--muted);
            border-top: 1px solid var(--border);
        }

        @media(max-width: 700px) {
            .navbar {
                justify-content: center;
            }

            .nav-links {
                justify-content: center;
            }

            .hero h1 {
                font-size: 36px;
            }

            .section h2 {
                font-size: 27px;
            }
        }
    </style>
</head>

<body>

<%
    String cp = request.getContextPath();
%>

<!-- NAVIGATION BAR -->
<nav class="navbar">

    <div class="logo">⚡ CodeQuest</div>

    <div class="nav-links">

        <a href="<%= cp %>/index.jsp">Home</a>

        <a href="#about">About</a>

        <a href="<%= cp %>/register.jsp">
            Student Register
        </a>

        <a href="<%= cp %>/login.jsp">
            Student Login
        </a>

        <a href="<%= cp %>/admin-login.jsp">
            Admin Login
        </a>

        <button type="button"
                class="theme-toggle"
                id="themeToggle"
                onclick="toggleTheme()">
            ☀️ Light Mode
        </button>

    </div>

</nav>


<!-- HERO SECTION -->
<section class="hero">

    <h1>Welcome to CodeQuest ⚡</h1>

    <p>
        Learn Programming. Solve Challenges. Earn XP.
        Level Up Your Coding Skills!
    </p>

    <p>
        Turn your programming journey into an exciting learning adventure.
    </p>

    <div class="hero-buttons">

        <a href="<%= cp %>/register.jsp" class="primary-btn">
            Start Your Journey
        </a>

        <a href="#about" class="secondary-btn">
            Explore CodeQuest
        </a>

    </div>

</section>


<!-- ABOUT SECTION -->
<section class="section" id="about">

    <h2>About CodeQuest</h2>

    <p class="section-intro">
        Your journey from learning programming to becoming a confident
        problem solver starts here.
    </p>

    <div class="about-content">

        <p>
            CodeQuest is a programming learning platform designed to make
            learning coding more interactive, engaging and enjoyable.
        </p>

        <br>

        <p>
            Instead of only studying programming concepts, students can
            practice their knowledge by solving programming-related
            missions and challenges.
        </p>

        <br>

        <p>
            Students earn Experience Points (XP) by completing missions,
            track their learning progress, improve their levels and
            compare their achievements through a leaderboard.
        </p>

        <br>

        <p>
            Administrators can manage missions and monitor student
            performance through the admin dashboard.
        </p>

    </div>

</section>


<!-- FEATURES SECTION -->
<section class="section features">

    <h2>What Makes CodeQuest Special?</h2>

    <p class="section-intro">
        Learn, practice, track and improve your programming skills.
    </p>

    <div class="card-grid">

        <div class="feature-card">
            <div class="emoji">🎯</div>
            <h3>Interactive Missions</h3>
            <p>
                Solve programming challenges with different difficulty
                levels and categories.
            </p>
        </div>

        <div class="feature-card">
            <div class="emoji">⭐</div>
            <h3>Earn XP Points</h3>
            <p>
                Earn experience points by correctly solving missions
                and improving your performance.
            </p>
        </div>

        <div class="feature-card">
            <div class="emoji">🚀</div>
            <h3>Level Up</h3>
            <p>
                Track your coding journey and work towards improving
                your player level.
            </p>
        </div>

        <div class="feature-card">
            <div class="emoji">📊</div>
            <h3>Progress Tracking</h3>
            <p>
                View completed missions, correct answers, accuracy
                and your learning history.
            </p>
        </div>

        <div class="feature-card">
            <div class="emoji">🏆</div>
            <h3>Leaderboard</h3>
            <p>
                Compare your XP and achievements with other students.
            </p>
        </div>

        <div class="feature-card">
            <div class="emoji">🛠️</div>
            <h3>Admin Management</h3>
            <p>
                Administrators can create, edit and delete missions
                and manage student accounts.
            </p>
        </div>

    </div>

</section>


<!-- HOW IT WORKS -->
<section class="section">

    <h2>How CodeQuest Works</h2>

    <p class="section-intro">
        Follow these simple steps to begin your coding journey.
    </p>

    <div class="steps">

        <div class="step-card">
            <div class="step-number">1</div>
            <h3>Register</h3>
            <p>Create your student account.</p>
        </div>

        <div class="step-card">
            <div class="step-number">2</div>
            <h3>Login</h3>
            <p>Enter your CodeQuest dashboard.</p>
        </div>

        <div class="step-card">
            <div class="step-number">3</div>
            <h3>Solve Missions</h3>
            <p>Choose and solve available challenges.</p>
        </div>

        <div class="step-card">
            <div class="step-number">4</div>
            <h3>Earn XP</h3>
            <p>Get XP for correct answers.</p>
        </div>

        <div class="step-card">
            <div class="step-number">5</div>
            <h3>Track Progress</h3>
            <p>Monitor your learning achievements.</p>
        </div>

    </div>

</section>


<!-- CATEGORIES -->
<section class="section categories">

    <h2>Explore Learning Categories</h2>

    <p class="section-intro">
        Practice important programming and computer science topics.
    </p>

    <div class="card-grid">

        <div class="category-card">
            ☕ Java Programming
        </div>

        <div class="category-card">
            🗄️ SQL
        </div>

        <div class="category-card">
            🧠 Data Structures & Algorithms
        </div>

    </div>

</section>


<!-- CALL TO ACTION -->
<section class="cta">

    <h2>Your Coding Adventure Starts Here!</h2>

    <p>
        Take your first step towards becoming a better programmer.
        Join CodeQuest today!
    </p>

    <a href="<%= cp %>/register.jsp">
        Register Now →
    </a>

</section>


<!-- FOOTER -->
<footer>

    <h3>⚡ CodeQuest</h3>

    <p>Learn. Code. Conquer.</p>

    <p>© 2026 CodeQuest. All Rights Reserved.</p>

</footer>

</body>
</html>