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
   
   // Get booking info from session
   Integer bookingId = (Integer) session.getAttribute("bookingId");
   Double totalAmount = (Double) session.getAttribute("totalAmount");
   Double addonAmount = (Double) session.getAttribute("addonAmount");
   
   if (bookingId == null || totalAmount == null) {
       response.sendRedirect("rooms.jsp");
       return;
   }
   
   if (addonAmount == null) {
       addonAmount = 0.0;
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
   
   // Get add-on services for this booking
   AddonServiceDAO addonServiceDAO = new AddonServiceDAO();
   List<AddonService> bookingServices = addonServiceDAO.getServicesForBooking(bookingId);
   
   SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
   SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");
   
   String bookingDate = dateFormat.format(booking.getStartTime());
   String startTime = timeFormat.format(booking.getStartTime());
   String endTime = timeFormat.format(booking.getEndTime());
   
   // Calculate room cost (total amount - addon amount)
   double roomCost = totalAmount - addonAmount;
%>

<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Payment - Roomly</title>
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
   <link rel="stylesheet" href="assets/css/style.css">
   <link rel="stylesheet" href="assets/css/payments.css">
</head>
<body>
   <jsp:include page="includes/header.jsp" />
   
   <div class="payment-header">
       <div class="container">
           <h1 class="display-4"><i class="fas fa-credit-card me-3"></i>Complete Your Payment</h1>
           <p class="lead">You're just one step away from confirming your booking!</p>
       </div>
   </div>
   
   <div class="container mt-4">
       <div class="row">
           <div class="col-lg-7">
               <div class="payment-card">
                   <div class="card-header">
                       <h4 class="mb-0"><i class="fas fa-wallet me-2"></i>Payment Method</h4>
                   </div>
                   <div class="card-body">
                       <form action="payment-process.jsp" method="post" id="paymentForm">
                           <input type="hidden" name="bookingId" value="<%= bookingId %>">
                           <input type="hidden" name="amount" value="<%= totalAmount %>">
                           
                           <div class="row mb-4">
                               <div class="col-md-6 mb-3">
                                   <div class="payment-method-card active card-animation" id="creditCardMethod">
                                       <div class="text-center">
                                           <div class="payment-method-icon">
                                               <i class="fas fa-credit-card"></i>
                                           </div>
                                           <h5>Credit Card</h5>
                                           <p class="text-muted mb-0">Pay securely with your card</p>
                                           <input class="form-check-input mt-3" type="radio" name="paymentMethod" id="creditCard" value="CREDIT_CARD" checked style="display: none;">
                                       </div>
                                   </div>
                               </div>
                               <div class="col-md-6 mb-3">
                                   <div class="payment-method-card card-animation" id="paypalMethod">
                                       <div class="text-center">
                                           <div class="payment-method-icon">
                                               <i class="fab fa-paypal"></i>
                                           </div>
                                           <h5>PayPal</h5>
                                           <p class="text-muted mb-0">Fast and secure payment</p>
                                           <input class="form-check-input mt-3" type="radio" name="paymentMethod" id="paypal" value="PAYPAL" style="display: none;">
                                       </div>
                                   </div>
                               </div>
                           </div>
                           
                           <div id="creditCardDetails" class="credit-card-form">
                               <div class="mb-3">
                                   <label for="cardNumber" class="form-label">Card Number</label>
                                   <div class="input-group">
                                       <span class="input-group-text"><i class="far fa-credit-card card-icon"></i></span>
                                       <input type="text" class="form-control" id="cardNumber" name="cardNumber" placeholder="1234 5678 9012 3456">
                                   </div>
                               </div>
                               <div class="row mb-3">
                                   <div class="col-md-6">
                                       <label for="expiryDate" class="form-label">Expiry Date</label>
                                       <div class="input-group">
                                           <span class="input-group-text"><i class="far fa-calendar-alt card-icon"></i></span>
                                           <input type="text" class="form-control" id="expiryDate" name="expiryDate" placeholder="MM/YY">
                                       </div>
                                   </div>
                                   <div class="col-md-6">
                                       <label for="cvv" class="form-label">CVV</label>
                                       <div class="input-group">
                                           <span class="input-group-text"><i class="fas fa-lock card-icon"></i></span>
                                           <input type="text" class="form-control" id="cvv" name="cvv" placeholder="123">
                                       </div>
                                   </div>
                               </div>
                               <div class="mb-3">
                                   <label for="cardholderName" class="form-label">Cardholder Name</label>
                                   <div class="input-group">
                                       <span class="input-group-text"><i class="far fa-user card-icon"></i></span>
                                       <input type="text" class="form-control" id="cardholderName" name="cardholderName" placeholder="John Doe">
                                   </div>
                               </div>
                           </div>
                           
                           <div id="paypalDetails" style="display: none;" class="text-center p-4">
                               <div class="alert alert-info">
                                   <i class="fab fa-paypal me-2"></i> You will be redirected to PayPal to complete your payment.
                               </div>
                               <img src="assets/images/paypal.jpg" alt="PayPal" class="img-fluid" style="max-width: 200px;">
                           </div>
                           
                           <div class="mb-3 form-check mt-4">
                               <input type="checkbox" class="form-check-input" id="termsAgreement" required>
                               <label class="form-check-label" for="termsAgreement">
                                   I agree to the <a href="terms.jsp">Terms and Conditions</a>
                               </label>
                           </div>
                           
                           <button type="submit" class="btn btn-primary btn-pay w-100 pulse">
                               <i class="fas fa-lock me-2"></i>Pay Now $<%= String.format("%.2f", totalAmount) %>
                           </button>
                       </form>
                   </div>
               </div>
           </div>
           
           <div class="col-lg-5">
               <div class="summary-card card-animation">
                   <div class="card-body">
                       <h4 class="card-title mb-4"><i class="fas fa-clipboard-list me-2"></i>Booking Summary</h4>
                       
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
                               <div class="col-5 fw-bold">Rate:</div>
                               <div class="col-7">$<%= String.format("%.2f", room.getPricePerHour()) %> per hour</div>
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
                               <div class="fw-bold mb-2">Add-on Services:</div>
                               <ul class="list-unstyled ps-2">
                                   <% for (AddonService service : bookingServices) { %>
                                       <li class="mb-1">
                                           <%= service.getQuantity() %> x <%= service.getServiceName() %>
                                           <span class="float-end">$<%= String.format("%.2f", service.getQuantity() * service.getPrice()) %></span>
                                       </li>
                                   <% } %>
                               </ul>
                           </div>
                       <% } %>
                       
                       <div class="mt-4 pt-3 border-top">
                           <div class="row align-items-center">
                               <div class="col-6">
                                   <h5 class="mb-0">Total Amount:</h5>
                               </div>
                               <div class="col-6 text-end">
                                   <div class="total-amount">$<%= String.format("%.2f", totalAmount) %></div>
                               </div>
                           </div>
                       </div>
                   </div>
               </div>
               
               <div class="card summary-card card-animation mt-4">
                   <div class="card-body">
                       <h5 class="card-title mb-3"><i class="fas fa-shield-alt me-2"></i>Secure Payment</h5>
                       <p class="text-muted">Your payment information is encrypted and secure. We never store your credit card details.</p>
                       <div class="text-center mt-3">
                           <i class="fab fa-cc-visa fa-2x me-2" style="color: #1A1F71;"></i>
                           <i class="fab fa-cc-mastercard fa-2x me-2" style="color: #EB001B;"></i>
                           <i class="fab fa-cc-amex fa-2x me-2" style="color: #006FCF;"></i>
                           <i class="fab fa-cc-discover fa-2x" style="color: #FF6000;"></i>
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
           // Payment method selection
           var creditCardMethod = document.getElementById("creditCardMethod");
           var paypalMethod = document.getElementById("paypalMethod");
           var creditCardRadio = document.getElementById("creditCard");
           var paypalRadio = document.getElementById("paypal");
           var creditCardDetails = document.getElementById("creditCardDetails");
           var paypalDetails = document.getElementById("paypalDetails");
           
           creditCardMethod.addEventListener("click", function() {
               creditCardRadio.checked = true;
               creditCardMethod.classList.add("active");
               paypalMethod.classList.remove("active");
               creditCardDetails.style.display = "block";
               paypalDetails.style.display = "none";
           });
           
           paypalMethod.addEventListener("click", function() {
               paypalRadio.checked = true;
               paypalMethod.classList.add("active");
               creditCardMethod.classList.remove("active");
               creditCardDetails.style.display = "none";
               paypalDetails.style.display = "block";
           });
           
           // Credit card formatting
           var cardNumberInput = document.getElementById("cardNumber");
           var expiryDateInput = document.getElementById("expiryDate");
           
           if (cardNumberInput) {
               cardNumberInput.addEventListener("input", function() {
                   var value = this.value.replace(/\s+/g, "");
                   if (value.length > 0) {
                       value = value.match(/.{1,4}/g).join(" ");
                   }
                   this.value = value;
               });
           }
           
           if (expiryDateInput) {
               expiryDateInput.addEventListener("input", function() {
                   var value = this.value.replace(/\D/g, "");
                   if (value.length > 2) {
                       value = value.substring(0, 2) + "/" + value.substring(2, 4);
                   }
                   this.value = value;
               });
           }
           
           // Form validation
           var paymentForm = document.getElementById("paymentForm");
           if (paymentForm) {
               paymentForm.addEventListener("submit", function(event) {
                   var paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
                   
                   if (paymentMethod === "CREDIT_CARD") {
                       var cardNumber = document.getElementById("cardNumber").value;
                       var expiryDate = document.getElementById("expiryDate").value;
                       var cvv = document.getElementById("cvv").value;
                       var cardholderName = document.getElementById("cardholderName").value;
                       
                       if (!cardNumber || !expiryDate || !cvv || !cardholderName) {
                           event.preventDefault();
                           alert("Please fill in all credit card details.");
                           return;
                       }
                       
                       // Basic credit card validation
                       if (!/^\d{4}\s\d{4}\s\d{4}\s\d{4}$/.test(cardNumber)) {
                           event.preventDefault();
                           alert("Please enter a valid 16-digit card number.");
                           return;
                       }
                       
                       if (!/^\d{3,4}$/.test(cvv)) {
                           event.preventDefault();
                           alert("Please enter a valid CVV code.");
                           return;
                       }
                       
                       if (!/^\d{2}\/\d{2}$/.test(expiryDate)) {
                           event.preventDefault();
                           alert("Please enter a valid expiry date (MM/YY).");
                           return;
                       }
                   }
               });
           }
       });
   </script>
</body>
</html>
