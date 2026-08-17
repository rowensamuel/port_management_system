package operation_implementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import db_config.DBConfig;
import model.DashboardData;
import operations.DashboardOperations;

public class DashboardImplementor implements DashboardOperations {

    @Override
    public DashboardData getDashboardData() {
        DashboardData data = new DashboardData();

        try (Connection con = DBConfig.getConnection()) {
            data.setTotalShips(getCount(con, "SELECT COUNT(*) FROM ship"));
            data.setActiveAllocations(getCount(con, "SELECT COUNT(*) FROM dock_allocation WHERE release_time IS NULL"));
            data.setAvailableDocks(getCount(con, "SELECT COUNT(*) FROM dock WHERE status='AVAILABLE'"));
            data.setOccupiedDocks(getCount(con, "SELECT COUNT(*) FROM dock WHERE status='OCCUPIED'"));
        } catch (Exception e) {
            e.printStackTrace();
        }

        return data;
    }

    private int getCount(Connection con, String sql) {
        int count = 0;
        try (PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
}