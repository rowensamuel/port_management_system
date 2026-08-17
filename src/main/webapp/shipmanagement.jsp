<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Ship" %>

<%
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("userName");
    String roleName = (String) session.getAttribute("roleName");

    List<Ship> list = (List<Ship>) request.getAttribute("shipList");
    if(list == null){
        list = new ArrayList<Ship>();
    }

    Ship editShip = (Ship) request.getAttribute("editShip");

    String searchShipId = request.getAttribute("searchShipId") != null ? (String) request.getAttribute("searchShipId") : "";
    String searchShipName = request.getAttribute("searchShipName") != null ? (String) request.getAttribute("searchShipName") : "";
    String searchOperatorId = request.getAttribute("searchOperatorId") != null ? (String) request.getAttribute("searchOperatorId") : "";
    String searchStatus = request.getAttribute("searchStatus") != null ? (String) request.getAttribute("searchStatus") : "";

    String editShipIdVal = "";
    String editShipNameVal = "";
    String editArrivalVal = "";
    String editDepartureVal = "";
    String editOperatorVal = "";
    String editStatusVal = "";

    if(editShip != null){
        editShipIdVal = String.valueOf(editShip.getShipId());
        editShipNameVal = editShip.getShipName() != null ? editShip.getShipName() : "";
        editOperatorVal = String.valueOf(editShip.getOperatorId());
        editStatusVal = editShip.getStatus() != null ? editShip.getStatus() : "";

        if(editShip.getArrivalDate() != null && editShip.getArrivalDate().length() >= 16){
            editArrivalVal = editShip.getArrivalDate().replace(" ", "T").substring(0, 16);
        }

        if(editShip.getDepartureDate() != null && editShip.getDepartureDate().length() >= 16){
            editDepartureVal = editShip.getDepartureDate().replace(" ", "T").substring(0, 16);
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ship Management - Port Management System</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>
*{ box-sizing:border-box; }

body{
    margin:0;
    font-family:Arial,sans-serif;
    background:linear-gradient(135deg,#edf4ff,#f8fbff);
}

.topbar{
    position:fixed;
    top:0;
    left:0;
    right:0;
    height:74px;
    background:linear-gradient(90deg,#0d47a1,#1565c0);
    color:#fff;
    display:flex;
    align-items:center;
    justify-content:space-between;
    padding:0 24px;
    z-index:1000;
    box-shadow:0 4px 16px rgba(0,0,0,0.18);
}

.brand-wrap{
    display:flex;
    align-items:center;
    gap:14px;
}

.brand-icon{
    width:46px;
    height:46px;
    border-radius:14px;
    background:rgba(255,255,255,0.15);
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:22px;
}

.brand-text h4{
    margin:0;
    font-size:24px;
    font-weight:700;
}

.brand-text small{
    color:#d7e8ff;
    font-size:12px;
}

.topbar-right{
    display:flex;
    align-items:center;
    gap:18px;
}

.user-box{
    display:flex;
    align-items:center;
    gap:10px;
    background:rgba(255,255,255,0.12);
    padding:8px 14px;
    border-radius:14px;
}

.user-avatar{
    width:38px;
    height:38px;
    border-radius:50%;
    background:rgba(255,255,255,0.18);
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:18px;
}

.user-meta .name{
    font-weight:700;
    font-size:14px;
    color:#fff;
}

.user-meta .role{
    font-size:12px;
    color:#d7e8ff;
}

.logout-btn{
    border:none;
    background:#fff;
    color:#0d47a1;
    padding:10px 18px;
    border-radius:12px;
    font-weight:700;
    text-decoration:none;
}

.sidebar{
    position:fixed;
    top:74px;
    left:0;
    width:260px;
    height:calc(100vh - 74px);
    background:linear-gradient(180deg,#07182c,#0b1f3a);
    color:#fff;
    overflow-y:auto;
    padding:22px 0;
}

.sidebar-title{
    padding:0 24px;
    margin:10px 0 12px;
    font-size:12px;
    text-transform:uppercase;
    letter-spacing:1px;
    font-weight:700;
    color:#8fb5e6;
}

.sidebar a{
    display:flex;
    align-items:center;
    gap:12px;
    text-decoration:none;
    color:#d8e7ff;
    padding:14px 24px;
    font-size:15px;
    transition:0.3s ease;
    border-left:4px solid transparent;
}

.sidebar a:hover,
.sidebar a.active{
    background:rgba(21,101,192,0.28);
    color:#fff;
    border-left:4px solid #42a5f5;
    padding-left:28px;
}

.main{
    margin-left:260px;
    margin-top:74px;
    padding:30px;
}

.hero-card{
    background:linear-gradient(135deg,#0d47a1,#1976d2);
    border-radius:24px;
    padding:28px;
    color:#fff;
    margin-bottom:26px;
}

.page-card{
    background:#fff;
    border:none;
    border-radius:22px;
    box-shadow:0 10px 22px rgba(13,71,161,0.08);
    padding:24px;
    margin-bottom:24px;
}

.section-title{
    font-size:24px;
    font-weight:700;
    color:#0d47a1;
    margin-bottom:16px;
}

.form-note{
    font-size:13px;
    color:#6c757d;
}

.record-actions .btn{
    min-width:140px;
}

.status-pill{
    display:inline-block;
    padding:6px 12px;
    border-radius:20px;
    font-size:12px;
    font-weight:700;
}

.anchored{
    background:#e3f2fd;
    color:#1565c0;
}

.docked{
    background:#e8f5e9;
    color:#2e7d32;
}

.departed{
    background:#ffebee;
    color:#c62828;
}

.table thead th{
    background:#f5f9ff;
}

@media(max-width:768px){
    .topbar{
        position:static;
        height:auto;
        padding:16px;
        flex-direction:column;
        align-items:flex-start;
        gap:14px;
    }

    .sidebar{
        position:static;
        width:100%;
        height:auto;
    }

    .main{
        margin-left:0;
        margin-top:0;
        padding:20px;
    }
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
        <a href="shipmanagement?action=show" class="active"><i class="bi bi-water"></i> Ship Management</a>
        <a href="dockmanagement?action=show"><i class="bi bi-grid-3x3-gap"></i> Dock Management</a>
        <a href="dockallocation?action=show"><i class="bi bi-arrow-left-right"></i> Dock Allocation</a>
        <a href="containermanagement?action=show"><i class="bi bi-box-seam"></i> Container Management</a>
        <a href="cargohandling?action=show"><i class="bi bi-boxes"></i> Cargo Handling</a>
        <a href="securitylog?action=show"><i class="bi bi-shield-check"></i> Security Log</a>

        <div class="sidebar-title mt-3">Admin</div>
        <a href="usermanagement?action=show"><i class="bi bi-people"></i> User Management</a>
    <% } %>

    <% if("Port Manager".equalsIgnoreCase(roleName)) { %>
        <a href="shipmanagement?action=show" class="active"><i class="bi bi-water"></i> Ship Management</a>
        <a href="dockmanagement?action=show"><i class="bi bi-grid-3x3-gap"></i> Dock Management</a>
        <a href="dockallocation?action=show"><i class="bi bi-arrow-left-right"></i> Dock Allocation</a>
        <a href="containermanagement?action=show"><i class="bi bi-box-seam"></i> Container Management</a>
        <a href="cargohandling?action=show"><i class="bi bi-boxes"></i> Cargo Handling</a>
        <a href="securitylog?action=show"><i class="bi bi-shield-check"></i> Security Log</a>
    <% } %>

    <% if("Ship Operator".equalsIgnoreCase(roleName)) { %>
        <a href="shipmanagement?action=show" class="active"><i class="bi bi-water"></i> Ship Management</a>
        <a href="containermanagement?action=show"><i class="bi bi-box-seam"></i> Container Management</a>
    <% } %>

    <% if("Dock Manager".equalsIgnoreCase(roleName)) { %>
        <a href="dockmanagement?action=show"><i class="bi bi-grid-3x3-gap"></i> Dock Management</a>
        <a href="dockallocation?action=show"><i class="bi bi-arrow-left-right"></i> Dock Allocation</a>
    <% } %>

    <% if("Cargo Handler".equalsIgnoreCase(roleName)) { %>
        <a href="cargohandling?action=show"><i class="bi bi-boxes"></i> Cargo Handling</a>
    <% } %>

    <a href="profile?action=show"><i class="bi bi-gear"></i> Profile & Settings</a>
</div>

<div class="main">

    <div class="hero-card">
        <h2>Ship Management</h2>
        <p>Register, update, delete, search and track all vessels in the system.</p>
    </div>

    <div class="page-card">
        <div class="section-title">Ship Record Entry</div>
        <div class="form-note mb-3">Status can be selected manually while adding or updating ship.</div>

        <form id="shipForm" method="post" action="shipmanagement">
            <input type="hidden" name="action" id="formAction" value="<%= editShip != null ? "update" : "add" %>">

            <div class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">Ship ID *</label>
                    <input type="number" name="shipId" id="shipId" class="form-control"
                           value="<%= editShip != null ? editShipIdVal : searchShipId %>"
                           placeholder="Required for Update / Delete / Search">
                </div>

                <div class="col-md-3">
                    <label class="form-label">Ship Name</label>
                    <input type="text" name="shipName" id="shipName" class="form-control"
                           value="<%= editShip != null ? editShipNameVal : searchShipName %>"
                           placeholder="Ship Name">
                </div>

                <div class="col-md-3">
                    <label class="form-label">Operator ID</label>
                    <input type="number" name="operatorId" id="operatorId" class="form-control"
                           value="<%= editShip != null ? editOperatorVal : searchOperatorId %>"
                           placeholder="Operator ID">
                </div>

                <div class="col-md-3">
                    <label class="form-label">Status</label>
                    <select name="status" id="status" class="form-select">
                        <option value="">-- Select Status --</option>
                        <option value="ANCHORED" <%= ("ANCHORED".equals(editStatusVal) || "ANCHORED".equals(searchStatus)) ? "selected" : "" %>>ANCHORED</option>
                        <option value="DOCKED" <%= ("DOCKED".equals(editStatusVal) || "DOCKED".equals(searchStatus)) ? "selected" : "" %>>DOCKED</option>
                        <option value="DEPARTED" <%= ("DEPARTED".equals(editStatusVal) || "DEPARTED".equals(searchStatus)) ? "selected" : "" %>>DEPARTED</option>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Arrival Date</label>
                    <input type="datetime-local" name="arrivalDate" id="arrivalDate" class="form-control"
                           value="<%= editArrivalVal %>" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Departure Date</label>
                    <input type="datetime-local" name="departureDate" id="departureDate" class="form-control"
                           value="<%= editDepartureVal %>">
                </div>
            </div>

            <div class="record-actions mt-4 d-flex flex-wrap gap-3">
                <button type="submit" class="btn btn-primary" onclick="setAction('add')">
                    <i class="bi bi-plus-circle me-1"></i> Insert
                </button>

                <button type="submit" class="btn btn-warning text-white" onclick="setAction('update')">
                    <i class="bi bi-pencil-square me-1"></i> Update
                </button>

                <button type="button" class="btn btn-danger" onclick="deleteShip()">
                    <i class="bi bi-trash me-1"></i> Delete
                </button>

                <button type="button" class="btn btn-success" onclick="searchShip()">
                    <i class="bi bi-search me-1"></i> Search
                </button>

                <a href="shipmanagement?action=show" class="btn btn-secondary">
                    <i class="bi bi-grid me-1"></i> Show All Records
                </a>
            </div>
        </form>
    </div>

    <div class="page-card">
        <div class="section-title">All Registered Ships</div>

        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead>
                    <tr>
                        <th>Ship ID</th>
                        <th>Ship Name</th>
                        <th>Arrival Date</th>
                        <th>Departure Date</th>
                        <th>Status</th>
                        <th>Operator ID</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if(!list.isEmpty()){
                        for(Ship s : list){
                %>
                    <tr>
                        <td><%= s.getShipId() %></td>
                        <td><%= s.getShipName() %></td>
                        <td><%= s.getArrivalDate() %></td>
                        <td><%= s.getDepartureDate() %></td>
                        <td>
                            <%
                                String st = s.getStatus();
                                if("ANCHORED".equalsIgnoreCase(st)){
                            %>
                                <span class="status-pill anchored">ANCHORED</span>
                            <%
                                } else if("DOCKED".equalsIgnoreCase(st)){
                            %>
                                <span class="status-pill docked">DOCKED</span>
                            <%
                                } else {
                            %>
                                <span class="status-pill departed">DEPARTED</span>
                            <%
                                }
                            %>
                        </td>
                        <td><%= s.getOperatorId() %></td>
                        <td>
                            <a href="shipmanagement?action=edit&shipId=<%= s.getShipId() %>" class="btn btn-warning btn-sm text-white">
                                Edit
                            </a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="7" class="text-center">No ship records found</td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<script>
function setAction(action){
    document.getElementById("formAction").value = action;
}

function deleteShip(){
    let shipId = document.getElementById("shipId").value;

    if(shipId == null || shipId.trim() === ""){
        alert("Ship ID is required for delete.");
        return;
    }

    if(confirm("Are you sure you want to delete this ship?")){
        window.location = "shipmanagement?action=delete&shipId=" + shipId;
    }
}

function searchShip(){
    let shipId = document.getElementById("shipId").value;
    let shipName = document.getElementById("shipName").value;
    let operatorId = document.getElementById("operatorId").value;
    let status = document.getElementById("status").value;

    let url = "shipmanagement?action=search"
        + "&shipId=" + encodeURIComponent(shipId)
        + "&shipName=" + encodeURIComponent(shipName)
        + "&operatorId=" + encodeURIComponent(operatorId)
        + "&status=" + encodeURIComponent(status);

    window.location = url;
}
</script>

</body>
</html>