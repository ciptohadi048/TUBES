<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.roomly.dao.BookingDAO" %>
<%@ page import="com.roomly.dao.PaymentDAO" %>
<%@ page import="com.roomly.model.Booking" %>
<%@ page import="com.roomly.model.Payment" %>
<%@ page import="com.roomly.model.User" %>
<%@ page import="java.util.UUID" %>

<%
    // Check if user is logged in
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get form data
    String bookingIdStr = request.getParameter("bookingId");
    String amountStr = request.getParameter("amount");
    String paymentMethod = request.getParameter("paymentMethod");
    
    // Validate input
    if (bookingIdStr == null || amountStr == null || paymentMethod == null) {
        response.sendRedirect("rooms.jsp");
        return;
    }
    
    try {
        int bookingId = Integer.parseInt(bookingIdStr);
        double amount = Double.parseDouble(amountStr);
        
        // Get booking details
        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getBookingById(bookingId);
        
        if (booking == null || booking.getUserId() != currentUser.getUserId()) {
            response.sendRedirect("rooms.jsp");
            return;
        }
        
        // Generate a transaction ID
        String transactionId = UUID.randomUUID().toString();
        
        // Create payment object
        Payment payment = new Payment();
        payment.setBookingId(bookingId);
        payment.setAmount(amount);
        payment.setPaymentStatus("COMPLETED");
        payment.setPaymentMethod(paymentMethod);
        payment.setTransactionId(transactionId);
        
        // Process payment and update booking status
        PaymentDAO paymentDAO = new PaymentDAO();
        boolean success = paymentDAO.processPayment(payment, bookingId);
        
        if (success) {
            // Clear session attributes
            session.removeAttribute("bookingId");
            session.removeAttribute("totalAmount");
            session.removeAttribute("addonAmount");
            
            // Redirect to confirmation page
            response.sendRedirect("booking-confirmation.jsp?id=" + bookingId);
        } else {
            response.sendRedirect("payment.jsp?error=1");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("payment.jsp?error=2");
    }
%>
