
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.codequest.util.DBConnection;
import com.codequest.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String loginId = request.getParameter("loginId");
        String password = request.getParameter("password");

        if (loginId == null || password == null
                || loginId.trim().isEmpty()
                || password.isEmpty()) {

            showMessage(request, response,
                    "Enter your username/email and password.");
            return;
        }

        String sql = "SELECT id, username, password, "
                + "total_xp, player_level, theme_preference "
                + "FROM users WHERE username = ? OR email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, loginId.trim());
            ps.setString(2, loginId.trim());

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    showMessage(request, response,
                            "Invalid username/email or password.");
                    return;
                }

                String storedHash = rs.getString("password");

                boolean valid = PasswordUtil.verifyPassword(
                        password, storedHash);

                if (!valid) {
                    showMessage(request, response,
                            "Invalid username/email or password.");
                    return;
                }

                int userId = rs.getInt("id");
                String username = rs.getString("username");
                int totalXp = rs.getInt("total_xp");
                int playerLevel = rs.getInt("player_level");

                String theme = rs.getString("theme_preference");

                // Use dark theme if the database value is empty.
                if (theme == null
                        || (!theme.equals("dark") && !theme.equals("light"))) {
                    theme = "dark";
                }

                // Invalidate the old session after successful authentication.
                HttpSession oldSession = request.getSession(false);

                if (oldSession != null) {
                    oldSession.invalidate();
                }

                HttpSession session = request.getSession(true);
                session.setMaxInactiveInterval(30 * 60);

                session.setAttribute("userId", userId);
                session.setAttribute("username", username);
                session.setAttribute("totalXp", totalXp);
                session.setAttribute("playerLevel", playerLevel);

                // Store the student's selected theme.
                session.setAttribute("theme", theme);

                response.sendRedirect(
                        request.getContextPath() + "/dashboard");
            }

        } catch (Exception e) {

            getServletContext().log("Student login failed", e);

            showMessage(request, response,
                    "Login could not be completed. Please try again.");
        }
    }

    private void showMessage(HttpServletRequest request,
            HttpServletResponse response, String message)
            throws ServletException, IOException {

        request.setAttribute("message", message);

        request.getRequestDispatcher("/login.jsp")
                .forward(request, response);
    }
}