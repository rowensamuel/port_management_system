<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Dock" %>

<%
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("userName");
    String roleName = (String) session.getAttribute("roleName");

    List<Dock> list = (List<Dock>) request.getAttribute("dockList");
    if(list == null){
        list = new ArrayList<Dock>();
    }

    Dock editDock = (Dock) request.getAttribute("editDock");

    String searchDockId = request.getAttribute("searchDockId") != null ? (String) request.getAttribute("searchDockId") : "";
    String searchDockName = request.getAttribute("searchDockName") != null ? (String) request.getAttribute("searchDockName") : "";
    String searchStatus = request.getAttribute("searchStatus") != null ? (String) request.getAttribute("searchStatus") : "";

    String editDockIdVal = "";
    String editDockNameVal = "";
    String editDockStatusVal = "";

    if(editDock != null){
        editDockIdVal = String.valueOf(editDock.getDockId());
        editDockNameVal = editDock.getDockName() != null ? editDock.getDockName() : "";
        editDockStatusVal = editDock.getStatus() != null ? editDock.getStatus() : "";
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dock Management - Port Management System</title>

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

.board-grid{
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(260px,1fr));
    gap:18px;
}

.dock-card{
    background:#fff;
    border-radius:20px;
    padding:20px;
    box-shadow:0 8px 18px rgba(13,71,161,0.08);
    border:1px solid #edf3fb;
}

.dock-card h5{
    margin:0 0 12px 0;
    color:#0d47a1;
    font-weight:700;
}

.status-pill{
    display:inline-block;
    padding:6px 12px;
    border-radius:20px;
    font-size:12px;
    font-weight:700;
    margin-bottom:10px;
}

.available{
    background:#e8f5e9;
    color:#2e7d32;
}

.occupied{
    background:#fff3e0;
    color:#ef6c00;
}

.maintenance{
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
        <a href="shipmanagement?action=show"><i class="bi bi-water"></i> Ship Management</a>
        <a href="dockmanagement?action=show" class="active"><i class="bi bi-grid-3x3-gap"></i> Dock Management</a>
        <a href="dockallocation?action=show"><i class="bi bi-arrow-left-right"></i> Dock Allocation</a>
        <a href="containermanagement?action=show"><i class="bi bi-box-seam"></i> Container Management</a>
        <a href="cargohandling?action=show"><i class="bi bi-boxes"></i> Cargo Handling</a>
        <a href="securitylog?action=show"><i class="bi bi-shield-check"></i> Security Log</a>

        <div class="sidebar-title mt-3">Admin</div>
        <a href="usermanagement?action=show"><i class="bi bi-people"></i> User Management</a>
    <% } %>

    <% if("Port Manager".equalsIgnoreCase(roleName)) { %>
        <a href="shipmanagement?action=show"><i class="bi bi-water"></i> Ship Management</a>
        <a href="dockmanagement?action=show" class="active"><i class="bi bi-grid-3x3-gap"></i> Dock Management</a>
        <a href="dockallocation?action=show"><i class="bi bi-arrow-left-right"></i> Dock Allocation</a>
        <a href="containermanagement?action=show"><i class="bi bi-box-seam"></i> Container Management</a>
        <a href="cargohandling?action=show"><i class="bi bi-boxes"></i> Cargo Handling</a>
        <a href="securitylog?action=show"><i class="bi bi-shield-check"></i> Security Log</a>
    <% } %>

    <% if("Dock Manager".equalsIgnoreCase(roleName)) { %>
        <a href="dockmanagement?action=show" class="active"><i class="bi bi-grid-3x3-gap"></i> Dock Management</a>
        <a href="dockallocation?action=show"><i class="bi bi-arrow-left-right"></i> Dock Allocation</a>
    <% } %>

    <a href="profile?action=show"><i class="bi bi-gear"></i> Profile & Settings</a>
</div>

