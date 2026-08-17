<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="model.Cargo"%>
<%@ page import="model.CargoMovement"%>
<%@ page import="model.Container"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>

<%
    if(session.getAttribute("userId") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("userName");
    String roleName = (String) session.getAttribute("roleName");
    Integer userId = (Integer) session.getAttribute("userId");

    List<Cargo> cargoList = (List<Cargo>) request.getAttribute("cargoList");
    if(cargoList == null) cargoList = new ArrayList<Cargo>();

    List<Container> containerList = (List<Container>) request.getAttribute("containerList");
    if(containerList == null) containerList = new ArrayList<Container>();

    List<CargoMovement> movementList = (List<CargoMovement>) request.getAttribute("movementList");
    if(movementList == null) movementList = new ArrayList<CargoMovement>();

    Cargo editCargo = (Cargo) request.getAttribute("editCargo");
    Container selectedContainer = (Container) request.getAttribute("selectedContainer");
    Cargo historyCargo = (Cargo) request.getAttribute("historyCargo");

    String errorMessage = request.getAttribute("errorMessage") != null ? (String) request.getAttribute("errorMessage") : "";

    String searchCargoId = request.getAttribute("searchCargoId") != null ? (String) request.getAttribute("searchCargoId") : "";
    String searchContainerId = request.getAttribute("searchContainerId") != null ? (String) request.getAttribute("searchContainerId") : "";
    String searchStatus = request.getAttribute("searchStatus") != null ? (String) request.getAttribute("searchStatus") : "";
    String searchDescription = request.getAttribute("searchDescription") != null ? (String) request.getAttribute("searchDescription") : "";

    String editCargoIdVal = "";
    String editContainerIdVal = "";
    String editDescriptionVal = "";
    String editWeightVal = "";
    String editStatusVal = "";

    if(editCargo != null){
        editCargoIdVal = String.valueOf(editCargo.getCargoId());
        editContainerIdVal = String.valueOf(editCargo.getContainerId());
        editDescriptionVal = editCargo.getDescription() != null ? editCargo.getDescription() : "";
        editWeightVal = String.valueOf(editCargo.getWeight());
        editStatusVal = editCargo.getStatus() != null ? editCargo.getStatus() : "";
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cargo Handling - Port Management System</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
	rel="stylesheet">

<style>
* {
	box-sizing: border-box;
}

body {
	margin: 0;
	font-family: Arial, sans-serif;
	background: linear-gradient(135deg, #edf4ff, #f8fbff);
}

.topbar {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	height: 74px;
	background: linear-gradient(90deg, #0d47a1, #1565c0);
	color: #fff;
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 0 24px;
	z-index: 1000;
	box-shadow: 0 4px 16px rgba(0, 0, 0, 0.18);
}

.brand-wrap {
	display: flex;
	align-items: center;
	gap: 14px;
}

.brand-icon {
	width: 46px;
	height: 46px;
	border-radius: 14px;
	background: rgba(255, 255, 255, 0.15);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 22px;
}

.brand-text h4 {
	margin: 0;
	font-size: 24px;
	font-weight: 700;
}

.brand-text small {
	color: #d7e8ff;
	font-size: 12px;
}

.topbar-right {
	display: flex;
	align-items: center;
	gap: 18px;
}

.user-box {
	display: flex;
	align-items: center;
	gap: 10px;
	background: rgba(255, 255, 255, 0.12);
	padding: 8px 14px;
	border-radius: 14px;
}

.user-avatar {
	width: 38px;
	height: 38px;
	border-radius: 50%;
	background: rgba(255, 255, 255, 0.18);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 18px;
}

.user-meta .name {
	font-weight: 700;
	font-size: 14px;
	color: #fff;
}

.user-meta .role {
	font-size: 12px;
	color: #d7e8ff;
}

.logout-btn {
	border: none;
	background: #fff;
	color: #0d47a1;
	padding: 10px 18px;
	border-radius: 12px;
	font-weight: 700;
	text-decoration: none;
}

.sidebar {
	position: fixed;
	top: 74px;
	left: 0;
	width: 260px;
	height: calc(100vh - 74px);
	background: linear-gradient(180deg, #07182c, #0b1f3a);
	color: #fff;
	overflow-y: auto;
	padding: 22px 0;
}

.sidebar-title {
	padding: 0 24px;
	margin: 10px 0 12px;
	font-size: 12px;
	text-transform: uppercase;
	letter-spacing: 1px;
	font-weight: 700;
	color: #8fb5e6;
}

.sidebar a {
	display: flex;
	align-items: center;
	gap: 12px;
	text-decoration: none;
	color: #d8e7ff;
	padding: 14px 24px;
	font-size: 15px;
	transition: 0.3s ease;
	border-left: 4px solid transparent;
}

.sidebar a:hover, .sidebar a.active {
	background: rgba(21, 101, 192, 0.28);
	color: #fff;
	border-left: 4px solid #42a5f5;
	padding-left: 28px;
}

.main {
	margin-left: 260px;
	margin-top: 74px;
	padding: 30px;
}

.hero-card {
	background: linear-gradient(135deg, #0d47a1, #1976d2);
	border-radius: 24px;
	padding: 28px;
	color: #fff;
	margin-bottom: 26px;
}

.page-card {
	background: #fff;
	border: none;
	border-radius: 22px;
	box-shadow: 0 10px 22px rgba(13, 71, 161, 0.08);
	padding: 24px;
	margin-bottom: 24px;
}

.section-title {
	font-size: 24px;
	font-weight: 700;
	color: #0d47a1;
	margin-bottom: 16px;
}

.info-box {
	background: #f5f9ff;
	border: 1px solid #d9e8ff;
	border-radius: 16px;
	padding: 18px;
	height: 100%;
}

.table thead th {
	background: #f5f9ff;
}

.movement-btn-group .btn {
	min-width: 110px;
}

@media ( max-width :768px) {
	.topbar {
		position: static;
		height: auto;
		padding: 16px;
		flex-direction: column;
		align-items: flex-start;
		gap: 14px;
	}
	.sidebar {
		position: static;
		width: 100%;
		height: auto;
	}
	.main {
		margin-left: 0;
		margin-top: 0;
		padding: 20px;
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
			<a href="logout" class="logout-btn"><i
				class="bi bi-box-arrow-right me-1"></i> Logout</a>
		</div>
	</div>

	<div class="sidebar">
		<div class="sidebar-title">Main Menu</div>
		<a href="dashboard"><i class="bi bi-speedometer2"></i> Dashboard</a>

		<div class="sidebar-title mt-3">Operations</div>

		<% if("Admin".equalsIgnoreCase(roleName)) { %>
		<a href="shipmanagement?action=show"><i class="bi bi-water"></i>
			Ship Management</a> <a href="dockmanagement?action=show"><i
			class="bi bi-grid-3x3-gap"></i> Dock Management</a> <a
			href="dockallocation?action=show"><i
			class="bi bi-arrow-left-right"></i> Dock Allocation</a> <a
			href="containermanagement?action=show"><i class="bi bi-box-seam"></i>
			Container Management</a> <a href="cargohandling?action=show"
			class="active"><i class="bi bi-boxes"></i> Cargo Handling</a> <a
			href="securitylog?action=show"><i class="bi bi-shield-check"></i>
			Security Log</a>

		<div class="sidebar-title mt-3">Admin</div>
		<a href="usermanagement?action=show"><i class="bi bi-people"></i>
			User Management</a>
		<% } %>

		<% if("Port Manager".equalsIgnoreCase(roleName)) { %>
		<a href="shipmanagement?action=show"><i class="bi bi-water"></i>
			Ship Management</a> <a href="dockmanagement?action=show"><i
			class="bi bi-grid-3x3-gap"></i> Dock Management</a> <a
			href="dockallocation?action=show"><i
			class="bi bi-arrow-left-right"></i> Dock Allocation</a> <a
			href="containermanagement?action=show"><i class="bi bi-box-seam"></i>
			Container Management</a> <a href="cargohandling?action=show"
			class="active"><i class="bi bi-boxes"></i> Cargo Handling</a> <a
			href="securitylog?action=show"><i class="bi bi-shield-check"></i>
			Security Log</a>
		<% } %>

		<% if("Cargo Handler".equalsIgnoreCase(roleName)) { %>
		<a href="cargohandling?action=show" class="active"><i
			class="bi bi-boxes"></i> Cargo Handling</a>
		<% } %>

		<a href="profile?action=show"><i class="bi bi-gear"></i> Profile &
			Settings</a>
	</div>

	<div class="main">

		<div class="hero-card">
			<h2>Cargo Handling</h2>
			<p>Manage cargo records and log operational movement history in
				one integrated module.</p>
		</div>

		<% if(errorMessage != null && !errorMessage.trim().isEmpty()) { %>
		<div class="alert alert-danger"><%= errorMessage %></div>
		<% } %>

		<!-- Cargo Management -->
		<div class="page-card">
			<div class="section-title">Cargo Record Management</div>

			<form id="cargoForm" method="post" action="cargohandling">
				<input type="hidden" name="action" id="cargoFormAction"
					value="<%= editCargo != null ? "updateCargo" : "addCargo" %>">

				<div class="row g-3">
					<div class="col-md-3">
						<label class="form-label">Cargo ID *</label> <input type="number"
							name="cargoId" id="cargoId" class="form-control"
							value="<%= editCargoIdVal %>"
							placeholder="Required for update / delete / search">
					</div>

					<div class="col-md-3">
						<label class="form-label">Description</label> <input type="text"
							name="description" id="description" class="form-control"
							value="<%= editDescriptionVal.isEmpty() ? searchDescription : editDescriptionVal %>"
							placeholder="Cargo Description">
					</div>

					<div class="col-md-3">
						<label class="form-label">Weight</label> <input type="number"
							step="0.01" name="weight" id="weight" class="form-control"
							value="<%= editWeightVal %>" placeholder="Weight">
					</div>

					<div class="col-md-3">
						<label class="form-label">Cargo Status</label> <select
							name="status" id="cargoStatus" class="form-select">
							<option value="">-- Select Status --</option>
							<option value="LOADED"
								<%= ("LOADED".equals(editStatusVal) || "LOADED".equals(searchStatus)) ? "selected" : "" %>>LOADED</option>
							<option value="UNLOADED"
								<%= ("UNLOADED".equals(editStatusVal) || "UNLOADED".equals(searchStatus)) ? "selected" : "" %>>UNLOADED</option>
							<option value="IN_TRANSIT"
								<%= ("IN_TRANSIT".equals(editStatusVal) || "IN_TRANSIT".equals(searchStatus)) ? "selected" : "" %>>IN_TRANSIT</option>
						</select>
					</div>

					<div class="col-md-6">
						<label class="form-label">Assign Container</label> <select
							name="containerId" id="containerId" class="form-select"
							onchange="showContainerInfo()" required>
							<option value="">Select Container</option>
							<%
                            for(Container c : containerList){
                        %>
							<option value="<%= c.getContainerId() %>"
								data-type="<%= c.getContainerType() %>"
								data-status="<%= c.getStatus() %>"
								data-ship="<%= c.getShipName() %>"
								<%= String.valueOf(c.getContainerId()).equals(editContainerIdVal) || String.valueOf(c.getContainerId()).equals(searchContainerId) ? "selected" : "" %>>
								<%= c.getContainerId() %> -
								<%= c.getContainerType() %> -
								<%= c.getShipName() %>
							</option>
							<%
                            }
                        %>
						</select>
					</div>
				</div>

				<div class="mt-4 d-flex flex-wrap gap-3">
					<button type="submit" class="btn btn-primary"
						onclick="setCargoAction('addCargo')">
						<i class="bi bi-plus-circle me-1"></i> Add Cargo
					</button>

					<button type="submit" class="btn btn-warning text-white"
						onclick="setCargoAction('updateCargo')">
						<i class="bi bi-pencil-square me-1"></i> Update Cargo
					</button>

					<button type="button" class="btn btn-danger"
						onclick="deleteCargo()">
						<i class="bi bi-trash me-1"></i> Delete Cargo
					</button>

					<button type="button" class="btn btn-success"
						onclick="searchCargo()">
						<i class="bi bi-search me-1"></i> Search / Filter
					</button>

					<button type="button" class="btn btn-secondary"
						onclick="handleShowAll()">
						<i class="bi bi-grid me-1"></i> Show All
					</button>

				</div>
			</form>

			<div class="row mt-4">
				<div class="col-md-6">
					<div class="info-box">
						<h6 class="fw-bold text-primary mb-3">Selected Container
							Information</h6>
						<p class="mb-2">
							<strong>Container ID:</strong> <span id="infoContainerId"><%= selectedContainer != null ? selectedContainer.getContainerId() : "-" %></span>
						</p>
						<p class="mb-2">
							<strong>Container Type:</strong> <span id="infoContainerType"><%= selectedContainer != null ? selectedContainer.getContainerType() : "-" %></span>
						</p>
						<p class="mb-2">
							<strong>Assigned Ship:</strong> <span id="infoShipName"><%= selectedContainer != null ? selectedContainer.getShipName() : "-" %></span>
						</p>
						<p class="mb-0">
							<strong>Container Status:</strong> <span id="infoContainerStatus"><%= selectedContainer != null ? selectedContainer.getStatus() : "-" %></span>
						</p>
					</div>
				</div>
			</div>
		</div>

		<div class="page-card">
			<div class="section-title">All Cargo Items</div>

			<div class="table-responsive">
				<table class="table table-bordered align-middle">
					<thead>
						<tr>
							<th>Cargo ID</th>
							<th>Description</th>
							<th>Weight</th>
							<th>Assigned Container</th>
							<th>Container Type</th>
							<th>Ship</th>
							<th>Status</th>
							<th>Actions</th>
						</tr>
					</thead>
					<tbody>
						<%
                    if(!cargoList.isEmpty()){
                        for(Cargo c : cargoList){
                %>
						<tr>
							<td><%= c.getCargoId() %></td>
							<td><%= c.getDescription() %></td>
							<td><%= c.getWeight() %></td>
							<td><%= c.getContainerId() %></td>
							<td><%= c.getContainerType() %></td>
							<td><%= c.getShipName() %></td>
							<td><%= c.getStatus() %></td>
							<td>
								<button type="button" class="btn btn-warning btn-sm text-white"
									onclick="openEditModal(
    '<%=c.getCargoId()%>',
    '<%=c.getDescription().replace("'", "\\'")%>',
    '<%=c.getWeight()%>',
    '<%=c.getStatus()%>',
    '<%=c.getContainerId()%>'
)">
									Edit</button> <a
								href="cargohandling?action=movementHistory&cargoId=<%=c.getCargoId()%>"
								class="btn btn-info btn-sm text-white">History</a>
							</td>
						</tr>
						<%
						}
						} else {
						%>
						<tr>
							<td colspan="8" class="text-center">No cargo records found</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>
		</div>

		<!-- Cargo Movement -->
		<div class="page-card">
			<div class="section-title">Cargo Movement Logging</div>

			<form method="post" action="cargohandling">
				<input type="hidden" name="action" value="addMovement">

				<div class="row g-3">
					<div class="col-md-4">
						<label class="form-label">Select Cargo Item</label> <select
							name="movementCargoId" class="form-select" required>
							<option value="">Select Cargo</option>
							<%
                            for(Cargo c : cargoList){
                        %>
							<option value="<%= c.getCargoId() %>"
								<%= (historyCargo != null && historyCargo.getCargoId() == c.getCargoId()) ? "selected" : "" %>>
								<%= c.getCargoId() %> -
								<%= c.getDescription() %>
							</option>
							<%
                            }
                        %>
						</select>
					</div>

					<div class="col-md-4">
						<label class="form-label">Movement Type</label>
						<div class="movement-btn-group btn-group d-flex" role="group">
							<input type="radio" class="btn-check" name="movementType"
								id="loadBtn" value="LOAD" checked> <label
								class="btn btn-outline-primary" for="loadBtn">LOAD</label> <input
								type="radio" class="btn-check" name="movementType"
								id="unloadBtn" value="UNLOAD"> <label
								class="btn btn-outline-primary" for="unloadBtn">UNLOAD</label> <input
								type="radio" class="btn-check" name="movementType"
								id="transferBtn" value="TRANSFER"> <label
								class="btn btn-outline-primary" for="transferBtn">TRANSFER</label>
						</div>
					</div>

					<div class="col-md-4">
						<label class="form-label">Date / Time</label> <input
							type="datetime-local" name="movementDate" id="movementDate"
							class="form-control">
					</div>
				</div>

				<div class="mt-4">
					<button type="submit" class="btn btn-primary">
						<i class="bi bi-journal-plus me-1"></i> Log Movement
					</button>
				</div>
			</form>
		</div>

		<div class="page-card" id="movementHistorySection">
			<div class="section-title">
				Movement History
				<% if(historyCargo != null){ %>
				- Cargo
				<%= historyCargo.getCargoId() %>
				/
				<%= historyCargo.getDescription() %>
				<% } %>
			</div>

			<div class="table-responsive">
				<table class="table table-bordered align-middle">
					<thead>
						<tr>
							<th>Movement ID</th>
							<th>Cargo</th>
							<th>Movement Type</th>
							<th>Date / Time</th>
							<th>Handler</th>
						</tr>
					</thead>
					<tbody>
						<%
                    if(!movementList.isEmpty()){
                        for(CargoMovement m : movementList){
                %>
						<tr>
							<td><%= m.getMovementId() %></td>
							<td><%= m.getCargoId() %> - <%= m.getCargoDescription() %></td>
							<td><%= m.getMovementType() %></td>
							<%
    String dbDate = m.getMovementDate(); // String from DB
    String formattedDate = "";

    if(dbDate != null && !dbDate.isEmpty()){
        try {
            // DB format (IMPORTANT: match exactly)
            SimpleDateFormat dbFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            Date dateObj = dbFormat.parse(dbDate);

            // Desired format
            SimpleDateFormat displayFormat = new SimpleDateFormat("dd/MM/yy hh:mm a");

            formattedDate = displayFormat.format(dateObj);
        } catch(Exception e){
            formattedDate = dbDate; // fallback
        }
    }
%>

							<td><%= formattedDate %></td>
							<td><%= m.getHandlerName() %></td>
						</tr>
						<%
                        }
                    } else {
                %>
						<tr>
							<td colspan="5" class="text-center">No movement history
								found</td>
						</tr>
						<%
                    }
                %>
					</tbody>
				</table>
			</div>
		</div>

	</div>

	<!-- Edit Cargo Modal -->
	<div class="modal fade" id="editCargoModal" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">

				<form method="post" action="cargohandling">
					<input type="hidden" name="action" value="updateCargo">

					<div class="modal-header">
						<h5 class="modal-title">Edit Cargo</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
					</div>

					<div class="modal-body">

						<div class="mb-3">
							<label>Cargo ID</label> <input type="number" name="cargoId"
								id="editCargoId" class="form-control" readonly>
						</div>

						<div class="mb-3">
							<label>Description</label> <input type="text" name="description"
								id="editDescription" class="form-control">
						</div>

						<div class="mb-3">
							<label>Weight</label> <input type="number" step="0.01"
								name="weight" id="editWeight" class="form-control">
						</div>

						<div class="mb-3">
							<label>Status</label> <select name="status" id="editStatus"
								class="form-select">
								<option value="LOADED">LOADED</option>
								<option value="UNLOADED">UNLOADED</option>
								<option value="IN_TRANSIT">IN_TRANSIT</option>
							</select>
						</div>

						<div class="mb-3">
							<label>Container</label> <select name="containerId"
								id="editContainerId" class="form-select">
								<% for(Container c : containerList){ %>
								<option value="<%= c.getContainerId() %>">
									<%= c.getContainerId() %> -
									<%= c.getContainerType() %>
								</option>
								<% } %>
							</select>
						</div>

					</div>

					<div class="modal-footer">
						<button type="submit" class="btn btn-primary">Done</button>
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Cancel</button>
					</div>

				</form>

			</div>
		</div>
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script>
function setCargoAction(action){
    document.getElementById("cargoFormAction").value = action;
}

function deleteCargo(){
    let cargoId = document.getElementById("cargoId").value;

    if(cargoId == null || cargoId.trim() === ""){
        alert("Cargo ID is required for delete.");
        return;
    }

    if(confirm("Are you sure you want to delete this cargo?")){
        window.location = "cargohandling?action=deleteCargo&cargoId=" + cargoId;
    }
}

function searchCargo(){
    let cargoId = document.getElementById("cargoId").value;
    let containerId = document.getElementById("containerId").value;
    let status = document.getElementById("cargoStatus").value;
    let description = document.getElementById("description").value;

    let url = "cargohandling?action=searchCargo"
        + "&cargoId=" + encodeURIComponent(cargoId)
        + "&containerId=" + encodeURIComponent(containerId)
        + "&status=" + encodeURIComponent(status)
        + "&description=" + encodeURIComponent(description);

    window.location = url;
}

function showContainerInfo(){
    const select = document.getElementById("containerId");
    const selected = select.options[select.selectedIndex];

    document.getElementById("infoContainerId").innerText = selected.value ? selected.value : "-";
    document.getElementById("infoContainerType").innerText = selected.getAttribute("data-type") ? selected.getAttribute("data-type") : "-";
    document.getElementById("infoShipName").innerText = selected.getAttribute("data-ship") ? selected.getAttribute("data-ship") : "-";
    document.getElementById("infoContainerStatus").innerText = selected.getAttribute("data-status") ? selected.getAttribute("data-status") : "-";
}

(function setCurrentDateTime(){
    const input = document.getElementById("movementDate");
    if(input && !input.value){
        const now = new Date();
        const pad = n => n < 10 ? '0' + n : n;
        const formatted = now.getFullYear() + "-"
            + pad(now.getMonth()+1) + "-"
            + pad(now.getDate()) + "T"
            + pad(now.getHours()) + ":"
            + pad(now.getMinutes());
        input.value = formatted;
    }
    showContainerInfo();
})();

function openEditModal(id, desc, weight, status, containerId){
    document.getElementById("editCargoId").value = id;
    document.getElementById("editDescription").value = desc;
    document.getElementById("editWeight").value = weight;
    document.getElementById("editStatus").value = status;
    document.getElementById("editContainerId").value = containerId;

    var modal = new bootstrap.Modal(document.getElementById('editCargoModal'));
    modal.show();
}


function handleShowAll(){
    let cargoId = document.getElementById("cargoId").value;

    let url = "";

    if(cargoId && cargoId.trim() !== ""){
        url = "cargohandling?action=movementHistory&cargoId=" + encodeURIComponent(cargoId);
    } else {
        url = "cargohandling?action=show";
    }

    url += "#movementHistorySection";

    window.location.href = url;
}
</script>

</body>
</html>