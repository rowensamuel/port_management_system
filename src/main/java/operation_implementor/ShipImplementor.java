package operation_implementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import db_config.DBConfig;
import model.Ship;
import operations.ShipOperations;

public class ShipImplementor implements ShipOperations {

    @Override
    public boolean addShip(Ship ship) {
        boolean flag = false;

        String sql = "INSERT INTO ship (ship_name, arrival_date, departure_date, status, operator_id) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, ship.getShipName());
            ps.setString(2, ship.getArrivalDate());

            if (ship.getDepartureDate() != null && !ship.getDepartureDate().trim().isEmpty()) {
                ps.setString(3, ship.getDepartureDate());
            } else {
                ps.setNull(3, Types.TIMESTAMP);
            }

            ps.setString(4, ship.getStatus());
            ps.setInt(5, ship.getOperatorId());

            flag = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

    @Override
    public boolean updateShip(Ship ship) {
        boolean flag = false;

        String sql = "UPDATE ship SET ship_name=?, arrival_date=?, departure_date=?, status=?, operator_id=? WHERE ship_id=?";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, ship.getShipName());
            ps.setString(2, ship.getArrivalDate());

            if (ship.getDepartureDate() != null && !ship.getDepartureDate().trim().isEmpty()) {
                ps.setString(3, ship.getDepartureDate());
            } else {
                ps.setNull(3, Types.TIMESTAMP);
            }

            ps.setString(4, ship.getStatus());
            ps.setInt(5, ship.getOperatorId());
            ps.setInt(6, ship.getShipId());

            flag = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

    @Override
    public boolean deleteShip(int shipId) {
        boolean flag = false;

        Connection con = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;
        PreparedStatement ps3 = null;
        PreparedStatement ps4 = null;

        try {
            con = DBConfig.getConnection();
            con.setAutoCommit(false);

            // 1. pehle cargo delete karo jo is ship ke containers me hai
            ps1 = con.prepareStatement(
                "DELETE FROM cargo WHERE container_id IN (SELECT container_id FROM container WHERE ship_id=?)"
            );
            ps1.setInt(1, shipId);
            ps1.executeUpdate();

            // 2. phir container delete karo
            ps2 = con.prepareStatement("DELETE FROM container WHERE ship_id=?");
            ps2.setInt(1, shipId);
            ps2.executeUpdate();

            // 3. phir dock allocation delete karo
            ps3 = con.prepareStatement("DELETE FROM dock_allocation WHERE ship_id=?");
            ps3.setInt(1, shipId);
            ps3.executeUpdate();

            // 4. finally ship delete karo
            ps4 = con.prepareStatement("DELETE FROM ship WHERE ship_id=?");
            ps4.setInt(1, shipId);

            int rows = ps4.executeUpdate();

            if (rows > 0) {
                con.commit();
                flag = true;
            } else {
                con.rollback();
            }

        } catch (Exception e) {
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (ps1 != null) ps1.close();
            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                if (ps2 != null) ps2.close();
            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                if (ps3 != null) ps3.close();
            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                if (ps4 != null) ps4.close();
            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return flag;
    }

    @Override
    public List<Ship> getAllShips() {
        List<Ship> list = new ArrayList<Ship>();

        String sql = "SELECT ship_id, ship_name, arrival_date, departure_date, status, operator_id FROM ship ORDER BY ship_id DESC";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Ship ship = new Ship();
                ship.setShipId(rs.getInt("ship_id"));
                ship.setShipName(rs.getString("ship_name"));
                ship.setArrivalDate(rs.getString("arrival_date"));
                ship.setDepartureDate(rs.getString("departure_date"));
                ship.setStatus(rs.getString("status"));
                ship.setOperatorId(rs.getInt("operator_id"));
                list.add(ship);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Ship> searchShips(String shipId, String shipName, String operatorId, String status) {
        List<Ship> list = new ArrayList<Ship>();

        String sql = "SELECT ship_id, ship_name, arrival_date, departure_date, status, operator_id "
                   + "FROM ship WHERE 1=1 ";

        if (shipId != null && !shipId.trim().isEmpty()) {
            sql += " AND CAST(ship_id AS CHAR) LIKE ? ";
        }
        if (shipName != null && !shipName.trim().isEmpty()) {
            sql += " AND ship_name LIKE ? ";
        }
        if (operatorId != null && !operatorId.trim().isEmpty()) {
            sql += " AND CAST(operator_id AS CHAR) LIKE ? ";
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND status = ? ";
        }

        sql += " ORDER BY ship_id DESC";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int i = 1;

            if (shipId != null && !shipId.trim().isEmpty()) {
                ps.setString(i++, "%" + shipId + "%");
            }
            if (shipName != null && !shipName.trim().isEmpty()) {
                ps.setString(i++, "%" + shipName + "%");
            }
            if (operatorId != null && !operatorId.trim().isEmpty()) {
                ps.setString(i++, "%" + operatorId + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(i++, status);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Ship ship = new Ship();
                ship.setShipId(rs.getInt("ship_id"));
                ship.setShipName(rs.getString("ship_name"));
                ship.setArrivalDate(rs.getString("arrival_date"));
                ship.setDepartureDate(rs.getString("departure_date"));
                ship.setStatus(rs.getString("status"));
                ship.setOperatorId(rs.getInt("operator_id"));
                list.add(ship);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public Ship getShipById(int shipId) {
        Ship ship = null;

        String sql = "SELECT ship_id, ship_name, arrival_date, departure_date, status, operator_id "
                   + "FROM ship WHERE ship_id=?";

        try (Connection con = DBConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, shipId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                ship = new Ship();
                ship.setShipId(rs.getInt("ship_id"));
                ship.setShipName(rs.getString("ship_name"));
                ship.setArrivalDate(rs.getString("arrival_date"));
                ship.setDepartureDate(rs.getString("departure_date"));
                ship.setStatus(rs.getString("status"));
                ship.setOperatorId(rs.getInt("operator_id"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ship;
    }
}