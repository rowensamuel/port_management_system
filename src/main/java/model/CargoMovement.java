package model;

import java.util.List;

import operation_implementor.CargoHandlingImplementor;

public class CargoMovement {

    private int movementId;
    private int cargoId;
    private String cargoDescription;
    private String movementType;
    private String movementDate;
    private int handledBy;
    private String handlerName;

    public int getMovementId() {
        return movementId;
    }

    public void setMovementId(int movementId) {
        this.movementId = movementId;
    }

    public int getCargoId() {
        return cargoId;
    }

    public void setCargoId(int cargoId) {
        this.cargoId = cargoId;
    }

    public String getCargoDescription() {
        return cargoDescription;
    }

    public void setCargoDescription(String cargoDescription) {
        this.cargoDescription = cargoDescription;
    }

    public String getMovementType() {
        return movementType;
    }

    public void setMovementType(String movementType) {
        this.movementType = movementType;
    }

    public String getMovementDate() {
        return movementDate;
    }

    public void setMovementDate(String movementDate) {
        this.movementDate = movementDate;
    }

    public int getHandledBy() {
        return handledBy;
    }

    public void setHandledBy(int handledBy) {
        this.handledBy = handledBy;
    }

    public String getHandlerName() {
        return handlerName;
    }

    public void setHandlerName(String handlerName) {
        this.handlerName = handlerName;
    }

    // ---------------- MODEL METHODS ----------------

    public List<CargoMovement> getAllMovements() {
        return new CargoHandlingImplementor().getAllMovements();
    }

    public List<CargoMovement> getMovementHistoryByCargo(int cargoId) {
        return new CargoHandlingImplementor().getMovementHistoryByCargo(cargoId);
    }

    public boolean addMovement(CargoMovement m) {
        return new CargoHandlingImplementor().addMovement(m);
    }
}