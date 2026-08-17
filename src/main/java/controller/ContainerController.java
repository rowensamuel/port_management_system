package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import model.Container;

@WebServlet("/containermanagement")
public class ContainerController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    Container model = new Container();

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
                && !"Ship Operator".equalsIgnoreCase(roleName)) {
            req.setAttribute("errorMessage", "Access Denied");
            req.getRequestDispatcher("accessdenied.jsp").forward(req, res);
            return;
        }

        String action = req.getParameter("action");

        if (action == null || "show".equalsIgnoreCase(action)) {

            req.setAttribute("containerList", model.getAllContainers());
            req.setAttribute("ships", model.getAllShips());

            req.getRequestDispatcher("containermanagement.jsp").forward(req, res);
            return;
        }

        if ("search".equalsIgnoreCase(action)) {

            String containerId = req.getParameter("containerId");
            String type = req.getParameter("type");
            String shipId = req.getParameter("shipId");
            String status = req.getParameter("status");

            req.setAttribute("containerList",
                    model.searchAndFilterContainers(containerId, type, shipId, status));

            req.setAttribute("ships", model.getAllShips());

            req.setAttribute("searchContainerId", containerId);
            req.setAttribute("searchType", type);
            req.setAttribute("searchShipId", shipId);
            req.setAttribute("searchStatus", status);

            req.getRequestDispatcher("containermanagement.jsp").forward(req, res);
            return;
        }

        if ("edit".equalsIgnoreCase(action)) {

            int containerId = Integer.parseInt(req.getParameter("containerId"));

            req.setAttribute("editContainer", model.getContainerById(containerId));
            req.setAttribute("containerList", model.getAllContainers());
            req.setAttribute("ships", model.getAllShips());

            req.getRequestDispatcher("containermanagement.jsp").forward(req, res);
            return;
        }

        if ("detail".equalsIgnoreCase(action)) {

            int containerId = Integer.parseInt(req.getParameter("containerId"));

            req.setAttribute("detailContainer", model.getContainerById(containerId));
            req.setAttribute("cargoList", model.getCargoByContainerId(containerId));
            req.setAttribute("containerList", model.getAllContainers());
            req.setAttribute("ships", model.getAllShips());

            req.getRequestDispatcher("containermanagement.jsp").forward(req, res);
            return;
        }

        if ("delete".equalsIgnoreCase(action)) {

            int containerId = Integer.parseInt(req.getParameter("containerId"));

            boolean result = model.deleteContainer(containerId);

            if (!result) {
                req.setAttribute("errorMessage", "Container delete failed. Cargo exists.");
                req.setAttribute("containerList", model.getAllContainers());
                req.setAttribute("ships", model.getAllShips());

                req.getRequestDispatcher("containermanagement.jsp").forward(req, res);
                return;
            }

            res.sendRedirect("containermanagement?action=show");
            return;
        }

        res.sendRedirect("containermanagement?action=show");
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

            String type = req.getParameter("containerType");
            String shipIdStr = req.getParameter("shipId");
            String status = req.getParameter("status");

            if (type == null || type.trim().isEmpty()
                    || shipIdStr == null || shipIdStr.trim().isEmpty()
                    || status == null || status.trim().isEmpty()) {

                req.setAttribute("errorMessage", "Fill all fields.");
                req.setAttribute("containerList", model.getAllContainers());
                req.setAttribute("ships", model.getAllShips());

                req.getRequestDispatcher("containermanagement.jsp").forward(req, res);
                return;
            }

            Container c = new Container();
            c.setContainerType(type.trim());
            c.setShipId(Integer.parseInt(shipIdStr));
            c.setStatus(status.trim());

            boolean result = false;

            if ("add".equalsIgnoreCase(action)) {
                result = model.addContainer(c);
            }

            else if ("update".equalsIgnoreCase(action)) {

                String containerIdStr = req.getParameter("containerId");

                if (containerIdStr == null || containerIdStr.trim().isEmpty()) {
                    req.setAttribute("errorMessage", "Container ID required.");
                    req.setAttribute("containerList", model.getAllContainers());
                    req.setAttribute("ships", model.getAllShips());

                    req.getRequestDispatcher("containermanagement.jsp").forward(req, res);
                    return;
                }

                c.setContainerId(Integer.parseInt(containerIdStr));
                result = model.updateContainer(c);
            }

            if (!result) {
                req.setAttribute("errorMessage", "Insert/Update failed.");
                req.setAttribute("containerList", model.getAllContainers());
                req.setAttribute("ships", model.getAllShips());

                req.getRequestDispatcher("containermanagement.jsp").forward(req, res);
                return;
            }

            res.sendRedirect("containermanagement?action=show");

        } catch (Exception e) {
            e.printStackTrace();

            req.setAttribute("errorMessage", "Error: " + e.getMessage());
            req.setAttribute("containerList", model.getAllContainers());
            req.setAttribute("ships", model.getAllShips());

            req.getRequestDispatcher("containermanagement.jsp").forward(req, res);
        }
    }
}