<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.roomly.dao.AddonServiceDAO" %>
<%@ page import="com.roomly.model.AddonService" %>
<%@ page import="com.roomly.model.User" %>
<%@ page import="java.util.List" %>

<%
    // Check if user is logged in and is admin
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !currentUser.isAdmin()) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Get all add-on services
    AddonServiceDAO addonServiceDAO = new AddonServiceDAO();
    List<AddonService> services = addonServiceDAO.getAllActiveServices();
    
    // Get success/error messages
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Add-on Services - Roomly Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="../assets/css/style.css">
    <style>
        .service-image {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 5px;
        }
        
        .service-type-badge {
            font-size: 0.8rem;
            padding: 0.3rem 0.6rem;
        }
        
        .catering-badge {
            background-color: #FF9370;
        }
        
        .equipment-badge {
            background-color: #6a11cb;
        }
        
        .other-badge {
            background-color: #6c757d;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Manage Add-on Services</h2>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addServiceModal">
                <i class="fas fa-plus me-2"></i>Add New Service
            </button>
        </div>
        
        <% if (success != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <% if (success.equals("add")) { %>
                    Add-on service added successfully.
                <% } else if (success.equals("update")) { %>
                    Add-on service updated successfully.
                <% } else if (success.equals("delete")) { %>
                    Add-on service deleted successfully.
                <% } %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <% if (error != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                An error occurred. Please try again.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Image</th>
                                <th>Service Name</th>
                                <th>Type</th>
                                <th>Price</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (AddonService service : services) { %>
                                <tr>
                                    <td><%= service.getServiceId() %></td>
                                    <td>
                                        <% if (service.getImageUrl() != null && !service.getImageUrl().isEmpty()) { %>
                                            <img src="<%= service.getImageUrl() %>" class="service-image" alt="<%= service.getServiceName() %>">
                                        <% } else { %>
                                            <img src="../assets/images/addons/placeholder.jpg" class="service-image" alt="<%= service.getServiceName() %>">
                                        <% } %>
                                    </td>
                                    <td><%= service.getServiceName() %></td>
                                    <td>
                                        <% if (service.getServiceType().equals("CATERING")) { %>
                                            <span class="badge catering-badge">Catering</span>
                                        <% } else if (service.getServiceType().equals("EQUIPMENT")) { %>
                                            <span class="badge equipment-badge">Equipment</span>
                                        <% } else { %>
                                            <span class="badge other-badge">Other</span>
                                        <% } %>
                                    </td>
                                    <td>$<%= String.format("%.2f", service.getPrice()) %></td>
                                    <td>
                                        <% if (service.isActive()) { %>
                                            <span class="badge bg-success">Active</span>
                                        <% } else { %>
                                            <span class="badge bg-danger">Inactive</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#editServiceModal<%= service.getServiceId() %>">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                        <button type="button" class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteServiceModal<%= service.getServiceId() %>">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </td>
                                </tr>
                                
                                <!-- Edit Service Modal -->
                                <div class="modal fade" id="editServiceModal<%= service.getServiceId() %>" tabindex="-1" aria-labelledby="editServiceModalLabel<%= service.getServiceId() %>" aria-hidden="true">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="editServiceModalLabel<%= service.getServiceId() %>">Edit Add-on Service</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <form action="addon-service-process.jsp" method="post">
                                                <div class="modal-body">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="serviceId" value="<%= service.getServiceId() %>">
                                                    
                                                    <div class="mb-3">
                                                        <label for="serviceName<%= service.getServiceId() %>" class="form-label">Service Name</label>
                                                        <input type="text" class="form-control" id="serviceName<%= service.getServiceId() %>" name="serviceName" value="<%= service.getServiceName() %>" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="serviceType<%= service.getServiceId() %>" class="form-label">Service Type</label>
                                                        <select class="form-select" id="serviceType<%= service.getServiceId() %>" name="serviceType" required>
                                                            <option value="CATERING" <%= "CATERING".equals(service.getServiceType()) ? "selected" : "" %>>Catering</option>
                                                            <option value="EQUIPMENT" <%= "EQUIPMENT".equals(service.getServiceType()) ? "selected" : "" %>>Equipment</option>
                                                            <option value="OTHER" <%= "OTHER".equals(service.getServiceType()) ? "selected" : "" %>>Other</option>
                                                        </select>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="description<%= service.getServiceId() %>" class="form-label">Description</label>
                                                        <textarea class="form-control" id="description<%= service.getServiceId() %>" name="description" rows="3"><%= service.getDescription() %></textarea>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="price<%= service.getServiceId() %>" class="form-label">Price</label>
                                                        <div class="input-group">
                                                            <span class="input-group-text">$</span>
                                                            <input type="number" class="form-control" id="price<%= service.getServiceId() %>" name="price" value="<%= service.getPrice() %>" min="0" step="0.01" required>
                                                        </div>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="imageUrl<%= service.getServiceId() %>" class="form-label">Image URL</label>
                                                        <input type="text" class="form-control" id="imageUrl<%= service.getServiceId() %>" name="imageUrl" value="<%= service.getImageUrl() != null ? service.getImageUrl() : "" %>">
                                                    </div>
                                                    <div class="mb-3 form-check">
                                                        <input type="checkbox" class="form-check-input" id="isActive<%= service.getServiceId() %>" name="isActive" <%= service.isActive() ? "checked" : "" %>>
                                                        <label class="form-check-label" for="isActive<%= service.getServiceId() %>">Active</label>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                    <button type="submit" class="btn btn-primary">Save Changes</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Delete Service Modal -->
                                <div class="modal fade" id="deleteServiceModal<%= service.getServiceId() %>" tabindex="-1" aria-labelledby="deleteServiceModalLabel<%= service.getServiceId() %>" aria-hidden="true">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="deleteServiceModalLabel<%= service.getServiceId() %>">Confirm Delete</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                Are you sure you want to delete the add-on service "<%= service.getServiceName() %>"? This action cannot be undone.
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                <a href="addon-service-process.jsp?action=delete&serviceId=<%= service.getServiceId() %>" class="btn btn-danger">Delete</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Add Service Modal -->
    <div class="modal fade" id="addServiceModal" tabindex="-1" aria-labelledby="addServiceModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addServiceModalLabel">Add New Add-on Service</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="addon-service-process.jsp" method="post">
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
                            <input type="text" class="form-control" id="imageUrl" name="imageUrl">
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
    
    <jsp:include page="../includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
