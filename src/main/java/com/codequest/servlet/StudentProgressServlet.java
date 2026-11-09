
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

@WebServlet("/student/progress")
public class StudentProgressServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check whether student is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        try (Connection con = DBConnection.getConnection()) {

            // 1. Get student information
            String userSql =
                "SELECT username, total_xp, player_level " +
                "FROM users WHERE id = ?";

            try (PreparedStatement ps = con.prepareStatement(userSql)) {

                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        request.setAttribute(
                            "username", rs.getString("username")
                        );

                        request.setAttribute(
                            "totalXp", rs.getInt("total_xp")
                        );

                        request.setAttribute(
                            "playerLevel", rs.getInt("player_level")
                        );
                    } else {
                        session.invalidate();
                        response.sendRedirect(
                            request.getContextPath() + "/login.jsp"
                        );
                        return;
                    }
                }
            }

            // 2. Get mission statistics
            String statsSql =
                "SELECT COUNT(*) AS total_missions, " +
                "SUM(CASE WHEN is_correct = TRUE THEN 1 ELSE 0 END) AS correct_answers, " +
                "SUM(CASE WHEN is_correct = FALSE THEN 1 ELSE 0 END) AS incorrect_answers " +
                "FROM mission_submissions WHERE user_id = ?";

            try (PreparedStatement ps = con.prepareStatement(statsSql)) {

                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        request.setAttribute(
                            "totalMissions", rs.getInt("total_missions")
                        );

                        request.setAttribute(
                            "correctAnswers", rs.getInt("correct_answers")
                        );

                        request.setAttribute(
                            "incorrectAnswers", rs.getInt("incorrect_answers")
                        );
                    }
                }
            }

            // 3. Get mission history
            String historySql =
                "SELECT m.title, m.category, m.difficulty, " +
                "m.xp_reward, s.answer, s.is_correct, s.completed_at " +
                "FROM mission_submissions s " +
                "JOIN missions m ON s.mission_id = m.id " +
                "WHERE s.user_id = ? " +
                "ORDER BY s.completed_at DESC";

            ArrayList<Map<String, Object>> history = new ArrayList<>();

            try (PreparedStatement ps = con.prepareStatement(historySql)) {

                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {

                        Map<String, Object> item = new HashMap<>();

                        item.put("title", rs.getString("title"));
                        item.put("category", rs.getString("category"));
                        item.put("difficulty", rs.getString("difficulty"));
                        item.put("xpReward", rs.getInt("xp_reward"));
                        item.put("answer", rs.getString("answer"));
                        item.put("correct", rs.getBoolean("is_correct"));
                        item.put("completedAt", rs.getTimestamp("completed_at"));

                        history.add(item);
                    }
                }
            }

            request.setAttribute("history", history);

            // 4. Open Student Progress page
            request.getRequestDispatcher(
                "/WEB-INF/student-progress.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Error loading student progress", e
            );
        }
    }
}