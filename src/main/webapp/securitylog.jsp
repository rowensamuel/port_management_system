<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.SecurityLog" %>
<%
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("userName");
    String roleName = (String) session.getAttribute("roleName");

    List<SecurityLog> list = (List<SecurityLog>) request.getAttribute("securityLogList");

    String username = request.getAttribute("username") != null ? (String) request.getAttribute("username") : "";
    String selectedRole = request.getAttribute("role") != null ? (String) request.getAttribute("role") : "All Roles";
    String fromDate = request.getAttribute("fromDate") != null ? (String) request.getAttribute("fromDate") : "";
    String toDate = request.getAttribute("toDate") != null ? (String) request.getAttribute("toDate") : "";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Security Log - Port Management System</title>

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
.main-content{ margin-left:260px; margin-top:74px; padding:30px; }
.hero-card{ background:linear-gradient(135deg,#0d47a1,#1976d2); border-radius:24px; padding:28px; color:#fff; margin-bottom:26px; }
.page-card{ background:#fff; border:none; border-radius:22px; box-shadow:0 10px 22px rgba(13,71,161,0.08); padding:24px; margin-bottom:24px; }
.section-title{ font-size:24px; font-weight:700; color:#0d47a1; margin-bottom:16px; }
.table th{ background:#f5f9ff; }
@media(max-width:768px){
    .topbar{ position:static; height:auto; padding:16px; flex-direction:column; align-items:flex-start; gap:14px; }
    .sidebar{ position:static; width:100%; height:auto; }
    .main-content{ margin-left:0; margin-top:0; padding:20px; }
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
        <a href="containermanagement?action=show"><i class="bi bi-box-seam"></i> Container Management</a>
        <a href="cargohandling?action=show"><i class="bi bi-boxes"></i> Cargo Handling</a>
        <a href="securitylog?action=show" class="active"><i class="bi bi-shield-check"></i> Security Log</a>

        <div class="sidebar-title mt-3">Admin</div>
        <a href="usermanagement?action=show"><i class="bi bi-people"></i> User Management</a>
    <% } %>

    <% if("Port Manager".equalsIgnoreCase(roleName)) { %>
        <a href="shipmanagement?action=show"><i class="bi bi-water"></i> Ship Management</a>
        <a href="dockmanagement?action=show"><i class="bi bi-grid-3x3-gap"></i> Dock Management</a>
        <a href="dockallocation?action=show"><i class="bi bi-arrow-left-right"></i> Dock Allocation</a>
        <a href="containermanagement?action=show"><i class="bi bi-box-seam"></i> Container Management</a>
        <a href="cargohandling?action=show"><i class="bi bi-boxes"></i> Cargo Handling</a>
        <a href="securitylog?action=show" class="active"><i class="bi bi-shield-check"></i> Security Log</a>
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

    <a href="profile?action=show"><i class="bi bi-gear"></i> Profile &amp; Settings</a>

</div>

<div class="main-content">

    <div class="hero-card">
        <h2>Security Log</h2>
        <p>Audit and compliance page for session history and security monitoring.</p>
    </div>

    <form action="securitylog" method="get" class="page-card">
        <input type="hidden" name="action" value="search">

        <div class="row g-3">
            <div class="col-md-3">
                <input type="text" name="username" value="<%= username %>" class="form-control" placeholder="Username">
            </div>

            <div class="col-md-2">
                <select name="role" class="form-select">
                    <option <%= "All Roles".equals(selectedRole) ? "selected" : "" %>>All Roles</option>
                    <option <%= "Admin".equals(selectedRole) ? "selected" : "" %>>Admin</option>
                    <option <%= "Port Manager".equals(selectedRole) ? "selected" : "" %>>Port Manager</option>
                    <option <%= "Ship Operator".equals(selectedRole) ? "selected" : "" %>>Ship Operator</option>
                    <option <%= "Dock Manager".equals(selectedRole) ? "selected" : "" %>>Dock Manager</option>
                    <option <%= "Cargo Handler".equals(selectedRole) ? "selected" : "" %>>Cargo Handler</option>
                </select>
            </div>

            <div class="col-md-2">
                <input type="date" name="fromDate" value="<%= fromDate %>" class="form-control">
            </div>

            <div class="col-md-2">
                <input type="date" name="toDate" value="<%= toDate %>" class="form-control">
            </div>

            <div class="col-md-3">
                <button class="btn btn-primary">Filter</button>
                <a href="securitylog?action=show" class="btn btn-dark">Reset</a>
                <a href="securitylog?action=export" class="btn btn-success">Export CSV</a>
            </div>
        </div>
    </form>

    <div class="page-card">
        <div class="section-title">Session History</div>

        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead>
                    <tr>
                        <th>Log ID</th>
                        <th>User ID</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Entry Time</th>
                        <th>Exit Time</th>
                        <th>Session Duration</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if(list != null && !list.isEmpty()){
                        for(SecurityLog s : list){
                %>
                    <tr>
                        <td><%= s.getLogId() %></td>
                        <td><%= s.getUserId() %></td>
                        <td><%= s.getUsername() %></td>
                        <td><%= s.getRoleName() %></td>
                        <td><%= s.getEntryTime() %></td>
                        <td><%= s.getExitTime() %></td>
                        <td><%= s.getDuration() %></td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="7" class="text-center">No security log records found</td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

</div>

</body>
</html>