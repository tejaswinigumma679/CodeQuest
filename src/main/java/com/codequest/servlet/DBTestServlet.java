
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import com.codequest.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/db-test")
public class DBTestServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        try (Connection con = DBConnection.getConnection()) {

            response.getWriter().println(
                    "CodeQuest database connection successful!");

            response.getWriter().println(
                    "Connected database: " + con.getCatalog());

        } catch (SQLException e) {

            getServletContext().log(
                    "CodeQuest database connection failed", e);

            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            response.getWriter().println(
                    "Database connection failed. " +
                    "Check the Eclipse Console for details.");
        }
    }
}