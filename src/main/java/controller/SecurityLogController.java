package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.SecurityLog;

@WebServlet("/securitylog")
public class SecurityLogController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    SecurityLog model = new SecurityLog();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String roleName = (String) session.getAttribute("roleName");

        if (!"Admin".equalsIgnoreCase(roleName) && !"Port Manager".equalsIgnoreCase(roleName)) {
            req.setAttribute("errorMessage", "Access Denied: Only Admin and Port Manager can access Security Log.");
            req.getRequestDispatcher("accessdenied.jsp").forward(req, resp);
            return;
        }

        String action = req.getParameter("action");

        if (action == null || "show".equalsIgnoreCase(action)) {
            List<SecurityLog> list = model.getAllLogs();
            req.setAttribute("securityLogList", list);
            req.getRequestDispatcher("securitylog.jsp").forward(req, resp);
            return;
        }

        else if ("search".equalsIgnoreCase(action)) {
            String username = req.getParameter("username");
            String role = req.getParameter("role");
            String fromDate = req.getParameter("fromDate");
            String toDate = req.getParameter("toDate");

            List<SecurityLog> list = model.searchLogs(username, role, fromDate, toDate);

            req.setAttribute("securityLogList", list);
            req.setAttribute("username", username);
            req.setAttribute("role", role);
            req.setAttribute("fromDate", fromDate);
            req.setAttribute("toDate", toDate);

            req.getRequestDispatcher("securitylog.jsp").forward(req, resp);
            return;
        }

        else if ("export".equalsIgnoreCase(action)) {
            List<SecurityLog> list = model.getAllLogs();

            resp.setContentType("text/csv");
            resp.setHeader("Content-Disposition", "attachment; filename=security_log.csv");

            PrintWriter out = resp.getWriter();
            out.println("Log ID,User ID,Username,Role,Entry Time,Exit Time,Session Duration");

            for (SecurityLog s : list) {
                out.println(
                    s.getLogId() + "," +
                    s.getUserId() + "," +
                    s.getUsername() + "," +
                    s.getRoleName() + "," +
                    s.getEntryTime() + "," +
                    s.getExitTime() + "," +
                    s.getDuration()
                );
            }

            out.flush();
            out.close();
            return;
        }

        resp.sendRedirect("securitylog?action=show");
    }
}