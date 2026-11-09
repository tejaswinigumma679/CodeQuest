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

@WebServlet("/admin/edit-mission")
public class EditMissionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("adminId") != null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        String idValue = request.getParameter("id");

        try {
            int id = Integer.parseInt(idValue);

            String sql = "SELECT * FROM missions WHERE id = ?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, id);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
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
                        mission.put("correctAnswer", rs.getString("correct_answer"));
                        mission.put("xpReward", rs.getInt("xp_reward"));

                        request.setAttribute("mission", mission);
                        request.getRequestDispatcher("/WEB-INF/edit-mission.jsp")
                               .forward(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/manage-missions?error=notfound");
                    }
                }
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-missions?error=invalidid");
        } catch (Exception e) {
            throw new ServletException("Unable to load mission for editing.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String category = request.getParameter("category");
            String difficulty = request.getParameter("difficulty");
            String optionA = request.getParameter("optionA");
            String optionB = request.getParameter("optionB");
            String optionC = request.getParameter("optionC");
            String optionD = request.getParameter("optionD");
            String correctAnswer = request.getParameter("correctAnswer");
            int xpReward = Integer.parseInt(request.getParameter("xpReward"));

            if (title == null || title.trim().isEmpty()
                    || description == null || description.trim().isEmpty()
                    || optionA == null || optionA.trim().isEmpty()
                    || optionB == null || optionB.trim().isEmpty()
                    || optionC == null || optionC.trim().isEmpty()
                    || optionD == null || optionD.trim().isEmpty()
                    || !("Java".equals(category) || "SQL".equals(category) || "DSA".equals(category))
                    || !("Easy".equals(difficulty) || "Medium".equals(difficulty) || "Hard".equals(difficulty))
                    || !("A".equals(correctAnswer) || "B".equals(correctAnswer)
                         || "C".equals(correctAnswer) || "D".equals(correctAnswer))
                    || xpReward < 1 || xpReward > 1000) {

                request.setAttribute("errorMessage", "Please enter valid values in all fields.");
                doGet(request, response);
                return;
            }

            String sql = "UPDATE missions SET title=?, description=?, category=?, difficulty=?, "
                    + "option_a=?, option_b=?, option_c=?, option_d=?, correct_answer=?, xp_reward=? "
                    + "WHERE id=?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, title.trim());
                ps.setString(2, description.trim());
                ps.setString(3, category);
                ps.setString(4, difficulty);
                ps.setString(5, optionA.trim());
                ps.setString(6, optionB.trim());
                ps.setString(7, optionC.trim());
                ps.setString(8, optionD.trim());
                ps.setString(9, correctAnswer);
                ps.setInt(10, xpReward);
                ps.setInt(11, id);

                int rowsUpdated = ps.executeUpdate();

                if (rowsUpdated > 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/manage-missions?updated=success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/manage-missions?error=notfound");
                }
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-missions?error=invaliddata");
        } catch (Exception e) {
            throw new ServletException("Unable to update mission.", e);
        }
    }
}