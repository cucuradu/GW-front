import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

/// Service for exporting sensor data to CSV and PDF formats
class ExportService {
  /// Export sensor data to CSV file
  Future<String> exportToCsv({
    required List<Map<String, dynamic>> data,
    required String sensorName,
  }) async {
    try {
      // Prepare CSV data
      final List<List<dynamic>> csvData = [];

      // Add headers
      if (data.isNotEmpty) {
        csvData.add(data.first.keys.toList());
      }

      // Add rows
      for (var row in data) {
        csvData.add(row.values.toList());
      }

      // Convert to CSV string
      final String csv = const ListToCsvConverter().convert(csvData);

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = '${sensorName}_data_$timestamp.csv';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsString(csv);

      return filePath;
    } catch (e) {
      throw Exception('Failed to export CSV: $e');
    }
  }

  /// Generate PDF report with sensor data and charts
  Future<String> generatePdfReport({
    required String sensorName,
    required Map<String, dynamic> summaryData,
    required List<Map<String, dynamic>> detailedData,
  }) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(32),
          build: (context) => [
            // Header
            pw.Header(
              level: 0,
              child: pw.Text(
                'GrowWise Sensor Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),

            pw.SizedBox(height: 20),

            // Sensor Info
            pw.Container(
              padding: pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Sensor: $sensorName',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Report Generated: ${DateFormat('MMM d, yyyy HH:mm').format(DateTime.now())}',
                    style: pw.TextStyle(color: PdfColors.grey700),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 30),

            // Summary Section
            pw.Text(
              'Summary',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),

            pw.Container(
              padding: pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: summaryData.entries.map((entry) {
                  return pw.Padding(
                    padding: pw.EdgeInsets.only(bottom: 8),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          entry.key,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(entry.value.toString()),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            pw.SizedBox(height: 30),

            // Detailed Data Table
            pw.Text(
              'Detailed Readings',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),

            if (detailedData.isNotEmpty)
              pw.Table.fromTextArray(
                context: context,
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.green700,
                ),
                cellAlignment: pw.Alignment.centerLeft,
                cellPadding: pw.EdgeInsets.all(8),
                data: [
                  // Headers
                  detailedData.first.keys.toList(),
                  // Rows (limit to last 50 entries)
                  ...detailedData.take(50).map((row) => row.values.toList()),
                ],
              ),

            pw.SizedBox(height: 20),

            // Footer
            pw.Footer(
              title: pw.Text(
                'Generated by GrowWise App',
                style: pw.TextStyle(color: PdfColors.grey600, fontSize: 10),
              ),
            ),
          ],
        ),
      );

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = '${sensorName}_report_$timestamp.pdf';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      return filePath;
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }

  /// Share exported file using native share sheet
  Future<void> shareFile({
    required String filePath,
    String? subject,
  }) async {
    try {
      final result = await Share.shareXFiles(
        [XFile(filePath)],
        subject: subject ?? 'GrowWise Sensor Data',
      );

      if (result.status == ShareResultStatus.success) {
        print('File shared successfully');
      }
    } catch (e) {
      throw Exception('Failed to share file: $e');
    }
  }

  /// Delete exported file
  Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Failed to delete file: $e');
    }
  }
}

/// Export options dialog
class ExportOptionsDialog extends StatelessWidget {
  final String sensorName;
  final Function(ExportFormat) onExport;

  const ExportOptionsDialog({
    Key? key,
    required this.sensorName,
    required this.onExport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Export Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Choose export format for $sensorName:'),
          SizedBox(height: 20),
          _buildExportOption(
            context,
            icon: Icons.table_chart,
            title: 'CSV File',
            subtitle: 'Spreadsheet compatible',
            format: ExportFormat.csv,
          ),
          SizedBox(height: 12),
          _buildExportOption(
            context,
            icon: Icons.picture_as_pdf,
            title: 'PDF Report',
            subtitle: 'Detailed report with charts',
            format: ExportFormat.pdf,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildExportOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required ExportFormat format,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onExport(format);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Color(0xFF8EAC50)),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

enum ExportFormat {
  csv,
  pdf,
}
