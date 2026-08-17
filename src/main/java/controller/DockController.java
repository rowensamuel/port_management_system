package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Dock;

@WebServlet("/dockmanagement")
public class DockController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    Dock model = new Dock();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String roleName = (String) session.getAttribute("roleName");

        if (!"Admin".equalsIgnoreCase(roleName)
                && !"Port Manager".equalsIgnoreCase(roleName)
                && !"Dock Manager".equalsIgnoreCase(roleName)) {
            req.setAttribute("errorMessage", "Access Denied");
            req.getRequestDispatcher("accessdenied.jsp").forward(req, res);
            return;
        }

        String action = req.getParameter("action");

        if (action == null || "show".equalsIgnoreCase(action)) {
            List<Dock> list = model.getAllDocks();
            req.setAttribute("dockList", list);
        }

        else if ("search".equalsIgnoreCase(action)) {
            String dockId = req.getParameter("dockId");
            String dockName = req.getParameter("dockName");
            String status = req.getParameter("status");

            List<Dock> list = model.searchDocks(dockId, dockName, status);

            req.setAttribute("dockList", list);
            req.setAttribute("searchDockId", dockId);
            req.setAttribute("searchDockName", dockName);
            req.setAttribute("searchStatus", status);
        }

        else if ("delete".equalsIgnoreCase(action)) {
            String dockId = req.getParameter("dockId");

            if (dockId != null && !dockId.trim().isEmpty()) {
                model.deleteDock(Integer.parseInt(dockId));
            }

            res.sendRedirect("dockmanagement?action=show");
            return;
        }

        else if ("edit".equalsIgnoreCase(action)) {
            String dockId = req.getParameter("dockId");

            if (dockId != null && !dockId.trim().isEmpty()) {
                Dock editDock = model.getDockById(Integer.parseInt(dockId));
                req.setAttribute("editDock", editDock);
            }

            List<Dock> list = model.getAllDocks();
            req.setAttribute("dockList", list);
        }

        req.getRequestDispatcher("dockmanagement.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");

        Dock data = new Dock();
        data.setDockName(req.getParameter("dockName"));
        data.setStatus(req.getParameter("status"));

        if ("add".equalsIgnoreCase(action)) {
            model.addDock(data);
        }

        else if ("update".equalsIgnoreCase(action)) {
            String dockId = req.getParameter("dockId");

            if (dockId != null && !dockId.trim().isEmpty()) {
                data.setDockId(Integer.parseInt(dockId));
                model.updateDock(data);
            }
        }

        res.sendRedirect("dockmanagement?action=show");
    }
}