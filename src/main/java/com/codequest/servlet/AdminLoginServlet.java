
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

@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/admin-login.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String sql = "SELECT id, username, password, email, created_at, "
                + "theme_preference FROM admins WHERE username=? OR email=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

        	ps.setString(1, username);
        	ps.setString(2, username);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next() && PasswordUtil.verifyPassword(password, rs.getString("password"))) {

                    HttpSession oldSession = request.getSession(false);

                    if (oldSession != null) {
                        oldSession.invalidate();
                    }

                    HttpSession session = request.getSession(true);
                    session.setMaxInactiveInterval(1800);

                    session.setAttribute("adminId", rs.getInt("id"));

                    session.setAttribute("adminUsername", rs.getString("username"));

                    session.setAttribute("adminEmail", rs.getString("email"));

                    session.setAttribute("adminCreatedAt", rs.getTimestamp("created_at"));

                    session.setAttribute("adminTheme", rs.getString("theme_preference"));

                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    return;
                }
            }

            request.setAttribute("message", "Invalid admin username or password.");

            request.getRequestDispatcher("/admin-login.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Admin login failed.", e);
        }
    }
}