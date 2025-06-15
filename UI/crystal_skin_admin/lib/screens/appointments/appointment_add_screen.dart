import 'package:confetti/confetti.dart';
import 'package:crystal_skin_admin/screens/appointments/appointment_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:crystal_skin_admin/providers/appointment_provider.dart';
import 'package:crystal_skin_admin/widgets/master_screen.dart';
import '../../helpers/colors.dart';
import '../../models/listItem.dart';

class AppointmentAddScreen extends StatefulWidget {
  static const String routeName = "appointment/add";
  const AppointmentAddScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentAddScreen> createState() => _AppointmentAddScreenState();
}

class _AppointmentAddScreenState extends State<AppointmentAddScreen> {
  final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());
  late TextEditingController _dobController;
  late TextEditingController _dateController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _dobController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDropdowns();
    });
  }

  Future<void> _loadDropdowns() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<AppointmentProvider>(context, listen: false)
          .loadDropdowns();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildPersonalInfoStep(AppointmentProvider provider) {
    return Form(
      key: _formKeys[0],
      onChanged: () => provider.notifyListeners(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lične informacije',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: app_color),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<ListItem>(
            items: provider.patients
                .map((i) => DropdownMenuItem(
                      value: i,
                      child:
                          Text(i.value, style: const TextStyle(fontSize: 16)),
                    ))
                .toList(),
            value: provider.selectedPatient,
            decoration: InputDecoration(
              labelText: 'Pacijent',
              border: OutlineInputBorder(),
              prefixIcon: const Icon(Icons.people),
              labelStyle: TextStyle(color: app_color),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: app_color),
              ),
            ),
            onChanged: (v) => provider.selectedPatient = v,
            validator: (v) => v == null ? 'Ovo polje je obavezno' : null,
            borderRadius: BorderRadius.circular(8),
            icon: const Icon(Icons.arrow_drop_down),
            isExpanded: true,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSelectionStep(AppointmentProvider provider) {
    return Form(
      key: _formKeys[1],
      onChanged: () => provider.notifyListeners(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Odabir usluge, pacijenta i doktora',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: app_color),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<ListItem>(
            items: provider.services
                .map((i) => DropdownMenuItem(
                      value: i,
                      child: Text(i.value, style: TextStyle(fontSize: 16)),
                    ))
                .toList(),
            value: provider.selectedService,
            decoration: InputDecoration(
              labelText: 'Usluga',
              labelStyle: TextStyle(color: app_color),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.medical_services),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: app_color),
              ),
            ),
            onChanged: (v) => provider.selectedService = v,
            validator: (v) => v == null ? 'Ovo polje je obavezno' : null,
            borderRadius: BorderRadius.circular(8),
            icon: Icon(Icons.arrow_drop_down),
            isExpanded: true,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<ListItem>(
            items: provider.employees
                .map((i) => DropdownMenuItem(
                      value: i,
                      child: Text(i.value, style: TextStyle(fontSize: 16)),
                    ))
                .toList(),
            value: provider.selectedEmployee,
            decoration: InputDecoration(
              labelText: 'Doktor',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.people),
              labelStyle: TextStyle(color: app_color),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: app_color),
              ),
            ),
            onChanged: (v) => provider.selectedEmployee = v,
            validator: (v) => v == null ? 'Ovo polje je obavezno' : null,
            borderRadius: BorderRadius.circular(8),
            icon: Icon(Icons.arrow_drop_down),
            isExpanded: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelectionStep(AppointmentProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Odabir datuma',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'Odaberite datum koji vam odgovara za posjetu kod specijaliste:',
          style: TextStyle(color: Colors.grey[600]),
        ),
        Form(
          key: _formKeys[2],
          onChanged: () => provider.notifyListeners(),
          child: Column(
            children: [
              if (provider.selectedEmployee != null)
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey[200]!),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: app_color.withOpacity(0.1),
                          child: Icon(Icons.person, color: app_color),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dr. ${provider.selectedEmployee?.value ?? ''}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Dostupno ${provider.selectedDate != null ? 'na ${DateFormat.MMMMd().format(provider.selectedDate!)}' : 'za odabrani datum'}',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(Duration(days: 1)),
                    firstDate: DateTime.now().add(Duration(days: 1)),
                    lastDate: DateTime.now().add(Duration(days: 30)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: app_color,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (d != null) {
                    provider.selectedDate = d;
                    _dateController.text = DateFormat.yMMMMd().format(d);
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Datum pregleda',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                      labelStyle: TextStyle(color: app_color),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: app_color),
                      ),
                    ),
                    validator: (_) => provider.selectedDate == null
                        ? 'Ovo polje je obavezno'
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelectionStep(AppointmentProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Odabir termina',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'Odaberite željeno vrijeme pregleda',
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        if (provider.isLoading)
          Center(child: CircularProgressIndicator())
        else if (provider.availableSlots.isEmpty)
          Center(
            child: Column(
              children: [
                Icon(Icons.schedule, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Nema dostupnih termina za odabrani datum',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => provider.goTo(2),
                  child: Text('Odaberite drugi datum'),
                ),
              ],
            ),
          )
        else
          Center(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: provider.availableSlots.map((s) {
                final selected = s == provider.selectedTimeSlot;
                return FilterChip(
                  backgroundColor: selected ? app_color : Colors.transparent,
                  label: Text(s),
                  onSelected: (_) {
                    // setState(() {
                    provider.selectedTimeSlot = s;
                    provider.notifyListeners();
                    //});
                  },
                  selectedColor: app_color,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 16),
        if (provider.selectedTimeSlot != null)
          Card(
            elevation: 0,
            color: app_color.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sažetak termina',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: app_color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(provider.selectedService?.value ?? ''),
                    Text('Dr. ${provider.selectedEmployee?.value ?? ''}'),
                    Text(
                      '${provider.selectedDate != null ? DateFormat.yMMMMd().format(provider.selectedDate!) : ''} u ${provider.selectedTimeSlot ?? ''}',
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildConfirmationStep(AppointmentProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Potvrda termina',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: app_color),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                    'Pacijent:', provider.selectedPatient?.value ?? ''),
                _buildDetailRow(
                    'Usluga:', provider.selectedService?.value ?? ''),
                _buildDetailRow(
                    'Doktor:', provider.selectedEmployee?.value ?? ''),
                _buildDetailRow('Datum:', _dateController.text),
                _buildDetailRow('Vrijeme:', _dobController.text),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: app_color),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppointmentProvider>(context);

    return MasterScreenWidget(
      title: 'Novi termin',
      child: _isLoading
          ? Center(child: CircularProgressIndicator(color: app_color))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kreiranje novog termina',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: app_color),
                  ),
                  const SizedBox(height: 24),
                  IndexedStack(
                    index: provider.currentStep,
                    children: [
                      _buildPersonalInfoStep(provider),
                      _buildServiceSelectionStep(provider),
                      _buildDateSelectionStep(provider),
                      _buildTimeSelectionStep(provider),
                      _buildConfirmationStep(provider),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (provider.currentStep > 0)
                        OutlinedButton(
                          onPressed: provider.back,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            side: BorderSide(color: app_color),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Nazad',
                            style: TextStyle(color: app_color),
                          ),
                        ),
                      ElevatedButton(
                        onPressed: provider.isLoading ||
                                !provider.isStepValid(provider.currentStep)
                            ? null
                            : () async {
                                if (provider.currentStep == 3 ||
                                    (_formKeys[provider.currentStep]
                                            .currentState
                                            ?.validate() ??
                                        false)) {
                                  if (provider.currentStep == 3) {
                                    var inserted = await provider.bookAppointment();

                                    if (inserted) {
                                      await showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => SuccessBookingDialog(),
                                      );
                                      provider.reset();
                                    } else {
                                      await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Greška', style: TextStyle(color: Colors.red)),
                                          content: Text('Dogodila se greška prilikom rezervacije termina'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: Text('OK', style: TextStyle(color: app_color)),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  } else {
                                    provider.next();
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          provider.currentStep == 3
                              ? 'Potvrdi termin'
                              : 'Dalje',
                          style: TextStyle(fontSize: 16, color: app_color),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _dobController.dispose();
    super.dispose();
  }
}

class SuccessBookingDialog extends StatefulWidget {
  const SuccessBookingDialog({Key? key}) : super(key: key);

  @override
  _SuccessBookingDialogState createState() => _SuccessBookingDialogState();
}

class _SuccessBookingDialogState extends State<SuccessBookingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _confettiController = ConfettiController(duration: Duration(seconds: 2));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),

        // Sadržaj dialoga
        Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(24),
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: app_color, // Koristite vašu app_color varijablu
                      size: 80,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Termin rezervisan!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: app_color,
                      ),
                    ),
                    SizedBox(height: 16),
                    const Text(
                      'Vaš termin je uspješno rezervisan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor : app_color,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const AppointmentListScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
