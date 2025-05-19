<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.roomly.model.User" %>
<%@ page import="com.roomly.util.DatabaseUtil" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    // Check if user is logged in and is admin
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !currentUser.isAdmin()) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Get services directly from database
    List<Map<String, Object>> services = new ArrayList<>();
    String errorMessage = null;
    
    try (Connection conn = DatabaseUtil.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery("SELECT * FROM addon_services ORDER BY service_type, service_name")) {
        
        while (rs.next()) {
            Map<String, Object> service = new HashMap<>();
            service.put("id", rs.getInt("service_id"));
            service.put("name", rs.getString("service_name"));
            service.put("type", rs.getString("service_type"));
            service.put("description", rs.getString("description"));
            service.put("price", rs.getDouble("price"));
            service.put("imageUrl", rs.getString("image_url"));
            service.put("active", rs.getBoolean("is_active"));
            
            services.add(service);
        }
    } catch (SQLException e) {
        errorMessage = e.getMessage();
        e.printStackTrace();
    }
    
    // Handle form submission
    String action = request.getParameter("action");
    String message = null;
    
    if (action != null) {
        try (Connection conn = DatabaseUtil.getConnection()) {
            if (action.equals("add")) {
                String name = request.getParameter("serviceName");
                String type = request.getParameter("serviceType");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));
                String imageUrl = request.getParameter("imageUrl");
                
                String sql = "INSERT INTO addon_services (service_name, service_type, description, price, image_url, is_active) VALUES (?, ?, ?, ?, ?, TRUE)";
                
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, name);
                    pstmt.setString(2, type);
                    pstmt.setString(3, description);
                    pstmt.setDouble(4, price);
                    pstmt.setString(5, imageUrl);
                    
                    int rowsAffected = pstmt.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        message = "Service added successfully!";
                        response.sendRedirect("addon-simple.jsp?success=add");
                        return;
                    }
                }
            }
        } catch (Exception e) {
            errorMessage = e.getMessage();
            e.printStackTrace();
        }
    }
    
    // Get success message
    String success = request.getParameter("success");
    if (success != null) {
        if (success.equals("add")) {
            message = "Service added successfully!";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simple Add-on Services - Roomly</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Simplified Add-on Services Management</h2>
        
        <% if (message != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <% if (errorMessage != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                Error: <%= errorMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Add-on Services</h5>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addServiceModal">
                    Add New Service
                </button>
            </div>
            <div class="card-body">
                <% if (services.isEmpty()) { %>
                    <div class="alert alert-info">
                        No services found. Add your first service using the button above.
                    </div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Type</th>
                                    <th>Price</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Map<String, Object> service : services) { %>
                                    <tr>
                                        <td><%= service.get("id") %></td>
                                        <td><%= service.get("name") %></td>
                                        <td><%= service.get("type") %></td>
                                        <td>$<%= String.format("%.2f", service.get("price")) %></td>
                                        <td>
                                            <% if ((Boolean) service.get("active")) { %>
                                                <span class="badge bg-success">Active</span>
                                            <% } else { %>
                                                <span class="badge bg-danger">Inactive</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
        
        <a href="addon-direct.jsp" class="btn btn-secondary">Back to Troubleshooting</a>
    </div>
    
    <!-- Add Service Modal -->
    <div class="modal fade" id="addServiceModal" tabindex="-1" aria-labelledby="addServiceModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addServiceModalLabel">Add New Service</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="addon-simple.jsp" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-3">
                            <label for="serviceName" class="form-label">Service Name</label>
                            <input type="text" class="form-control" id="serviceName" name="serviceName" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="serviceType" class="form-label">Service Type</label>
                            <select class="form-select" id="serviceType" name="serviceType" required>
                                <option value="CATERING">Catering</option>
                                <option value="EQUIPMENT">Equipment</option>
                                <option value="OTHER">Other</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label for="price" class="form-label">Price</label>
                            <div class="input-group">
                                <span class="input-group-text">$</span>
                                <input type="number" class="form-control" id="price" name="price" min="0" step="0.01" required>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="imageUrl" class="form-label">Image URL</label>
                            <input type="text" class="form-control" id="imageUrl" name="imageUrl" value="../assets/images/placeholder.jpg">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Add Service</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
