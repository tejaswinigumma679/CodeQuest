
package com.codequest.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.codequest.util.DBConnection;
import com.codequest.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword =
                request.getParameter("confirmPassword");

        if (username == null || email == null
                || password == null || confirmPassword == null) {
            showMessage(request, response,
                    "Please fill in all fields.");
            return;
        }

        username = username.trim();
        email = email.trim();

        if (username.isEmpty() || email.isEmpty()
                || username.length() > 50
                || email.length() > 100) {
            showMessage(request, response,
                    "Please enter a valid username and email.");
            return;
        }

        if (password.length() < 8) {
            showMessage(request, response,
                    "Password must contain at least 8 characters.");
            return;
        }

        if (!password.equals(confirmPassword)) {
            showMessage(request, response,
                    "Passwords do not match.");
            return;
        }

        String sql = "INSERT INTO users "
                + "(username, email, password) VALUES (?, ?, ?)";

        try {
            String hashedPassword =
                    PasswordUtil.hashPassword(password);

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, username);
                ps.setString(2, email);
                ps.setString(3, hashedPassword);

                ps.executeUpdate();
            }

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp?registered=success"
            );
            return;

        } catch (SQLException e) {

            if (e.getSQLState() != null
                    && e.getSQLState().startsWith("23")) {
                showMessage(request, response,
                        "That username or email may already be registered.");
            } else {
                getServletContext().log(
                        "Student registration failed", e);
                showMessage(request, response,
                        "Registration failed. Please try again.");
            }

        } catch (Exception e) {
            getServletContext().log(
                    "Password hashing failed", e);
            showMessage(request, response,
                    "Could not process your registration. Please try again.");
        }
    }

    private void showMessage(HttpServletRequest request,
            HttpServletResponse response, String message)
            throws ServletException, IOException {

        request.setAttribute("message", message);
        request.getRequestDispatcher("/register.jsp")
                .forward(request, response);
    }
}