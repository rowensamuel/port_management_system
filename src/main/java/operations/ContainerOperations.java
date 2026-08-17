package operations;

import java.util.List;
import model.Cargo;
import model.Container;
import model.Ship;

public interface ContainerOperations {

    boolean addContainer(Container c);

    boolean updateContainer(Container c);

    boolean deleteContainer(int containerId);

    List<Container> getAllContainers();

    List<Container> searchAndFilterContainers(String containerId, String type, String shipId, String status);

    Container getContainerById(int containerId);

    List<Cargo> getCargoByContainerId(int containerId);

    List<Ship> getAllShips();
}