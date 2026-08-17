package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;

@WebServlet("/usermanagement")
public class UserController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    User model = new User();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String roleName = (String) session.getAttribute("roleName");

        if (!"Admin".equalsIgnoreCase(roleName)) {
            req.setAttribute("errorMessage", "Access Denied: Only Admin can access User Management.");
            req.getRequestDispatcher("accessdenied.jsp").forward(req, res);
            return;
        }

        String action = req.getParameter("action");

        if (action == null || "show".equalsIgnoreCase(action)) {

            List<User> list = model.getAllUsers();
            req.setAttribute("userList", list);
            req.getRequestDispatcher("usermanagement.jsp").forward(req, res);
            return;
        }

        else if ("toggle".equalsIgnoreCase(action)) {

            String id = req.getParameter("id");
            String status = req.getParameter("status");

            if (id != null && !id.trim().isEmpty() && status != null) {
                model.toggleStatus(Integer.parseInt(id), !Boolean.parseBoolean(status));
            }

            res.sendRedirect("usermanagement?action=show");
            return;
        }

        res.sendRedirect("usermanagement?action=show");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String roleName = (String) session.getAttribute("roleName");

        if (!"Admin".equalsIgnoreCase(roleName)) {
            req.setAttribute("errorMessage", "Access Denied: Only Admin can perform this action.");
            req.getRequestDispatcher("accessdenied.jsp").forward(req, res);
            return;
        }

        String action = req.getParameter("action");

        User data = new User();

        if ("add".equalsIgnoreCase(action)) {

            data.setName(req.getParameter("name"));
            data.setEmail(req.getParameter("email"));
            data.setPassword(req.getParameter("password"));

            String roleId = req.getParameter("roleId");
            if (roleId != null && !roleId.trim().isEmpty()) {
                data.setRoleId(Integer.parseInt(roleId));
            }

            model.addUser(data);
        }

        else if ("update".equalsIgnoreCase(action)) {

            String userId = req.getParameter("userId");
            if (userId != null && !userId.trim().isEmpty()) {
                data.setUserId(Integer.parseInt(userId));
            }

            data.setName(req.getParameter("name"));
            data.setEmail(req.getParameter("email"));

            String roleId = req.getParameter("roleId");
            if (roleId != null && !roleId.trim().isEmpty()) {
                data.setRoleId(Integer.parseInt(roleId));
            }

            model.updateUser(data);
        }

        else if ("updateRole".equalsIgnoreCase(action)) {

            String userId = req.getParameter("userId");
            String roleId = req.getParameter("roleId");

            if (userId != null && !userId.trim().isEmpty()
                    && roleId != null && !roleId.trim().isEmpty()) {
                model.updateRole(Integer.parseInt(userId), Integer.parseInt(roleId));
            }
        }

        res.sendRedirect("usermanagement?action=show");
    }
}