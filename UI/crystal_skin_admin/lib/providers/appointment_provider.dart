import 'dart:convert';
import 'package:crystal_skin_admin/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../helpers/duration_helper.dart';
import '../models/appointment.dart';
import 'package:crystal_skin_admin/utils/authorization.dart';
import '../models/listItem.dart';
import 'base_provider.dart';
import 'dropdown_provider.dart';

class AppointmentProvider extends BaseProvider<Appointment> {
  AppointmentProvider() : super('Appointments');

  final DropdownProvider _dropdownProvider = DropdownProvider();
  final UserProvider _userProvider = UserProvider();

  List<ListItem> services = [];
  List<ListItem> employees = [];
  List<ListItem> patients = [];
  List<String> availableSlots = [];

  bool isLoading = false;
  int currentStep = 0;

  String firstName = '';
  String lastName = '';
  DateTime? birthDate;
  ListItem? selectedService;
  ListItem? selectedEmployee;
  ListItem? selectedPatient;
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
        return selectedPatient != null;
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
    patients = await _dropdownProvider.getItems('patients');

    isLoading = false;
    notifyListeners();
  }

  Future<void> checkAvailability() async {
    if (!isStepValid(2)) return;
    isLoading = true;
    notifyListeners();

    var timeslots = await getAvailableTimeSlots(
        selectedEmployee!.key, selectedService!.key, selectedDate!);

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

    var patient = await _userProvider.getById(selectedPatient!.key, null);

    var appointment = Appointment(
        id: 0,
        patientId: selectedPatient!.key,
        firstName: patient.firstName,
        lastName: patient.lastName,
        birthDate: patient.birthDate,
        employeeId: selectedEmployee!.key,
        dateTime: selectedDate!
            .add(DurationHelper.stringToDuration(selectedTimeSlot!)),
        serviceId: selectedService!.key,
        status: AppointmentStatus.Scheduled);

    var inserted = await insert(appointment);

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
    selectedPatient = null;
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
    var uri =
        Uri.parse('${BaseProvider.apiUrl}/$endpoint/available-time-slots');

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

  Future<bool> changeAppointmentStatus(int appointmentId, AppointmentStatus status) async {
    try {

      final response = await http.get(
        Uri.parse('${BaseProvider.apiUrl}/Appointments/change-status/$appointmentId/${status.index}'),
        headers: Authorization.createHeaders(),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('User is not authenticated');
      } else {
        throw Exception('Failed to change appointment status: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error changing appointment status: $e');
    }
  }

  @override
  Appointment fromJson(data) {
    return Appointment.fromJson(data);
  }
}
