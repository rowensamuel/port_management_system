package operations;

import java.util.List;
import model.Ship;

public interface ShipOperations {

    boolean addShip(Ship ship);

    boolean updateShip(Ship ship);

    boolean deleteShip(int shipId);

    List<Ship> getAllShips();

    List<Ship> searchShips(String shipId, String shipName, String operatorId, String status);

    Ship getShipById(int shipId);
}