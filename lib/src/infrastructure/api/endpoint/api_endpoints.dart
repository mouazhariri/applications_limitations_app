class ApiEndPoints {
  static const domain = "van_sales.van_sales.api";

  //? --- Home ---
  static const String homeDashboard = '$domain.dashboard.get_dashboard';
  static const String homeServices = '$domain.smart_clinic.get_home_services';
  static const String doctors = '$domain.smart_clinic.get_doctors';
  static const String doctorDetails = '$domain.smart_clinic.get_doctor_details';
  static const String appointments = '$domain.smart_clinic.get_appointments';
  static const String bookAppointment = '$domain.smart_clinic.book_appointment';
  static const String cancelAppointment = '$domain.smart_clinic.cancel_appointment';

  //? --- Booking ---
  static const String doctorSchedule = '$domain.smart_clinic.get_doctor_schedule';
  static const String paymentMethods = '$domain.smart_clinic.get_payment_methods';
  static const String createBooking = '$domain.smart_clinic.create_booking';
  static const String confirmBooking = '$domain.smart_clinic.confirm_booking';
  static const String cancelBooking = '$domain.smart_clinic.cancel_booking';
  static const String profile = '$domain.smart_clinic.get_profile';

  //? --- Customers ---
  static const String createCustomer = '$domain.customer.create_customer';
  static const String getCustomers = '$domain.customer.get_customers';
  static const String searchCustomers = '$domain.customer.search_customers';

  //? --- Orders ---
  static const String orderSummary = '$domain.orders.get_order_summary';
  static const String getInvoiceDetails = '$domain.orders.get_invoice_details';



  //? --- AUTH ---
  static const String signIn = '$domain.auth.login';

  //? --- VAN STOCK ---
  static const String getVanStock = '$domain.inventory.get_warehouse_stock';
  //? --- MY TRIPS ---
  static const String getTripsData = '$domain.trip.get_trip_details';
  static const String updateVisitStatus = '$domain.visit.update_visit_status';
  static const String startTrip = '$domain.trip.start_trip';

  //? --- CREATION INVOICE ---
  static const String createInvoice = '$domain.orders.create_invoice';
  static const String createPaymentApi = '$domain.payments.create_payment';
  static const String createReturnOrder = '$domain.returns.create_return_order';
  //? --- Settings ---
  static const String deleteAccountApi = '$domain.profile.delete_user_profile';
  static const String logoutApi = '$domain.auth.logout';
  static const String appNotification = 'sabaa.api.api.get_notification_logs';

  static const String sendFcmToken = 'fcm_frappe.api.device_token';

}
