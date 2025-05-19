<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.roomly.dao.BookingDAO" %>
<%@ page import="com.roomly.dao.RoomDAO" %>
<%@ page import="com.roomly.dao.UserDAO" %>
<%@ page import="com.roomly.dao.PaymentDAO" %>
<%@ page import="com.roomly.model.Booking" %>
<%@ page import="com.roomly.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
   // Check if user is logged in and is admin
   User currentUser = (User) session.getAttribute("currentUser");
   if (currentUser == null || !currentUser.isAdmin()) {
       response.sendRedirect("../login.jsp");
       return;
   }
   
   // Get recent bookings
   BookingDAO bookingDAO = new BookingDAO();
   List<Booking> recentBookings = bookingDAO.getAllBookings();
   // Limit to 5 most recent bookings
   if (recentBookings.size() > 5) {
       recentBookings = recentBookings.subList(0, 5);
   }
   
   SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, MMM d, yyyy");
   SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");
%>

<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Admin Dashboard - Roomly</title>
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
   <link rel="stylesheet" href="../assets/css/style.css">
   <style>
       .feature-card {
           border: 2px solid #ff6b6b;
           background-color: #fff0f0;
           border-radius: 8px;
           padding: 20px;
           margin-bottom: 20px;
           box-shadow: 0 4px 6px rgba(0,0,0,0.1);
       }
       
       .feature-card h3 {
           color: #ff6b6b;
           margin-bottom: 15px;
       }
       
       .feature-card .btn-feature {
           background-color: #ff6b6b;
           border-color: #ff6b6b;
           color: white;
           font-weight: bold;
           padding: 10px 20px;
       }
       
       .feature-card .btn-feature:hover {
           background-color: #ff5252;
           border-color: #ff5252;
       }
   </style>
</head>
<body>
   <jsp:include page="../includes/header.jsp" />
   
   <div class="container mt-5">
       <h2 class="mb-4">Admin Dashboard</h2>
       
       <!-- NEW FEATURE CARD - VERY PROMINENT -->
       <div class="feature-card mb-4">
           <div class="row align-items-center">
               <div class="col-md-8">
                   <h3><i class="fas fa-star me-2"></i> NEW FEATURE: Add-on Services</h3>
                   <p class="mb-0">Enhance your room bookings with catering and equipment rentals! Manage your add-on services to increase revenue and provide more value to your customers.</p>
               </div>
               <div class="col-md-4 text-end">
                   <a href="addon-direct.jsp" class="btn btn-feature btn-lg">
                       <i class="fas fa-concierge-bell me-2"></i> Manage Add-ons
                   </a>
               </div>
           </div>
       </div>
       
       <div class="row mb-4">
           <div class="col-md-3">
               <div class="card admin-stats-card">
                   <div class="stat-value">
                       <%= recentBookings.size() %>
                   </div>
                   <div class="stat-label">Recent Bookings</div>
               </div>
           </div>
           <div class="col-md-3">
               <div class="card admin-stats-card">
                   <div class="stat-value">
                       <% 
                           int confirmedCount = 0;
                           for (Booking booking : recentBookings) {
                               if (booking.getBookingStatus().equals("CONFIRMED")) {
                                   confirmedCount++;
                               }
                           }
                       %>
                       <%= confirmedCount %>
                   </div>
                   <div class="stat-label">Confirmed Bookings</div>
               </div>
           </div>
           <div class="col-md-3">
               <div class="card admin-stats-card">
                   <div class="stat-value">
                       <% 
                           int pendingCount = 0;
                           for (Booking booking : recentBookings) {
                               if (booking.getBookingStatus().equals("PENDING")) {
                                   pendingCount++;
                               }
                           }
                       %>
                       <%= pendingCount %>
                   </div>
                   <div class="stat-label">Pending Bookings</div>
               </div>
           </div>
           <div class="col-md-3">
               <div class="card admin-stats-card">
                   <div class="stat-value">
                       <% 
                           int cancelledCount = 0;
                           for (Booking booking : recentBookings) {
                               if (booking.getBookingStatus().equals("CANCELLED")) {
                                   cancelledCount++;
                               }
                           }
                       %>
                       <%= cancelledCount %>
                   </div>
                   <div class="stat-label">Cancelled Bookings</div>
               </div>
           </div>
       </div>
       
       <div class="row">
           <div class="col-md-12">
               <div class="card">
                   <div class="card-header d-flex justify-content-between align-items-center">
                       <h5 class="mb-0">Recent Bookings</h5>
                       <a href="bookings.jsp" class="btn btn-sm btn-primary">View All</a>
                   </div>
                   <div class="card-body">
                       <div class="table-responsive">
                           <table class="table table-hover">
                               <thead>
                                   <tr>
                                       <th>ID</th>
                                       <th>User</th>
                                       <th>Room</th>
                                       <th>Date</th>
                                       <th>Time</th>
                                       <th>Status</th>
                                       <th>Actions</th>
                                   </tr>
                               </thead>
                               <tbody>
                                   <% for (Booking booking : recentBookings) { %>
                                       <tr>
                                           <td>#<%= booking.getBookingId() %></td>
                                           <td><%= booking.getUserName() %></td>
                                           <td><%= booking.getRoomName() %></td>
                                           <td><%= dateFormat.format(booking.getStartTime()) %></td>
                                           <td><%= timeFormat.format(booking.getStartTime()) %> - <%= timeFormat.format(booking.getEndTime()) %></td>
                                           <td>
                                               <% if (booking.getBookingStatus().equals("CONFIRMED")) { %>
                                                   <span class="badge bg-success">Confirmed</span>
                                               <% } else if (booking.getBookingStatus().equals("PENDING")) { %>
                                                   <span class="badge bg-warning text-dark">Pending</span>
                                               <% } else if (booking.getBookingStatus().equals("CANCELLED")) { %>
                                                   <span class="badge bg-danger">Cancelled</span>
                                               <% } %>
                                           </td>
                                           <td>
                                               <a href="booking-details.jsp?id=<%= booking.getBookingId() %>" class="btn btn-sm btn-primary">View</a>
                                           </td>
                                       </tr>
                                   <% } %>
                               </tbody>
                           </table>
                       </div>
                   </div>
               </div>
           </div>
       </div>
       
       <div class="row mt-4">
           <div class="col-md-12">
               <div class="card">
                   <div class="card-header d-flex justify-content-between align-items-center">
                       <h5 class="mb-0">Quick Actions</h5>
                   </div>
                   <div class="card-body">
                       <div class="row">
                           <div class="col-md-3">
                               <a href="rooms.jsp" class="btn btn-primary w-100 mb-3">
                                   <i class="fas fa-door-open me-2"></i> Manage Rooms
                               </a>
                           </div>
                           <div class="col-md-3">
                               <a href="bookings.jsp" class="btn btn-success w-100 mb-3">
                                   <i class="fas fa-calendar-check me-2"></i> View All Bookings
                               </a>
                           </div>
                           <div class="col-md-3">
                               <a href="payments.jsp" class="btn btn-info w-100 mb-3 text-white">
                                   <i class="fas fa-credit-card me-2"></i> Payment History
                               </a>
                           </div>
                           <div class="col-md-3">
                               <a href="addon-direct.jsp" class="btn btn-danger w-100 mb-3 text-white">
                                   <i class="fas fa-concierge-bell me-2"></i> Manage Add-ons
                               </a>
                           </div>
                       </div>
                   </div>
               </div>
           </div>
       </div>
   </div>
   
   <jsp:include page="../includes/footer.jsp" />
   
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
   <script src="../assets/js/script.js"></script>
</body>
</html>
