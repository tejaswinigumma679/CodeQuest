
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/student/settings")
public class SettingsServlet extends HttpServlet {

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

        request.getRequestDispatcher(
                "/WEB-INF/settings.jsp").forward(request, response);
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

        String theme = request.getParameter("theme");

        if (!"dark".equals(theme) && !"light".equals(theme)) {
            request.setAttribute("message", "Please select a valid theme.");
            request.getRequestDispatcher(
                    "/WEB-INF/settings.jsp").forward(request, response);
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String sql = "UPDATE users SET theme_preference = ? WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, theme);
            ps.setInt(2, userId);

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated == 1) {

                // Update the current student's session.
                session.setAttribute("theme", theme);

                response.sendRedirect(
                        request.getContextPath()
                        + "/student/settings?saved=success");

            } else {
                request.setAttribute(
                        "message", "Unable to update your settings.");

                request.getRequestDispatcher(
                        "/WEB-INF/settings.jsp").forward(request, response);
            }

        } catch (Exception e) {

            getServletContext().log("Student settings update failed", e);

            request.setAttribute(
                    "message", "Something went wrong. Please try again.");

            request.getRequestDispatcher(
                    "/WEB-INF/settings.jsp").forward(request, response);
        }
    }
}