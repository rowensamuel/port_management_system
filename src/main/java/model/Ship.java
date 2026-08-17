package model;

import java.util.List;
import operation_implementor.ShipImplementor;

public class Ship {

    private int shipId;
    private String shipName;
    private String status;
    private boolean allocated;
    private String arrivalDate;
    private String departureDate;
    private int operatorId;

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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isAllocated() {
        return allocated;
    }

    public void setAllocated(boolean allocated) {
        this.allocated = allocated;
    }

    public String getArrivalDate() {
        return arrivalDate;
    }

    public void setArrivalDate(String arrivalDate) {
        this.arrivalDate = arrivalDate;
    }

    public String getDepartureDate() {
        return departureDate;
    }

    public void setDepartureDate(String departureDate) {
        this.departureDate = departureDate;
    }

    public int getOperatorId() {
        return operatorId;
    }

    public void setOperatorId(int operatorId) {
        this.operatorId = operatorId;
    }

    public List<Ship> getAllShips() {
        return new ShipImplementor().getAllShips();
    }

    public List<Ship> searchShips(String shipId, String shipName, String operatorId, String status) {
        return new ShipImplementor().searchShips(shipId, shipName, operatorId, status);
    }

    public Ship getShipById(int shipId) {
        return new ShipImplementor().getShipById(shipId);
    }

    public boolean addShip(Ship ship) {
        return new ShipImplementor().addShip(ship);
    }

    public boolean updateShip(Ship ship) {
        return new ShipImplementor().updateShip(ship);
    }

    public boolean deleteShip(int shipId) {
        return new ShipImplementor().deleteShip(shipId);
    }
}