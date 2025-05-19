<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.roomly.model.User" %>

<%
    // Check if user is logged in and is admin
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !currentUser.isAdmin()) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add-on Services Direct Access - Roomly</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="alert alert-info">
            <h4>Troubleshooting Add-on Services</h4>
            <p>This page helps diagnose issues with the add-on services feature.</p>
        </div>
        
        <div class="card mb-4">
            <div class="card-header">
                <h5>Database Check</h5>
            </div>
            <div class="card-body">
                <p>Click the button below to check if the add-on services tables exist in your database:</p>
                <a href="addon-check.jsp" class="btn btn-primary">Check Database Tables</a>
            </div>
        </div>
        
        <div class="card mb-4">
            <div class="card-header">
                <h5>Direct Access Links</h5>
            </div>
            <div class="card-body">
                <p>Try accessing the add-on services page directly:</p>
                <a href="addon-services.jsp" class="btn btn-success mb-2">Go to Add-on Services Page</a>
                
                <p class="mt-3">If the above link doesn't work, try the simplified version:</p>
                <a href="addon-simple.jsp" class="btn btn-warning">Go to Simplified Add-on Page</a>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h5>Navigation Check</h5>
            </div>
            <div class="card-body">
                <p>Return to the admin dashboard:</p>
                <a href="index.jsp" class="btn btn-secondary">Go to Admin Dashboard</a>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
