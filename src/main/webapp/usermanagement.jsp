<%@ page import="java.util.*,model.User" %>

<%
if(session.getAttribute("userId")==null){
    response.sendRedirect("login.jsp");
    return;
}

String userName = (String) session.getAttribute("userName");
String roleName = (String) session.getAttribute("roleName");

List<User> list = (List<User>)request.getAttribute("userList");
%>

<!DOCTYPE html>
<html>
<head>
<title>User Management</title>

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
    justify-content:space-between;
    align-items:center;
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
    border-radius:22px;
    padding:28px;
    margin-bottom:28px;
    box-shadow:0 10px 25px rgba(13,71,161,0.18);
}

.hero-box h2{
    margin:0 0 8px 0;
    font-size:30px;
    font-weight:700;
}

.hero-box p{
    margin:0;
    color:#dce9ff;
}

.page-card{
    background:#fff;
    border-radius:22px;
    box-shadow:0 10px 22px rgba(13,71,161,0.08);
    padding:24px;
    margin-bottom:24px;
}

.table thead th{
    background:#f5f9ff;
    color:#50657a;
    font-size:13px;
    text-transform:uppercase;
    letter-spacing:0.5px;
    border:none;
    white-space:nowrap;
}

.table td{
    vertical-align:middle;
    border-color:#eef3f8;
}

.status-pill{
    padding:6px 12px;
    border-radius:999px;
    font-size:12px;
    font-weight:700;
    display:inline-block;
}

.status-active{
    background:#e8f5e9;
    color:#2e7d32;
}

.status-inactive{
    background:#ffebee;
    color:#c62828;
}

.role-pill{
    padding:6px 12px;
    border-radius:999px;
    font-size:12px;
    font-weight:700;
    display:inline-block;
    background:#e3f2fd;
    color:#0d47a1;
}

.action-btns{
    display:flex;
    align-items:center;
    gap:10px;
    flex-wrap:nowrap;
    min-width:370px;
}

.action-btns form{
    margin:0;
}

.action-btns .btn{
    height:36px;
    min-width:110px;
    display:inline-flex;
    align-items:center;
    justify-content:center;
    border-radius:10px;
    font-size:13px;
    font-weight:600;
    white-space:nowrap;
    padding:0 14px;
}

.action-btns .form-select{
    height:36px;
    min-width:150px;
    border-radius:10px;
    font-size:13px;
}

.modal-content{
    border-radius:18px;
    border:none;
}

.modal-header{
    background:linear-gradient(90deg,#0d47a1,#1565c0);
    color:#fff;
    border-top-left-radius:18px;
    border-top-right-radius:18px;
}

.btn-close{
    filter:invert(1);
}

.section-title{
    font-size:20px;
    font-weight:700;
    color:#0d47a1;
    margin-bottom:16px;
}

@media(max-width:992px){
    .action-btns{
        flex-wrap:wrap;
        min-width:auto;
    }
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
        <a href="dockallocation?action=show"><i class="bi bi-arrow-left-right"></i> Dock Allocation</a>
        <a href="containermanagement?action=show"><i class="bi bi-box-seam"></i> Container Management</a>
        <a href="cargohandling?action=show"><i class="bi bi-boxes"></i> Cargo Handling</a>
        <a href="securitylog?action=show"><i class="bi bi-shield-check"></i> Security Log</a>

        <div class="sidebar-title mt-3">Admin</div>
        <a href="usermanagement?action=show" class="active"><i class="bi bi-people"></i> User Management</a>
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
        <h2>User Management</h2>
        <p>Administrator-only page to manage all registered users, roles, and account access status.</p>
    </div>

    <div class="page-card">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <div class="section-title">Registered Users</div>
                <p class="text-muted mb-0">Add new users, edit user details, reassign roles, and activate/deactivate accounts.</p>
            </div>

            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                <i class="bi bi-plus-circle me-1"></i> Add User
            </button>
        </div>
    </div>

    <div class="page-card">
        <div class="table-responsive">
            <table class="table align-middle">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Account Status</th>
                        <th style="width:390px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% if(list != null && !list.isEmpty()){ for(User u:list){ %>
                    <tr>
                        <td><strong><%=u.getName()%></strong></td>
                        <td><%=u.getEmail()%></td>
                        <td><span class="role-pill"><%=u.getRoleName()%></span></td>
                        <td>
                            <% if(u.isActive()){ %>
                                <span class="status-pill status-active">Active</span>
                            <% } else { %>
                                <span class="status-pill status-inactive">Inactive</span>
                            <% } %>
                        </td>
                        <td>
                            <div class="action-btns">
                                <button type="button"
                                        class="btn btn-info btn-sm text-white"
                                        data-bs-toggle="modal"
                                        data-bs-target="#editUserModal"
                                        onclick="setEditUser('<%=u.getUserId()%>','<%=u.getName()%>','<%=u.getEmail()%>','<%=u.getRoleId()%>')">
                                    <i class="bi bi-pencil-square me-1"></i>Edit
                                </button>

                                <form action="usermanagement" method="post">
                                    <input type="hidden" name="action" value="updateRole">
                                    <input type="hidden" name="userId" value="<%=u.getUserId()%>">

                                    <select name="roleId" class="form-select form-select-sm" onchange="this.form.submit()">
                                        <option value="1" <%=u.getRoleId()==1?"selected":""%>>Admin</option>
                                        <option value="2" <%=u.getRoleId()==2?"selected":""%>>Port Manager</option>
                                        <option value="3" <%=u.getRoleId()==3?"selected":""%>>Ship Operator</option>
                                        <option value="4" <%=u.getRoleId()==4?"selected":""%>>Dock Manager</option>
                                        <option value="5" <%=u.getRoleId()==5?"selected":""%>>Cargo Handler</option>
                                    </select>
                                </form>

                                <a href="usermanagement?action=toggle&id=<%=u.getUserId()%>&status=<%=u.isActive()%>"
                                   class="btn btn-warning btn-sm"
                                   onclick="return confirm('Are you sure you want to <%=u.isActive() ? "deactivate" : "activate"%> this account?');">
                                   <%=u.isActive() ? "Deactivate" : "Activate"%>
                                </a>
                            </div>
                        </td>
                    </tr>
                <% }} else { %>
                    <tr>
                        <td colspan="5" class="text-center text-muted">No users found</td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<div class="modal fade" id="addUserModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="usermanagement" method="post">
                <input type="hidden" name="action" value="add">

                <div class="modal-header">
                    <h5 class="modal-title">Add User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" name="name" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Role</label>
                        <select name="roleId" class="form-select">
                            <option value="1">Admin</option>
                            <option value="2">Port Manager</option>
                            <option value="3">Ship Operator</option>
                            <option value="4">Dock Manager</option>
                            <option value="5">Cargo Handler</option>
                        </select>
                    </div>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-primary">Save User</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="editUserModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="usermanagement" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="userId" id="editUserId">

                <div class="modal-header">
                    <h5 class="modal-title">Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" name="name" id="editName" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="email" id="editEmail" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Role</label>
                        <select name="roleId" id="editRoleId" class="form-select">
                            <option value="1">Admin</option>
                            <option value="2">Port Manager</option>
                            <option value="3">Ship Operator</option>
                            <option value="4">Dock Manager</option>
                            <option value="5">Cargo Handler</option>
                        </select>
                    </div>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-success">Update User</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function setEditUser(userId, name, email, roleId){
    document.getElementById("editUserId").value = userId;
    document.getElementById("editName").value = name;
    document.getElementById("editEmail").value = email;
    document.getElementById("editRoleId").value = roleId;
}
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>