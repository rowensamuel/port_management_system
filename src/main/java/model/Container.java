package model;

import java.util.List;

import operation_implementor.ContainerImplementor;

public class Container {

    private int containerId;
    private String containerType;
    private int shipId;
    private String shipName;
    private String status;

    // ---------------- GETTERS SETTERS ----------------

    public int getContainerId() {
        return containerId;
    }

    public void setContainerId(int containerId) {
        this.containerId = containerId;
    }

    public String getContainerType() {
        return containerType;
    }

    public void setContainerType(String containerType) {
        this.containerType = containerType;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // ---------------- MODEL METHODS ----------------

    public List<Container> getAllContainers() {
        return new ContainerImplementor().getAllContainers();
    }

    public List<Ship> getAllShips() {
        return new ContainerImplementor().getAllShips();
    }

    public List<Container> searchAndFilterContainers(String containerId, String type, String shipId, String status) {
        return new ContainerImplementor().searchAndFilterContainers(containerId, type, shipId, status);
    }

    public Container getContainerById(int containerId) {
        return new ContainerImplementor().getContainerById(containerId);
    }

    public List<Cargo> getCargoByContainerId(int containerId) {
        return new ContainerImplementor().getCargoByContainerId(containerId);
    }

    public boolean addContainer(Container c) {
        return new ContainerImplementor().addContainer(c);
    }

    public boolean updateContainer(Container c) {
        return new ContainerImplementor().updateContainer(c);
    }

    public boolean deleteContainer(int containerId) {
        return new ContainerImplementor().deleteContainer(containerId);
    }
}