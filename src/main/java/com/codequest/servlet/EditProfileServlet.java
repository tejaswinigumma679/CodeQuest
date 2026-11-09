
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/student/edit-profile")
public class EditProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private boolean isStudentLoggedIn(HttpSession session) {
        return session != null
                && session.getAttribute("userId") != null;
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isStudentLoggedIn(session)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String sql = "SELECT username, email FROM users WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    request.setAttribute("username",
                            rs.getString("username"));

                    request.setAttribute("email",
                            rs.getString("email"));

                    request.getRequestDispatcher(
                            "/WEB-INF/edit-profile.jsp")
                            .forward(request, response);
                } else {
                    response.sendRedirect(
                            request.getContextPath() + "/login.jsp");
                }
            }

        } catch (Exception e) {
            getServletContext().log("Unable to load edit profile", e);
            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load profile details.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (!isStudentLoggedIn(session)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String username = request.getParameter("username");
        String email = request.getParameter("email");

        username = username == null ? "" : username.trim();
        email = email == null ? "" : email.trim();

        request.setAttribute("username", username);
        request.setAttribute("email", email);

        if (username.isEmpty() || email.isEmpty()
                || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {

            request.setAttribute("message",
                    "Please enter a valid username and email address.");

            request.getRequestDispatcher(
                    "/WEB-INF/edit-profile.jsp").forward(request, response);
            return;
        }

        String checkSql =
                "SELECT id FROM users " +
                "WHERE (username = ? OR email = ?) AND id <> ?";

        String updateSql =
                "UPDATE users SET username = ?, email = ? WHERE id = ?";

        try (Connection con = DBConnection.getConnection()) {

            try (PreparedStatement check = con.prepareStatement(checkSql)) {

                check.setString(1, username);
                check.setString(2, email);
                check.setInt(3, userId);

                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) {
                        request.setAttribute("message",
                                "Username or email is already used by another student.");

                        request.getRequestDispatcher(
                                "/WEB-INF/edit-profile.jsp")
                                .forward(request, response);
                        return;
                    }
                }
            }

            try (PreparedStatement update =
                    con.prepareStatement(updateSql)) {

                update.setString(1, username);
                update.setString(2, email);
                update.setInt(3, userId);

                int rows = update.executeUpdate();

                if (rows == 1) {
                    session.setAttribute("username", username);

                    response.sendRedirect(
                            request.getContextPath()
                            + "/student/profile?updated=success");
                } else {
                    request.setAttribute("message",
                            "Unable to update your profile.");

                    request.getRequestDispatcher(
                            "/WEB-INF/edit-profile.jsp")
                            .forward(request, response);
                }
            }

        } catch (Exception e) {
            getServletContext().log("Profile update failed", e);

            request.setAttribute("message",
                    "Something went wrong. Please try again.");

            request.getRequestDispatcher(
                    "/WEB-INF/edit-profile.jsp")
                    .forward(request, response);
        }
    }
}