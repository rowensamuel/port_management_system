package operations;

import java.util.List;
import model.Dock;
import model.DockAllocation;
import model.Ship;

public interface DockAllocationOperations {

    List<Ship> getShipsForAllocation();

    List<Dock> getAvailableDocks();

    List<DockAllocation> getActiveAllocations();

    List<DockAllocation> getReleasedAllocations();

    List<DockAllocation> getActiveAllocations(int start, int limit);

    List<DockAllocation> getReleasedAllocations(int start, int limit);

    int getActiveAllocationCount();

    int getReleasedAllocationCount();

    boolean allocateDock(int shipId, int dockId, int userId, String allocationTime);

    boolean releaseDock(int allocationId);
}