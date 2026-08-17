<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model.DashboardData" %>

<%
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("userName");
    String roleName = (String) session.getAttribute("roleName");

    DashboardData dashboardData = (DashboardData) request.getAttribute("dashboardData");

    int totalShips = 0;
    int activeAllocations = 0;
    int availableDocks = 0;
    int occupiedDocks = 0;

    if(dashboardData != null){
        totalShips = dashboardData.getTotalShips();
        activeAllocations = dashboardData.getActiveAllocations();
        availableDocks = dashboardData.getAvailableDocks();
        occupiedDocks = dashboardData.getOccupiedDocks();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>
*{ box-sizing:border-box; }

body{
    margin:0;
    font-family:Arial, sans-serif;
    background:linear-gradient(135deg,#edf4ff,#f8fbff);
}

/* SAME NAVBAR */
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

/* SAME SIDEBAR */
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

/* MAIN */
.main{
    margin-left:260px;
    margin-top:74px;
    padding:30px;
}

/* HERO SECTION */
.hero-box{
    background:linear-gradient(135deg,#0d47a1,#1976d2);
    color:#fff;
    border-radius:20px;
    padding:28px;
    box-shadow:0 10px 25px rgba(13,71,161,0.18);
    margin-bottom:28px;
}

.hero-box h2{
    margin:0 0 8px 0;
    font-size:32px;
    font-weight:700;
}

.hero-box p{
    margin:0;
    color:#dce9ff;
}

/* STATS CARDS */
.card-box{
    padding:22px;
    border-radius:18px;
    background:#fff;
    text-align:left;
    box-shadow:0 8px 18px rgba(0,0,0,0.06);
    transition:0.3s;
    height:100%;
}

.card-box:hover{
    transform:translateY(-4px);
}

.card-icon{
    width:54px;
    height:54px;
    border-radius:14px;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:24px;
    margin-bottom:14px;
}

.icon-ship{ background:#e3f2fd; color:#0d47a1; }
.icon-allocation{ background:#e8f5e9; color:#2e7d32; }
.icon-available{ background:#fff3e0; color:#ef6c00; }
.icon-occupied{ background:#f3e5f5; color:#6a1b9a; }

.card-title{
    font-size:20px;
    font-weight:700;
    margin-bottom:6px;
    color:#1f3552;
}

.card-count{
    font-size:34px;
    font-weight:800;
    line-height:1;
    margin-bottom:10px;
}

.card-text{
    color:#6b7d90;
    font-size:14px;
    margin:0;
}

/* QUICK PANEL */
.panel{
    background:#fff;
    border-radius:18px;
    padding:22px;
    box-shadow:0 8px 18px rgba(0,0,0,0.06);
    margin-top:28px;
}

.panel h4{
    margin-bottom:16px;
    font-weight:700;
    color:#0d47a1;
}

.badge-role{
    background:rgba(255,255,255,0.18);
    padding:8px 14px;
    border-radius:20px;
    font-size:13px;
    display:inline-block;
    margin-top:10px;
}

.quick-stat{
    background:#f8fbff;
    border:1px solid #e0ecff;
    border-radius:14px;
    padding:16px;
    height:100%;
}

.quick-stat h6{
    margin:0 0 8px 0;
    color:#0d47a1;
    font-weight:700;
}

.quick-stat p{
    margin:0;
    color:#4f647a;
    font-size:14px;
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
    <a href="dashboard" class="active"><i class="bi bi-speedometer2"></i> Dashboard</a>

    <div class="sidebar-title mt-3">Operations</div>

    <% if("Admin".equalsIgnoreCase(roleName)) { %>
        <a href="shipmanagement?action=show"><i class="bi bi-water"></i> Ship Management</a>
        <a href="dockmanagement?action=show"><i class="bi bi-grid-3x3-gap"></i> Dock Management</a>
        <a href="dockallocation?action=show"><i class="bi bi-arrow-left-right"></i> Dock Allocation</a>
        <a href="containermanagement?action=show"><i class="bi bi-box-seam"></i> Container Management</a>
        <a href="cargohandling?action=show"><i class="bi bi-boxes"></i> Cargo Handling</a>
        <a href="securitylog?action=show"><i class="bi bi-shield-check"></i> Security Log</a>

        <div class="sidebar-title mt-3">Admin</div>
        <a href="usermanagement?action=show"><i class="bi bi-people"></i> User Management</a>
    <% } %>

    <% if("Port Manager".equalsIgnoreCase(roleName)) { %>
        <a href="shipmanagement?action=show"><i class="bi bi-water"></i> Ship Management</a>
        <a href="dockmanagement?action=show"><i class="bi bi-grid-3x3-gap"></i> Dock Management</a>
        <a href="dockallocation?action=show"><i class="bi bi-arrow-left-right"></i> Dock Allocation</a>
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
        <a href="dockallocation?action=show"><i class="bi bi-arrow-left-right"></i> Dock Allocation</a>
    <% } %>

    <% if("Cargo Handler".equalsIgnoreCase(roleName)) { %>
        <a href="cargohandling?action=show"><i class="bi bi-boxes"></i> Cargo Handling</a>
    <% } %>

    <a href="profile?action=show"><i class="bi bi-gear"></i> Profile & Settings</a>
</div>

<div class="main">

    <div class="hero-box">
        <h2>Dashboard</h2>
        <p>Welcome back, <strong><%= userName %></strong>. Manage your port operations from one central workspace.</p>
        <div class="badge-role">
            Logged in as: <%= roleName %>
        </div>
    </div>

    <div class="row g-4">

        <div class="col-md-3">
            <div class="card-box">
                <div class="card-icon icon-ship">
                    <i class="bi bi-water"></i>
                </div>
                <div class="card-title">Total Ships</div>
                <div class="card-count text-primary"><%= totalShips %></div>
                <p class="card-text">Total ship records currently available in the database.</p>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-box">
                <div class="card-icon icon-allocation">
                    <i class="bi bi-arrow-left-right"></i>
                </div>
                <div class="card-title">Active Allocations</div>
                <div class="card-count text-success"><%= activeAllocations %></div>
                <p class="card-text">Ships that are currently allocated to docks.</p>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-box">
                <div class="card-icon icon-available">
                    <i class="bi bi-unlock"></i>
                </div>
                <div class="card-title">Available Docks</div>
                <div class="card-count text-warning"><%= availableDocks %></div>
                <p class="card-text">Docks available right now for fresh allocation.</p>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-box">
                <div class="card-icon icon-occupied">
                    <i class="bi bi-lock"></i>
                </div>
                <div class="card-title">Occupied Docks</div>
                <div class="card-count text-danger"><%= occupiedDocks %></div>
                <p class="card-text">Docks currently occupied by allocated ships.</p>
            </div>
        </div>

    </div>

    <div class="panel">
        <h4><i class="bi bi-lightning-charge me-2"></i>Quick Overview</h4>

        <div class="row g-3">
            <div class="col-md-3">
                <div class="quick-stat">
                    <h6>Ships</h6>
                    <p><strong><%= totalShips %></strong> ship records available.</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="quick-stat">
                    <h6>Allocations</h6>
                    <p><strong><%= activeAllocations %></strong> active dock allocations running.</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="quick-stat">
                    <h6>Available Docks</h6>
                    <p><strong><%= availableDocks %></strong> docks ready for use.</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="quick-stat">
                    <h6>Occupied Docks</h6>
                    <p><strong><%= occupiedDocks %></strong> docks currently engaged.</p>
                </div>
            </div>
        </div>
    </div>

</div>

</body>
</html>