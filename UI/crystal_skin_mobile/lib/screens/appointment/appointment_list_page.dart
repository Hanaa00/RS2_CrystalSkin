import 'package:crystal_skin_mobile/models/appointment.dart';
import 'package:crystal_skin_mobile/providers/appointment_provider.dart';
import 'package:crystal_skin_mobile/utils/authorization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppointmentListPage extends StatefulWidget {
  const AppointmentListPage({super.key});

  @override
  State<AppointmentListPage> createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  final AppointmentProvider _appointmentProvider = AppointmentProvider();
  final List<Appointment> _appointments = [];
  int _page = 1;
  int _pageSize = 10;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadAppointments();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadAppointments();
    }
  }

  Future<void> _loadAppointments() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final response = await _appointmentProvider.getForPagination({
        'userId': Authorization.id!.toString(),
        'pageNumber': _page.toString(),
        'pageSize': _pageSize.toString(),
      });

      setState(() {
        _appointments.addAll(response.items);
        _hasMore = response.items.length < 10;
        _page++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška prilikom učitavanja termina: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _cancelAppointment(Appointment appointment) async {
    final now = DateTime.now();
    final appointmentDate = appointment.dateTime;
    final isSameDay = appointmentDate.year == now.year &&
        appointmentDate.month == now.month &&
        appointmentDate.day == now.day;

    if (isSameDay) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Termin se ne može otkazati isti dan.'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    //if (appointment.status != AppointmentStatus.Scheduled) {
    //  ScaffoldMessenger.of(context).showSnackBar(
    //    SnackBar(
    //      content: Text('Termin je već ${_getStatusText(appointment.status)}.'),
    //      backgroundColor: Colors.red.shade600,
    //      behavior: SnackBarBehavior.floating,
    //      shape: RoundedRectangleBorder(
    //        borderRadius: BorderRadius.circular(10),
    //      ),
    //    ),
    //  );
    //  return;
    //}

    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Otkazivanje termina'),
          content: const Text('Da li ste sigurni da želite otkazati ovaj termin?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Ne'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Da', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      setState(() => _isLoading = true);

      var result = await _appointmentProvider.cancelAppointment(appointment.id!);

      if (result){
        setState(() {
          final index = _appointments.indexOf(appointment);
          _appointments[index].status = AppointmentStatus.Canceled;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Termin je uspješno otkazan.'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Termin ne možete otkazati isti dan.'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška prilikom otkazivanja termina: ${e.toString()}'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  String _getStatusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.Scheduled:
        return 'na čekanju';
      case AppointmentStatus.Completed:
        return 'odobren';
      case AppointmentStatus.Canceled:
        return 'otkazan';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50.withOpacity(0.3), Colors.white],
          ),
        ),
        child: _appointments.isEmpty && !_isLoading
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //SvgPicture.asset(
              //  'assets/images/empty_appointments.svg',
              //  height: 200,
              //  semanticsLabel: 'Nema zakazivanja termina',
              //),
              //const SizedBox(height: 20),
              Text(
                'Nisu pronađeni termini',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Rezervirajte svoj prvi termin već danas!',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        )
            : RefreshIndicator(
          color: Colors.blue,
          onRefresh: () async {
            setState(() {
              _page = 1;
              _appointments.clear();
              _hasMore = true;
            });
            await _loadAppointments();
          },
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            itemCount: _appointments.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _appointments.length) {
                return _buildLoader();
              }
              return _buildAppointmentCard(_appointments[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
          child: _isLoading
              ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : null
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('HH:mm');
    final now = DateTime.now();
    final appointmentDate = appointment.dateTime;
    final isPastAppointment = appointmentDate.isBefore(now);
    final isSameDay = appointmentDate.year == now.year &&
        appointmentDate.month == now.month &&
        appointmentDate.day == now.day;
    final canCancel = appointment.status == AppointmentStatus.Scheduled &&
        !isPastAppointment &&
        !isSameDay;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // Handle tap on appointment
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          appointment.service?.name ?? 'N/A',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isPastAppointment
                                ? Colors.grey.shade600
                                : Colors.blue.shade800,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStatusChip(appointment.status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateFormat.format(appointment.dateTime),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeFormat.format(appointment.dateTime),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (appointment.employee != null)
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Dr. ${appointment.employee!.firstName} ${appointment.employee!.lastName}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  if (appointment.service?.duration != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${appointment.service!.duration.inMinutes} minuta',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ],
                  if (canCancel) ...[
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => _cancelAppointment(appointment),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.red.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Otkaži',
                            style: TextStyle(color: Colors.red.shade600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(AppointmentStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;
    IconData icon;

    switch (status) {
      case AppointmentStatus.Scheduled:
        backgroundColor = Colors.orange.shade50;
        textColor = Colors.orange.shade800;
        text = 'Zakazan';
        icon = Icons.access_time;
        break;
      case AppointmentStatus.Completed:
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green.shade800;
        text = 'Završen';
        icon = Icons.check_circle_outline;
        break;
      case AppointmentStatus.Canceled:
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade800;
        text = 'Otkazan';
        icon = Icons.cancel_outlined;
        break;
    }

    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      avatar: Icon(icon, size: 16, color: textColor),
      label: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: textColor.withOpacity(0.2)),
      ),
    );
  }
}