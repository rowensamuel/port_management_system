package operation_implementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import db_config.DBConfig;
import model.Cargo;
import model.CargoMovement;
import model.Container;
import operations.CargoHandlingOperations;

public class CargoHandlingImplementor implements CargoHandlingOperations {

    @Override
    public boolean addCargo(Cargo c) {
        boolean flag = false;

        String sql = "INSERT INTO cargo (container_id, description, weight, status) VALUES (?, ?, ?, ?)";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, c.getContainerId());
            ps.setString(2, c.getDescription());
            ps.setDouble(3, c.getWeight());
            ps.setString(4, c.getStatus());

            flag = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

    @Override
    public boolean updateCargo(Cargo c) {
        boolean flag = false;

        String sql = "UPDATE cargo SET container_id=?, description=?, weight=?, status=? WHERE cargo_id=?";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, c.getContainerId());
            ps.setString(2, c.getDescription());
            ps.setDouble(3, c.getWeight());
            ps.setString(4, c.getStatus());
            ps.setInt(5, c.getCargoId());

            flag = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

    @Override
    public boolean deleteCargo(int cargoId) {
        boolean flag = false;

        String checkSql = "SELECT COUNT(*) FROM cargo_movement WHERE cargo_id=?";
        String deleteSql = "DELETE FROM cargo WHERE cargo_id=?";

        try (Connection con = DBConfig.getConnection()) {

            try (PreparedStatement ps1 = con.prepareStatement(checkSql)) {
                ps1.setInt(1, cargoId);
                ResultSet rs = ps1.executeQuery();

                if (rs.next() && rs.getInt(1) > 0) {
                    return false;
                }
            }

            try (PreparedStatement ps2 = con.prepareStatement(deleteSql)) {
                ps2.setInt(1, cargoId);
                flag = ps2.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

    @Override
    public List<Cargo> getAllCargo() {
        List<Cargo> list = new ArrayList<Cargo>();

        String sql = "SELECT cg.cargo_id, cg.container_id, cg.description, cg.weight, cg.status, "
                   + "c.container_type, c.status AS container_status, s.ship_name "
                   + "FROM cargo cg "
                   + "LEFT JOIN container c ON cg.container_id = c.container_id "
                   + "LEFT JOIN ship s ON c.ship_id = s.ship_id "
                   + "ORDER BY cg.cargo_id DESC";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Cargo c = new Cargo();
                c.setCargoId(rs.getInt("cargo_id"));
                c.setContainerId(rs.getInt("container_id"));
                c.setDescription(rs.getString("description"));
                c.setWeight(rs.getDouble("weight"));
                c.setStatus(rs.getString("status"));
                c.setContainerType(rs.getString("container_type"));
                c.setContainerStatus(rs.getString("container_status"));
                c.setShipName(rs.getString("ship_name"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Cargo> searchCargo(String cargoId, String containerId, String status, String description) {
        List<Cargo> list = new ArrayList<Cargo>();

        String sql = "SELECT cg.cargo_id, cg.container_id, cg.description, cg.weight, cg.status, "
                   + "c.container_type, c.status AS container_status, s.ship_name "
                   + "FROM cargo cg "
                   + "LEFT JOIN container c ON cg.container_id = c.container_id "
                   + "LEFT JOIN ship s ON c.ship_id = s.ship_id "
                   + "WHERE 1=1 ";

        if (cargoId != null && !cargoId.trim().isEmpty()) {
            sql += " AND CAST(cg.cargo_id AS CHAR) LIKE ? ";
        }
        if (containerId != null && !containerId.trim().isEmpty()) {
            sql += " AND CAST(cg.container_id AS CHAR) LIKE ? ";
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND cg.status = ? ";
        }
        if (description != null && !description.trim().isEmpty()) {
            sql += " AND cg.description LIKE ? ";
        }

        sql += " ORDER BY cg.cargo_id DESC";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int i = 1;

            if (cargoId != null && !cargoId.trim().isEmpty()) {
                ps.setString(i++, "%" + cargoId + "%");
            }
            if (containerId != null && !containerId.trim().isEmpty()) {
                ps.setString(i++, "%" + containerId + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(i++, status);
            }
            if (description != null && !description.trim().isEmpty()) {
                ps.setString(i++, "%" + description + "%");
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Cargo c = new Cargo();
                c.setCargoId(rs.getInt("cargo_id"));
                c.setContainerId(rs.getInt("container_id"));
                c.setDescription(rs.getString("description"));
                c.setWeight(rs.getDouble("weight"));
                c.setStatus(rs.getString("status"));
                c.setContainerType(rs.getString("container_type"));
                c.setContainerStatus(rs.getString("container_status"));
                c.setShipName(rs.getString("ship_name"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public Cargo getCargoById(int cargoId) {
        Cargo c = null;

        String sql = "SELECT cg.cargo_id, cg.container_id, cg.description, cg.weight, cg.status, "
                   + "c.container_type, c.status AS container_status, s.ship_name "
                   + "FROM cargo cg "
                   + "LEFT JOIN container c ON cg.container_id = c.container_id "
                   + "LEFT JOIN ship s ON c.ship_id = s.ship_id "
                   + "WHERE cg.cargo_id=?";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cargoId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                c = new Cargo();
                c.setCargoId(rs.getInt("cargo_id"));
                c.setContainerId(rs.getInt("container_id"));
                c.setDescription(rs.getString("description"));
                c.setWeight(rs.getDouble("weight"));
                c.setStatus(rs.getString("status"));
                c.setContainerType(rs.getString("container_type"));
                c.setContainerStatus(rs.getString("container_status"));
                c.setShipName(rs.getString("ship_name"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return c;
    }

    @Override
    public List<Container> getAllContainersForCargo() {
        List<Container> list = new ArrayList<Container>();

        String sql = "SELECT c.container_id, c.container_type, c.status, s.ship_name "
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
                c.setStatus(rs.getString("status"));
                c.setShipName(rs.getString("ship_name"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public Container getContainerDetails(int containerId) {
        Container c = null;

        String sql = "SELECT c.container_id, c.container_type, c.status, c.ship_id, s.ship_name "
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
                c.setStatus(rs.getString("status"));
                c.setShipId(rs.getInt("ship_id"));
                c.setShipName(rs.getString("ship_name"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return c;
    }

    @Override
    public boolean addMovement(CargoMovement m) {
        boolean flag = false;

        String sql = "INSERT INTO cargo_movement (cargo_id, movement_type, movement_date, handled_by) VALUES (?, ?, ?, ?)";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, m.getCargoId());
            ps.setString(2, m.getMovementType());

            if (m.getMovementDate() == null || m.getMovementDate().trim().isEmpty()) {
                ps.setNull(3, Types.TIMESTAMP);
            } else {
                ps.setString(3, m.getMovementDate());
            }

            ps.setInt(4, m.getHandledBy());

            flag = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

    @Override
    public List<CargoMovement> getMovementHistoryByCargo(int cargoId) {
        List<CargoMovement> list = new ArrayList<CargoMovement>();

        String sql = "SELECT cm.movement_id, cm.cargo_id, cg.description, cm.movement_type, cm.movement_date, "
                   + "cm.handled_by, u.name "
                   + "FROM cargo_movement cm "
                   + "LEFT JOIN cargo cg ON cm.cargo_id = cg.cargo_id "
                   + "LEFT JOIN user u ON cm.handled_by = u.user_id "
                   + "WHERE cm.cargo_id=? "
                   + "ORDER BY cm.movement_date DESC, cm.movement_id DESC";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cargoId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CargoMovement m = new CargoMovement();
                m.setMovementId(rs.getInt("movement_id"));
                m.setCargoId(rs.getInt("cargo_id"));
                m.setCargoDescription(rs.getString("description"));
                m.setMovementType(rs.getString("movement_type"));
                m.setMovementDate(String.valueOf(rs.getTimestamp("movement_date")));
                m.setHandledBy(rs.getInt("handled_by"));
                m.setHandlerName(rs.getString("name"));
                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<CargoMovement> getAllMovements() {
        List<CargoMovement> list = new ArrayList<CargoMovement>();

        String sql = "SELECT cm.movement_id, cm.cargo_id, cg.description, cm.movement_type, cm.movement_date, "
                   + "cm.handled_by, u.name "
                   + "FROM cargo_movement cm "
                   + "LEFT JOIN cargo cg ON cm.cargo_id = cg.cargo_id "
                   + "LEFT JOIN user u ON cm.handled_by = u.user_id "
                   + "ORDER BY cm.movement_date DESC, cm.movement_id DESC";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                CargoMovement m = new CargoMovement();
                m.setMovementId(rs.getInt("movement_id"));
                m.setCargoId(rs.getInt("cargo_id"));
                m.setCargoDescription(rs.getString("description"));
                m.setMovementType(rs.getString("movement_type"));
                m.setMovementDate(String.valueOf(rs.getTimestamp("movement_date")));
                m.setHandledBy(rs.getInt("handled_by"));
                m.setHandlerName(rs.getString("name"));
                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}