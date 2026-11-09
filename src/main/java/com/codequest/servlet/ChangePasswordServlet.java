
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

@WebServlet("/student/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        request.getRequestDispatcher(
                "/WEB-INF/change-password.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String currentPassword =
                request.getParameter("currentPassword");

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");

        if (currentPassword == null || newPassword == null
                || confirmPassword == null
                || currentPassword.isEmpty()
                || newPassword.isEmpty()
                || confirmPassword.isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/profile?passwordError=empty");
            return;
        }

        if (newPassword.length() < 8) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/student/profile?passwordError=short");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/student/profile?passwordError=mismatch");
            return;
        }

        String selectSql =
                "SELECT password FROM users WHERE id = ?";

        String updateSql =
                "UPDATE users SET password = ? WHERE id = ?";

        try (Connection con = DBConnection.getConnection()) {

            String storedHash;

            try (PreparedStatement ps =
                    con.prepareStatement(selectSql)) {

                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {
                        response.sendRedirect(
                                request.getContextPath() + "/login.jsp");
                        return;
                    }

                    storedHash = rs.getString("password");
                }
            }

            if (!PasswordUtil.verifyPassword(
                    currentPassword, storedHash)) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/student/profile?passwordError=incorrect");
                return;
            }

            String newHash =
                    PasswordUtil.hashPassword(newPassword);

            try (PreparedStatement ps =
                    con.prepareStatement(updateSql)) {

                ps.setString(1, newHash);
                ps.setInt(2, userId);

                int rows = ps.executeUpdate();

                if (rows == 1) {

                    // End the current student session
                    session.invalidate();

                    // Redirect to login page
                    response.sendRedirect(
                            request.getContextPath()
                            + "/login.jsp?passwordChanged=success");
                } else {
                    response.sendRedirect(
                            request.getContextPath()
                            + "/student/profile?passwordError=failed");
                }
            }

        } catch (Exception e) {
            getServletContext().log("Password change failed", e);

            response.sendRedirect(
                    request.getContextPath()
                    + "/student/profile?passwordError=failed");
        }
    }
}