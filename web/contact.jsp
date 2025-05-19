<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - Roomly</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/contact.css">
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <div class="contact-page">
        <div class="container">
            <div class="contact-header animate-fadeInUp">
                <h1 class="contact-title">Get In Touch</h1>
                <p class="contact-subtitle">We'd love to hear from you. Whether you have a question about our rooms, pricing, or anything else, our team is ready to answer all your questions.</p>
            </div>
            
            <div class="row">
                <div class="col-lg-6 mb-4 animate-fadeInUp" style="animation-delay: 0.1s;">
                    <div class="contact-form-card">
                        <div class="contact-card-header">
                            <h4 class="mb-0"><i class="fas fa-paper-plane me-2"></i>Send us a Message</h4>
                        </div>
                        <div class="contact-form">
                            <% 
                                String success = request.getParameter("success");
                                if (success != null && success.equals("1")) {
                            %>
                                <div class="alert alert-success" role="alert">
                                    <i class="fas fa-check-circle me-2"></i>Your message has been sent successfully. We'll get back to you soon!
                                </div>
                            <% } %>
                            
                            <form action="contact-process.jsp" method="post" id="contactForm">
                                <div class="mb-3">
                                    <label for="name" class="form-label">Your Name</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                                        <input type="text" class="form-control" id="name" name="name" placeholder="Enter your name" required>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email Address</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                        <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="subject" class="form-label">Subject</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-heading"></i></span>
                                        <input type="text" class="form-control" id="subject" name="subject" placeholder="Enter subject" required>
                                    </div>
                                </div>
                                <div class="mb-4">
                                    <label for="message" class="form-label">Message</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-comment-alt"></i></span>
                                        <textarea class="form-control" id="message" name="message" rows="5" placeholder="Enter your message" required></textarea>
                                    </div>
                                </div>
                                <button type="submit" class="contact-btn w-100">
                                    <i class="fas fa-paper-plane me-2"></i>Send Message
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-6 animate-fadeInUp" style="animation-delay: 0.2s;">
                    <div class="contact-info-card mb-4">
                        <div class="contact-card-header">
                            <h4 class="mb-0"><i class="fas fa-info-circle me-2"></i>Contact Information</h4>
                        </div>
                        <div class="card-body">
                            <div class="contact-info-item">
                                <div class="contact-info-icon">
                                    <i class="fas fa-map-marker-alt"></i>
                                </div>
                                <div class="contact-info-content">
                                    <h5>Our Location</h5>
                                    <p>123 Booking Street<br>Room City, RC 12345<br>United States</p>
                                </div>
                            </div>
                            
                            <div class="contact-info-item">
                                <div class="contact-info-icon">
                                    <i class="fas fa-phone-alt"></i>
                                </div>
                                <div class="contact-info-content">
                                    <h5>Phone Numbers</h5>
                                    <p>+1 (123) 456-7890<br>+1 (987) 654-3210</p>
                                </div>
                            </div>
                            
                            <div class="contact-info-item">
                                <div class="contact-info-icon">
                                    <i class="fas fa-envelope"></i>
                                </div>
                                <div class="contact-info-content">
                                    <h5>Email Address</h5>
                                    <p>info@roomly.com<br>support@roomly.com</p>
                                </div>
                            </div>
                            
                            <div class="contact-info-item">
                                <div class="contact-info-icon">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div class="contact-info-content">
                                    <h5>Business Hours</h5>
                                    <p>Monday - Friday: 9:00 AM - 6:00 PM<br>
                                    Saturday: 10:00 AM - 4:00 PM<br>
                                    Sunday: Closed</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    
                </div>
            </div>
            
            <div class="faq-section animate-fadeInUp" style="animation-delay: 0.4s;">
                <div class="contact-header">
                    <h2 class="contact-title">Frequently Asked Questions</h2>
                    <p class="contact-subtitle">Find quick answers to common questions about our services.</p>
                </div>
                
                <div class="faq-card">
                    <div class="accordion" id="faqAccordion">
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="faqOne">
                                <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#faqCollapseOne" aria-expanded="true" aria-controls="faqCollapseOne">
                                    <i class="fas fa-question-circle me-2"></i>How do I book a room?
                                </button>
                            </h2>
                            <div id="faqCollapseOne" class="accordion-collapse collapse show" aria-labelledby="faqOne" data-bs-parent="#faqAccordion">
                                <div class="accordion-body">
                                    Booking a room is simple! Browse our available rooms, select the one you want, choose your date and time, and complete the payment process. You'll receive an instant confirmation of your booking.
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="faqTwo">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faqCollapseTwo" aria-expanded="false" aria-controls="faqCollapseTwo">
                                    <i class="fas fa-times-circle me-2"></i>Can I cancel my booking?
                                </button>
                            </h2>
                            <div id="faqCollapseTwo" class="accordion-collapse collapse" aria-labelledby="faqTwo" data-bs-parent="#faqAccordion">
                                <div class="accordion-body">
                                    Yes, you can cancel your booking through your account dashboard. Please note that cancellation policies may vary depending on how close to the booking time you cancel.
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="faqThree">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faqCollapseThree" aria-expanded="false" aria-controls="faqCollapseThree">
                                    <i class="fas fa-credit-card me-2"></i>What payment methods do you accept?
                                </button>
                            </h2>
                            <div id="faqCollapseThree" class="accordion-collapse collapse" aria-labelledby="faqThree" data-bs-parent="#faqAccordion">
                                <div class="accordion-body">
                                    We accept all major credit cards and PayPal. All payments are processed securely through our payment gateway.
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="faqFour">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faqCollapseFour" aria-expanded="false" aria-controls="faqCollapseFour">
                                    <i class="fas fa-calendar-alt me-2"></i>How far in advance can I book a room?
                                </button>
                            </h2>
                            <div id="faqCollapseFour" class="accordion-collapse collapse" aria-labelledby="faqFour" data-bs-parent="#faqAccordion">
                                <div class="accordion-body">
                                    You can book rooms up to 3 months in advance. This allows for better planning while ensuring availability information remains accurate.
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="faqFive">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faqCollapseFive" aria-expanded="false" aria-controls="faqCollapseFive">
                                    <i class="fas fa-exchange-alt me-2"></i>Can I reschedule my booking?
                                </button>
                            </h2>
                            <div id="faqCollapseFive" class="accordion-collapse collapse" aria-labelledby="faqFive" data-bs-parent="#faqAccordion">
                                <div class="accordion-body">
                                    Yes, you can reschedule your booking through your account dashboard. Rescheduling is subject to room availability for your new requested time.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="includes/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/script.js"></script>
    <script>
        // Add animation class when elements come into view
        document.addEventListener('DOMContentLoaded', function() {
            const animatedElements = document.querySelectorAll('.animate-fadeInUp');
            
            function checkIfInView() {
                animatedElements.forEach(element => {
                    const elementTop = element.getBoundingClientRect().top;
                    const elementVisible = 150;
                    
                    if (elementTop < window.innerHeight - elementVisible) {
                        element.style.opacity = '1';
                    }
                });
            }
            
            // Set initial opacity to 0
            animatedElements.forEach(element => {
                element.style.opacity = '0';
            });
            
            window.addEventListener('scroll', checkIfInView);
            // Trigger once on page load
            checkIfInView();
        });
    </script>
</body>
</html>
