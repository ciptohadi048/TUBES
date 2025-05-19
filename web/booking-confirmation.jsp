<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.roomly.dao.BookingDAO" %>
<%@ page import="com.roomly.dao.RoomDAO" %>
<%@ page import="com.roomly.dao.AddonServiceDAO" %>
<%@ page import="com.roomly.model.Booking" %>
<%@ page import="com.roomly.model.Room" %>
<%@ page import="com.roomly.model.User" %>
<%@ page import="com.roomly.model.AddonService" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>

<%
    // Check if user is logged in
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get booking ID from request
    String bookingIdStr = request.getParameter("id");
    int bookingId = 0;
    
    try {
        bookingId = Integer.parseInt(bookingIdStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("my-bookings.jsp");
        return;
    }
    
    // Get booking details
    BookingDAO bookingDAO = new BookingDAO();
    Booking booking = bookingDAO.getBookingById(bookingId);
    
    if (booking == null || booking.getUserId() != currentUser.getUserId()) {
        response.sendRedirect("my-bookings.jsp");
        return;
    }
    
    // Get room details
    RoomDAO roomDAO = new RoomDAO();
    Room room = roomDAO.getRoomById(booking.getRoomId());
    
    if (room == null) {
        response.sendRedirect("my-bookings.jsp");
        return;
    }
    
    // Get add-on services for this booking
    AddonServiceDAO addonServiceDAO = new AddonServiceDAO();
    List<AddonService> bookingServices = addonServiceDAO.getServicesForBooking(bookingId);
    
    // Format dates
    SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");
    
    String bookingDate = dateFormat.format(booking.getStartTime());
    String startTime = timeFormat.format(booking.getStartTime());
    String endTime = timeFormat.format(booking.getEndTime());
    
    // Calculate add-on services total
    double addonTotal = 0.0;
    for (AddonService service : bookingServices) {
        addonTotal += service.getPrice() * service.getQuantity();
    }
    
    // Calculate room cost (total price - addon total)
    double roomCost = booking.getTotalPrice() - addonTotal;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmation - Roomly</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .confirmation-header {
            background: linear-gradient(135deg, #00b09b 0%, #96c93d 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            border-radius: 0.5rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        
        .confirmation-card {
            border: none;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }
        
        .confirmation-card .card-header {
            background: linear-gradient(135deg, #00b09b 0%, #96c93d 100%);
            color: white;
            font-weight: bold;
            padding: 1.5rem;
        }
        
        .booking-detail {
            padding: 0.75rem 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .booking-detail:last-child {
            border-bottom: none;
        }
        
        .confirmation-icon {
            font-size: 5rem;
            color: #00b09b;
            margin-bottom: 1rem;
        }
        
        .btn-view-bookings {
            background: linear-gradient(135deg, #00b09b 0%, #96c93d 100%);
            border: none;
            padding: 1rem;
            font-weight: bold;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .btn-view-bookings:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 176, 155, 0.3);
        }
        
        .addon-service-item {
            padding: 0.5rem 0;
        }
        
        /* Animation for confirmation checkmark */
        @keyframes checkmark {
            0% { transform: scale(0); opacity: 0; }
            50% { transform: scale(1.2); opacity: 1; }
            100% { transform: scale(1); opacity: 1; }
        }
        
        .animate-checkmark {
            animation: checkmark 1s ease-in-out;
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <div class="confirmation-header">
        <div class="container">
            <h1 class="display-4"><i class="fas fa-check-circle me-3"></i>Booking Confirmed!</h1>
            <p class="lead">Your room has been successfully booked.</p>
        </div>
    </div>
    
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="text-center mb-5">
                    <div class="confirmation-icon animate-checkmark">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h2>Thank You for Your Booking</h2>
                    <p class="lead text-muted">A confirmation email has been sent to your registered email address.</p>
                </div>
                
                <div class="confirmation-card">
                    <div class="card-header">
                        <h4 class="mb-0"><i class="fas fa-info-circle me-2"></i>Booking Details</h4>
                    </div>
                    <div class="card-body">
                        <div class="booking-detail">
                            <div class="row">
                                <div class="col-5 fw-bold">Booking ID:</div>
                                <div class="col-7">#<%= booking.getBookingId() %></div>
                            </div>
                        </div>
                        
                        <div class="booking-detail">
                            <div class="row">
                                <div class="col-5 fw-bold">Status:</div>
                                <div class="col-7">
                                    <span class="badge bg-success"><%= booking.getBookingStatus() %></span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="booking-detail">
                            <div class="row">
                                <div class="col-5 fw-bold">Room:</div>
                                <div class="col-7"><%= room.getRoomName() %></div>
                            </div>
                        </div>
                        
                        <div class="booking-detail">
                            <div class="row">
                                <div class="col-5 fw-bold">Date:</div>
                                <div class="col-7"><%= bookingDate %></div>
                            </div>
                        </div>
                        
                        <div class="booking-detail">
                            <div class="row">
                                <div class="col-5 fw-bold">Time:</div>
                                <div class="col-7"><%= startTime %> - <%= endTime %></div>
                            </div>
                        </div>
                        
                        <div class="booking-detail">
                            <div class="row">
                                <div class="col-5 fw-bold">Duration:</div>
                                <div class="col-7"><%= String.format("%.1f", booking.getDurationHours()) %> hours</div>
                            </div>
                        </div>
                        
                        <div class="booking-detail">
                            <div class="row">
                                <div class="col-5 fw-bold">Room Cost:</div>
                                <div class="col-7">$<%= String.format("%.2f", roomCost) %></div>
                            </div>
                        </div>
                        
                        <% if (!bookingServices.isEmpty()) { %>
                            <div class="booking-detail">
                                <div class="row">
                                    <div class="col-5 fw-bold">Add-on Services:</div>
                                    <div class="col-7">
                                        <% for (AddonService service : bookingServices) { %>
                                            <div class="addon-service-item">
                                                <%= service.getQuantity() %> x <%= service.getServiceName() %>
                                                <span class="float-end">$<%= String.format("%.2f", service.getQuantity() * service.getPrice()) %></span>
                                            </div>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                        
                        <div class="booking-detail">
                            <div class="row">
                                <div class="col-5 fw-bold">Total Amount:</div>
                                <div class="col-7 fw-bold">$<%= String.format("%.2f", booking.getTotalPrice()) %></div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="confirmation-card">
                    <div class="card-header">
                        <h4 class="mb-0"><i class="fas fa-map-marker-alt me-2"></i>Location & Instructions</h4>
                    </div>
                    <div class="card-body">
                        <p>Your room is located at our main facility. Please arrive 10 minutes before your scheduled time.</p>
                        <p>You will need to present your booking ID and a valid ID at the reception desk.</p>
                        <p>If you need to cancel or reschedule your booking, please do so at least 24 hours in advance.</p>
                    </div>
                </div>
                
                <div class="text-center mt-4 mb-5">
                    <a href="my-bookings.jsp" class="btn btn-primary btn-view-bookings">
                        <i class="fas fa-calendar-alt me-2"></i>View My Bookings
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
