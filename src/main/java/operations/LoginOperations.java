package operations;

import model.User;

public interface LoginOperations {

    User login(String email, String password);
    boolean logout(int userId);
}