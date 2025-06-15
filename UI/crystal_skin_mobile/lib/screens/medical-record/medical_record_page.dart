import 'package:crystal_skin_mobile/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crystal_skin_mobile/providers/medical_record_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MedicalRecordPage extends StatefulWidget {
  const MedicalRecordPage({Key? key}) : super(key: key);

  @override
  State<MedicalRecordPage> createState() => _MedicalRecordPageState();
}

class _MedicalRecordPageState extends State<MedicalRecordPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicalRecordProvider>().getUserMedicalRecord();
    });
  }

  Future<void> _generateAndPrintPdf() async {
    final provider = context.read<MedicalRecordProvider>();
    if (provider.medicalRecord == null) return;

    final record = provider.medicalRecord!;
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Zdravstveni karton',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              _buildPdfSectionTitle('Licni podaci'),
              _buildPdfInfoRow('Krvna grupa', record.bloodType),
              _buildPdfInfoRow('Visina', '${record.height} cm'),
              _buildPdfInfoRow('Tezina', '${record.weight} kg'),

              pw.SizedBox(height: 16),

              _buildPdfSectionTitle('Medicinski podaci'),
              _buildPdfInfoRow('Dijagnoze', record.diagnoses, isMultiline: true),
              _buildPdfInfoRow('Alergije', record.allergies, isMultiline: true),
              _buildPdfInfoRow('Trenutni tretmani', record.treatments, isMultiline: true),

              pw.SizedBox(height: 16),

              _buildPdfSectionTitle('Dodatne biljeske'),
              _buildPdfInfoRow('Biljeske', record.notes, isMultiline: true),

              if (record.lastUpdateByEmployee != null) ...[
                pw.SizedBox(height: 16),
                _buildPdfSectionTitle('Posljednje azuriranje'),
                _buildPdfInfoRow(
                  'Azurirao/la',
                  '${record.lastUpdateByEmployee?.firstName} ${record.lastUpdateByEmployee?.lastName}',
                ),
              ],
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildPdfSectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 18,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue800,
        ),
      ),
    );
  }

  pw.Widget _buildPdfInfoRow(String label, String value, {bool isMultiline = false}) {
    final emptyValue = 'Nema dostupnih informacija';

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey600,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value.isEmpty ? emptyValue : value,
            style: isMultiline
                ? const pw.TextStyle(fontSize: 14)
                : pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicalRecordProvider>();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zdravstveni karton'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _generateAndPrintPdf(),
          ),
        ],
      ),
      body: _buildBody(provider, theme, isDarkMode),
    );
  }

  Widget _buildBody(MedicalRecordProvider provider, ThemeData theme, bool isDarkMode) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                provider.error!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: () => provider.getUserMedicalRecord(),
              child: const Text('Pokušaj ponovo'),
            ),
          ],
        ),
      );
    }

    if (provider.medicalRecord == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_services_outlined, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Nema dostupnih zdravstvenih podataka',
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Lični podaci', Icons.person_outline, theme),
          _buildInfoCard(
            theme: theme,
            isDarkMode: isDarkMode,
            children: [
              _buildInfoRow(
                context: context,
                icon: Icons.bloodtype_outlined,
                label: 'Krvna grupa',
                value: provider.medicalRecord!.bloodType,
              ),
              const Divider(height: 20, indent: 40),
              _buildInfoRow(
                context: context,
                icon: Icons.height_outlined,
                label: 'Visina',
                value: '${provider.medicalRecord!.height} cm',
              ),
              const Divider(height: 20, indent: 40),
              _buildInfoRow(
                context: context,
                icon: Icons.monitor_weight_outlined,
                label: 'Težina',
                value: '${provider.medicalRecord!.weight} kg',
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('Medicinski podaci', Icons.medical_information_outlined, theme),
          _buildInfoCard(
            theme: theme,
            isDarkMode: isDarkMode,
            children: [
              _buildInfoRow(
                context: context,
                icon: Icons.monitor_heart,
                label: 'Dijagnoze',
                value: provider.medicalRecord!.diagnoses,
                isMultiline: true,
              ),
              const Divider(height: 20, indent: 40),
              _buildInfoRow(
                context: context,
                icon: Icons.warning_amber_outlined,
                label: 'Alergije',
                value: provider.medicalRecord!.allergies,
                isMultiline: true,
              ),
              const Divider(height: 20, indent: 40),
              _buildInfoRow(
                context: context,
                icon: Icons.medication_outlined,
                label: 'Trenutni tretmani',
                value: provider.medicalRecord!.treatments,
                isMultiline: true,
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('Dodatne bilješke', Icons.notes_outlined, theme),
          _buildInfoCard(
            theme: theme,
            isDarkMode: isDarkMode,
            children: [
              _buildInfoRow(
                context: context,
                icon: Icons.note_alt_outlined,
                label: 'Bilješke',
                value: provider.medicalRecord!.notes,
                isMultiline: true,
              ),
            ],
          ),

          if (provider.medicalRecord!.lastUpdateByEmployee != null) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('Posljednje ažuriranje', Icons.update_outlined, theme),
            _buildInfoCard(
              theme: theme,
              isDarkMode: isDarkMode,
              children: [
                _buildInfoRow(
                  context: context,
                  icon: Icons.person_outline,
                  label: 'Ažurirao/la',
                  value: '${provider.medicalRecord!.lastUpdateByEmployee?.firstName} '
                      '${provider.medicalRecord!.lastUpdateByEmployee?.lastName}',
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: app_color),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: app_color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required ThemeData theme,
    required bool isDarkMode,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      color: isDarkMode
          ? theme.colorScheme.surfaceVariant.withOpacity(0.5)
          : theme.colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    bool isMultiline = false,
  }) {
    final theme = Theme.of(context);
    final emptyValue = 'Nema dostupnih informacija';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: app_color.withOpacity(0.7)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              isMultiline
                  ? Text(
                value.isEmpty ? emptyValue : value,
                style: theme.textTheme.bodyMedium,
              )
                  : Text(
                value.isEmpty ? emptyValue : value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}