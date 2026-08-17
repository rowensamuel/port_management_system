package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Profile;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    Profile model = new Profile();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        Profile profile = model.getProfile(userId);
        req.setAttribute("profileData", profile);

        req.getRequestDispatcher("profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = req.getParameter("action");

        if ("updateName".equalsIgnoreCase(action)) {
            String newName = req.getParameter("name");

            if (newName == null || newName.trim().isEmpty()) {
                req.setAttribute("error", "Name cannot be empty");
            } else {
                boolean updated = model.updateName(userId, newName.trim());

                if (updated) {
                    session.setAttribute("userName", newName.trim());
                    req.setAttribute("success", "Name updated successfully");
                } else {
                    req.setAttribute("error", "Name update failed");
                }
            }
        }

        else if ("updateEmail".equalsIgnoreCase(action)) {
            String newEmail = req.getParameter("email");

            if (newEmail == null || newEmail.trim().isEmpty()) {
                req.setAttribute("error", "Email cannot be empty");
            } 
            else if (!newEmail.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                req.setAttribute("error", "Invalid email format");
            } 
            else {
                String msg = model.updateEmail(userId, newEmail.trim());

                if ("Email updated successfully".equals(msg)) {
                    req.setAttribute("success", msg);
                } else {
                    req.setAttribute("error", msg);
                }
            }
        }

        else if ("changePassword".equalsIgnoreCase(action)) {
            String currentPassword = req.getParameter("currentPassword");
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");

            if (currentPassword == null || currentPassword.trim().isEmpty()
                    || newPassword == null || newPassword.trim().isEmpty()
                    || confirmPassword == null || confirmPassword.trim().isEmpty()) {
                req.setAttribute("error", "All password fields are required");
            } 
            else if (!newPassword.equals(confirmPassword)) {
                req.setAttribute("error", "New password and confirm password do not match");
            } 
            else {
                String message = model.changePassword(userId, currentPassword, newPassword);

                if ("Password changed successfully".equals(message)) {
                    req.setAttribute("success", message);
                } else {
                    req.setAttribute("error", message);
                }
            }
        }

        Profile profile = model.getProfile(userId);
        req.setAttribute("profileData", profile);

        req.getRequestDispatcher("profile.jsp").forward(req, resp);
    }
}