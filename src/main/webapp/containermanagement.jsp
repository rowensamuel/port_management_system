<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Container" %>
<%@ page import="model.Cargo" %>
<%@ page import="model.Ship" %>

<%
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("userName");
    String roleName = (String) session.getAttribute("roleName");

    List<Container> list = (List<Container>) request.getAttribute("containerList");
    if(list == null){
        list = new ArrayList<Container>();
    }

    List<Ship> ships = (List<Ship>) request.getAttribute("ships");
    if(ships == null){
        ships = new ArrayList<Ship>();
    }

    List<Cargo> cargoList = (List<Cargo>) request.getAttribute("cargoList");
    if(cargoList == null){
        cargoList = new ArrayList<Cargo>();
    }

    Container editContainer = (Container) request.getAttribute("editContainer");
    Container detailContainer = (Container) request.getAttribute("detailContainer");

    String errorMessage = request.getAttribute("errorMessage") != null ? (String) request.getAttribute("errorMessage") : "";

    String searchContainerId = request.getAttribute("searchContainerId") != null ? (String) request.getAttribute("searchContainerId") : "";
    String searchType = request.getAttribute("searchType") != null ? (String) request.getAttribute("searchType") : "";
    String searchShipId = request.getAttribute("searchShipId") != null ? (String) request.getAttribute("searchShipId") : "";
    String searchStatus = request.getAttribute("searchStatus") != null ? (String) request.getAttribute("searchStatus") : "";

    String editContainerIdVal = "";
    String editTypeVal = "";
    String editShipIdVal = "";
    String editStatusVal = "";

    if(editContainer != null){
        editContainerIdVal = String.valueOf(editContainer.getContainerId());
        editTypeVal = editContainer.getContainerType() != null ? editContainer.getContainerType() : "";
        editShipIdVal = String.valueOf(editContainer.getShipId());
        editStatusVal = editContainer.getStatus() != null ? editContainer.getStatus() : "";
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Container Management - Port Management System</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>
*{ box-sizing:border-box; }
body{ margin:0; font-family:Arial,sans-serif; background:linear-gradient(135deg,#edf4ff,#f8fbff); }
.topbar{ position:fixed; top:0; left:0; right:0; height:74px; background:linear-gradient(90deg,#0d47a1,#1565c0); color:#fff; display:flex; align-items:center; justify-content:space-between; padding:0 24px; z-index:1000; box-shadow:0 4px 16px rgba(0,0,0,0.18); }
.brand-wrap{ display:flex; align-items:center; gap:14px; }
.brand-icon{ width:46px; height:46px; border-radius:14px; background:rgba(255,255,255,0.15); display:flex; align-items:center; justify-content:center; font-size:22px; }
.brand-text h4{ margin:0; font-size:24px; font-weight:700; }
.brand-text small{ color:#d7e8ff; font-size:12px; }
.topbar-right{ display:flex; align-items:center; gap:18px; }
.user-box{ display:flex; align-items:center; gap:10px; background:rgba(255,255,255,0.12); padding:8px 14px; border-radius:14px; }
.user-avatar{ width:38px; height:38px; border-radius:50%; background:rgba(255,255,255,0.18); display:flex; align-items:center; justify-content:center; font-size:18px; }
.user-meta .name{ font-weight:700; font-size:14px; color:#fff; }
.user-meta .role{ font-size:12px; color:#d7e8ff; }
.logout-btn{ border:none; background:#fff; color:#0d47a1; padding:10px 18px; border-radius:12px; font-weight:700; text-decoration:none; }
.sidebar{ position:fixed; top:74px; left:0; width:260px; height:calc(100vh - 74px); background:linear-gradient(180deg,#07182c,#0b1f3a); color:#fff; overflow-y:auto; padding:22px 0; }
.sidebar-title{ padding:0 24px; margin:10px 0 12px; font-size:12px; text-transform:uppercase; letter-spacing:1px; font-weight:700; color:#8fb5e6; }
.sidebar a{ display:flex; align-items:center; gap:12px; text-decoration:none; color:#d8e7ff; padding:14px 24px; font-size:15px; transition:0.3s ease; border-left:4px solid transparent; }
.sidebar a:hover,.sidebar a.active{ background:rgba(21,101,192,0.28); color:#fff; border-left:4px solid #42a5f5; padding-left:28px; }
.main{ margin-left:260px; margin-top:74px; padding:30px; }
.hero-card{ background:linear-gradient(135deg,#0d47a1,#1976d2); border-radius:24px; padding:28px; color:#fff; margin-bottom:26px; }
.page-card{ background:#fff; border:none; border-radius:22px; box-shadow:0 10px 22px rgba(13,71,161,0.08); padding:24px; margin-bottom:24px; }
.section-title{ font-size:24px; font-weight:700; color:#0d47a1; margin-bottom:16px; }
.table thead th{ background:#f5f9ff; }
@media(max-width:768px){
    .topbar{ position:static; height:auto; padding:16px; flex-direction:column; align-items:flex-start; gap:14px; }
    .sidebar{ position:static; width:100%; height:auto; }
    .main{ margin-left:0; margin-top:0; padding:20px; }
}
</style>
</head>
<body>

<div class="topbar">
    <div class="brand-wrap">
        <div class="brand-icon"><i class="bi bi-water"></i></div>
        <div class="brand-text">
            <h4>Port Management System</h4>
            <small>Port Operations &amp; Technology Division</small>
        </div>
    </div>

    <div class="topbar-right">
        <div class="user-box">
            <div class="user-avatar"><i class="bi bi-person-fill"></i></div>
            <div class="user-meta">
                <div class="name"><%= userName %></div>
                <div class="role"><%= roleName %></div>
            </div>
        </div>
        <a href="logout" class="logout-btn"><i class="bi bi-box-arrow-right me-1"></i> Logout</a>
    </div>
</div>

<div class="sidebar">
    <div class="sidebar-title">Main Menu</div>
    <a href="dashboard"><i class="bi bi-speedometer2"></i> Dashboard</a>

    <div class="sidebar-title mt-3">Operations</div>

    <% if("Admin".equalsIgnoreCase(roleName)) { %>
        <a href="shipmanagement?action=show"><i class="bi bi-water"></i> Ship Management</a>
        <a href="dockmanagement?action=show"><i class="bi bi-grid-3x3-gap"></i> Dock Management</a>
        <a href="dockallocation?action=show"><i class="bi bi-arrow-left-right"></i> Dock Allocation</a>
        <a href="containermanagement?action=show" class="active"><i class="bi bi-box-seam"></i> Container Management</a>
        <a href="cargohandling?action=show"><i class="bi bi-boxes"></i> Cargo Handling</a>
        <a href="securitylog?action=show"><i class="bi bi-shield-check"></i> Security Log</a>

        <div class="sidebar-title mt-3">Admin</div>
        <a href="usermanagement?action=show"><i class="bi bi-people"></i> User Management</a>
    <% } %>

    <% if("Port Manager".equalsIgnoreCase(roleName)) { %>
        <a href="shipmanagement?action=show"><i class="bi bi-water"></i> Ship Management</a>
        <a href="dockmanagement?action=show"><i class="bi bi-grid-3x3-gap"></i> Dock Management</a>
        <a href="dockallocation?action=show"><i class="bi bi-arrow-left-right"></i> Dock Allocation</a>
        <a href="containermanagement?action=show" class="active"><i class="bi bi-box-seam"></i> Container Management</a>
        <a href="cargohandling?action=show"><i class="bi bi-boxes"></i> Cargo Handling</a>
        <a href="securitylog?action=show"><i class="bi bi-shield-check"></i> Security Log</a>
    <% } %>

    <% if("Ship Operator".equalsIgnoreCase(roleName)) { %>
        <a href="shipmanagement?action=show"><i class="bi bi-water"></i> Ship Management</a>
        <a href="containermanagement?action=show" class="active"><i class="bi bi-box-seam"></i> Container Management</a>
    <% } %>

    <a href="profile?action=show"><i class="bi bi-gear"></i> Profile & Settings</a>
</div>

<div class="main">

    <div class="hero-card">
        <h2>Container Management</h2>
        <p>Search, filter, add, update, delete and inspect containers with cargo detail.</p>
    </div>

    <% if(errorMessage != null && !errorMessage.trim().isEmpty()) { %>
    <div class="alert alert-danger"><%= errorMessage %></div>
    <% } %>

    <div class="page-card">
        <div class="section-title">Container Record Entry</div>

        <form id="containerForm" method="post" action="containermanagement">
            <input type="hidden" name="action" id="formAction" value="<%= editContainer != null ? "update" : "add" %>">

            <div class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">Container ID *</label>
                    <input type="number" name="containerId" id="containerId" class="form-control"
                           value="<%= editContainerIdVal %>"
                           placeholder="Required for Update / Delete / Search">
                </div>

                <div class="col-md-3">
                    <label class="form-label">Container Type</label>
                    <select name="containerType" id="containerType" class="form-select">
                        <option value="">-- Select Type --</option>
                        <option value="Dry" <%= ("Dry".equals(editTypeVal) || "Dry".equals(searchType)) ? "selected" : "" %>>Dry</option>
                        <option value="Reefer" <%= ("Reefer".equals(editTypeVal) || "Reefer".equals(searchType)) ? "selected" : "" %>>Reefer</option>
                        <option value="Open Top" <%= ("Open Top".equals(editTypeVal) || "Open Top".equals(searchType)) ? "selected" : "" %>>Open Top</option>
                        <option value="Tank" <%= ("Tank".equals(editTypeVal) || "Tank".equals(searchType)) ? "selected" : "" %>>Tank</option>
                    </select>
                </div>

                <div class="col-md-3">
                    <label class="form-label">Assign Ship</label>
                    <select name="shipId" id="shipId" class="form-select" required>
                        <option value="">Select Ship</option>
                        <%
                            for(Ship s : ships){
                        %>
                        <option value="<%= s.getShipId() %>" <%= String.valueOf(s.getShipId()).equals(editShipIdVal) || String.valueOf(s.getShipId()).equals(searchShipId) ? "selected" : "" %>>
                            <%= s.getShipId() %> - <%= s.getShipName() %> (<%= s.getStatus() %>)
                        </option>
                        <%
                            }
                        %>
                    </select>
                </div>

                <div class="col-md-3">
                    <label class="form-label">Status</label>
                    <select name="status" id="status" class="form-select">
                        <option value="">-- Select Status --</option>
                        <option value="loaded" <%= ("loaded".equals(editStatusVal) || "loaded".equals(searchStatus)) ? "selected" : "" %>>loaded</option>
                        <option value="empty" <%= ("empty".equals(editStatusVal) || "empty".equals(searchStatus)) ? "selected" : "" %>>empty</option>
                        <option value="in transit" <%= ("in transit".equals(editStatusVal) || "in transit".equals(searchStatus)) ? "selected" : "" %>>in transit</option>
                    </select>
                </div>
            </div>

            <div class="mt-4 d-flex flex-wrap gap-3">
                <button type="submit" class="btn btn-primary" onclick="setAction('add')">Add Container</button>
                <button type="submit" class="btn btn-warning text-white" onclick="setAction('update')">Update Container</button>
                <button type="button" class="btn btn-danger" onclick="deleteContainer()">Delete Container</button>
                <button type="button" class="btn btn-success" onclick="searchContainer()">Search / Filter</button>
                <a href="containermanagement?action=show" class="btn btn-secondary">Show All</a>
            </div>
        </form>
    </div>

    <div class="page-card">
        <div class="section-title">All Containers</div>

        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead>
                    <tr>
                        <th>Container ID</th>
                        <th>Type</th>
                        <th>Assigned Ship</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if(!list.isEmpty()){
                        for(Container c : list){
                %>
                    <tr>
                        <td><%= c.getContainerId() %></td>
                        <td><%= c.getContainerType() %></td>
                        <td><%= c.getShipName() %></td>
                        <td><%= c.getStatus() %></td>
                        <td>
                            <a href="containermanagement?action=edit&containerId=<%= c.getContainerId() %>" class="btn btn-warning btn-sm text-white">Edit</a>
                            <a href="containermanagement?action=detail&containerId=<%= c.getContainerId() %>" class="btn btn-info btn-sm text-white">View Detail</a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="5" class="text-center">No container records found</td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <% if(detailContainer != null){ %>
    <div class="page-card">
        <div class="section-title">Container Detail</div>

        <div class="row">
            <div class="col-md-6">
                <p><strong>Container ID:</strong> <%= detailContainer.getContainerId() %></p>
                <p><strong>Type:</strong> <%= detailContainer.getContainerType() %></p>
                <p><strong>Assigned Ship:</strong> <%= detailContainer.getShipName() %></p>
                <p><strong>Status:</strong> <%= detailContainer.getStatus() %></p>
            </div>

            <div class="col-md-6">
                <p><strong>Cargo Items Inside:</strong></p>
                <ul>
                    <%
                        if(!cargoList.isEmpty()){
                            for(Cargo cg : cargoList){
                    %>
                        <li>
                            <strong><%= cg.getDescription() %></strong> |
                            Weight: <%= cg.getWeight() %> |
                            Status: <%= cg.getStatus() %>
                        </li>
                    <%
                            }
                        } else {
                    %>
                        <li>No cargo found in this container</li>
                    <%
                        }
                    %>
                </ul>
            </div>
        </div>
    </div>
    <% } %>

</div>

<script>
function setAction(action){
    document.getElementById("formAction").value = action;
}

function deleteContainer(){
    let containerId = document.getElementById("containerId").value;

    if(containerId == null || containerId.trim() === ""){
        alert("Container ID is required for delete.");
        return;
    }

    if(confirm("Are you sure you want to delete this container?")){
        window.location = "containermanagement?action=delete&containerId=" + containerId;
    }
}

function searchContainer(){
    let containerId = document.getElementById("containerId").value;
    let type = document.getElementById("containerType").value;
    let shipId = document.getElementById("shipId").value;
    let status = document.getElementById("status").value;

    let url = "containermanagement?action=search"
        + "&containerId=" + encodeURIComponent(containerId)
        + "&type=" + encodeURIComponent(type)
        + "&shipId=" + encodeURIComponent(shipId)
        + "&status=" + encodeURIComponent(status);

    window.location = url;
}
</script>

</body>
</html>