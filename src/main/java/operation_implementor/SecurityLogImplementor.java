package operation_implementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import db_config.DBConfig;
import model.SecurityLog;
import operations.SecurityLogOperations;

public class SecurityLogImplementor implements SecurityLogOperations {

    private SecurityLog mapResultSet(ResultSet rs) throws Exception {
        SecurityLog s = new SecurityLog();

        s.setLogId(rs.getInt("log_id"));
        s.setUserId(rs.getInt("user_id"));
        s.setUsername(rs.getString("username"));
        s.setRoleName(rs.getString("role_name"));

        s.setEntryTime(
            rs.getTimestamp("entry_time") == null
                ? "-"
                : rs.getTimestamp("entry_time").toString()
        );

        s.setExitTime(
            rs.getTimestamp("exit_time") == null
                ? "Still Logged In"
                : rs.getTimestamp("exit_time").toString()
        );

        s.setDuration(rs.getString("duration"));

        return s;
    }

    @Override
    public List<SecurityLog> getAllLogs() {
        List<SecurityLog> list = new ArrayList<>();

        String sql = "SELECT sl.log_id, u.user_id, u.name AS username, r.role_name, "
                   + "sl.entry_time, sl.exit_time, "
                   + "CASE "
                   + " WHEN sl.exit_time IS NULL THEN 'Active Session' "
                   + " WHEN TIMESTAMPDIFF(MINUTE, sl.entry_time, sl.exit_time) < 1 THEN 'Less than 1 min' "
                   + " WHEN TIMESTAMPDIFF(MINUTE, sl.entry_time, sl.exit_time) = 1 THEN '1 min' "
                   + " ELSE CONCAT(TIMESTAMPDIFF(MINUTE, sl.entry_time, sl.exit_time), ' mins') "
                   + "END AS duration "
                   + "FROM security_log sl "
                   + "JOIN `user` u ON sl.user_id = u.user_id "
                   + "JOIN role r ON u.role_id = r.role_id "
                   + "ORDER BY sl.log_id DESC";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSet(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<SecurityLog> searchLogs(String username, String role, String fromDate, String toDate) {
        List<SecurityLog> list = new ArrayList<>();

        String sql = "SELECT sl.log_id, u.user_id, u.name AS username, r.role_name, "
                   + "sl.entry_time, sl.exit_time, "
                   + "CASE "
                   + " WHEN sl.exit_time IS NULL THEN 'Active Session' "
                   + " WHEN TIMESTAMPDIFF(MINUTE, sl.entry_time, sl.exit_time) < 1 THEN 'Less than 1 min' "
                   + " WHEN TIMESTAMPDIFF(MINUTE, sl.entry_time, sl.exit_time) = 1 THEN '1 min' "
                   + " ELSE CONCAT(TIMESTAMPDIFF(MINUTE, sl.entry_time, sl.exit_time), ' mins') "
                   + "END AS duration "
                   + "FROM security_log sl "
                   + "JOIN `user` u ON sl.user_id = u.user_id "
                   + "JOIN role r ON u.role_id = r.role_id "
                   + "WHERE 1=1 ";

        if (username != null && !username.trim().isEmpty()) {
            sql += " AND u.name LIKE ? ";
        }

        if (role != null && !role.trim().isEmpty() && !"All Roles".equalsIgnoreCase(role)) {
            sql += " AND r.role_name = ? ";
        }

        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql += " AND DATE(sl.entry_time) >= ? ";
        }

        if (toDate != null && !toDate.trim().isEmpty()) {
            sql += " AND DATE(sl.entry_time) <= ? ";
        }

        sql += " ORDER BY sl.log_id DESC";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            int index = 1;

            if (username != null && !username.trim().isEmpty()) {
                pst.setString(index++, "%" + username + "%");
            }

            if (role != null && !role.trim().isEmpty() && !"All Roles".equalsIgnoreCase(role)) {
                pst.setString(index++, role);
            }

            if (fromDate != null && !fromDate.trim().isEmpty()) {
                pst.setString(index++, fromDate);
            }

            if (toDate != null && !toDate.trim().isEmpty()) {
                pst.setString(index++, toDate);
            }

            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSet(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}