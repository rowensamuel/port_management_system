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
import model.DockAllocation;
import model.Ship;

@WebServlet("/dockallocation")
public class DockAllocationController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    DockAllocation model = new DockAllocation();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");

        if ("release".equalsIgnoreCase(action)) {
            String allocationId = req.getParameter("allocationId");

            if (allocationId != null && !allocationId.trim().isEmpty()) {
                model.releaseDock(Integer.parseInt(allocationId));
            }

            resp.sendRedirect("dockallocation");
            return;
        }

        loadPage(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");

        if ("allocate".equalsIgnoreCase(action)) {
            String shipId = req.getParameter("shipId");
            String dockId = req.getParameter("dockId");
            String userId = req.getParameter("userId");
            String allocationTime = req.getParameter("allocationTime");

            if (shipId != null && !shipId.trim().isEmpty()
                    && dockId != null && !dockId.trim().isEmpty()
                    && userId != null && !userId.trim().isEmpty()
                    && allocationTime != null && !allocationTime.trim().isEmpty()) {

                model.allocateDock(
                        Integer.parseInt(shipId),
                        Integer.parseInt(dockId),
                        Integer.parseInt(userId),
                        allocationTime
                );
            }

            resp.sendRedirect("dockallocation");
            return;
        }

        loadPage(req, resp);
    }

    private void loadPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int activePage = 1;
        int releasedPage = 1;
        int limit = 5;

        try {
            if (req.getParameter("activePage") != null) {
                activePage = Integer.parseInt(req.getParameter("activePage"));
            }

            if (req.getParameter("releasedPage") != null) {
                releasedPage = Integer.parseInt(req.getParameter("releasedPage"));
            }
        } catch (Exception e) {
            activePage = 1;
            releasedPage = 1;
        }

        int activeStart = (activePage - 1) * limit;
        int releasedStart = (releasedPage - 1) * limit;

        List<Ship> ships = model.getShipsForAllocation();
        List<Dock> docks = model.getAvailableDocks();

        List<DockAllocation> activeAllocations = model.getActiveAllocations(activeStart, limit);
        List<DockAllocation> releasedAllocations = model.getReleasedAllocations(releasedStart, limit);

        int activeTotalRecords = model.getActiveAllocationCount();
        int releasedTotalRecords = model.getReleasedAllocationCount();

        int activeTotalPages = (int) Math.ceil((double) activeTotalRecords / limit);
        int releasedTotalPages = (int) Math.ceil((double) releasedTotalRecords / limit);

        req.setAttribute("ships", ships);
        req.setAttribute("docks", docks);

        req.setAttribute("activeAllocations", activeAllocations);
        req.setAttribute("releasedAllocations", releasedAllocations);

        req.setAttribute("activePage", activePage);
        req.setAttribute("releasedPage", releasedPage);

        req.setAttribute("activeTotalPages", activeTotalPages);
        req.setAttribute("releasedTotalPages", releasedTotalPages);

        req.getRequestDispatcher("dockallocation.jsp").forward(req, resp);
    }
}