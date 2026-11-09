
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/student/solve-mission")
public class SolveMissionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Check student login
    private int getUserId(HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            return -1;
        }

        return Integer.parseInt(
            session.getAttribute("userId").toString()
        );
    }

    // Get mission details without exposing the correct answer
    private Map<String, Object> getMission(Connection con, int id)
            throws Exception {

        String sql = "SELECT id, title, description, category, difficulty, "
                   + "option_a, option_b, option_c, option_d, xp_reward "
                   + "FROM missions WHERE id = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    return null;
                }

                Map<String, Object> mission = new HashMap<>();

                mission.put("id", rs.getInt("id"));
                mission.put("title", rs.getString("title"));
                mission.put("description", rs.getString("description"));
                mission.put("category", rs.getString("category"));
                mission.put("difficulty", rs.getString("difficulty"));

                mission.put("optionA", rs.getString("option_a"));
                mission.put("optionB", rs.getString("option_b"));
                mission.put("optionC", rs.getString("option_c"));
                mission.put("optionD", rs.getString("option_d"));

                mission.put("xpReward", rs.getInt("xp_reward"));

                return mission;
            }
        }
    }

    // Open mission page
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        int userId = getUserId(request);

        if (userId == -1) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        try {

            int missionId = Integer.parseInt(
                request.getParameter("id")
            );

            try (Connection con = DBConnection.getConnection()) {

                Map<String, Object> mission =
                    getMission(con, missionId);

                if (mission == null) {
                    response.sendRedirect(
                        request.getContextPath()
                        + "/student/missions?error=notfound"
                    );
                    return;
                }

                // Check previous attempt
                String checkSql =
                    "SELECT is_correct FROM mission_submissions "
                    + "WHERE user_id = ? AND mission_id = ?";

                try (PreparedStatement ps =
                        con.prepareStatement(checkSql)) {

                    ps.setInt(1, userId);
                    ps.setInt(2, missionId);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (rs.next()) {
                            request.setAttribute(
                                "alreadyAttempted", true
                            );

                            request.setAttribute(
                                "previousCorrect",
                                rs.getBoolean("is_correct")
                            );
                        }
                    }
                }

                request.setAttribute("mission", mission);

                request.getRequestDispatcher(
                    "/WEB-INF/solve-mission.jsp"
                ).forward(request, response);
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                request.getContextPath()
                + "/student/missions?error=invalidid"
            );

        } catch (Exception e) {
            throw new ServletException(
                "Unable to open mission.", e
            );
        }
    }

    // Submit student's answer
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        int userId = getUserId(request);

        if (userId == -1) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        request.setCharacterEncoding("UTF-8");

        int missionId;

        try {
            missionId = Integer.parseInt(
                request.getParameter("id")
            );
        } catch (NumberFormatException e) {
            response.sendRedirect(
                request.getContextPath() + "/student/missions"
            );
            return;
        }

        String answer = request.getParameter("answer");

        if (!("A".equals(answer) || "B".equals(answer)
                || "C".equals(answer) || "D".equals(answer))) {

            response.sendRedirect(
                request.getContextPath()
                + "/student/solve-mission?id=" + missionId
            );
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try {

                // Lock student record to serialize their submissions
                String lockSql =
                    "SELECT id FROM users WHERE id = ? FOR UPDATE";

                try (PreparedStatement ps =
                        con.prepareStatement(lockSql)) {

                    ps.setInt(1, userId);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (!rs.next()) {
                            con.rollback();

                            response.sendRedirect(
                                request.getContextPath() + "/login.jsp"
                            );
                            return;
                        }
                    }
                }

                // Check whether the student already attempted
                String checkSql =
                    "SELECT id FROM mission_submissions "
                    + "WHERE user_id = ? AND mission_id = ?";

                try (PreparedStatement ps =
                        con.prepareStatement(checkSql)) {

                    ps.setInt(1, userId);
                    ps.setInt(2, missionId);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (rs.next()) {

                            con.rollback();

                            request.setAttribute(
                                "resultMessage",
                                "You have already attempted this mission."
                            );

                            request.setAttribute(
                                "resultType", "warning"
                            );

                            request.setAttribute(
                                "alreadyAttempted", true
                            );

                            try (Connection readCon =
                                    DBConnection.getConnection()) {

                                Map<String, Object> mission =
                                    getMission(readCon, missionId);

                                if (mission == null) {
                                    response.sendRedirect(
                                        request.getContextPath()
                                        + "/student/missions"
                                    );
                                    return;
                                }

                                request.setAttribute("mission", mission);

                                request.getRequestDispatcher(
                                    "/WEB-INF/solve-mission.jsp"
                                ).forward(request, response);
                            }

                            return;
                        }
                    }
                }

                // Get correct answer and XP from database
                String missionSql =
                    "SELECT correct_answer, xp_reward "
                    + "FROM missions WHERE id = ?";

                String correctAnswer;
                int xpReward;

                try (PreparedStatement ps =
                        con.prepareStatement(missionSql)) {

                    ps.setInt(1, missionId);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (!rs.next()) {
                            con.rollback();

                            response.sendRedirect(
                                request.getContextPath()
                                + "/student/missions?error=notfound"
                            );
                            return;
                        }

                        correctAnswer = rs.getString("correct_answer");
                        xpReward = rs.getInt("xp_reward");
                    }
                }

                // Check answer
                boolean isCorrect =
                    answer.equalsIgnoreCase(correctAnswer);

                // Insert submission
                String insertSql =
                    "INSERT INTO mission_submissions "
                    + "(user_id, mission_id, answer, is_correct) "
                    + "VALUES (?, ?, ?, ?)";

                try (PreparedStatement ps =
                        con.prepareStatement(insertSql)) {

                    ps.setInt(1, userId);
                    ps.setInt(2, missionId);
                    ps.setString(3, answer);
                    ps.setBoolean(4, isCorrect);

                    ps.executeUpdate();
                }

                // Award XP only if answer is correct
                int earnedXp = 0;

                if (isCorrect) {

                    String updateSql =
                        "UPDATE users SET total_xp = total_xp + ? "
                        + "WHERE id = ?";

                    try (PreparedStatement ps =
                            con.prepareStatement(updateSql)) {

                        ps.setInt(1, xpReward);
                        ps.setInt(2, userId);

                        ps.executeUpdate();
                    }

                    earnedXp = xpReward;
                }

                // Read updated XP
                int totalXp;

                String xpSql =
                    "SELECT total_xp FROM users WHERE id = ?";

                try (PreparedStatement ps =
                        con.prepareStatement(xpSql)) {

                    ps.setInt(1, userId);

                    try (ResultSet rs = ps.executeQuery()) {
                        rs.next();
                        totalXp = rs.getInt("total_xp");
                    }
                }

                // Commit all database changes
                con.commit();

                HttpSession session = request.getSession(false);

                session.setAttribute("totalXp", totalXp);

                request.setAttribute("isCorrect", isCorrect);
                request.setAttribute("earnedXp", earnedXp);
                request.setAttribute("totalXp", totalXp);

                request.setAttribute(
                    "resultMessage",
                    isCorrect
                    ? "Correct answer! Congratulations!"
                    : "Incorrect answer. Better luck next time!"
                );

                request.setAttribute(
                    "resultType",
                    isCorrect ? "success" : "danger"
                );

                request.setAttribute("alreadyAttempted", true);

                try (Connection readCon =
                        DBConnection.getConnection()) {

                    Map<String, Object> mission =
                        getMission(readCon, missionId);

                    request.setAttribute("mission", mission);

                    request.getRequestDispatcher(
                        "/WEB-INF/solve-mission.jsp"
                    ).forward(request, response);
                }

            } catch (Exception e) {

                con.rollback();
                throw e;
            }

        } catch (Exception e) {

            throw new ServletException(
                "Unable to submit mission answer.", e
            );
        }
    }
}