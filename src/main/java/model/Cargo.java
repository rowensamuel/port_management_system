package model;

import java.util.List;

import operation_implementor.CargoHandlingImplementor;

public class Cargo {

    private int cargoId;
    private int containerId;
    private String description;
    private double weight;
    private String status;

    // extra display fields
    private String containerType;
    private String containerStatus;
    private String shipName;

    public int getCargoId() {
        return cargoId;
    }

    public void setCargoId(int cargoId) {
        this.cargoId = cargoId;
    }

    public int getContainerId() {
        return containerId;
    }

    public void setContainerId(int containerId) {
        this.containerId = containerId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getContainerType() {
        return containerType;
    }

    public void setContainerType(String containerType) {
        this.containerType = containerType;
    }

    public String getContainerStatus() {
        return containerStatus;
    }

    public void setContainerStatus(String containerStatus) {
        this.containerStatus = containerStatus;
    }

    public String getShipName() {
        return shipName;
    }

    public void setShipName(String shipName) {
        this.shipName = shipName;
    }

    // MODEL METHODS

    public List<Cargo> getAllCargo() {
        return new CargoHandlingImplementor().getAllCargo();
    }

    public List<Cargo> searchCargo(String cargoId, String containerId, String status, String description) {
        return new CargoHandlingImplementor().searchCargo(cargoId, containerId, status, description);
    }

    public Cargo getCargoById(int cargoId) {
        return new CargoHandlingImplementor().getCargoById(cargoId);
    }

    public boolean addCargo(Cargo c) {
        return new CargoHandlingImplementor().addCargo(c);
    }

    public boolean updateCargo(Cargo c) {
        return new CargoHandlingImplementor().updateCargo(c);
    }

    public boolean deleteCargo(int cargoId) {
        return new CargoHandlingImplementor().deleteCargo(cargoId);
    }

    public List<Container> getAllContainersForCargo() {
        return new CargoHandlingImplementor().getAllContainersForCargo();
    }

    public Container getContainerDetails(int containerId) {
        return new CargoHandlingImplementor().getContainerDetails(containerId);
    }
}