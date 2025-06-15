import 'package:flutter/material.dart';
import 'package:crystal_skin_admin/widgets/master_screen.dart';
import '../../models/appointment.dart';
import '../../providers/appointment_provider.dart';
import 'appointment_add_screen.dart';

class AppointmentListScreen extends StatefulWidget {
  static const String routeName = "appointments";
  const AppointmentListScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  final AppointmentProvider _appointmentProvider = AppointmentProvider();
  final TextEditingController _searchController = TextEditingController();

  List<Appointment> _appointments = [];
  int _page = 1;
  int _pageSize = 10;
  int _totalCount = 0;
  bool _isLoading = true;
  DateTime? _selectedDate;
  AppointmentStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    var params = {
      'PageNumber': _page.toString(),
      'PageSize': _pageSize.toString(),
      'SearchFilter': _searchController.text,
    };

    if (_selectedDate != null) {
      params['Date'] = _selectedDate!.toIso8601String();
    }

    if (_selectedStatus != null){
      params['Status'] = _selectedStatus!.index.toString();
    }

    try {
      final response = await _appointmentProvider.getForPagination(params);

      setState(() {
        _appointments = response.items;
        _totalCount = response.totalCount;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Greška pri učitavanju termina: ${e.toString()}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildStatusChip(AppointmentStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case AppointmentStatus.Scheduled:
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[800]!;
        text = 'Zakazan';
        break;
      case AppointmentStatus.Completed:
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        text = 'Završen';
        break;
      case AppointmentStatus.Canceled:
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        text = 'Otkazan';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Future<void> _changeAppointmentStatus(int id, AppointmentStatus newStatus) async {
    try {
      // Show confirmation dialog for status changes
      bool confirm = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Potvrda promjene statusa'),
          content: Text('Da li ste sigurni da želite promijeniti status termina?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Odustani', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () => Navigator.pop(context, true),
              child: Text('Potvrdi'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await _appointmentProvider.changeAppointmentStatus(id, newStatus);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Status termina uspješno promijenjen"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );

        // Refresh the data
        _loadData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Greška pri promjeni statusa: ${e.toString()}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              hintText: 'Pretraži termine...',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.teal),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  _loadData();
                },
              )
                  : null,
            ),
            onChanged: (value) => _loadData(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                        _loadData();
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20, color: Colors.teal),
                        const SizedBox(width: 10),
                        Text(
                          _selectedDate == null
                              ? 'Svi datumi'
                              : '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}',
                          style: TextStyle(
                            color: _selectedDate == null ? Colors.grey : Colors.black,
                          ),
                        ),
                        if (_selectedDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 16),
                            onPressed: () {
                              setState(() {
                                _selectedDate = null;
                                _loadData();
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<AppointmentStatus?>(
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Svi statusi',
                  ),
                  items: [
                    DropdownMenuItem<AppointmentStatus?>(
                      value: null,
                      child: Text('Svi statusi'),
                    ),
                    ...AppointmentStatus.values.map((status) {
                      return DropdownMenuItem<AppointmentStatus?>(
                        value: status,
                        child: Text(
                          status == AppointmentStatus.Scheduled
                              ? 'Zakazani'
                              : status == AppointmentStatus.Completed
                              ? 'Završeni'
                              : 'Otkazani',
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (status) {
                    setState(() {
                      _selectedStatus = status;
                      _loadData();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Termini",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Novi termin'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AppointmentAddScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            _buildSearchAndFilters(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.teal))
                  : _appointments.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      "Nema pronađenih termina",
                      style: TextStyle(
                          color: Colors.grey[600], fontSize: 18),
                    ),
                  ],
                ),
              )
                  : RefreshIndicator(
                onRefresh: _loadData,
                color: Colors.teal,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _appointments.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final appointment = _appointments[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.zero,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          // Navigate to appointment details if needed
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${appointment.firstName} ${appointment.lastName}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  _buildStatusChip(appointment.status),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Usluga: ${appointment.service?.name ?? 'Nepoznato'}',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: Colors.teal),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${appointment.dateTime.day}.${appointment.dateTime.month}.${appointment.dateTime.year}',
                                  ),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.access_time, size: 16, color: Colors.teal),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${appointment.dateTime.hour}:${appointment.dateTime.minute.toString().padLeft(2, '0')}',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (appointment.employee != null)
                                Text(
                                  'Zaposlenik: ${appointment.employee?.firstName ?? ''} ${appointment.employee?.lastName ?? ''}',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              const SizedBox(height: 12),
                              if (appointment.notes?.isNotEmpty ?? false)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Napomene:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(appointment.notes!),
                                  ],
                                ),
                              const SizedBox(height: 12),
                              if (appointment.status == AppointmentStatus.Scheduled)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: const BorderSide(color: Colors.red),
                                      ),
                                      onPressed: () => _changeAppointmentStatus(
                                          appointment.id, AppointmentStatus.Canceled),
                                      child: const Text('Otkaži'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      onPressed: () => _changeAppointmentStatus(
                                          appointment.id, AppointmentStatus.Completed),
                                      child: const Text('Završi'),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            _buildPaginationControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    final totalPages = (_totalCount / _pageSize).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Prikazano ${_appointments.length} od $_totalCount zapisa',
            style: TextStyle(color: Colors.grey[600]),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _page > 1
                    ? () {
                  setState(() {
                    _page--;
                    _loadData();
                  });
                }
                    : null,
              ),
              ...List.generate(
                totalPages,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _page = index + 1;
                        _loadData();
                      });
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _page == index + 1 ? Colors.teal : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: _page == index + 1 ? Colors.white : Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _page < totalPages
                    ? () {
                  setState(() {
                    _page++;
                    _loadData();
                  });
                }
                    : null,
              ),
            ],
          ),
          Row(
            children: [
              const Text('Zapisa po stranici:'),
              const SizedBox(width: 10),
              DropdownButton<int>(
                value: _pageSize,
                items: [5, 10, 20, 50].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _pageSize = newValue;
                      _page = 1;
                      _loadData();
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}