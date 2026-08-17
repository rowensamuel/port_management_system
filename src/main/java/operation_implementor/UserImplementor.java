package operation_implementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import db_config.DBConfig;
import model.User;
import operations.UserOperations;

public class UserImplementor implements UserOperations {

    @Override
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<User>();

        String sql = "SELECT u.user_id, u.name, u.email, u.role_id, r.role_name, u.is_active "
                   + "FROM `user` u "
                   + "JOIN role r ON u.role_id = r.role_id "
                   + "ORDER BY u.user_id DESC";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setRoleId(rs.getInt("role_id"));
                u.setRoleName(rs.getString("role_name"));
                u.setActive(rs.getBoolean("is_active"));
                list.add(u);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public boolean addUser(User u) {
        boolean status = false;

        String checkSql = "SELECT user_id FROM `user` WHERE email=?";
        String sql = "INSERT INTO `user` (name, email, password, role_id, is_active) "
                   + "VALUES (?, ?, SHA2(?,256), ?, 1)";

        try (Connection con = DBConfig.getConnection()) {

            try (PreparedStatement checkPst = con.prepareStatement(checkSql)) {
                checkPst.setString(1, u.getEmail());
                ResultSet rs = checkPst.executeQuery();
                if (rs.next()) {
                    return false;
                }
            }

            try (PreparedStatement pst = con.prepareStatement(sql)) {
                pst.setString(1, u.getName());
                pst.setString(2, u.getEmail());
                pst.setString(3, u.getPassword());
                pst.setInt(4, u.getRoleId());

                status = pst.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    @Override
    public boolean updateUser(User u) {
        boolean status = false;

        String checkSql = "SELECT user_id FROM `user` WHERE email=? AND user_id<>?";
        String sql = "UPDATE `user` SET name=?, email=?, role_id=? WHERE user_id=?";

        try (Connection con = DBConfig.getConnection()) {

            try (PreparedStatement checkPst = con.prepareStatement(checkSql)) {
                checkPst.setString(1, u.getEmail());
                checkPst.setInt(2, u.getUserId());

                ResultSet rs = checkPst.executeQuery();
                if (rs.next()) {
                    return false;
                }
            }

            try (PreparedStatement pst = con.prepareStatement(sql)) {
                pst.setString(1, u.getName());
                pst.setString(2, u.getEmail());
                pst.setInt(3, u.getRoleId());
                pst.setInt(4, u.getUserId());

                status = pst.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    @Override
    public boolean updateRole(int userId, int roleId) {
        boolean status = false;

        String sql = "UPDATE `user` SET role_id=? WHERE user_id=?";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setInt(1, roleId);
            pst.setInt(2, userId);

            status = pst.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    @Override
    public boolean toggleStatus(int userId, boolean statusValue) {
        boolean status = false;

        String sql = "UPDATE `user` SET is_active=? WHERE user_id=?";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setBoolean(1, statusValue);
            pst.setInt(2, userId);

            status = pst.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
}