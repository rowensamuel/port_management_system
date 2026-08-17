package operations;

import java.util.List;
import model.User;

public interface UserOperations {

    List<User> getAllUsers();

    boolean addUser(User u);

    boolean updateUser(User u);

    boolean updateRole(int userId, int roleId);

    boolean toggleStatus(int userId, boolean status);
}