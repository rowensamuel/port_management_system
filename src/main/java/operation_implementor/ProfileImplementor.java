package operation_implementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import db_config.DBConfig;
import model.Profile;
import operations.ProfileOperations;

public class ProfileImplementor implements ProfileOperations {

    @Override
    public Profile getProfile(int userId) {
        Profile p = null;

        String sql = "SELECT u.user_id, u.name, u.email, r.role_name "
                   + "FROM `user` u "
                   + "JOIN role r ON u.role_id = r.role_id "
                   + "WHERE u.user_id = ?";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setInt(1, userId);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                p = new Profile();
                p.setUserId(rs.getInt("user_id"));
                p.setName(rs.getString("name"));
                p.setEmail(rs.getString("email"));
                p.setRoleName(rs.getString("role_name"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return p;
    }

    @Override
    public boolean updateName(int userId, String newName) {
        boolean status = false;

        String sql = "UPDATE `user` SET name=? WHERE user_id=?";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setString(1, newName);
            pst.setInt(2, userId);

            status = pst.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    @Override
    public String updateEmail(int userId, String newEmail) {

        String checkSql = "SELECT user_id FROM `user` WHERE email=? AND user_id<>?";
        String updateSql = "UPDATE `user` SET email=? WHERE user_id=?";

        try (Connection con = DBConfig.getConnection()) {

            try (PreparedStatement checkPst = con.prepareStatement(checkSql)) {
                checkPst.setString(1, newEmail);
                checkPst.setInt(2, userId);

                ResultSet rs = checkPst.executeQuery();
                if (rs.next()) {
                    return "Email already exists";
                }
            }

            try (PreparedStatement pst = con.prepareStatement(updateSql)) {
                pst.setString(1, newEmail);
                pst.setInt(2, userId);

                int row = pst.executeUpdate();
                if (row > 0) {
                    return "Email updated successfully";
                } else {
                    return "Email update failed";
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "Something went wrong";
        }
    }

    @Override
    public String changePassword(int userId, String currentPassword, String newPassword) {

        String checkSql = "SELECT user_id FROM `user` WHERE user_id=? AND password=SHA2(?,256)";
        String updateSql = "UPDATE `user` SET password=SHA2(?,256) WHERE user_id=?";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement checkPst = con.prepareStatement(checkSql)) {

            checkPst.setInt(1, userId);
            checkPst.setString(2, currentPassword);

            ResultSet rs = checkPst.executeQuery();

            if (!rs.next()) {
                return "Current password is incorrect";
            }

            try (PreparedStatement updatePst = con.prepareStatement(updateSql)) {
                updatePst.setString(1, newPassword);
                updatePst.setInt(2, userId);

                int row = updatePst.executeUpdate();

                if (row > 0) {
                    return "Password changed successfully";
                } else {
                    return "Password update failed";
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            return "Something went wrong";
        }
    }
}