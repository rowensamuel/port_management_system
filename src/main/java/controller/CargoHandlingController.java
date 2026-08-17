package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.Cargo;
import model.CargoMovement;

@WebServlet("/cargohandling")
public class CargoHandlingController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    Cargo cargoModel = new Cargo();
    CargoMovement movementModel = new CargoMovement();

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
                && !"Cargo Handler".equalsIgnoreCase(roleName)) {
            req.setAttribute("errorMessage", "Access Denied");
            req.getRequestDispatcher("accessdenied.jsp").forward(req, res);
            return;
        }

        String action = req.getParameter("action");

        if (action == null || "show".equalsIgnoreCase(action)) {
            loadDefaultData(req);
            req.getRequestDispatcher("cargohandling.jsp").forward(req, res);
            return;
        }

        if ("searchCargo".equalsIgnoreCase(action)) {
            String cargoId = req.getParameter("cargoId");
            String containerId = req.getParameter("containerId");
            String status = req.getParameter("status");
            String description = req.getParameter("description");

            req.setAttribute("cargoList", cargoModel.searchCargo(cargoId, containerId, status, description));
            req.setAttribute("containerList", cargoModel.getAllContainersForCargo());
            req.setAttribute("movementList", movementModel.getAllMovements());

            req.setAttribute("searchCargoId", cargoId);
            req.setAttribute("searchContainerId", containerId);
            req.setAttribute("searchStatus", status);
            req.setAttribute("searchDescription", description);

            req.getRequestDispatcher("cargohandling.jsp").forward(req, res);
            return;
        }

        if ("editCargo".equalsIgnoreCase(action)) {
            int cargoId = Integer.parseInt(req.getParameter("cargoId"));

            req.setAttribute("editCargo", cargoModel.getCargoById(cargoId));
            req.setAttribute("cargoList", cargoModel.getAllCargo());
            req.setAttribute("containerList", cargoModel.getAllContainersForCargo());
            req.setAttribute("movementList", movementModel.getAllMovements());

            req.getRequestDispatcher("cargohandling.jsp").forward(req, res);
            return;
        }

        if ("deleteCargo".equalsIgnoreCase(action)) {
            int cargoId = Integer.parseInt(req.getParameter("cargoId"));
            boolean result = cargoModel.deleteCargo(cargoId);

            if (!result) {
                req.setAttribute("errorMessage", "Cargo delete failed. Movement history exists for this cargo.");
                loadDefaultData(req);
                req.getRequestDispatcher("cargohandling.jsp").forward(req, res);
                return;
            }

            res.sendRedirect("cargohandling?action=show");
            return;
        }

        if ("containerDetail".equalsIgnoreCase(action)) {
            int containerId = Integer.parseInt(req.getParameter("containerId"));

            req.setAttribute("selectedContainer", cargoModel.getContainerDetails(containerId));
            req.setAttribute("cargoList", cargoModel.getAllCargo());
            req.setAttribute("containerList", cargoModel.getAllContainersForCargo());
            req.setAttribute("movementList", movementModel.getAllMovements());

            req.getRequestDispatcher("cargohandling.jsp").forward(req, res);
            return;
        }

        if ("movementHistory".equalsIgnoreCase(action)) {
            int cargoId = Integer.parseInt(req.getParameter("cargoId"));

            req.setAttribute("historyCargo", cargoModel.getCargoById(cargoId));
            req.setAttribute("movementList", movementModel.getMovementHistoryByCargo(cargoId));
            req.setAttribute("cargoList", cargoModel.getAllCargo());
            req.setAttribute("containerList", cargoModel.getAllContainersForCargo());

            req.getRequestDispatcher("cargohandling.jsp").forward(req, res);
            return;
        }

        res.sendRedirect("cargohandling?action=show");
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

        try {
            if ("addCargo".equalsIgnoreCase(action) || "updateCargo".equalsIgnoreCase(action)) {

                String containerIdStr = req.getParameter("containerId");
                String description = req.getParameter("description");
                String weightStr = req.getParameter("weight");
                String status = req.getParameter("status");

                if (containerIdStr == null || containerIdStr.trim().isEmpty()
                        || description == null || description.trim().isEmpty()
                        || weightStr == null || weightStr.trim().isEmpty()
                        || status == null || status.trim().isEmpty()) {

                    req.setAttribute("errorMessage", "Please fill Container, Description, Weight and Status.");
                    loadDefaultData(req);
                    req.getRequestDispatcher("cargohandling.jsp").forward(req, res);
                    return;
                }

                Cargo c = new Cargo();
                c.setContainerId(Integer.parseInt(containerIdStr));
                c.setDescription(description.trim());
                c.setWeight(Double.parseDouble(weightStr));
                c.setStatus(status.trim());

                boolean result = false;

                if ("addCargo".equalsIgnoreCase(action)) {
                    result = cargoModel.addCargo(c);
                } else {
                    String cargoIdStr = req.getParameter("cargoId");

                    if (cargoIdStr == null || cargoIdStr.trim().isEmpty()) {
                        req.setAttribute("errorMessage", "Cargo ID is required for update.");
                        loadDefaultData(req);
                        req.getRequestDispatcher("cargohandling.jsp").forward(req, res);
                        return;
                    }

                    c.setCargoId(Integer.parseInt(cargoIdStr));
                    result = cargoModel.updateCargo(c);
                }

                if (!result) {
                    req.setAttribute("errorMessage", "Cargo insert/update failed.");
                    loadDefaultData(req);
                    req.getRequestDispatcher("cargohandling.jsp").forward(req, res);
                    return;
                }

                res.sendRedirect("cargohandling?action=show");
                return;
            }

            if ("addMovement".equalsIgnoreCase(action)) {
                String cargoIdStr = req.getParameter("movementCargoId");
                String movementType = req.getParameter("movementType");
                String movementDate = req.getParameter("movementDate");
                Integer handledBy = (Integer) session.getAttribute("userId");

                if (cargoIdStr == null || cargoIdStr.trim().isEmpty()
                        || movementType == null || movementType.trim().isEmpty()
                        || handledBy == null) {

                    req.setAttribute("errorMessage", "Please select cargo and movement type.");
                    loadDefaultData(req);
                    req.getRequestDispatcher("cargohandling.jsp").forward(req, res);
                    return;
                }

                CargoMovement m = new CargoMovement();
                m.setCargoId(Integer.parseInt(cargoIdStr));
                m.setMovementType(movementType.trim());

                if (movementDate != null && !movementDate.trim().isEmpty()) {
                    m.setMovementDate(movementDate.replace("T", " ") + ":00");
                } else {
                    m.setMovementDate(null);
                }

                m.setHandledBy(handledBy);

                boolean result = movementModel.addMovement(m);

                if (!result) {
                    req.setAttribute("errorMessage", "Cargo movement logging failed.");
                    loadDefaultData(req);
                    req.getRequestDispatcher("cargohandling.jsp").forward(req, res);
                    return;
                }

                res.sendRedirect("cargohandling?action=movementHistory&cargoId=" + m.getCargoId());
                return;
            }

            res.sendRedirect("cargohandling?action=show");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Error: " + e.getMessage());
            loadDefaultData(req);
            req.getRequestDispatcher("cargohandling.jsp").forward(req, res);
        }
    }

    private void loadDefaultData(HttpServletRequest req) {
        req.setAttribute("cargoList", cargoModel.getAllCargo());
        req.setAttribute("containerList", cargoModel.getAllContainersForCargo());
        req.setAttribute("movementList", movementModel.getAllMovements());
    }
}