<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Ship" %>
<%@ page import="model.Dock" %>
<%@ page import="model.DockAllocation" %>
<%
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("userName");
    String roleName = (String) session.getAttribute("roleName");
    Integer userId = (Integer) session.getAttribute("userId");

    List<Ship> ships = (List<Ship>) request.getAttribute("ships");
    List<Dock> docks = (List<Dock>) request.getAttribute("docks");
    List<DockAllocation> activeAllocations = (List<DockAllocation>) request.getAttribute("activeAllocations");
    List<DockAllocation> releasedAllocations = (List<DockAllocation>) request.getAttribute("releasedAllocations");

    Integer activePage = (Integer) request.getAttribute("activePage");
    Integer releasedPage = (Integer) request.getAttribute("releasedPage");
    Integer activeTotalPages = (Integer) request.getAttribute("activeTotalPages");
    Integer releasedTotalPages = (Integer) request.getAttribute("releasedTotalPages");

    if(activePage == null) activePage = 1;
    if(releasedPage == null) releasedPage = 1;
    if(activeTotalPages == null) activeTotalPages = 0;
    if(releasedTotalPages == null) releasedTotalPages = 0;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dock Allocation - Port Management System</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>
    *{ box-sizing:border-box; }

    body{
        margin:0;
        font-family:Arial, sans-serif;
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

    .main-content{
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

    .ship-card{
        background:#fff;
        border:none;
        border-radius:20px;
        box-shadow:0 8px 18px rgba(13,71,161,0.08);
        padding:20px;
        height:100%;
        border:1px solid #edf3fb;
    }

    .status-badge{
        display:inline-block;
        padding:6px 12px;
        border-radius:20px;
        font-size:12px;
        font-weight:700;
    }

    .status-anchored{
        background:#e3f2fd;
        color:#1565c0;
    }

    .status-docked{
        background:#e8f5e9;
        color:#2e7d32;
    }

    .search-box{
        max-width:260px;
    }

    .pagination .page-link{
        color:#0d47a1;
        font-weight:600;
        border-radius:10px;
        margin:0 3px;
    }

    .pagination .page-item.active .page-link{
        background:#0d47a1;
        border-color:#0d47a1;
        color:#fff;
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

        .main-content{
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
        <div class="brand-icon">
            <i class="bi bi-water"></i>
        </div>
        <div class="brand-text">
            <h4>Port Management System</h4>
            <small>Port Operations &amp; Technology Division</small>
        </div>
    </div>

    <div class="topbar-right">
        <div class="user-box">
            <div class="user-avatar">
                <i class="bi bi-person-fill"></i>
            </div>
            <div class="user-meta">
                <div class="name"><%= userName %></div>
                <div class="role"><%= roleName %></div>
            </div>
        </div>
        <a href="logout" class="logout-btn">
            <i class="bi bi-box-arrow-right me-1"></i> Logout
        </a>
    </div>
</div>

<div class="sidebar">
    <div class="sidebar-title">Main Menu</div>
    <a href="dashboard"><i class="bi bi-speedometer2"></i> Dashboard</a>

    <div class="sidebar-title mt-3">Operations</div>

    <% if("Admin".equalsIgnoreCase(roleName)) { %>
        <a href="shipmanagement?action=show"><i class="bi bi-water"></i> Ship Management</a>
        <a href="dockmanagement?action=show"><i class="bi bi-grid-3x3-gap"></i> Dock Management</a>
        <a href="dockallocation?action=show" class="active"><i class="bi bi-arrow-left-right"></i> Dock Allocation</a>
        <a href="containermanagement?action=show"><i class="bi bi-box-seam"></i> Container Management</a>
        <a href="cargohandling?action=show"><i class="bi bi-boxes"></i> Cargo Handling</a>
        <a href="securitylog?action=show"><i class="bi bi-shield-check"></i> Security Log</a>

        <div class="sidebar-title mt-3">Admin</div>
        <a href="usermanagement?action=show"><i class="bi bi-people"></i> User Management</a>
    <% } %>

    <% if("Port Manager".equalsIgnoreCase(roleName)) { %>
        <a href="shipmanagement?action=show"><i class="bi bi-water"></i> Ship Management</a>
        <a href="dockmanagement?action=show"><i class="bi bi-grid-3x3-gap"></i> Dock Management</a>
        <a href="dockallocation?action=show" class="active"><i class="bi bi-arrow-left-right"></i> Dock Allocation</a>
        <a href="containermanagement?action=show"><i class="bi bi-box-seam"></i> Container Management</a>
        <a href="cargohandling?action=show"><i class="bi bi-boxes"></i> Cargo Handling</a>
        <a href="securitylog?action=show"><i class="bi bi-shield-check"></i> Security Log</a>
    <% } %>

    <% if("Ship Operator".equalsIgnoreCase(roleName)) { %>
        <a href="shipmanagement?action=show"><i class="bi bi-water"></i> Ship Management</a>
        <a href="containermanagement?action=show"><i class="bi bi-box-seam"></i> Container Management</a>
    <% } %>

    <% if("Dock Manager".equalsIgnoreCase(roleName)) { %>
        <a href="dockmanagement?action=show"><i class="bi bi-grid-3x3-gap"></i> Dock Management</a>
        <a href="dockallocation?action=show" class="active"><i class="bi bi-arrow-left-right"></i> Dock Allocation</a>
    <% } %>

    <% if("Cargo Handler".equalsIgnoreCase(roleName)) { %>
        <a href="cargohandling?action=show"><i class="bi bi-boxes"></i> Cargo Handling</a>
    <% } %>

    <a href="profile?action=show"><i class="bi bi-gear"></i> Profile &amp; Settings</a>
</div>

<div class="main-content">

    <div class="hero-card">
        <h2>Dock Allocation</h2>
        <p>Assign ships to available docks and manage released dock history.</p>
    </div>

    <div class="page-card">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <div class="section-title mb-1">Search &amp; Show</div>
                <p class="text-muted mb-0">Search ships by ID, name, or status.</p>
            </div>

            <div class="d-flex gap-2 flex-wrap">
                <input type="text" id="shipSearch" class="form-control search-box" placeholder="Search ship...">
                <select id="tableFilter" class="form-select" style="width:180px;">
                    <option value="all">Show All</option>
                    <option value="active">Active Allocations</option>
                    <option value="released">Released History</option>
                </select>
            </div>
        </div>
    </div>

    <div class="page-card">
        <div class="section-title">Ships Available for Allocation</div>

        <div class="row g-4" id="shipContainer">
            <%
                if(ships != null && !ships.isEmpty()){
                    for(Ship s : ships){
                        String badgeClass = "status-anchored";
                        if("DOCKED".equalsIgnoreCase(s.getStatus())) badgeClass = "status-docked";
            %>
            <div class="col-lg-4 col-md-6 ship-item"
                 data-shipid="<%= s.getShipId() %>"
                 data-shipname="<%= s.getShipName().toLowerCase() %>"
                 data-status="<%= s.getStatus().toLowerCase() %>">
                <div class="ship-card">
                    <h5 class="fw-bold mb-2"><%= s.getShipName() %></h5>
                    <p class="mb-2"><strong>Ship ID:</strong> <%= s.getShipId() %></p>
                    <p class="mb-3">
                        <strong>Status:</strong>
                        <span class="status-badge <%= badgeClass %>"><%= s.getStatus() %></span>
                    </p>

                    <% if(s.isAllocated()){ %>
                        <button class="btn btn-secondary w-100" disabled>Allocated</button>
                    <% } else { %>
                        <button class="btn btn-primary w-100"
                                data-bs-toggle="modal"
                                data-bs-target="#allocateModal"
                                onclick="setAllocationData('<%= s.getShipId() %>', '<%= s.getShipName() %>', '<%= userId %>')">
                            Allocate Dock
                        </button>
                    <% } %>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>

        <div id="noShipFound" class="alert alert-info mt-4" style="display:none;">
            No ship found for this search.
        </div>
    </div>

    <div class="page-card" id="activeSection">
        <div class="section-title">Active Allocations</div>
        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead>
                    <tr>
                        <th>Allocation ID</th>
                        <th>Ship ID</th>
                        <th>Ship Name</th>
                        <th>Dock ID</th>
                        <th>Dock Name</th>
                        <th>Allocation Time</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if(activeAllocations != null && !activeAllocations.isEmpty()){
                        for(DockAllocation da : activeAllocations){
                %>
                    <tr>
                        <td><%= da.getAllocationId() %></td>
                        <td><%= da.getShipId() %></td>
                        <td><%= da.getShipName() %></td>
                        <td><%= da.getDockId() %></td>
                        <td><%= da.getDockName() %></td>
                        <td><%= da.getAllocationTime() %></td>
                        <td>
                            <a href="dockallocation?action=release&allocationId=<%= da.getAllocationId() %>"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Are you sure you want to release this dock?');">
                               Release Dock
                            </a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="7" class="text-center">No active allocations found</td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>

        <% if(activeTotalPages > 1){ %>
        <nav>
            <ul class="pagination justify-content-center mt-3">

                <li class="page-item <%= (activePage == 1) ? "disabled" : "" %>">
                    <a class="page-link" href="dockallocation?activePage=<%= activePage - 1 %>&releasedPage=<%= releasedPage %>">
                        Previous
                    </a>
                </li>

                <% for(int i = 1; i <= activeTotalPages; i++){ %>
                    <li class="page-item <%= (i == activePage) ? "active" : "" %>">
                        <a class="page-link" href="dockallocation?activePage=<%= i %>&releasedPage=<%= releasedPage %>">
                            <%= i %>
                        </a>
                    </li>
                <% } %>

                <li class="page-item <%= (activePage == activeTotalPages) ? "disabled" : "" %>">
                    <a class="page-link" href="dockallocation?activePage=<%= activePage + 1 %>&releasedPage=<%= releasedPage %>">
                        Next
                    </a>
                </li>

            </ul>
        </nav>
        <% } %>
    </div>

    <div class="page-card" id="releasedSection">
        <div class="section-title">Released Dock History</div>
        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead>
                    <tr>
                        <th>Allocation ID</th>
                        <th>Ship ID</th>
                        <th>Ship Name</th>
                        <th>Dock ID</th>
                        <th>Dock Name</th>
                        <th>Allocation Time</th>
                        <th>Release Time</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if(releasedAllocations != null && !releasedAllocations.isEmpty()){
                        for(DockAllocation da : releasedAllocations){
                %>
                    <tr>
                        <td><%= da.getAllocationId() %></td>
                        <td><%= da.getShipId() %></td>
                        <td><%= da.getShipName() %></td>
                        <td><%= da.getDockId() %></td>
                        <td><%= da.getDockName() %></td>
                        <td><%= da.getAllocationTime() %></td>
                        <td><%= da.getReleaseTime() %></td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="7" class="text-center">No released allocation history found</td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>

        <% if(releasedTotalPages > 1){ %>
        <nav>
            <ul class="pagination justify-content-center mt-3">

                <li class="page-item <%= (releasedPage == 1) ? "disabled" : "" %>">
                    <a class="page-link" href="dockallocation?activePage=<%= activePage %>&releasedPage=<%= releasedPage - 1 %>">
                        Previous
                    </a>
                </li>

                <% for(int i = 1; i <= releasedTotalPages; i++){ %>
                    <li class="page-item <%= (i == releasedPage) ? "active" : "" %>">
                        <a class="page-link" href="dockallocation?activePage=<%= activePage %>&releasedPage=<%= i %>">
                            <%= i %>
                        </a>
                    </li>
                <% } %>

                <li class="page-item <%= (releasedPage == releasedTotalPages) ? "disabled" : "" %>">
                    <a class="page-link" href="dockallocation?activePage=<%= activePage %>&releasedPage=<%= releasedPage + 1 %>">
                        Next
                    </a>
                </li>

            </ul>
        </nav>
        <% } %>
    </div>
</div>

<div class="modal fade" id="allocateModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="dockallocation" method="post">
                <input type="hidden" name="action" value="allocate">

                <div class="modal-header">
                    <h5 class="modal-title">Allocate Dock</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">

                    <div class="mb-3">
                        <label class="form-label">Ship ID</label>
                        <input type="text" class="form-control" name="shipId" id="modalShipId" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Ship Name</label>
                        <input type="text" class="form-control" id="modalShipName" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">User ID</label>
                        <input type="text" class="form-control" name="userId" id="modalUserId" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Select Available Dock</label>
                        <select name="dockId" class="form-select" required>
                            <option value="">Select Dock</option>
                            <%
                                if(docks != null){
                                    for(Dock d : docks){
                            %>
                            <option value="<%= d.getDockId() %>">
                                <%= d.getDockId() %> - <%= d.getDockName() %> - <%= d.getStatus() %>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Allocation Time</label>
                        <input type="datetime-local" name="allocationTime" class="form-control" required>
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Confirm Allocation</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function setAllocationData(shipId, shipName, userId){
    document.getElementById("modalShipId").value = shipId;
    document.getElementById("modalShipName").value = shipName;
    document.getElementById("modalUserId").value = userId;
}

const shipSearch = document.getElementById("shipSearch");
const shipItems = document.querySelectorAll(".ship-item");
const noShipFound = document.getElementById("noShipFound");

shipSearch.addEventListener("keyup", function(){
    const keyword = this.value.toLowerCase().trim();
    let visibleCount = 0;

    shipItems.forEach(function(item){
        const shipId = item.getAttribute("data-shipid").toLowerCase();
        const shipName = item.getAttribute("data-shipname");
        const status = item.getAttribute("data-status");

        if(shipId.includes(keyword) || shipName.includes(keyword) || status.includes(keyword)){
            item.style.display = "block";
            visibleCount++;
        } else {
            item.style.display = "none";
        }
    });

    if(visibleCount === 0){
        noShipFound.style.display = "block";
    } else {
        noShipFound.style.display = "none";
    }
});

const tableFilter = document.getElementById("tableFilter");
const activeSection = document.getElementById("activeSection");
const releasedSection = document.getElementById("releasedSection");

tableFilter.addEventListener("change", function(){
    const value = this.value;

    if(value === "active"){
        activeSection.style.display = "block";
        releasedSection.style.display = "none";
    } else if(value === "released"){
        activeSection.style.display = "none";
        releasedSection.style.display = "block";
    } else {
        activeSection.style.display = "block";
        releasedSection.style.display = "block";
    }
});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>