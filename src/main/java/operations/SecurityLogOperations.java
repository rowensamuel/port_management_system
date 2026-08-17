package operations;

import java.util.List;
import model.SecurityLog;

public interface SecurityLogOperations {

    List<SecurityLog> getAllLogs();

    List<SecurityLog> searchLogs(String username, String role, String fromDate, String toDate);
}