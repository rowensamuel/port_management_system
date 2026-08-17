package operations;

import model.Profile;

public interface ProfileOperations {

    Profile getProfile(int userId);

    boolean updateName(int userId, String newName);

    String updateEmail(int userId, String newEmail);

    String changePassword(int userId, String currentPassword, String newPassword);
}