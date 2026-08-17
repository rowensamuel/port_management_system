package operation_implementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import db_config.DBConfig;
import model.Dock;
import model.DockAllocation;
import model.Ship;
import operations.DockAllocationOperations;

public class DockAllocationImplementor implements DockAllocationOperations {

    @Override
    public List<Ship> getShipsForAllocation() {
        List<Ship> list = new ArrayList<Ship>();

        String sql = "SELECT s.ship_id, s.ship_name, s.status, "
                   + "CASE WHEN EXISTS (SELECT 1 FROM dock_allocation da WHERE da.ship_id=s.ship_id AND da.release_time IS NULL) "
                   + "THEN 1 ELSE 0 END AS allocated "
                   + "FROM ship s "
                   + "WHERE s.status IN ('ANCHORED','ARRIVED','DOCKED') "
                   + "ORDER BY s.ship_id DESC";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                Ship s = new Ship();
                s.setShipId(rs.getInt("ship_id"));
                s.setShipName(rs.getString("ship_name"));
                s.setStatus(rs.getString("status"));
                s.setAllocated(rs.getInt("allocated") == 1);
                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Dock> getAvailableDocks() {
        List<Dock> list = new ArrayList<Dock>();

        String sql = "SELECT dock_id, dock_name, status FROM dock WHERE status='AVAILABLE' ORDER BY dock_id";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                Dock d = new Dock();
                d.setDockId(rs.getInt("dock_id"));
                d.setDockName(rs.getString("dock_name"));
                d.setStatus(rs.getString("status"));
                list.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<DockAllocation> getActiveAllocations() {
        return getActiveAllocations(0, 5);
    }

    @Override
    public List<DockAllocation> getReleasedAllocations() {
        return getReleasedAllocations(0, 5);
    }

    @Override
    public List<DockAllocation> getActiveAllocations(int start, int limit) {
        List<DockAllocation> list = new ArrayList<DockAllocation>();

        String sql = "SELECT da.allocation_id, da.ship_id, s.ship_name, da.dock_id, d.dock_name, d.status, "
                   + "da.allocation_time, da.release_time "
                   + "FROM dock_allocation da "
                   + "JOIN ship s ON da.ship_id = s.ship_id "
                   + "JOIN dock d ON da.dock_id = d.dock_id "
                   + "WHERE da.release_time IS NULL "
                   + "ORDER BY da.allocation_id DESC "
                   + "LIMIT ? OFFSET ?";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setInt(1, limit);
            pst.setInt(2, start);

            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    DockAllocation da = new DockAllocation();
                    da.setAllocationId(rs.getInt("allocation_id"));
                    da.setShipId(rs.getInt("ship_id"));
                    da.setShipName(rs.getString("ship_name"));
                    da.setDockId(rs.getInt("dock_id"));
                    da.setDockName(rs.getString("dock_name"));
                    da.setDockStatus(rs.getString("status"));
                    da.setAllocationTime(String.valueOf(rs.getTimestamp("allocation_time")));
                    da.setReleaseTime(String.valueOf(rs.getTimestamp("release_time")));
                    list.add(da);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<DockAllocation> getReleasedAllocations(int start, int limit) {
        List<DockAllocation> list = new ArrayList<DockAllocation>();

        String sql = "SELECT da.allocation_id, da.ship_id, s.ship_name, da.dock_id, d.dock_name, d.status, "
                   + "da.allocation_time, da.release_time "
                   + "FROM dock_allocation da "
                   + "JOIN ship s ON da.ship_id = s.ship_id "
                   + "JOIN dock d ON da.dock_id = d.dock_id "
                   + "WHERE da.release_time IS NOT NULL "
                   + "ORDER BY da.allocation_id DESC "
                   + "LIMIT ? OFFSET ?";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setInt(1, limit);
            pst.setInt(2, start);

            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    DockAllocation da = new DockAllocation();
                    da.setAllocationId(rs.getInt("allocation_id"));
                    da.setShipId(rs.getInt("ship_id"));
                    da.setShipName(rs.getString("ship_name"));
                    da.setDockId(rs.getInt("dock_id"));
                    da.setDockName(rs.getString("dock_name"));
                    da.setDockStatus(rs.getString("status"));
                    da.setAllocationTime(String.valueOf(rs.getTimestamp("allocation_time")));
                    da.setReleaseTime(String.valueOf(rs.getTimestamp("release_time")));
                    list.add(da);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public int getActiveAllocationCount() {
        int count = 0;

        String sql = "SELECT COUNT(*) FROM dock_allocation WHERE release_time IS NULL";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    @Override
    public int getReleasedAllocationCount() {
        int count = 0;

        String sql = "SELECT COUNT(*) FROM dock_allocation WHERE release_time IS NOT NULL";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    @Override
    public boolean allocateDock(int shipId, int dockId, int userId, String allocationTime) {
        boolean status = false;

        String insertSql = "INSERT INTO dock_allocation(ship_id, dock_id, allocation_time, release_time) VALUES (?, ?, ?, NULL)";
        String updateDock = "UPDATE dock SET status='OCCUPIED' WHERE dock_id=?";
        String updateShip = "UPDATE ship SET status='DOCKED' WHERE ship_id=?";

        try (Connection con = DBConfig.getConnection()) {
            con.setAutoCommit(false);

            try (PreparedStatement pst1 = con.prepareStatement(insertSql);
                 PreparedStatement pst2 = con.prepareStatement(updateDock);
                 PreparedStatement pst3 = con.prepareStatement(updateShip)) {

                pst1.setInt(1, shipId);
                pst1.setInt(2, dockId);
                pst1.setString(3, allocationTime);
                pst1.executeUpdate();

                pst2.setInt(1, dockId);
                pst2.executeUpdate();

                pst3.setInt(1, shipId);
                pst3.executeUpdate();

                con.commit();
                status = true;

            } catch (Exception e) {
                con.rollback();
                e.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    @Override
    public boolean releaseDock(int allocationId) {
        boolean status = false;

        String getDockSql = "SELECT dock_id, ship_id FROM dock_allocation WHERE allocation_id=?";
        String releaseSql = "UPDATE dock_allocation SET release_time=NOW() WHERE allocation_id=?";
        String updateDock = "UPDATE dock SET status='AVAILABLE' WHERE dock_id=?";
        String updateShip = "UPDATE ship SET status='DEPARTED', departure_date=NOW() WHERE ship_id=?";

        try (Connection con = DBConfig.getConnection()) {
            con.setAutoCommit(false);

            int dockId = 0;
            int shipId = 0;

            try (PreparedStatement pst = con.prepareStatement(getDockSql)) {
                pst.setInt(1, allocationId);

                try (ResultSet rs = pst.executeQuery()) {
                    if (rs.next()) {
                        dockId = rs.getInt("dock_id");
                        shipId = rs.getInt("ship_id");
                    }
                }
            }

            if (dockId == 0 || shipId == 0) {
                con.rollback();
                return false;
            }

            try (PreparedStatement pst1 = con.prepareStatement(releaseSql);
                 PreparedStatement pst2 = con.prepareStatement(updateDock);
                 PreparedStatement pst3 = con.prepareStatement(updateShip)) {

                pst1.setInt(1, allocationId);
                pst1.executeUpdate();

                pst2.setInt(1, dockId);
                pst2.executeUpdate();

                pst3.setInt(1, shipId);
                pst3.executeUpdate();

                con.commit();
                status = true;

            } catch (Exception e) {
                con.rollback();
                e.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
}