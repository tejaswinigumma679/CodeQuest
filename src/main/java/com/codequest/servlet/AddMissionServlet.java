
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/add-mission")
public class AddMissionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.sendRedirect(
                request.getContextPath() + "/admin-login");
            return;
        }

        request.getRequestDispatcher(
            "/WEB-INF/add-mission.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.sendRedirect(
                request.getContextPath() + "/admin-login");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String difficulty = request.getParameter("difficulty");

        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");

        String correctAnswer = request.getParameter("correctAnswer");
        String xpText = request.getParameter("xpReward");

        // Validate required fields.
        if (title == null || title.isBlank() ||
            description == null || description.isBlank() ||
            optionA == null || optionA.isBlank() ||
            optionB == null || optionB.isBlank() ||
            optionC == null || optionC.isBlank() ||
            optionD == null || optionD.isBlank()) {

            request.setAttribute("message", "Please fill in all fields.");
            request.getRequestDispatcher(
                "/WEB-INF/add-mission.jsp").forward(request, response);
            return;
        }

        // Validate category.
        if (!"Java".equals(category) &&
            !"SQL".equals(category) &&
            !"DSA".equals(category)) {

            request.setAttribute("message", "Invalid category.");
            request.getRequestDispatcher(
                "/WEB-INF/add-mission.jsp").forward(request, response);
            return;
        }

        // Validate difficulty.
        if (!"Easy".equals(difficulty) &&
            !"Medium".equals(difficulty) &&
            !"Hard".equals(difficulty)) {

            request.setAttribute("message", "Invalid difficulty.");
            request.getRequestDispatcher(
                "/WEB-INF/add-mission.jsp").forward(request, response);
            return;
        }

        // Validate correct answer.
        if (!"A".equals(correctAnswer) &&
            !"B".equals(correctAnswer) &&
            !"C".equals(correctAnswer) &&
            !"D".equals(correctAnswer)) {

            request.setAttribute("message", "Select a valid correct answer.");
            request.getRequestDispatcher(
                "/WEB-INF/add-mission.jsp").forward(request, response);
            return;
        }

        int xpReward;

        try {
            xpReward = Integer.parseInt(xpText);

            if (xpReward < 1 || xpReward > 1000) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {
            request.setAttribute(
                "message", "XP reward must be between 1 and 1000.");

            request.getRequestDispatcher(
                "/WEB-INF/add-mission.jsp").forward(request, response);
            return;
        }

        int adminId = (Integer) session.getAttribute("adminId");

        String sql = "INSERT INTO missions "
            + "(title, description, category, difficulty, "
            + "option_a, option_b, option_c, option_d, "
            + "correct_answer, xp_reward, created_by) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
            ps.setInt(11, adminId);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                request.setAttribute(
                    "message", "Mission added successfully!");
                request.setAttribute("success", true);
            }

            request.getRequestDispatcher(
                "/WEB-INF/add-mission.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to add mission.", e);
        }
    }
}