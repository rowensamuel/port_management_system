<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model.Profile" %>
<%
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("userName");
    String roleName = (String) session.getAttribute("roleName");

    Profile profile = (Profile) request.getAttribute("profileData");

    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Profile & Settings</title>

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

.hero-box{
    background:linear-gradient(135deg,#0d47a1,#1976d2);
    color:#fff;
    border-radius:20px;
    padding:28px;
    margin-bottom:28px;
    box-shadow:0 10px 25px rgba(13,71,161,0.18);
}

.profile-card{
    background:#fff;
    border-radius:18px;
    padding:24px;
    box-shadow:0 8px 18px rgba(0,0,0,0.06);
    margin-bottom:24px;
}

.profile-card h4{
    color:#0d47a1;
    font-weight:700;
    margin-bottom:18px;
}

.info-box{
    background:#f8fbff;
    border:1px solid #e0ebfa;
    border-radius:14px;
    padding:14px 16px;
    margin-bottom:12px;
}

.label{
    font-size:13px;
    color:#6b7d90;
}

.value{
    font-size:16px;
    font-weight:600;
    color:#1f3552;
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

    <a href="profile?action=show" class="active"><i class="bi bi-gear"></i> Profile & Settings</a>
</div>

<div class="main">

    <div class="hero-box">
        <h2>Profile & Settings</h2>
        <p>Manage your personal information and password securely.</p>
    </div>

    <% if(success != null){ %>
        <div class="alert alert-success"><%= success %></div>
    <% } %>

    <% if(error != null){ %>
        <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <div class="row g-4">
        <div class="col-lg-5">
            <div class="profile-card">
                <h4><i class="bi bi-person-circle me-2"></i>My Profile</h4>

                <div class="info-box">
                    <div class="label">User ID</div>
                    <div class="value"><%= profile != null ? profile.getUserId() : "" %></div>
                </div>

                <div class="info-box">
                    <div class="label">Name</div>
                    <div class="value"><%= profile != null ? profile.getName() : "" %></div>
                </div>

                <div class="info-box">
                    <div class="label">Email</div>
                    <div class="value"><%= profile != null ? profile.getEmail() : "" %></div>
                </div>

                <div class="info-box">
                    <div class="label">Role</div>
                    <div class="value"><%= profile != null ? profile.getRoleName() : "" %></div>
                </div>
            </div>
        </div>

        <div class="col-lg-7">
            <div class="profile-card">
                <h4><i class="bi bi-pencil-square me-2"></i>Update Display Name</h4>

                <form action="profile" method="post">
                    <input type="hidden" name="action" value="updateName">

                    <div class="mb-3">
                        <label class="form-label">Display Name</label>
                        <input type="text" name="name" class="form-control"
                               value="<%= profile != null ? profile.getName() : "" %>" required>
                    </div>

                    <button type="submit" class="btn btn-primary">Update Name</button>
                </form>
            </div>

            <div class="profile-card">
                <h4><i class="bi bi-envelope me-2"></i>Update Email</h4>

                <form action="profile" method="post">
                    <input type="hidden" name="action" value="updateEmail">

                    <div class="mb-3">
                        <label class="form-label">Email Address</label>
                        <input type="email" name="email" class="form-control"
                               value="<%= profile != null ? profile.getEmail() : "" %>" required>
                    </div>

                    <button type="submit" class="btn btn-primary">Update Email</button>
                </form>
            </div>

            <div class="profile-card">
                <h4><i class="bi bi-key me-2"></i>Change Password</h4>

                <form action="profile" method="post">
                    <input type="hidden" name="action" value="changePassword">

                    <div class="mb-3">
                        <label class="form-label">Current Password</label>
                        <input type="password" name="currentPassword" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">New Password</label>
                        <input type="password" name="newPassword" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Confirm New Password</label>
                        <input type="password" name="confirmPassword" class="form-control" required>
                    </div>

                    <button type="submit" class="btn btn-dark">Change Password</button>
                </form>
            </div>
        </div>
    </div>

</div>

</body>
</html>