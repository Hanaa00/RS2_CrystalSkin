import 'package:crystal_skin_mobile/helpers/colors.dart';
import 'package:crystal_skin_mobile/providers/appointment_provider.dart';
import 'package:crystal_skin_mobile/providers/login_provider.dart';
import 'package:crystal_skin_mobile/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:crystal_skin_mobile/models/list_item.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final _formKeys = List.generate(4, (_) => GlobalKey<FormState>());
  late TextEditingController _dobController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _dobController = TextEditingController(
      text: LoginProvider.authResponse?.birthDate != null
          ? DateFormat.yMMMd().format(LoginProvider.authResponse!.birthDate!)
          : null,
    );
    _dateController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentProvider>().loadDropdowns();
    });
  }

  @override
  void dispose() {
    _dobController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          context.read<AppointmentProvider>().reset();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Rezervacija termina'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: app_color,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Consumer<AppointmentProvider>(
                builder: (context, provider, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        color: app_color,
                        value: (provider.currentStep + 1) / 4,
                        backgroundColor: Colors.grey[200],
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 24),

                      _buildStepContent(provider),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (provider.currentStep > 0)
                            OutlinedButton(
                              onPressed: provider.back,
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Nazad',
                                  style: TextStyle(fontSize: 16, color: app_color)),
                            ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: provider.isLoading || !provider.isStepValid(provider.currentStep)
                                ? null
                                : () async {
                              if (provider.currentStep == 3 || (_formKeys[provider.currentStep].currentState?.validate() ?? false)) {
                                if (provider.currentStep == 3) {
                                  var inserted = await provider.bookAppointment();

                                  if (inserted){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Termin uspješno rezervisan!'),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.popAndPushNamed(context, HomePage.routeName);
                                    provider.reset();
                                  }
                                  else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Dogodila se greška prilikom rezervacije termina'),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } else {
                                  provider.next();
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              provider.currentStep == 3 ? 'Potvrdi termin' : 'Dalje',
                              style: TextStyle(fontSize: 16, color: app_color),
                            ),
                          ),

                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
    );
  }

  Widget _buildStepContent(AppointmentProvider provider) {
    switch (provider.currentStep) {
      case 0:
        return _buildPersonalInfoStep(provider);
      case 1:
        return _buildServiceSelectionStep(provider);
      case 2:
        return _buildDateSelectionStep(provider);
      case 3:
        return _buildTimeSelectionStep(provider);
      default:
        return Container();
    }
  }

  Widget _buildPersonalInfoStep(AppointmentProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lične informacije',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'Unesite osnovne informacije kako biste započeli proces rezervacije termina',
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        Form(
          key: _formKeys[0],
          //autovalidateMode: AutovalidateMode.onUnfocus,
          onChanged: () => provider.notifyListeners(),
          child: Column(
            children: [
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZšđčćžŠĐČĆŽ\s]')),
                ],
                decoration: InputDecoration(
                  labelText: 'Ime',
                  labelStyle: TextStyle(color: app_color),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: app_color),
                  ),
                ),
                initialValue: provider.firstName,
                onChanged: (v) => provider.firstName = v,
                validator: (v) => v!.isEmpty ? 'Ovo polje je obavezno' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZšđčćžŠĐČĆŽ\s]')),
                ],
                decoration: InputDecoration(
                  labelText: 'Prezime',
                  labelStyle: TextStyle(color: app_color),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: app_color),
                  ),
                ),
                initialValue: provider.lastName,
                onChanged: (v) => provider.lastName = v,
                validator: (v) => v!.isEmpty ? 'Ovo polje je obavezno' : null,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
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
                    provider.birthDate = d;
                    _dobController.text = DateFormat.yMMMd().format(d);
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      labelText: 'Datum rođenja',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: app_color),
                      prefixIcon: Icon(Icons.calendar_today),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: app_color),
                      ),
                    ),
                    validator: (_) => provider.birthDate == null ? 'Ovo polje je obavezno' : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceSelectionStep(AppointmentProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Odabir usluge i doktora',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'Odaberite uslugu koja vam je potrebna i svog željenog dermatologa',
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        Form(
          key: _formKeys[1],
          onChanged: () => provider.notifyListeners(),
          child: Column(
            children: [
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
        ),
      ],
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
                              'Dostupno ${provider.selectedDate != null
                                  ? 'na ${DateFormat.MMMMd().format(provider.selectedDate!)}'
                                  : 'za odabrani datum'}',
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
                    validator: (_) => provider.selectedDate == null ? 'Ovo polje je obavezno' : null,
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
                    Text('${provider.selectedService?.value ?? ''}'),
                    Text('Dr. ${provider.selectedEmployee?.value ?? ''}'),
                    Text(
                      '${provider.selectedDate != null
                          ? DateFormat.yMMMMd().format(provider.selectedDate!)
                          : ''} u ${provider.selectedTimeSlot ?? ''}',
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
