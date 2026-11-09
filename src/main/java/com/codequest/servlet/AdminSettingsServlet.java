
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

@WebServlet("/admin/settings")
public class AdminSettingsServlet extends HttpServlet {

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

        String sql = "SELECT theme_preference FROM admins WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, adminId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String theme = rs.getString("theme_preference");

                    if (!"light".equals(theme)) {
                        theme = "dark";
                    }

                    session.setAttribute("adminTheme", theme);
                    request.setAttribute("adminTheme", theme);

                    request.getRequestDispatcher("/WEB-INF/admin-settings.jsp")
                           .forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin-login.jsp");
                }
            }

        } catch (Exception e) {
            throw new ServletException("Unable to load admin settings.", e);
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
        String theme = request.getParameter("theme");

        if (!"dark".equals(theme) && !"light".equals(theme)) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/settings?error=invalid");
            return;
        }

        String sql = "UPDATE admins SET theme_preference = ? WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, theme);
            ps.setInt(2, adminId);

            if (ps.executeUpdate() > 0) {
                session.setAttribute("adminTheme", theme);

                response.sendRedirect(request.getContextPath()
                        + "/admin/settings?updated=success");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/admin/settings?error=failed");
            }

        } catch (Exception e) {
            throw new ServletException("Unable to save admin settings.", e);
        }
    }
}