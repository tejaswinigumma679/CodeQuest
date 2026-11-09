
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

@WebServlet("/admin/profile")
public class AdminProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/admin-login.jsp");
            return;
        }

        int adminId = (Integer) session.getAttribute("adminId");

        String sql = "SELECT id, username, email, created_at "
                   + "FROM admins WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    request.setAttribute("adminId", rs.getInt("id"));
                    request.setAttribute(
                        "adminUsername", rs.getString("username"));
                    request.setAttribute(
                        "adminEmail", rs.getString("email"));
                    request.setAttribute(
                        "adminCreatedAt", rs.getTimestamp("created_at"));

                    request.getRequestDispatcher(
                        "/WEB-INF/admin-profile.jsp")
                        .forward(request, response);

                } else {
                    response.sendRedirect(
                        request.getContextPath() + "/admin-login.jsp");
                }
            }

        } catch (Exception e) {
            throw new ServletException("Unable to load admin profile.", e);
        }
    }
}