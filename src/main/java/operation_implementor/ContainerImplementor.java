package operation_implementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import db_config.DBConfig;
import model.Cargo;
import model.Container;
import model.Ship;
import operations.ContainerOperations;

public class ContainerImplementor implements ContainerOperations {

    @Override
    public boolean addContainer(Container c) {
        boolean flag = false;

        String checkShipSql = "SELECT status FROM ship WHERE ship_id=?";
        String sql = "INSERT INTO container (container_type, ship_id, status) VALUES (?, ?, ?)";

        try (Connection con = DBConfig.getConnection()) {

            // ✅ only DOCKED ship allowed
            try (PreparedStatement checkPs = con.prepareStatement(checkShipSql)) {
                checkPs.setInt(1, c.getShipId());
                ResultSet rs = checkPs.executeQuery();

                if (rs.next()) {
                    String shipStatus = rs.getString("status");
                    if (!"DOCKED".equalsIgnoreCase(shipStatus)) {
                        return false;
                    }
                } else {
                    return false;
                }
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, c.getContainerType());
                ps.setInt(2, c.getShipId());
                ps.setString(3, c.getStatus());

                flag = ps.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

    @Override
    public boolean updateContainer(Container c) {
        boolean flag = false;

        String checkShipSql = "SELECT status FROM ship WHERE ship_id=?";
        String sql = "UPDATE container SET container_type=?, ship_id=?, status=? WHERE container_id=?";

        try (Connection con = DBConfig.getConnection()) {

            // ✅ only DOCKED ship allowed
            try (PreparedStatement checkPs = con.prepareStatement(checkShipSql)) {
                checkPs.setInt(1, c.getShipId());
                ResultSet rs = checkPs.executeQuery();

                if (rs.next()) {
                    String shipStatus = rs.getString("status");
                    if (!"DOCKED".equalsIgnoreCase(shipStatus)) {
                        return false;
                    }
                } else {
                    return false;
                }
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, c.getContainerType());
                ps.setInt(2, c.getShipId());
                ps.setString(3, c.getStatus());
                ps.setInt(4, c.getContainerId());

                flag = ps.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

    @Override
    public boolean deleteContainer(int containerId) {
        boolean flag = false;

        String checkCargoSql = "SELECT COUNT(*) FROM cargo WHERE container_id=?";
        String deleteSql = "DELETE FROM container WHERE container_id=?";

        try (Connection con = DBConfig.getConnection()) {

            try (PreparedStatement ps1 = con.prepareStatement(checkCargoSql)) {
                ps1.setInt(1, containerId);
                ResultSet rs = ps1.executeQuery();

                if (rs.next() && rs.getInt(1) > 0) {
                    return false;
                }
            }

            try (PreparedStatement ps2 = con.prepareStatement(deleteSql)) {
                ps2.setInt(1, containerId);
                flag = ps2.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

    @Override
    public List<Container> getAllContainers() {
        List<Container> list = new ArrayList<Container>();

        String sql = "SELECT c.container_id, c.container_type, c.ship_id, c.status, s.ship_name "
                   + "FROM container c "
                   + "LEFT JOIN ship s ON c.ship_id = s.ship_id "
                   + "ORDER BY c.container_id DESC";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Container c = new Container();
                c.setContainerId(rs.getInt("container_id"));
                c.setContainerType(rs.getString("container_type"));
                c.setShipId(rs.getInt("ship_id"));
                c.setShipName(rs.getString("ship_name"));
                c.setStatus(rs.getString("status"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Container> searchAndFilterContainers(String containerId, String type, String shipId, String status) {
        List<Container> list = new ArrayList<Container>();

        String sql = "SELECT c.container_id, c.container_type, c.ship_id, c.status, s.ship_name "
                   + "FROM container c "
                   + "LEFT JOIN ship s ON c.ship_id = s.ship_id "
                   + "WHERE 1=1 ";

        if (containerId != null && !containerId.trim().isEmpty()) {
            sql += " AND CAST(c.container_id AS CHAR) LIKE ? ";
        }
        if (type != null && !type.trim().isEmpty()) {
            sql += " AND c.container_type = ? ";
        }
        if (shipId != null && !shipId.trim().isEmpty()) {
            sql += " AND CAST(c.ship_id AS CHAR) LIKE ? ";
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND c.status = ? ";
        }

        sql += " ORDER BY c.container_id DESC";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int i = 1;

            if (containerId != null && !containerId.trim().isEmpty()) {
                ps.setString(i++, "%" + containerId + "%");
            }
            if (type != null && !type.trim().isEmpty()) {
                ps.setString(i++, type);
            }
            if (shipId != null && !shipId.trim().isEmpty()) {
                ps.setString(i++, "%" + shipId + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(i++, status);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Container c = new Container();
                c.setContainerId(rs.getInt("container_id"));
                c.setContainerType(rs.getString("container_type"));
                c.setShipId(rs.getInt("ship_id"));
                c.setShipName(rs.getString("ship_name"));
                c.setStatus(rs.getString("status"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public Container getContainerById(int containerId) {
        Container c = null;

        String sql = "SELECT c.container_id, c.container_type, c.ship_id, c.status, s.ship_name "
                   + "FROM container c "
                   + "LEFT JOIN ship s ON c.ship_id = s.ship_id "
                   + "WHERE c.container_id=?";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, containerId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                c = new Container();
                c.setContainerId(rs.getInt("container_id"));
                c.setContainerType(rs.getString("container_type"));
                c.setShipId(rs.getInt("ship_id"));
                c.setShipName(rs.getString("ship_name"));
                c.setStatus(rs.getString("status"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return c;
    }

    @Override
    public List<Cargo> getCargoByContainerId(int containerId) {
        List<Cargo> list = new ArrayList<Cargo>();

        String sql = "SELECT cargo_id, container_id, description, weight, status "
                   + "FROM cargo WHERE container_id=? ORDER BY cargo_id DESC";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, containerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Cargo cg = new Cargo();
                cg.setCargoId(rs.getInt("cargo_id"));
                cg.setContainerId(rs.getInt("container_id"));
                cg.setDescription(rs.getString("description"));
                cg.setWeight(rs.getDouble("weight"));
                cg.setStatus(rs.getString("status"));
                list.add(cg);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Ship> getAllShips() {
        List<Ship> list = new ArrayList<Ship>();

        // ✅ only docked ships for assign-to-ship dropdown
        String sql = "SELECT ship_id, ship_name, status FROM ship WHERE status='DOCKED' ORDER BY ship_id DESC";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Ship s = new Ship();
                s.setShipId(rs.getInt("ship_id"));
                s.setShipName(rs.getString("ship_name"));
                s.setStatus(rs.getString("status"));
                list.add(s);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}