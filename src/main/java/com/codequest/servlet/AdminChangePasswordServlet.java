
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

@WebServlet("/admin/change-password")
public class AdminChangePasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/admin-change-password.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
            return;
        }

        int adminId = (Integer) session.getAttribute("adminId");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || newPassword == null ||
            confirmPassword == null ||
            currentPassword.isEmpty() || newPassword.isEmpty() ||
            confirmPassword.isEmpty()) {

            response.sendRedirect(request.getContextPath()
                    + "/admin/change-password?error=empty");
            return;
        }

        if (newPassword.length() < 8) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/change-password?error=length");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/change-password?error=mismatch");
            return;
        }

        String selectSql = "SELECT password FROM admins WHERE id = ?";
        String updateSql = "UPDATE admins SET password = ? WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement selectPs = con.prepareStatement(selectSql)) {

            selectPs.setInt(1, adminId);

            try (ResultSet rs = selectPs.executeQuery()) {

                if (!rs.next()) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/change-password?error=failed");
                    return;
                }

                String storedPassword = rs.getString("password");

                if (!PasswordUtil.verifyPassword(
                        currentPassword, storedPassword)) {

                    response.sendRedirect(request.getContextPath()
                            + "/admin/change-password?error=current");
                    return;
                }
            }

            String hashedPassword = PasswordUtil.hashPassword(newPassword);

            try (PreparedStatement updatePs = con.prepareStatement(updateSql)) {

                updatePs.setString(1, hashedPassword);
                updatePs.setInt(2, adminId);

                if (updatePs.executeUpdate() > 0) {
                    session.invalidate();

                    response.sendRedirect(request.getContextPath()
                            + "/admin-login.jsp?passwordChanged=success");
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/change-password?error=failed");
                }
            }

        } catch (Exception e) {
            throw new ServletException("Unable to change admin password.", e);
        }
    }
}