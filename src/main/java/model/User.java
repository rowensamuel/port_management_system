package model;

import java.util.List;

import operation_implementor.UserImplementor;
import operation_implementor.LoginImplementor;

public class User {

    private int userId;
    private String name;
    private String email;
    private String password;
    private int roleId;
    private String roleName;
    private boolean active;

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    // USER MANAGEMENT METHODS
    public List<User> getAllUsers() {
        return new UserImplementor().getAllUsers();
    }

    public boolean addUser(User user) {
        return new UserImplementor().addUser(user);
    }

    public boolean updateUser(User user) {
        return new UserImplementor().updateUser(user);
    }

    public boolean updateRole(int userId, int roleId) {
        return new UserImplementor().updateRole(userId, roleId);
    }

    public boolean toggleStatus(int userId, boolean status) {
        return new UserImplementor().toggleStatus(userId, status);
    }

    // LOGIN / LOGOUT METHODS
    public User login(String email, String password) {
        return new LoginImplementor().login(email, password);
    }

    public boolean logout(int userId) {
        return new LoginImplementor().logout(userId);
    }
}