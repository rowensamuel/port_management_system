<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String msg = (String) request.getAttribute("errorMessage");
if(msg == null){
    msg = "Access Denied";
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Access Denied</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body{
    background: linear-gradient(135deg, #edf4ff, #f8fbff);
    font-family: Arial, sans-serif;
}
.box{
    max-width: 550px;
    margin: 120px auto;
    background: #fff;
    padding: 35px;
    border-radius: 20px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.08);
    text-align: center;
}
</style>
</head>
<body>

<div class="box">
    <h2 class="text-danger mb-3">Access Denied</h2>
    <p class="text-muted"><%= msg %></p>
    <a href="dashboard" class="btn btn-primary mt-3">Go Back to Dashboard</a>
</div>

</body>
</html>