package model;

import operation_implementor.DashboardImplementor;

public class DashboardData {

    private int totalShips;
    private int activeAllocations;
    private int availableDocks;
    private int occupiedDocks;

    public int getTotalShips() {
        return totalShips;
    }

    public void setTotalShips(int totalShips) {
        this.totalShips = totalShips;
    }

    public int getActiveAllocations() {
        return activeAllocations;
    }

    public void setActiveAllocations(int activeAllocations) {
        this.activeAllocations = activeAllocations;
    }

    public int getAvailableDocks() {
        return availableDocks;
    }

    public void setAvailableDocks(int availableDocks) {
        this.availableDocks = availableDocks;
    }

    public int getOccupiedDocks() {
        return occupiedDocks;
    }

    public void setOccupiedDocks(int occupiedDocks) {
        this.occupiedDocks = occupiedDocks;
    }

    // ---------------- MODEL METHOD ----------------

    public DashboardData getDashboardData() {
        return new DashboardImplementor().getDashboardData();
    }
}