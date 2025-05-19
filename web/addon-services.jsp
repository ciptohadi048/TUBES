<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.roomly.dao.AddonServiceDAO" %>
<%@ page import="com.roomly.dao.BookingDAO" %>
<%@ page import="com.roomly.dao.RoomDAO" %>
<%@ page import="com.roomly.model.AddonService" %>
<%@ page import="com.roomly.model.Booking" %>
<%@ page import="com.roomly.model.Room" %>
<%@ page import="com.roomly.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // Check if user is logged in
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get booking ID from session
    Integer bookingId = (Integer) session.getAttribute("bookingId");
    Double totalAmount = (Double) session.getAttribute("totalAmount");
    
    if (bookingId == null || totalAmount == null) {
        response.sendRedirect("rooms.jsp");
        return;
    }
    
    // Get booking details
    BookingDAO bookingDAO = new BookingDAO();
    Booking booking = bookingDAO.getBookingById(bookingId);
    
    if (booking == null) {
        response.sendRedirect("rooms.jsp");
        return;
    }
    
    // Get room details
    RoomDAO roomDAO = new RoomDAO();
    Room room = roomDAO.getRoomById(booking.getRoomId());
    
    if (room == null) {
        response.sendRedirect("rooms.jsp");
        return;
    }
    
    // Get add-on services
    AddonServiceDAO addonServiceDAO = new AddonServiceDAO();
    List<AddonService> cateringServices = addonServiceDAO.getServicesByType("CATERING");
    List<AddonService> equipmentServices = addonServiceDAO.getServicesByType("EQUIPMENT");
    
    // Format dates
    SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");
    
    String bookingDate = dateFormat.format(booking.getStartTime());
    String startTime = timeFormat.format(booking.getStartTime());
    String endTime = timeFormat.format(booking.getEndTime());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add-on Services - Roomly</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        /* Enhanced styling for add-on services page */
        .addon-header {
            background: linear-gradient(135deg, #FF9370 0%, #FF5E62 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            border-radius: 0.5rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        
        .addon-card {
            border: none;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
        }
        
        .addon-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }
        
        .addon-card .card-img-top {
            height: 180px;
            object-fit: cover;
        }
        
        .addon-card .card-body {
            padding: 1.5rem;
        }
        
        .addon-card .card-title {
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        
        .addon-card .card-text {
            color: #6c757d;
            margin-bottom: 1rem;
        }
        
        .addon-price {
            font-size: 1.25rem;
            font-weight: bold;
            color: #FF5E62;
            margin-bottom: 1rem;
        }
        
        .section-title {
            position: relative;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            font-weight: bold;
        }
        
        .section-title:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 3px;
            background: linear-gradient(135deg, #FF9370 0%, #FF5E62 100%);
        }
        
        .quantity-control {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 1rem;
        }
        
        .quantity-control .btn {
            width: 36px;
            height: 36px;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background-color: #f8f9fa;
            color: #495057;
            border: 1px solid #ced4da;
        }
        
        .quantity-control .form-control {
            width: 50px;
            text-align: center;
            margin: 0 0.5rem;
            padding: 0.375rem 0.5rem;
            border-radius: 0.5rem;
        }
        
        .summary-card {
            border: none;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 2rem;
        }
        
        .summary-card .card-header {
            background: linear-gradient(135deg, #FF9370 0%, #FF5E62 100%);
            color: white;
            font-weight: bold;
            padding: 1.5rem;
        }
        
        .summary-item {
            padding: 0.75rem 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .summary-item:last-child {
            border-bottom: none;
        }
        
        .total-amount {
            font-size: 1.5rem;
            font-weight: bold;
            color: #FF5E62;
        }
        
        .btn-continue {
            background: linear-gradient(135deg, #FF9370 0%, #FF5E62 100%);
            border: none;
            padding: 1rem;
            font-weight: bold;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .btn-continue:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(255, 94, 98, 0.3);
        }
        
        .btn-skip {
            background-color: #6c757d;
            border: none;
            padding: 1rem;
            font-weight: bold;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .btn-skip:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(108, 117, 125, 0.3);
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <div class="addon-header">
        <div class="container">
            <h1 class="display-4"><i class="fas fa-concierge-bell me-3"></i>Add-on Services</h1>
            <p class="lead">Enhance your booking with catering and equipment services</p>
        </div>
    </div>
    
    <div class="container mt-4 mb-5">
        <div class="row">
            <div class="col-lg-8">
                <form action="addon-services-process.jsp" method="post" id="addonForm">
                    <input type="hidden" name="bookingId" value="<%= bookingId %>">
                    
                    <h2 class="section-title">Catering Services</h2>
                    <div class="row row-cols-1 row-cols-md-2 g-4 mb-5">
                        <% for (AddonService service : cateringServices) { %>
                            <div class="col">
                                <div class="card addon-card">
                                    <% if (service.getImageUrl() != null && !service.getImageUrl().isEmpty()) { %>
                                        <img src="<%= service.getImageUrl() %>" class="card-img-top" alt="<%= service.getServiceName() %>">
                                    <% } else { %>
                                        <img src="assets/images/addons/placeholder.jpg" class="card-img-top" alt="<%= service.getServiceName() %>">
                                    <% } %>
                                    <div class="card-body">
                                        <h5 class="card-title"><%= service.getServiceName() %></h5>
                                        <p class="card-text"><%= service.getDescription() %></p>
                                        <div class="addon-price">$<%= String.format("%.2f", service.getPrice()) %></div>
                                        <div class="quantity-control">
                                            <button type="button" class="btn btn-sm btn-quantity-minus" data-service-id="<%= service.getServiceId() %>">
                                                <i class="fas fa-minus"></i>
                                            </button>
                                            <input type="number" class="form-control service-quantity" 
                                                   name="quantity_<%= service.getServiceId() %>" 
                                                   id="quantity_<%= service.getServiceId() %>" 
                                                   value="0" min="0" max="10"
                                                   data-service-id="<%= service.getServiceId() %>"
                                                   data-service-price="<%= service.getPrice() %>"
                                                   data-service-name="<%= service.getServiceName() %>">
                                            <button type="button" class="btn btn-sm btn-quantity-plus" data-service-id="<%= service.getServiceId() %>">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                    
                    <h2 class="section-title">Equipment Rentals</h2>
                    <div class="row row-cols-1 row-cols-md-2 g-4 mb-5">
                        <% for (AddonService service : equipmentServices) { %>
                            <div class="col">
                                <div class="card addon-card">
                                    <% if (service.getImageUrl() != null && !service.getImageUrl().isEmpty()) { %>
                                        <img src="<%= service.getImageUrl() %>" class="card-img-top" alt="<%= service.getServiceName() %>">
                                    <% } else { %>
                                        <img src="assets/images/addons/placeholder.jpg" class="card-img-top" alt="<%= service.getServiceName() %>">
                                    <% } %>
                                    <div class="card-body">
                                        <h5 class="card-title"><%= service.getServiceName() %></h5>
                                        <p class="card-text"><%= service.getDescription() %></p>
                                        <div class="addon-price">$<%= String.format("%.2f", service.getPrice()) %></div>
                                        <div class="quantity-control">
                                            <button type="button" class="btn btn-sm btn-quantity-minus" data-service-id="<%= service.getServiceId() %>">
                                                <i class="fas fa-minus"></i>
                                            </button>
                                            <input type="number" class="form-control service-quantity" 
                                                   name="quantity_<%= service.getServiceId() %>" 
                                                   id="quantity_<%= service.getServiceId() %>" 
                                                   value="0" min="0" max="10"
                                                   data-service-id="<%= service.getServiceId() %>"
                                                   data-service-price="<%= service.getPrice() %>"
                                                   data-service-name="<%= service.getServiceName() %>">
                                            <button type="button" class="btn btn-sm btn-quantity-plus" data-service-id="<%= service.getServiceId() %>">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </form>
            </div>
            
            <div class="col-lg-4">
                <div class="card summary-card">
                    <div class="card-header">
                        <h4 class="mb-0"><i class="fas fa-clipboard-list me-2"></i>Booking Summary</h4>
                    </div>
                    <div class="card-body">
                        <div class="summary-item">
                            <div class="row">
                                <div class="col-5 fw-bold">Room:</div>
                                <div class="col-7"><%= room.getRoomName() %></div>
                            </div>
                        </div>
                        
                        <div class="summary-item">
                            <div class="row">
                                <div class="col-5 fw-bold">Date:</div>
                                <div class="col-7"><%= bookingDate %></div>
                            </div>
                        </div>
                        
                        <div class="summary-item">
                            <div class="row">
                                <div class="col-5 fw-bold">Time:</div>
                                <div class="col-7"><%= startTime %> - <%= endTime %></div>
                            </div>
                        </div>
                        
                        <div class="summary-item">
                            <div class="row">
                                <div class="col-5 fw-bold">Room Cost:</div>
                                <div class="col-7">$<%= String.format("%.2f", totalAmount) %></div>
                            </div>
                        </div>
                        
                        <div id="selected-addons-container" class="d-none">
                            <div class="summary-item">
                                <div class="fw-bold mb-2">Selected Add-ons:</div>
                                <ul id="selected-addons-list" class="list-unstyled ps-2 mb-0">
                                    <!-- Selected add-ons will be added here dynamically -->
                                </ul>
                            </div>
                        </div>
                        
                        <div class="mt-4 pt-3 border-top">
                            <div class="row align-items-center">
                                <div class="col-6">
                                    <h5 class="mb-0">Total:</h5>
                                </div>
                                <div class="col-6 text-end">
                                    <div class="total-amount" id="total-amount">$<%= String.format("%.2f", totalAmount) %></div>
                                    <input type="hidden" id="original-amount" value="<%= totalAmount %>">
                                    <input type="hidden" id="addon-amount" value="0">
                                </div>
                            </div>
                        </div>
                        
                        <div class="d-grid gap-2 mt-4">
                            <button type="button" class="btn btn-primary btn-continue" id="continueBtn">
                                <i class="fas fa-check-circle me-2"></i>Continue with Add-ons
                            </button>
                            <a href="payment.jsp" class="btn btn-secondary btn-skip">
                                <i class="fas fa-forward me-2"></i>Skip Add-ons
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const quantityInputs = document.querySelectorAll('.service-quantity');
            const minusButtons = document.querySelectorAll('.btn-quantity-minus');
            const plusButtons = document.querySelectorAll('.btn-quantity-plus');
            const selectedAddonsList = document.getElementById('selected-addons-list');
            const selectedAddonsContainer = document.getElementById('selected-addons-container');
            const totalAmountElement = document.getElementById('total-amount');
            const originalAmount = parseFloat(document.getElementById('original-amount').value);
            const addonAmountInput = document.getElementById('addon-amount');
            const continueBtn = document.getElementById('continueBtn');
            const addonForm = document.getElementById('addonForm');
            
            // Initialize selected add-ons
            updateSelectedAddons();
            
            // Add event listeners to quantity inputs
            quantityInputs.forEach(input => {
                input.addEventListener('change', function() {
                    const value = parseInt(this.value);
                    if (isNaN(value) || value < 0) {
                        this.value = 0;
                    } else if (value > 10) {
                        this.value = 10;
                    }
                    updateSelectedAddons();
                });
            });
            
            // Add event listeners to minus buttons
            minusButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const serviceId = this.getAttribute('data-service-id');
                    const input = document.getElementById('quantity_' + serviceId);
                    let value = parseInt(input.value);
                    if (value > 0) {
                        input.value = value - 1;
                        updateSelectedAddons();
                    }
                });
            });
            
            // Add event listeners to plus buttons
            plusButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const serviceId = this.getAttribute('data-service-id');
                    const input = document.getElementById('quantity_' + serviceId);
                    let value = parseInt(input.value);
                    if (value < 10) {
                        input.value = value + 1;
                        updateSelectedAddons();
                    }
                });
            });
            
            // Continue button click handler
            continueBtn.addEventListener('click', function() {
                addonForm.submit();
            });
            
            // Update selected add-ons and total amount
            function updateSelectedAddons() {
                let hasSelectedAddons = false;
                let addonAmount = 0;
                
                // Clear the list
                selectedAddonsList.innerHTML = '';
                
                // Add selected add-ons to the list
                quantityInputs.forEach(input => {
                    const quantity = parseInt(input.value);
                    if (quantity > 0) {
                        hasSelectedAddons = true;
                        const serviceId = input.getAttribute('data-service-id');
                        const serviceName = input.getAttribute('data-service-name');
                        const servicePrice = parseFloat(input.getAttribute('data-service-price'));
                        const totalPrice = servicePrice * quantity;
                        addonAmount += totalPrice;
                        
                        const listItem = document.createElement('li');
                        listItem.className = 'mb-1';
                        listItem.innerHTML = `${serviceName} x${quantity} <span class="float-end">$${totalPrice.toFixed(2)}</span>`;
                        selectedAddonsList.appendChild(listItem);
                    }
                });
                
                // Show or hide the selected add-ons container
                if (hasSelectedAddons) {
                    selectedAddonsContainer.classList.remove('d-none');
                } else {
                    selectedAddonsContainer.classList.add('d-none');
                }
                
                // Update total amount
                const totalAmount = originalAmount + addonAmount;
                totalAmountElement.textContent = '$' + totalAmount.toFixed(2);
                addonAmountInput.value = addonAmount.toFixed(2);
                
                // Update continue button text
                if (hasSelectedAddons) {
                    continueBtn.innerHTML = '<i class="fas fa-check-circle me-2"></i>Continue with Add-ons';
                } else {
                    continueBtn.innerHTML = '<i class="fas fa-forward me-2"></i>Continue without Add-ons';
                }
            }
        });
    </script>
</body>
</html>
