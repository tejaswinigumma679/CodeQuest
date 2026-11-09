
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.codequest.util.DBConnection;

@WebServlet("/admin/delete-student")
public class DeleteStudentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();

        // Check admin authentication
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(contextPath + "/admin-login.jsp");
            return;
        }

        // Get student ID
        String studentIdValue = request.getParameter("studentId");

        int studentId;

        try {
            studentId = Integer.parseInt(studentIdValue);

            if (studentId <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(
                contextPath + "/admin/students?error=invalid"
            );
            return;
        }

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 1. Delete the student's mission submissions
            String deleteSubmissions =
                "DELETE FROM mission_submissions WHERE user_id = ?";

            try (PreparedStatement ps =
                    con.prepareStatement(deleteSubmissions)) {

                ps.setInt(1, studentId);
                ps.executeUpdate();
            }

            // 2. Delete the student account
            String deleteStudent =
                "DELETE FROM users WHERE id = ?";

            int deletedRows;

            try (PreparedStatement ps =
                    con.prepareStatement(deleteStudent)) {

                ps.setInt(1, studentId);
                deletedRows = ps.executeUpdate();
            }

            if (deletedRows == 0) {
                con.rollback();

                response.sendRedirect(
                    contextPath + "/admin/students?error=notfound"
                );
                return;
            }

            // 3. Commit both deletions
            con.commit();

            response.sendRedirect(
                contextPath + "/admin/students?deleted=success"
            );

        } catch (Exception e) {

            if (con != null) {
                try {
                    con.rollback();
                } catch (Exception rollbackError) {
                    e.addSuppressed(rollbackError);
                }
            }

            throw new ServletException(
                "Error deleting student account", e
            );

        } finally {

            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (Exception closeError) {
                    log("Error closing database connection", closeError);
                }
            }
        }
    }
}