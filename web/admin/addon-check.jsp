<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.roomly.model.User" %>
<%@ page import="com.roomly.util.DatabaseUtil" %>
<%@ page import="java.sql.*" %>

<%
    // Check if user is logged in and is admin
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !currentUser.isAdmin()) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    boolean addonTableExists = false;
    boolean junctionTableExists = false;
    String errorMessage = null;
    
    try (Connection conn = DatabaseUtil.getConnection()) {
        // Check if addon_services table exists
        try (ResultSet rs = conn.getMetaData().getTables(null, null, "addon_services", null)) {
            addonTableExists = rs.next();
        }
        
        // Check if booking_addon_services table exists
        try (ResultSet rs = conn.getMetaData().getTables(null, null, "booking_addon_services", null)) {
            junctionTableExists = rs.next();
        }
        
        // If tables don't exist, try to create them
        if (!addonTableExists || !junctionTableExists) {
            Statement stmt = conn.createStatement();
            
            // Create addon_services table if it doesn't exist
            if (!addonTableExists) {
                String createAddonTable = "CREATE TABLE IF NOT EXISTS addon_services (" +
                    "service_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "service_name VARCHAR(100) NOT NULL, " +
                    "service_type ENUM('CATERING', 'EQUIPMENT', 'OTHER') NOT NULL, " +
                    "description TEXT, " +
                    "price DECIMAL(10, 2) NOT NULL, " +
                    "image_url VARCHAR(255), " +
                    "is_active BOOLEAN DEFAULT TRUE, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)";
                
                stmt.executeUpdate(createAddonTable);
                
                // Check again if table was created
                try (ResultSet rs = conn.getMetaData().getTables(null, null, "addon_services", null)) {
                    addonTableExists = rs.next();
                }
            }
            
            // Create booking_addon_services table if it doesn't exist
            if (!junctionTableExists && addonTableExists) {
                String createJunctionTable = "CREATE TABLE IF NOT EXISTS booking_addon_services (" +
                    "booking_id INT, " +
                    "service_id INT, " +
                    "quantity INT NOT NULL DEFAULT 1, " +
                    "price_at_booking DECIMAL(10, 2) NOT NULL, " +
                    "PRIMARY KEY (booking_id, service_id), " +
                    "FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE, " +
                    "FOREIGN KEY (service_id) REFERENCES addon_services(service_id) ON DELETE CASCADE)";
                
                stmt.executeUpdate(createJunctionTable);
                
                // Check again if table was created
                try (ResultSet rs = conn.getMetaData().getTables(null, null, "booking_addon_services", null)) {
                    junctionTableExists = rs.next();
                }
            }
            
            // Insert sample data if addon_services table was just created
            if (addonTableExists) {
                // Check if table is empty
                boolean isEmpty = true;
                try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM addon_services")) {
                    if (rs.next()) {
                        isEmpty = rs.getInt(1) == 0;
                    }
                }
                
                if (isEmpty) {
                    // Insert sample data
                    String insertSampleData = "INSERT INTO addon_services (service_name, service_type, description, price, image_url) VALUES " +
                        "('Coffee & Tea Service', 'CATERING', 'Fresh brewed coffee and assorted teas', 45.00, '../assets/images/placeholder.jpg'), " +
                        "('Projector & Screen', 'EQUIPMENT', 'High-definition projector with screen', 75.00, '../assets/images/placeholder.jpg')";
                    
                    stmt.executeUpdate(insertSampleData);
                }
            }
        }
    } catch (SQLException e) {
        errorMessage = e.getMessage();
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Database Check - Roomly</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Database Check Results</h2>
        
        <% if (errorMessage != null) { %>
            <div class="alert alert-danger">
                <h4>Database Error</h4>
                <p><%= errorMessage %></p>
                <p>Please run the SQL script manually to create the required tables.</p>
                <pre class="bg-light p-3 mt-3">
-- Create addon_services table
CREATE TABLE IF NOT EXISTS addon_services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    service_type ENUM('CATERING', 'EQUIPMENT', 'OTHER') NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    image_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create booking_addon_services junction table
CREATE TABLE IF NOT EXISTS booking_addon_services (
    booking_id INT,
    service_id INT,
    quantity INT NOT NULL DEFAULT 1,
    price_at_booking DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (booking_id, service_id),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES addon_services(service_id) ON DELETE CASCADE
);

-- Insert sample data
INSERT INTO addon_services (service_name, service_type, description, price, image_url)
VALUES 
('Coffee & Tea Service', 'CATERING', 'Fresh brewed coffee and assorted teas', 45.00, '../assets/images/placeholder.jpg'),
('Projector & Screen', 'EQUIPMENT', 'High-definition projector with screen', 75.00, '../assets/images/placeholder.jpg');
                </pre>
            </div>
        <% } else { %>
            <div class="card mb-4">
                <div class="card-header">
                    <h5>Table Status</h5>
                </div>
                <div class="card-body">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Table</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>addon_services</td>
                                <td>
                                    <% if (addonTableExists) { %>
                                        <span class="badge bg-success">Exists</span>
                                    <% } else { %>
                                        <span class="badge bg-danger">Missing</span>
                                    <% } %>
                                </td>
                            </tr>
                            <tr>
                                <td>booking_addon_services</td>
                                <td>
                                    <% if (junctionTableExists) { %>
                                        <span class="badge bg-success">Exists</span>
                                    <% } else { %>
                                        <span class="badge bg-danger">Missing</span>
                                    <% } %>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <div class="card mb-4">
                <div class="card-header">
                    <h5>Next Steps</h5>
                </div>
                <div class="card-body">
                    <% if (addonTableExists && junctionTableExists) { %>
                        <div class="alert alert-success">
                            <p><strong>Good news!</strong> All required tables exist in your database.</p>
                            <p>You should now be able to access the add-on services page.</p>
                        </div>
                        <a href="addon-services.jsp" class="btn btn-primary">Go to Add-on Services</a>
                    <% } else { %>
                        <div class="alert alert-warning">
                            <p><strong>Warning:</strong> Some required tables are missing.</p>
                            <p>Please run the SQL script to create the necessary tables.</p>
                        </div>
                    <% } %>
                </div>
            </div>
        <% } %>
        
        <a href="addon-direct.jsp" class="btn btn-secondary">Back to Troubleshooting</a>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