<div class="main">

    <div class="hero-card">
        <h2>Dock Management</h2>
        <p>Manage berths, view dock status board, search docks, and update berth information.</p>
    </div>

    <div class="page-card">
        <div class="section-title">Dock Record Entry</div>

        <form id="dockForm" method="post" action="dockmanagement">
            <input type="hidden" name="action" id="formAction" value="<%= editDock != null ? "update" : "add" %>">

            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Dock ID *</label>
                    <input type="number" name="dockId" id="dockId" class="form-control"
                           value="<%= editDock != null ? editDockIdVal : searchDockId %>"
                           placeholder="Required for Update / Delete / Search">
                </div>

                <div class="col-md-4">
                    <label class="form-label">Dock Name</label>
                    <input type="text" name="dockName" id="dockName" class="form-control"
                           value="<%= editDock != null ? editDockNameVal : searchDockName %>"
                           placeholder="Dock Name">
                </div>

                <div class="col-md-4">
                    <label class="form-label">Status</label>
                    <select name="status" id="status" class="form-select">
                        <option value="">-- Select Status --</option>
                        <option value="AVAILABLE" <%= ("AVAILABLE".equals(editDockStatusVal) || "AVAILABLE".equals(searchStatus)) ? "selected" : "" %>>AVAILABLE</option>
                        <option value="OCCUPIED" <%= ("OCCUPIED".equals(editDockStatusVal) || "OCCUPIED".equals(searchStatus)) ? "selected" : "" %>>OCCUPIED</option>
                        <option value="MAINTENANCE" <%= ("MAINTENANCE".equals(editDockStatusVal) || "MAINTENANCE".equals(searchStatus)) ? "selected" : "" %>>MAINTENANCE</option>
                    </select>
                </div>
            </div>

            <div class="mt-4 d-flex flex-wrap gap-3">
                <button type="submit" class="btn btn-primary" onclick="setAction('add')">
                    <i class="bi bi-plus-circle me-1"></i> Add Dock
                </button>

                <button type="submit" class="btn btn-warning text-white" onclick="setAction('update')">
                    <i class="bi bi-pencil-square me-1"></i> Edit Dock
                </button>

                <button type="button" class="btn btn-danger" onclick="deleteDock()">
                    <i class="bi bi-trash me-1"></i> Delete Dock
                </button>

                <button type="button" class="btn btn-success" onclick="searchDock()">
                    <i class="bi bi-search me-1"></i> Search Dock
                </button>

                <a href="dockmanagement?action=show" class="btn btn-secondary">
                    <i class="bi bi-grid me-1"></i> Show All
                </a>
            </div>
        </form>
    </div>

    <div class="page-card">
        <div class="section-title">Dock Status Board</div>

        <div class="board-grid">
            <%
                if(!list.isEmpty()){
                    for(Dock d : list){
                        String statusClass = "available";
                        if("OCCUPIED".equalsIgnoreCase(d.getStatus())){
                            statusClass = "occupied";
                        } else if("MAINTENANCE".equalsIgnoreCase(d.getStatus())){
                            statusClass = "maintenance";
                        }
            %>
            <div class="dock-card">
                <h5><i class="bi bi-grid-3x3-gap-fill me-2"></i><%= d.getDockName() %></h5>
                <div class="status-pill <%= statusClass %>"><%= d.getStatus() %></div>
                <p class="mb-2"><strong>Assigned Ship:</strong> <%= d.getAssignedShipName() %></p>
                <a href="dockmanagement?action=edit&dockId=<%= d.getDockId() %>" class="btn btn-warning btn-sm text-white">Edit</a>
            </div>
            <%
                    }
                } else {
            %>
            <div class="dock-card">
                <h5>No Dock Data</h5>
                <p>No dock records available.</p>
            </div>
            <%
                }
            %>
        </div>
    </div>

    <div class="page-card">
        <div class="section-title">All Docks</div>

        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead>
                    <tr>
                        <th>Dock ID</th>
                        <th>Dock Name</th>
                        <th>Status</th>
                        <th>Assigned Ship</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if(!list.isEmpty()){
                        for(Dock d : list){
                %>
                    <tr>
                        <td><%= d.getDockId() %></td>
                        <td><%= d.getDockName() %></td>
                        <td><%= d.getStatus() %></td>
                        <td><%= d.getAssignedShipName() %></td>
                        <td>
                            <a href="dockmanagement?action=edit&dockId=<%= d.getDockId() %>" class="btn btn-warning btn-sm text-white">Edit</a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="5" class="text-center">No dock records found</td>
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

function deleteDock(){
    let dockId = document.getElementById("dockId").value;

    if(dockId == null || dockId.trim() === ""){
        alert("Dock ID is required for delete.");
        return;
    }

    if(confirm("Are you sure you want to delete this dock?")){
        window.location = "dockmanagement?action=delete&dockId=" + dockId;
    }
}

function searchDock(){
    let dockId = document.getElementById("dockId").value;
    let dockName = document.getElementById("dockName").value;
    let status = document.getElementById("status").value;

    let url = "dockmanagement?action=search"
        + "&dockId=" + encodeURIComponent(dockId)
        + "&dockName=" + encodeURIComponent(dockName)
        + "&status=" + encodeURIComponent(status);

    window.location = url;
}
</script>

</body>
</html>