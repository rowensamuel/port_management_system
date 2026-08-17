package operation_implementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import db_config.DBConfig;
import model.User;
import operations.LoginOperations;

public class LoginImplementor implements LoginOperations {

    @Override
    public User login(String email, String password) {
        User user = null;

        String sql = "SELECT u.user_id, u.name, u.email, u.role_id, r.role_name, u.is_active "
                   + "FROM user u "
                   + "JOIN role r ON u.role_id = r.role_id "
                   + "WHERE u.email=? AND u.password=SHA2(?,256) AND u.is_active=1";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setString(1, email);
            pst.setString(2, password);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setRoleId(rs.getInt("role_id"));
                user.setRoleName(rs.getString("role_name"));
                user.setActive(rs.getBoolean("is_active"));

                insertLoginLog(con, user.getUserId());
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    private void insertLoginLog(Connection con, int userId) {
        String sql = "INSERT INTO security_log(user_id, entry_time, exit_time) VALUES (?, NOW(), NULL)";
        try (PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, userId);
            pst.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean logout(int userId) {
        boolean status = false;

        String sql = "UPDATE security_log SET exit_time = NOW() "
                   + "WHERE user_id=? AND exit_time IS NULL "
                   + "ORDER BY entry_time DESC LIMIT 1";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setInt(1, userId);
            status = pst.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
}