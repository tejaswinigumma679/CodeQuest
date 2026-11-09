
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

@WebServlet("/admin/edit-profile")
public class AdminEditProfileServlet extends HttpServlet {

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

        int adminId = (Integer) session.getAttribute("adminId");

        String sql = "SELECT username, email FROM admins WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute("adminUsername", rs.getString("username"));
                    request.setAttribute("adminEmail", rs.getString("email"));

                    request.getRequestDispatcher("/WEB-INF/admin-edit-profile.jsp")
                           .forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
                }
            }

        } catch (Exception e) {
            throw new ServletException("Unable to load admin profile.", e);
        }
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

        String username = request.getParameter("username");
        String email = request.getParameter("email");

        if (username == null || email == null ||
            username.trim().isEmpty() || email.trim().isEmpty()) {

            response.sendRedirect(request.getContextPath()
                    + "/admin/edit-profile?error=empty");
            return;
        }

        username = username.trim();
        email = email.trim();

        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/edit-profile?error=email");
            return;
        }

        String checkSql = "SELECT id FROM admins "
                        + "WHERE (username = ? OR email = ?) AND id <> ?";

        String updateSql = "UPDATE admins SET username = ?, email = ? WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement checkPs = con.prepareStatement(checkSql)) {

            checkPs.setString(1, username);
            checkPs.setString(2, email);
            checkPs.setInt(3, adminId);

            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/edit-profile?error=exists");
                    return;
                }
            }

            try (PreparedStatement updatePs = con.prepareStatement(updateSql)) {
                updatePs.setString(1, username);
                updatePs.setString(2, email);
                updatePs.setInt(3, adminId);

                int updated = updatePs.executeUpdate();

                if (updated > 0) {
                    session.setAttribute("adminUsername", username);
                    session.setAttribute("adminEmail", email);

                    response.sendRedirect(request.getContextPath()
                            + "/admin/profile?updated=success");
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/admin/edit-profile?error=failed");
                }
            }

        } catch (Exception e) {
            throw new ServletException("Unable to update admin profile.", e);
        }
    }
}