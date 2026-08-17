package db_config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConfig {

    public static Connection getConnection() {
        Connection con = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/port_management_system?useSSL=false&serverTimezone=UTC",
                "root",
                ""
            );

        } catch (Exception e) {
            e.printStackTrace();
        }

        return con;
    }
}