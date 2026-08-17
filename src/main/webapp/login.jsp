<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login - Port Management System</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>
body {
    background: linear-gradient(135deg, #ffffff, #ffffff);
    min-height: 100vh;
    font-family: Arial, sans-serif;
    margin: 0;
}
.navbar-custom {
    background: linear-gradient(90deg, #0d47a1, #1565c0);
}
.brand-title {
    font-weight: 700;
    font-size: 22px;
    display: flex;
    align-items: center;
    gap: 10px;
}
.login-wrapper {
    min-height: calc(100vh - 72px);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
}
.login-card {
    width: 100%;
    max-width: 420px;
    border-radius: 18px;
    padding: 30px;
    background: linear-gradient(135deg, #0d47a1, #1976d2);
    color: white;
    box-shadow: 0 15px 35px rgba(0,0,0,0.4);
    text-align: center;
}
.login-icon {
    font-size: 45px;
    margin-bottom: 10px;
}
.form-label-custom {
    color: #ffffff;
    font-weight: 600;
    margin-bottom: 8px;
    display: block;
    text-align: left;
}
.form-control {
    border-radius: 10px;
    border: none;
    background: rgba(255,255,255,0.95);
    height: 48px;
}
.btn-login {
    background: #ffffff;
    color: #0d47a1;
    font-weight: bold;
    border-radius: 10px;
    border: none;
}
</style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
    <div class="container-fluid px-4">
        <a class="navbar-brand brand-title" href="#">
            <i class="bi bi-water"></i>
            Port Management System
        </a>
    </div>
</nav>

<div class="login-wrapper">
    <div class="login-card">

        <div class="login-icon">
            <i class="bi bi-water"></i>
        </div>

        <h3 class="fw-bold mb-2">Welcome Back</h3>
        <p class="mb-4">Login to access your dashboard</p>

        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>

        <form action="login" method="post">
            <div class="mb-3 text-start">
                <label class="form-label-custom">Email</label>
                <input type="email" class="form-control" name="email" placeholder="Enter your email" required>
            </div>

            <div class="mb-4 text-start">
                <label class="form-label-custom">Password</label>
                <input type="password" class="form-control" name="password" placeholder="Enter your password" required>
            </div>

            <button type="submit" class="btn btn-login w-100 py-2">Login</button>
        </form>

    </div>
</div>

</body>
</html>