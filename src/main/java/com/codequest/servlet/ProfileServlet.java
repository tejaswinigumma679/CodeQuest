
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

@WebServlet("/student/profile")
public class ProfileServlet extends HttpServlet {

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

        int userId = (Integer) session.getAttribute("userId");

        String sql = "SELECT id, username, email, created_at " +
                     "FROM users WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

            	if (rs.next()) {

            	    request.setAttribute("studentId", rs.getInt("id"));
            	    request.setAttribute("username", rs.getString("username"));
            	    request.setAttribute("email", rs.getString("email"));
            	    request.setAttribute("createdAt", rs.getTimestamp("created_at"));

            	    request.getRequestDispatcher(
            	        "/WEB-INF/student-profile.jsp"
            	    ).forward(request, response);
            	} else {
                    response.sendRedirect(
                        request.getContextPath() + "/login.jsp");
                }
            }

        } catch (Exception e) {
            getServletContext().log("Unable to load student profile", e);
            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load profile.");
        }
    }
}