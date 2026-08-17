package model;

import java.util.List;

import operation_implementor.DockImplementor;

public class Dock {

    private int dockId;
    private String dockName;
    private String status;

    // 🔥 Display field (DB me nahi hai)
    private String assignedShipName;

    // ---------------- GETTERS SETTERS ----------------

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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAssignedShipName() {
        return assignedShipName;
    }

    public void setAssignedShipName(String assignedShipName) {
        this.assignedShipName = assignedShipName;
    }

    // ---------------- MODEL METHODS ----------------

    public List<Dock> getAllDocks() {
        return new DockImplementor().getAllDocks();
    }

    public List<Dock> searchDocks(String dockId, String dockName, String status) {
        return new DockImplementor().searchDocks(dockId, dockName, status);
    }

    public Dock getDockById(int dockId) {
        return new DockImplementor().getDockById(dockId);
    }

    public boolean addDock(Dock dock) {
        return new DockImplementor().addDock(dock);
    }

    public boolean updateDock(Dock dock) {
        return new DockImplementor().updateDock(dock);
    }

    public boolean deleteDock(int dockId) {
        return new DockImplementor().deleteDock(dockId);
    }
}