package model;

import java.util.List;
import operation_implementor.DockAllocationImplementor;

public class DockAllocation {

    private int allocationId;
    private int shipId;
    private String shipName;
    private int dockId;
    private String dockName;
    private String dockStatus;
    private String allocationTime;
    private String releaseTime;
    private int userId;

    public int getAllocationId() {
        return allocationId;
    }

    public void setAllocationId(int allocationId) {
        this.allocationId = allocationId;
    }

    public int getShipId() {
        return shipId;
    }

    public void setShipId(int shipId) {
        this.shipId = shipId;
    }

    public String getShipName() {
        return shipName;
    }

    public void setShipName(String shipName) {
        this.shipName = shipName;
    }

    public int getDockId() {
        return dockId;
    }

    public void setDockId(int dockId) {
        this.dockId = dockId;
    }

    public String getDockName() {
        return dockName;
    }

    public void setDockName(String dockName) {
        this.dockName = dockName;
    }

    public String getDockStatus() {
        return dockStatus;
    }

    public void setDockStatus(String dockStatus) {
        this.dockStatus = dockStatus;
    }

    public String getAllocationTime() {
        return allocationTime;
    }

    public void setAllocationTime(String allocationTime) {
        this.allocationTime = allocationTime;
    }

    public String getReleaseTime() {
        return releaseTime;
    }

    public void setReleaseTime(String releaseTime) {
        this.releaseTime = releaseTime;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }


    public boolean allocateDock(int shipId, int dockId, int userId, String allocationTime) {
        return new DockAllocationImplementor().allocateDock(shipId, dockId, userId, allocationTime);
    }

    public boolean releaseDock(int allocationId) {
        return new DockAllocationImplementor().releaseDock(allocationId);
    }

    public List<Ship> getShipsForAllocation() {
        return new DockAllocationImplementor().getShipsForAllocation();
    }

    public List<Dock> getAvailableDocks() {
        return new DockAllocationImplementor().getAvailableDocks();
    }

    public List<DockAllocation> getActiveAllocations() {
        return new DockAllocationImplementor().getActiveAllocations();
    }

    public List<DockAllocation> getReleasedAllocations() {
        return new DockAllocationImplementor().getReleasedAllocations();
    }

    public List<DockAllocation> getActiveAllocations(int start, int limit) {
        return new DockAllocationImplementor().getActiveAllocations(start, limit);
    }

    public List<DockAllocation> getReleasedAllocations(int start, int limit) {
        return new DockAllocationImplementor().getReleasedAllocations(start, limit);
    }

    public int getActiveAllocationCount() {
        return new DockAllocationImplementor().getActiveAllocationCount();
    }

    public int getReleasedAllocationCount() {
        return new DockAllocationImplementor().getReleasedAllocationCount();
    }
}