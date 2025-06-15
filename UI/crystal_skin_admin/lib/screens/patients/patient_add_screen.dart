import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crystal_skin_admin/models/listItem.dart';
import 'package:crystal_skin_admin/providers/dropdown_provider.dart';
import 'package:crystal_skin_admin/widgets/master_screen.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../providers/users_provider.dart';
import 'package:crystal_skin_admin/screens/patients/patient_list_screen.dart';

class PatientAddScreen extends StatefulWidget {
  static const String routeName = "patient/add";
  const PatientAddScreen({super.key});

  @override
  State<PatientAddScreen> createState() => _PatientAddScreenState();
}

class _PatientAddScreenState extends State<PatientAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  final _diagnosesController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _treatmentsController = TextEditingController();
  final _medicalNotesController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  DropdownProvider? _dropdownProvider;
  UserProvider? _userProvider;
  dynamic bytes = null;
  dynamic _imageFile;
  List<ListItem> countries = [];
  List<ListItem> bloodTypes = [
    ListItem(key: 1, value: "A+"),
    ListItem(key: 2, value: "A-"),
    ListItem(key: 3, value: "B+"),
    ListItem(key: 4, value: "B-"),
    ListItem(key: 5, value: "AB+"),
    ListItem(key: 6, value: "AB-"),
    ListItem(key: 7, value: "0+"),
    ListItem(key: 8, value: "0-"),
  ];
  List<ListItem> genders = [
    ListItem(key: 1, value: "Muški"),
    ListItem(key: 2, value: "Ženski"),
    ListItem(key: 3, value: "Ostalo"),
  ];
  ListItem? _selectedCountry = null;
  ListItem? _selectedBloodType = null;
  DateTime? _selectedDate;
  ListItem? _selectedGender;

  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.teal,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat('dd.MM.yyyy').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _imageFile = null;
    _dropdownProvider = DropdownProvider();
    _userProvider = UserProvider();
    loadCountries();
  }

  Future loadCountries() async {
    var response = await _dropdownProvider?.getItems("countries");
    setState(() {
      countries = response as List<ListItem>;
      if (countries.isNotEmpty) {
        _selectedCountry = countries[0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dodaj novog pacijenta",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.teal,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Osnovne informacije",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.teal.withOpacity(0.5)),
                                  ),
                                  child: _imageFile != null
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(
                                      bytes,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : const Icon(Icons.person, size: 60, color: Colors.teal),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  icon:
                                      const Icon(Icons.photo_camera, size: 18),
                                  label: const Text('Dodaj sliku'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: _selectImage,
                                ),
                              ],
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildTextField(
                                          controller: _firstNameController,
                                          label: 'Ime',
                                          icon: Icons.person_outline,
                                          validator: (value) =>
                                              value?.isEmpty ?? true
                                                  ? 'Unesite ime'
                                                  : null,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: _buildTextField(
                                          controller: _lastNameController,
                                          label: 'Prezime',
                                          icon: Icons.person_outline,
                                          validator: (value) =>
                                              value?.isEmpty ?? true
                                                  ? 'Unesite prezime'
                                                  : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  _buildTextField(
                                    controller: _usernameController,
                                    label: 'Korisničko ime',
                                    icon: Icons.alternate_email,
                                    validator: (value) => value?.isEmpty ?? true
                                        ? 'Unesite korisničko ime'
                                        : null,
                                  ),
                                  const SizedBox(height: 15),
                                  _buildTextField(
                                    controller: _emailController,
                                    label: 'Email',
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true)
                                        return 'Unesite email';
                                      if (!RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(value!)) {
                                        return 'Unesite validan email';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Dodatne informacije",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _addressController,
                                label: 'Adresa',
                                icon: Icons.home_outlined,
                                validator: (value) => value?.isEmpty ?? true
                                    ? 'Unesite adresu'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildTextField(
                                controller: _phoneController,
                                label: 'Telefon',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                validator: _validatePhone,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _birthDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Datum rođenja',
                            prefixIcon:
                                Icon(Icons.calendar_today, color: Colors.teal),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: Colors.teal, width: 2),
                            ),
                          ),
                          onTap: () => _selectDate(context),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Odaberite datum rođenja'
                              : null,
                        ),
                        const SizedBox(height: 15),
                        DropdownButtonFormField<ListItem>(
                          value: _selectedGender,
                          decoration: InputDecoration(
                            labelText: "Spol",
                            prefixIcon: const Icon(Icons.person_outline,
                                color: Colors.teal),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: genders.map((ListItem gender) {
                            return DropdownMenuItem<ListItem>(
                              value: gender,
                              child: Text(gender.value),
                            );
                          }).toList(),
                          onChanged: (ListItem? newValue) {
                            setState(() {
                              _selectedGender = newValue;
                            });
                          },
                          validator: (value) =>
                          value == null ? 'Odaberite spol' : null,
                        ),
                        const SizedBox(height: 15),
                        DropdownButtonFormField<ListItem>(
                          value: _selectedCountry,
                          decoration: InputDecoration(
                            labelText: "Država",
                            prefixIcon: const Icon(Icons.flag_outlined,
                                color: Colors.teal),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: TextStyle(color: Colors.grey[800]),
                          dropdownColor: Colors.white,
                          icon: const Icon(Icons.arrow_drop_down,
                              color: Colors.teal),
                          onChanged: (ListItem? newValue) {
                            setState(() {
                              _selectedCountry = newValue!;
                            });
                          },
                          items: countries.map((ListItem country) {
                            return DropdownMenuItem<ListItem>(
                              value: country,
                              child: Text(country.value),
                            );
                          }).toList(),
                          validator: (value) =>
                              value == null ? 'Odaberite državu' : null,
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Napomene',
                            alignLabelWithHint: true,
                            prefixIcon: const Icon(Icons.note_outlined,
                                color: Colors.teal),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Karton pacijenta",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<ListItem>(
                                value: _selectedBloodType,
                                decoration: InputDecoration(
                                  labelText: "Krvna grupa",
                                  prefixIcon:
                                      Icon(Icons.bloodtype, color: Colors.teal),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: bloodTypes.map((ListItem type) {
                                  return DropdownMenuItem<ListItem>(
                                    value: type,
                                    child: Text(type.value),
                                  );
                                }).toList(),
                                onChanged: (ListItem? newValue) {
                                  setState(() {
                                    _selectedBloodType = newValue;
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Odaberite krvnu grupu'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildTextField(
                                controller: _heightController,
                                label: 'Visina (cm)',
                                icon: Icons.height,
                                keyboardType: TextInputType.number,
                                validator: _validateHeight,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildTextField(
                                controller: _weightController,
                                label: 'Težina (kg)',
                                icon: Icons.monitor_weight,
                                keyboardType: TextInputType.number,
                                validator: _validateWeight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildLargeTextField(
                          controller: _diagnosesController,
                          label: 'Dijagnoze',
                          icon: Icons.medical_services,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Unesite dijagnoze'
                              : null,
                        ),
                        const SizedBox(height: 15),
                        _buildLargeTextField(
                          controller: _allergiesController,
                          label: 'Alergije',
                          icon: Icons.warning_amber_rounded,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Unesite alergije'
                              : null,
                        ),
                        const SizedBox(height: 15),
                        _buildLargeTextField(
                          controller: _treatmentsController,
                          label: 'Tretmani i terapije',
                          icon: Icons.medication,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Unesite tretmane'
                              : null,
                        ),
                        const SizedBox(height: 15),
                        _buildLargeTextField(
                          controller: _medicalNotesController,
                          label: 'Medicinske napomene',
                          icon: Icons.note_add,
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Unesite medicinske napomene'
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        foregroundColor: Colors.teal,
                      ),
                      child: const Text('Odustani'),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Spasi'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final formattedDate =
            DateFormat('yyyy-MM-dd').format(_selectedDate ?? DateTime.now());

        final Map<String, dynamic> formData = {
          'id': '0',
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'userName': _usernameController.text,
          'email': _emailController.text,
          'phoneNumber': _phoneController.text,
          'birthDate': formattedDate,
          'address': _addressController.text,
          'gender': _selectedGender?.key ?? '3',
          'description': _notesController.text,
          'isPatient': 'true',
          'MedicalRecord.Diagnoses': _diagnosesController.text,
          'MedicalRecord.Allergies': _allergiesController.text,
          'MedicalRecord.Treatments': _treatmentsController.text,
          'MedicalRecord.Notes': _medicalNotesController.text,
          'MedicalRecord.BloodType': _selectedBloodType?.value ?? "",
          'MedicalRecord.Height':
              _heightController.text.isNotEmpty ? _heightController.text : '0',
          'MedicalRecord.Weight':
              _weightController.text.isNotEmpty ? _weightController.text : '0',
        };

        if (bytes != null) {
          formData['file'] = http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: 'image.jpg',
          );
        }

        bool? result = await _userProvider?.insertFormData(formData);

        if (result != null && result) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Pacijent uspješno dodan"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PatientListScreen(),
            ),
          );
        } else {
          throw Exception("Greška pri spremanju podataka o pacijentu.");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Greška pri dodavanju pacijenta: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Unesite broj telefona';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Broj telefona može sadržavati samo brojeve';
    }
    if (value.length < 7) {
      return 'Broj telefona mora imati najmanje 7 cifara';
    }
    return null;
  }

  String? _validateHeight(String? value) {
    if (value != null && value.isNotEmpty) {
      final height = int.tryParse(value);
      if (height == null) {
        return 'Unesite validan broj';
      }
      if (height < 50 || height > 250) {
        return 'Visina mora biti između 50 i 250 cm';
      }
    }
    return null;
  }

  String? _validateWeight(String? value) {
    if (value != null && value.isNotEmpty) {
      final weight = int.tryParse(value);
      if (weight == null) {
        return 'Unesite validan broj';
      }
      if (weight < 2 || weight > 300) {
        return 'Težina mora biti između 2 i 300 kg';
      }
    }
    return null;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    _diagnosesController.dispose();
    _allergiesController.dispose();
    _treatmentsController.dispose();
    _medicalNotesController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}
