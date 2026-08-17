package operations;

import java.util.List;
import model.Dock;

public interface DockOperations {

    boolean addDock(Dock dock);

    boolean updateDock(Dock dock);

    boolean deleteDock(int dockId);

    List<Dock> getAllDocks();

    List<Dock> searchDocks(String dockId, String dockName, String status);

    Dock getDockById(int dockId);
}