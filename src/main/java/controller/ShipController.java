package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Ship;

@WebServlet("/shipmanagement")
public class ShipController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    Ship model = new Ship();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");

        if (action == null || "show".equalsIgnoreCase(action)) {

            List<Ship> list = model.getAllShips();
            req.setAttribute("shipList", list);
            req.getRequestDispatcher("shipmanagement.jsp").forward(req, res);
            return;
        }

        else if ("search".equalsIgnoreCase(action)) {

            String shipId = req.getParameter("shipId");
            String shipName = req.getParameter("shipName");
            String operatorId = req.getParameter("operatorId");
            String status = req.getParameter("status");

            List<Ship> list = model.searchShips(shipId, shipName, operatorId, status);

            req.setAttribute("shipList", list);
            req.setAttribute("searchShipId", shipId);
            req.setAttribute("searchShipName", shipName);
            req.setAttribute("searchOperatorId", operatorId);
            req.setAttribute("searchStatus", status);

            req.getRequestDispatcher("shipmanagement.jsp").forward(req, res);
            return;
        }

        else if ("delete".equalsIgnoreCase(action)) {

            String shipId = req.getParameter("shipId");

            if (shipId != null && !shipId.trim().isEmpty()) {
                model.deleteShip(Integer.parseInt(shipId));
            }

            res.sendRedirect("shipmanagement?action=show");
            return;
        }

        else if ("edit".equalsIgnoreCase(action)) {

            String shipId = req.getParameter("shipId");

            if (shipId != null && !shipId.trim().isEmpty()) {
                Ship editShip = model.getShipById(Integer.parseInt(shipId));
                req.setAttribute("editShip", editShip);
            }

            List<Ship> list = model.getAllShips();
            req.setAttribute("shipList", list);

            req.getRequestDispatcher("shipmanagement.jsp").forward(req, res);
            return;
        }

        res.sendRedirect("shipmanagement?action=show");
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

        Ship data = new Ship();

        data.setShipName(req.getParameter("shipName"));

        String arrival = req.getParameter("arrivalDate");
        if (arrival != null && !arrival.trim().isEmpty()) {
            data.setArrivalDate(arrival.replace("T", " ") + ":00");
        } else {
            data.setArrivalDate(null);
        }

        String departure = req.getParameter("departureDate");
        if (departure != null && !departure.trim().isEmpty()) {
            data.setDepartureDate(departure.replace("T", " ") + ":00");
        } else {
            data.setDepartureDate(null);
        }

        String operatorId = req.getParameter("operatorId");
        if (operatorId != null && !operatorId.trim().isEmpty()) {
            data.setOperatorId(Integer.parseInt(operatorId));
        }

        String status = req.getParameter("status");
        if (status == null || status.trim().isEmpty()) {
            data.setStatus("ANCHORED");
        } else {
            data.setStatus(status);
        }

        if ("add".equalsIgnoreCase(action)) {
            model.addShip(data);
        }

        else if ("update".equalsIgnoreCase(action)) {

            String shipId = req.getParameter("shipId");

            if (shipId != null && !shipId.trim().isEmpty()) {
                data.setShipId(Integer.parseInt(shipId));
                model.updateShip(data);
            }
        }

        res.sendRedirect("shipmanagement?action=show");
    }
}