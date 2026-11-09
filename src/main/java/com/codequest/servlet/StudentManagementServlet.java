
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.codequest.util.DBConnection;

@WebServlet("/admin/students")
public class StudentManagementServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check admin login
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/admin-login.jsp"
            );
            return;
        }

        String search = request.getParameter("search");

        if (search == null) {
            search = "";
        }

        ArrayList<Map<String, Object>> students = new ArrayList<>();

        String sql =
            "SELECT u.id, u.username, u.email, u.total_xp, " +
            "u.player_level, u.created_at, " +
            "COUNT(s.id) AS missions_attempted, " +
            "SUM(CASE WHEN s.is_correct = TRUE THEN 1 ELSE 0 END) AS correct_answers " +
            "FROM users u " +
            "LEFT JOIN mission_submissions s ON u.id = s.user_id " +
            "WHERE u.username LIKE ? OR u.email LIKE ? " +
            "GROUP BY u.id, u.username, u.email, u.total_xp, " +
            "u.player_level, u.created_at " +
            "ORDER BY u.id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + search + "%");
            ps.setString(2, "%" + search + "%");

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Map<String, Object> student = new HashMap<>();

                    student.put("id", rs.getInt("id"));
                    student.put("username", rs.getString("username"));
                    student.put("email", rs.getString("email"));
                    student.put("totalXp", rs.getInt("total_xp"));
                    student.put("playerLevel", rs.getInt("player_level"));
                    student.put("createdAt", rs.getTimestamp("created_at"));
                    student.put("missionsAttempted",
                        rs.getInt("missions_attempted"));
                    student.put("correctAnswers",
                        rs.getInt("correct_answers"));

                    students.add(student);
                }
            }

            request.setAttribute("students", students);
            request.setAttribute("search", search);

            request.getRequestDispatcher(
                "/WEB-INF/admin-students.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Error loading student management page", e
            );
        }
    }
}