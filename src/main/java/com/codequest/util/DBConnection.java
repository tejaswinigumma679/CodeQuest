
package com.codequest.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/codequest_db";

    private static final String USER = "root";

    private static final String PASSWORD =
            "Teju@143";

    public static Connection getConnection()
            throws SQLException {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                    "MySQL Connector/J driver was not found. "
                    + "Check WEB-INF/lib and Tomcat deployment.",
                    e
            );
        }

        return DriverManager.getConnection(
                URL, USER, PASSWORD
        );
    }
}
