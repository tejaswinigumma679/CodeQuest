
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

@WebServlet("/student/leaderboard")
public class LeaderboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check student login
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        int currentUserId = (Integer) session.getAttribute("userId");

        String sql =
            "SELECT id, username, total_xp, player_level " +
            "FROM users " +
            "ORDER BY total_xp DESC, player_level DESC, username ASC";

        ArrayList<Map<String, Object>> leaderboard =
            new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            int rank = 1;

            while (rs.next()) {

                Map<String, Object> student = new HashMap<>();

                int studentId = rs.getInt("id");

                student.put("rank", rank);
                student.put("username", rs.getString("username"));
                student.put("totalXp", rs.getInt("total_xp"));
                student.put("playerLevel", rs.getInt("player_level"));
                student.put("currentUser", studentId == currentUserId);

                leaderboard.add(student);

                rank++;
            }

            request.setAttribute("leaderboard", leaderboard);

            request.getRequestDispatcher(
                "/WEB-INF/leaderboard.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Error loading leaderboard", e
            );
        }
    }
}