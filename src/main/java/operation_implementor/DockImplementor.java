package operation_implementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import db_config.DBConfig;
import model.Dock;
import operations.DockOperations;

public class DockImplementor implements DockOperations {

    @Override
    public boolean addDock(Dock dock) {
        boolean flag = false;

        String sql = "INSERT INTO dock (dock_name, status) VALUES (?, ?)";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, dock.getDockName());
            ps.setString(2, dock.getStatus());

            flag = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

    @Override
    public boolean updateDock(Dock dock) {
        boolean flag = false;

        String sql = "UPDATE dock SET dock_name=?, status=? WHERE dock_id=?";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, dock.getDockName());
            ps.setString(2, dock.getStatus());
            ps.setInt(3, dock.getDockId());

            flag = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

    @Override
    public boolean deleteDock(int dockId) {
        boolean flag = false;

        String checkSql = "SELECT COUNT(*) FROM dock_allocation WHERE dock_id=? AND release_time IS NULL";
        String deleteSql = "DELETE FROM dock WHERE dock_id=?";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement checkPs = con.prepareStatement(checkSql)) {

            checkPs.setInt(1, dockId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                return false; // active allocation present
            }

            try (PreparedStatement deletePs = con.prepareStatement(deleteSql)) {
                deletePs.setInt(1, dockId);
                flag = deletePs.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

    @Override
    public List<Dock> getAllDocks() {
        List<Dock> list = new ArrayList<Dock>();

        String sql =
            "SELECT d.dock_id, d.dock_name, d.status, s.ship_name " +
            "FROM dock d " +
            "LEFT JOIN dock_allocation da ON d.dock_id = da.dock_id AND da.release_time IS NULL " +
            "LEFT JOIN ship s ON da.ship_id = s.ship_id " +
            "ORDER BY d.dock_id DESC";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Dock d = new Dock();
                d.setDockId(rs.getInt("dock_id"));
                d.setDockName(rs.getString("dock_name"));
                d.setStatus(rs.getString("status"));

                String shipName = rs.getString("ship_name");
                if (shipName == null || shipName.trim().isEmpty()) {
                    shipName = "No Ship Assigned";
                }
                d.setAssignedShipName(shipName);

                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Dock> searchDocks(String dockId, String dockName, String status) {
        List<Dock> list = new ArrayList<Dock>();

        String sql =
            "SELECT d.dock_id, d.dock_name, d.status, s.ship_name " +
            "FROM dock d " +
            "LEFT JOIN dock_allocation da ON d.dock_id = da.dock_id AND da.release_time IS NULL " +
            "LEFT JOIN ship s ON da.ship_id = s.ship_id " +
            "WHERE 1=1 ";

        if (dockId != null && !dockId.trim().isEmpty()) {
            sql += " AND CAST(d.dock_id AS CHAR) LIKE ? ";
        }
        if (dockName != null && !dockName.trim().isEmpty()) {
            sql += " AND d.dock_name LIKE ? ";
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND d.status = ? ";
        }

        sql += " ORDER BY d.dock_id DESC";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int i = 1;

            if (dockId != null && !dockId.trim().isEmpty()) {
                ps.setString(i++, "%" + dockId + "%");
            }
            if (dockName != null && !dockName.trim().isEmpty()) {
                ps.setString(i++, "%" + dockName + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(i++, status);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Dock d = new Dock();
                d.setDockId(rs.getInt("dock_id"));
                d.setDockName(rs.getString("dock_name"));
                d.setStatus(rs.getString("status"));

                String shipName = rs.getString("ship_name");
                if (shipName == null || shipName.trim().isEmpty()) {
                    shipName = "No Ship Assigned";
                }
                d.setAssignedShipName(shipName);

                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public Dock getDockById(int dockId) {
        Dock d = null;

        String sql = "SELECT dock_id, dock_name, status FROM dock WHERE dock_id=?";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, dockId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                d = new Dock();
                d.setDockId(rs.getInt("dock_id"));
                d.setDockName(rs.getString("dock_name"));
                d.setStatus(rs.getString("status"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return d;
    }
}