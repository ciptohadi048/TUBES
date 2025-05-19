<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.roomly.dao.AddonServiceDAO" %>
<%@ page import="com.roomly.dao.BookingDAO" %>
<%@ page import="com.roomly.model.AddonService" %>
<%@ page import="com.roomly.model.Booking" %>
<%@ page import="com.roomly.model.User" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.List" %>

<%
    // Check if user is logged in
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get booking ID from request
    String bookingIdStr = request.getParameter("bookingId");
    if (bookingIdStr == null) {
        response.sendRedirect("rooms.jsp");
        return;
    }
    
    try {
        int bookingId = Integer.parseInt(bookingIdStr);
        
        // Get booking details
        BookingDAO bookingDAO = new BookingDAO();
        Booking booking = bookingDAO.getBookingById(bookingId);
        
        if (booking == null || booking.getUserId() != currentUser.getUserId()) {
            response.sendRedirect("rooms.jsp");
            return;
        }
        
        // Get add-on service quantities from request
        AddonServiceDAO addonServiceDAO = new AddonServiceDAO();
        List<AddonService> selectedServices = new ArrayList<>();
        double addonTotalAmount = 0.0;
        
        Enumeration<String> parameterNames = request.getParameterNames();
        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();
            if (paramName.startsWith("quantity_")) {
                String serviceIdStr = paramName.substring("quantity_".length());
                int serviceId = Integer.parseInt(serviceIdStr);
                int quantity = Integer.parseInt(request.getParameter(paramName));
                
                if (quantity > 0) {
                    AddonService service = addonServiceDAO.getServiceById(serviceId);
                    if (service != null) {
                        service.setQuantity(quantity);
                        selectedServices.add(service);
                        addonTotalAmount += service.getPrice() * quantity;
                    }
                }
            }
        }
        
        // Add selected services to booking
        if (!selectedServices.isEmpty()) {
            boolean success = addonServiceDAO.addServicesToBooking(bookingId, selectedServices);
            if (success) {
                // Update total amount in session
                Double originalAmount = (Double) session.getAttribute("totalAmount");
                if (originalAmount != null) {
                    session.setAttribute("totalAmount", originalAmount + addonTotalAmount);
                    session.setAttribute("addonAmount", addonTotalAmount);
                }
            }
        }
        
        // Redirect to payment page
        response.sendRedirect("payment.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("rooms.jsp");
    }
%>
