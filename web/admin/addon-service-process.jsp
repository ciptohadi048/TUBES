<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.roomly.dao.AddonServiceDAO" %>
<%@ page import="com.roomly.model.AddonService" %>
<%@ page import="com.roomly.model.User" %>

<%
    // Check if user is logged in and is admin
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || !currentUser.isAdmin()) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    // Get action parameter
    String action = request.getParameter("action");
    
    if (action == null) {
        response.sendRedirect("addon-services.jsp?error=1");
        return;
    }
    
    AddonServiceDAO addonServiceDAO = new AddonServiceDAO();
    
    if (action.equals("add")) {
        // Add new add-on service
        String serviceName = request.getParameter("serviceName");
        String serviceType = request.getParameter("serviceType");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String imageUrl = request.getParameter("imageUrl");
        
        try {
            double price = Double.parseDouble(priceStr);
            
            AddonService service = new AddonService();
            service.setServiceName(serviceName);
            service.setServiceType(serviceType);
            service.setDescription(description);
            service.setPrice(price);
            service.setImageUrl(imageUrl);
            service.setActive(true);
            
            boolean success = addonServiceDAO.addService(service);
            
            if (success) {
                response.sendRedirect("addon-services.jsp?success=add");
            } else {
                response.sendRedirect("addon-services.jsp?error=1");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("addon-services.jsp?error=1");
        }
    } else if (action.equals("update")) {
        // Update existing add-on service
        String serviceIdStr = request.getParameter("serviceId");
        String serviceName = request.getParameter("serviceName");
        String serviceType = request.getParameter("serviceType");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String imageUrl = request.getParameter("imageUrl");
        String isActiveStr = request.getParameter("isActive");
        
        try {
            int serviceId = Integer.parseInt(serviceIdStr);
            double price = Double.parseDouble(priceStr);
            boolean isActive = isActiveStr != null;
            
            AddonService service = new AddonService();
            service.setServiceId(serviceId);
            service.setServiceName(serviceName);
            service.setServiceType(serviceType);
            service.setDescription(description);
            service.setPrice(price);
            service.setImageUrl(imageUrl);
            service.setActive(isActive);
            
            boolean success = addonServiceDAO.updateService(service);
            
            if (success) {
                response.sendRedirect("addon-services.jsp?success=update");
            } else {
                response.sendRedirect("addon-services.jsp?error=1");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("addon-services.jsp?error=1");
        }
    } else if (action.equals("delete")) {
        // Delete add-on service (soft delete)
        String serviceIdStr = request.getParameter("serviceId");
        
        try {
            int serviceId = Integer.parseInt(serviceIdStr);
            
            boolean success = addonServiceDAO.deleteService(serviceId);
            
            if (success) {
                response.sendRedirect("addon-services.jsp?success=delete");
            } else {
                response.sendRedirect("addon-services.jsp?error=1");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("addon-services.jsp?error=1");
        }
    } else {
        response.sendRedirect("addon-services.jsp?error=1");
    }
%>
