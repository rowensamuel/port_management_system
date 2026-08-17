package operations;

import java.util.List;
import model.Cargo;
import model.CargoMovement;
import model.Container;

public interface CargoHandlingOperations {

    // Cargo Management
    boolean addCargo(Cargo c);
    boolean updateCargo(Cargo c);
    boolean deleteCargo(int cargoId);

    List<Cargo> getAllCargo();
    List<Cargo> searchCargo(String cargoId, String containerId, String status, String description);
    Cargo getCargoById(int cargoId);

    // Container support
    List<Container> getAllContainersForCargo();
    Container getContainerDetails(int containerId);

    // Movement
    boolean addMovement(CargoMovement m);
    List<CargoMovement> getMovementHistoryByCargo(int cargoId);
    List<CargoMovement> getAllMovements();
}