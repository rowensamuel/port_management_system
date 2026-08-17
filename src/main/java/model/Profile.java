package model;

import operation_implementor.ProfileImplementor;

public class Profile {

    private int userId;
    private String name;
    private String email;
    private String roleName;

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

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    // ---------------- MODEL METHODS ----------------

    public Profile getProfile(int userId) {
        return new ProfileImplementor().getProfile(userId);
    }

    public boolean updateName(int userId, String newName) {
        return new ProfileImplementor().updateName(userId, newName);
    }

    public String updateEmail(int userId, String newEmail) {
        return new ProfileImplementor().updateEmail(userId, newEmail);
    }

    public String changePassword(int userId, String currentPassword, String newPassword) {
        return new ProfileImplementor().changePassword(userId, currentPassword, newPassword);
    }
}