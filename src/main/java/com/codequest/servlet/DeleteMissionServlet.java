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

@WebServlet("/admin/delete-mission")
public class DeleteMissionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            try (Connection con = DBConnection.getConnection()) {

                con.setAutoCommit(false);

                try {
                    // Check whether students have submitted this mission.
                    String checkSql =
                        "SELECT COUNT(*) FROM mission_submissions WHERE mission_id = ?";

                    int submissionCount = 0;

                    try (PreparedStatement checkPs = con.prepareStatement(checkSql)) {
                        checkPs.setInt(1, id);

                        try (ResultSet rs = checkPs.executeQuery()) {
                            if (rs.next()) {
                                submissionCount = rs.getInt(1);
                            }
                        }
                    }

                    if (submissionCount > 0) {
                        con.rollback();

                        response.sendRedirect(request.getContextPath()
                            + "/admin/manage-missions?error=has_submissions");
                        return;
                    }

                    // Delete only if no student submissions exist.
                    String deleteSql = "DELETE FROM missions WHERE id = ?";

                    int rowsDeleted;

                    try (PreparedStatement deletePs = con.prepareStatement(deleteSql)) {
                        deletePs.setInt(1, id);
                        rowsDeleted = deletePs.executeUpdate();
                    }

                    con.commit();

                    if (rowsDeleted > 0) {
                        response.sendRedirect(request.getContextPath()
                            + "/admin/manage-missions?deleted=success");
                    } else {
                        response.sendRedirect(request.getContextPath()
                            + "/admin/manage-missions?error=notfound");
                    }

                } catch (Exception e) {
                    con.rollback();
                    throw e;
                }
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                + "/admin/manage-missions?error=invalidid");

        } catch (Exception e) {
            throw new ServletException("Unable to delete mission.", e);
        }
    }
}