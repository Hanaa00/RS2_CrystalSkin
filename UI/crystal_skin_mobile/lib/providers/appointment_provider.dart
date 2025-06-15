import 'dart:convert';
import 'package:crystal_skin_mobile/helpers/duration_helper.dart';
import 'package:crystal_skin_mobile/models/appointment.dart';
import 'package:crystal_skin_mobile/models/list_item.dart';
import 'package:crystal_skin_mobile/providers/base_provider.dart';
import 'package:crystal_skin_mobile/providers/dropdown_provider.dart';
import 'package:crystal_skin_mobile/providers/login_provider.dart';
import 'package:crystal_skin_mobile/utils/authorization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppointmentProvider extends BaseProvider<Appointment> {
  AppointmentProvider() : super('Appointments');

  final DropdownProvider _dropdownProvider = DropdownProvider();

  List<ListItem> services = [];
  List<ListItem> employees = [];
  List<String> availableSlots = [];

  bool isLoading = false;
  int currentStep = 0;

  // form data
  String firstName = LoginProvider.authResponse?.firstName ?? '';
  String lastName = LoginProvider.authResponse?.lastName ?? '';
  DateTime? birthDate = LoginProvider.authResponse?.birthDate;
  ListItem? selectedService;
  ListItem? selectedEmployee;
  DateTime? selectedDate;
  String? selectedTimeSlot;

  StepState getStepState(int step) {
    if (currentStep > step) return StepState.complete;
    if (currentStep == step) return StepState.editing;
    return StepState.indexed;
  }

  bool isStepValid(int step) {
    switch (step) {
      case 0:
        return firstName.isNotEmpty && lastName.isNotEmpty && birthDate != null;
      case 1:
        return selectedService != null && selectedEmployee != null;
      case 2:
        return selectedDate != null;
      case 3:
        return selectedTimeSlot != null;
      default:
        return false;
    }
  }

  Future<void> loadDropdowns() async {
    isLoading = true;
    notifyListeners();

    services = await _dropdownProvider.getItems('services');
    employees = await _dropdownProvider.getItems('employees');

    isLoading = false;
    notifyListeners();
  }

  Future<void> checkAvailability() async {
    if (!isStepValid(2)) return;
    isLoading = true;
    notifyListeners();

    var timeslots = await getAvailableTimeSlots(selectedEmployee!.key, selectedService!.key, selectedDate!);

    availableSlots = timeslots.map((e) {
      final hours = e.inHours.toString().padLeft(2, '0');
      final minutes = (e.inMinutes % 60).toString().padLeft(2, '0');
      return '$hours:$minutes';

    }).toList();

    isLoading = false;
    notifyListeners();
  }

  Future<bool> bookAppointment() async {
    if (!isStepValid(3)) return false;
    isLoading = true;
    notifyListeners();

    var appointment = Appointment(
        id: 0,
        patientId: Authorization.id!,
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate!,
        employeeId: selectedEmployee!.key,
        dateTime: selectedDate!.add(DurationHelper.stringToDuration(selectedTimeSlot!)),
        serviceId: selectedService!.key,
        status: AppointmentStatus.Scheduled
    );

    var inserted = await this.insert(appointment);

    isLoading = false;
    notifyListeners();

    return inserted;
  }

  void goTo(int step) {
    if (step <= currentStep || isStepValid(currentStep)) {
      currentStep = step;
      notifyListeners();
    }
  }

  void next() {
    if (isStepValid(currentStep)) {
      currentStep++;
      if (currentStep == 3) {
        checkAvailability();
      }
      notifyListeners();
    }
  }

  void back() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  void reset() {
    currentStep = 0;
    firstName = '';
    lastName = '';
    birthDate = null;
    selectedService = null;
    selectedEmployee = null;
    selectedDate = null;
    selectedTimeSlot = null;
    availableSlots = [];
    notifyListeners();
  }

  Future<List<Duration>> getAvailableTimeSlots(
      int employeeId,
      int serviceId,
      DateTime date,
      ) async {
    var uri = Uri.parse('${BaseProvider.apiUrl}/$endpoint/available-time-slots');

    var params = {
      "employeeId": employeeId.toString(),
      "serviceId": serviceId.toString(),
      "date": date.toIso8601String(),
    };

    uri = uri.replace(queryParameters: params);
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return List<String>.from(data).map<Duration>((timeString) {
        final parts = timeString.split(':');
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);
        return Duration(hours: hours, minutes: minutes);
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> cancelAppointment(int appointmentId) async {
    var uri = Uri.parse('${BaseProvider.apiUrl}/$endpoint/cancel-appointment/$appointmentId');

    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to change status');
    }
  }


  @override
  Appointment fromJson(data) {
    return Appointment.fromJson(data);
  }
}
