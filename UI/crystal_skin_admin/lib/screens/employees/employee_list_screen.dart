import 'package:flutter/material.dart';
import 'package:crystal_skin_admin/models/appUser.dart';
import 'package:crystal_skin_admin/providers/users_provider.dart';
import 'package:crystal_skin_admin/widgets/master_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shimmer/shimmer.dart';
import 'employee_add_screen.dart';
import 'employee_edit_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  static const String routeName = "employees";
  const EmployeeListScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  UserProvider? _userProvider;
  final TextEditingController _searchController = TextEditingController();
  List<AppUser> data = [];
  int page = 1;
  int pageSize = 10;
  int totalRecordCounts = 0;
  String searchFilter = '';
  bool isLoading = true;
  final String apiUrl = dotenv.env['API_URL']!;
  final bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _userProvider = UserProvider();
    loadData(searchFilter, page, pageSize);
  }

  Future loadData(searchFilter, page, pageSize) async {
    setState(() {
      isLoading = true;
    });

    if (searchFilter != '') {
      page = 1;
    }

    var response = await _userProvider?.getForPagination({
      'SearchFilter': searchFilter.toString(),
      'IsEmployee': 'true',
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString()
    });

    setState(() {
      data = response?.items as List<AppUser>;
      totalRecordCounts = response?.totalCount as int;
      isLoading = false;
    });
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
              MaterialPageRoute(builder: (_) => const EmployeeAddScreen()),
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
            "Uposlenici",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          if (_isSearching)
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 24),
                  child: _buildSearchField()),
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
        contentPadding:
        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
              "Nema pronađenih uposlenika",
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
        return _buildEmployeeCard(user);
      },
    );
  }

  Widget _buildEmployeeCard(AppUser user) {
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

              // Employee Info Section
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

                      // Position Badge
                      if (user.position != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user.position!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.teal[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                      // Basic Info
                      _buildInfoRow(Icons.email_outlined, user.email ?? "-"),
                      _buildInfoRow(Icons.phone_outlined, user.phoneNumber ?? "-"),

                      // Divider
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(height: 1, color: Colors.grey),
                      ),

                      // Professional Info Section
                      const Text(
                        "Profesionalni podaci",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 6),

                      if (user.yearsOfExperience != null)
                        _buildInfoRow(Icons.work_outline, "${user.yearsOfExperience} god. iskustva"),

                      if (user.licenseNumber != null)
                        _buildInfoRow(Icons.badge_outlined, "Licenca: ${user.licenseNumber}"),

                      if (user.position != null)
                        _buildInfoRow(Icons.medical_services_outlined, "Pozicija: ${user.position}"),
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
                        MaterialPageRoute(builder: (_) => EmployeeEditScreen(id: user.id)),
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
            "Da li ste sigurni da želite obrisati uposlenika ${user.firstName} ${user.lastName}?",
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
                await _deleteEmployee(user.id);
              },
              child:
              const Text("Obriši", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEmployee(int id) async {
    try {
      await _userProvider?.deleteById(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Uposlenik uspješno obrisan'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      loadData(searchFilter, 1, pageSize);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Greška pri brisanju uposlenika'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}