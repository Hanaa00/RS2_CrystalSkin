import 'dart:typed_data';
import 'package:crystal_skin_admin/screens/patients/patient_add_screen.dart';
import 'package:crystal_skin_admin/screens/patients/patient_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:crystal_skin_admin/models/appUser.dart';
import 'package:crystal_skin_admin/providers/users_provider.dart';
import 'package:crystal_skin_admin/widgets/master_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:file_saver/file_saver.dart';
import '../../providers/reports_provider.dart';

class PatientListScreen extends StatefulWidget {
  static const String routeName = "patients";
  const PatientListScreen({Key? key}) : super(key: key);

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  UserProvider? _userProvider;
  final TextEditingController _searchController = TextEditingController();
  List<AppUser> data = [];
  int page = 1;
  int pageSize = 10;
  int totalRecordCounts = 0;
  String searchFilter = '';
  bool isLoading = true;
  String apiUrl = "";
  final bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    apiUrl = dotenv.env['API_URL']!;
    _userProvider = UserProvider();
    // SnackBar se NIKADA ne poziva u initState!
    loadData(searchFilter, page, pageSize);
  }

  Future<void> loadData(searchFilter, page, pageSize) async {
    setState(() {
      isLoading = true;
    });

    if (searchFilter != '') {
      page = 1;
    }

    var response = await _userProvider?.getForPagination({
      'SearchFilter': searchFilter.toString(),
      'IsPatient': 'true',
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString()
    });

    setState(() {
      data = response?.items as List<AppUser>;
      totalRecordCounts = response?.totalCount as int;
      isLoading = false;
    });
  }

  Future<void> _generateReport() async {
    if (data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Nema podataka za generisanje izvještaja"),
          backgroundColor: Colors.yellow[800],
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final reportsProvider = Provider.of<ReportsProvider>(context, listen: false);
      final pdfBytes = await reportsProvider.downloadPatientsReport(
        searchFilter: searchFilter,
        isPatient: true,
        pageNumber: page,
        pageSize: pageSize,
      );

      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = "izvjestaj_pacijenata_$timestamp.pdf";

      final filePath = await FileSaver.instance.saveFile(
        name: fileName,
        bytes: pdfBytes as Uint8List,
        ext: "pdf",
        mimeType: MimeType.pdf,
      );

      if (filePath != null) {
        await OpenFile.open(filePath);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Izvještaj uspješno preuzet i otvoren"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Greška prilikom generisanja izvještaja: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Column(
          children: [
            _buildHeader(),
            _buildSearch(),
            Expanded(
              child: isLoading ? _buildShimmerLoader() : _buildList(),
            ),
            _buildPagination(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PatientAddScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Pacijenti",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.bar_chart, size: 20),
                label: const Text("Izvještaj"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: _generateReport,
              ),
              const SizedBox(width: 16),
              if (_isSearching)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 24),
                    child: _buildSearchField(),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildSearchField(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        hintText: 'Pretraži...',
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
            setState(() {
              searchFilter = '';
              loadData(searchFilter, 1, pageSize);
            });
          },
        )
            : null,
      ),
      onChanged: (value) {
        setState(() {
          searchFilter = value;
          loadData(searchFilter, 1, pageSize);
        });
      },
    );
  }

  Widget _buildShimmerLoader() {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildList() {
    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_alt_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "Nema pronađenih pacijenata",
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final user = data[index];
        return _buildPatientCard(user);
      },
    );
  }

  Widget _buildPatientCard(AppUser user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Image Section
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  color: Colors.teal[100],
                ),
                child: (user.profilePhoto != null)
                    ? ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    user.profilePhoto!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
                  ),
                )
                    : _buildDefaultAvatar(),
              ),

              // Patient Info Section
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        "${user.firstName} ${user.lastName}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Basic Info
                      _buildInfoRow(Icons.person_outline, user.userName ?? "-"),
                      _buildInfoRow(Icons.email_outlined, user.email ?? "-"),
                      _buildInfoRow(Icons.phone_outlined, user.phoneNumber ?? "-"),

                      // Divider
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(height: 1, color: Colors.grey),
                      ),

                      // Medical Info Section
                      const Text(
                        "Medicinski podaci",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 6),

                      if (user.medicalRecord?.height != null)
                        _buildInfoRow(Icons.height, "${user.medicalRecord?.height} cm"),

                      if (user.medicalRecord?.weight != null)
                        _buildInfoRow(Icons.monitor_weight, "${user.medicalRecord?.weight} kg"),

                      if (user.medicalRecord?.bloodType != null)
                        _buildInfoRow(Icons.bloodtype, "Krvna grupa: ${user.medicalRecord?.bloodType}"),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Action Buttons
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(
                    icon: Icons.edit,
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PatientEditScreen(id: user.id)),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.delete,
                    color: Colors.red,
                    onPressed: () {
                      _showDeleteDialog(context, user);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return const Center(
      child: Icon(Icons.person, size: 60, color: Colors.teal),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 18, color: color),
      onPressed: onPressed,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[800],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    final totalPages = (totalRecordCounts / pageSize).ceil();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: page > 1
                ? () {
              setState(() {
                page--;
                loadData(searchFilter, page, pageSize);
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
                    page = index + 1;
                    loadData(searchFilter, page, pageSize);
                  });
                },
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: page == index + 1 ? Colors.teal : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      color: page == index + 1 ? Colors.white : Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: page < totalPages
                ? () {
              setState(() {
                page++;
                loadData(searchFilter, page, pageSize);
              });
            }
                : null,
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AppUser user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              Icon(Icons.warning_amber_rounded, size: 48, color: Colors.orange),
              const SizedBox(height: 16),
              const Text("Potvrda brisanja"),
            ],
          ),
          content: Text(
            "Da li ste sigurni da želite obrisati pacijenta ${user.firstName} ${user.lastName}?",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Odustani"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await _deletePatient(user.id);
              },
              child: const Text("Obriši", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePatient(int id) async {
    try {
      await _userProvider?.deleteById(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Pacijent uspješno obrisan"),
          backgroundColor: Colors.green[700],
        ),
      );
      loadData(searchFilter, 1, pageSize);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Greška pri brisanju pacijenta"),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }
}
