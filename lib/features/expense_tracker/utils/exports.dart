import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:dailycore/utils/custom_toast.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:toastification/toastification.dart';

import 'expense_util.dart';

Future exportToCSV(
  context,
  List<dynamic> data,
  List<String> headers,
  String title,
  bool isMonthly, {
  double? totalExpenses,
  double? totalIncome,
  double? totalBalance,
}) async {
  final rows = data.map((item) => item.toList()).toList();
  List<List<String>> csvData = [
    [title], // ← title row
    [], // ← empty spacer row
    headers, // headers
    ...rows, // your actual data rows
  ];
  List<List<String>> csvDataMonthly = [
    [title], // ← title row
    [
      'Total Expense: ${formatAmountRP(totalExpenses!)}',
      'Total Income: ${formatAmountRP(totalIncome!)}',
      'Total Balance: ${formatAmountRP(totalBalance!)}',
    ],
    [], // ← empty spacer row
    headers, // headers
    ...rows, // your actual data rows
  ];
  final csvString = const ListToCsvConverter().convert(
    isMonthly ? csvDataMonthly : csvData,
  );
  final directory = Directory('/storage/emulated/0/Download');
  final file = File(
    '${directory.path}/export_${title}_${DateTime.now().millisecondsSinceEpoch}.csv',
  );

  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  final sdkInt = androidInfo.version.sdkInt;

  bool hasPermission = false;

  if (sdkInt >= 30) {
    // Android 11+
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      hasPermission = true;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  } else {
    // Android 10 and below
    final status = await Permission.storage.request();
    if (status.isGranted) {
      hasPermission = true;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  if (hasPermission) {
    try {
      await file.writeAsString(csvString);
      toastification.show(
        context: context,
        title: Text('CSV exported!'),
        description: Text('Location: ${file.path}'),
        style: ToastificationStyle.fillColored,
        type: ToastificationType.success,
        autoCloseDuration: Duration(seconds: 6),
      );
      print('CSV exported to: ${file.path}');
      Navigator.pop(context);
    } catch (e) {
      print('Failed to write file: $e');
      errorToast(context, 'Failed to write file');
    }
  } else {
    print('Permission not granted.');
    errorToast(context, 'Permission not granted');
  }
}

Future<Uint8List> buildPdf(
  List<List<dynamic>> data,
  double totalExpenses,
  double totalIncome,
  double totalBalance,
  List<String> headers,
  String title,
) async {
  final pdf = pw.Document();

  final rows = data.map((e) => e.toList()).toList();

  pdf.addPage(
    pw.Page(
      build:
          (context) => pw.Column(
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  _buildColumn('Total Expense', totalExpenses),
                  _buildColumn('Total Income', totalIncome),
                  _buildColumn('Total Balance', totalBalance),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.TableHelper.fromTextArray(headers: headers, data: rows),
            ],
          ),
    ),
  );

  return pdf.save();
}

pw.Column _buildColumn(String label, double amount) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text('Total Expenses'),
      pw.SizedBox(height: 4),
      pw.Text(
        formatAmountRP(amount),
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
    ],
  );
}

void previewPdf(
  BuildContext context,
  List<List<dynamic>> data,
  double totalExpenses,
  double totalIncome,
  double totalBalance,
  List<String> headers,
  String title,
) {
  Printing.layoutPdf(
    usePrinterSettings: false,
    onLayout:
        (format) => buildPdf(
          data,
          totalExpenses,
          totalIncome,
          totalBalance,
          headers,
          title,
        ),
    name: 'Monthly Report',
  );
}

Future showExportOptions(
  BuildContext context,
  List<List<dynamic>> data,
  double totalExpenses,
  double totalIncome,
  double totalBalance,
  List<String> headers,
  String title,
  bool isMonthly,
) {
  return showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    context: context,
    builder:
        (context) => Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                onPressed:
                    () => previewPdf(
                      context,
                      data,
                      totalExpenses,
                      totalIncome,
                      totalBalance,
                      headers,
                      title,
                    ),
                label: Text('Export as PDF'),
                icon: Image.asset('assets/images/pdf.png', width: 25),
              ),
              Divider(),
              TextButton.icon(
                onPressed:
                    () => exportToCSV(
                      context,
                      data,
                      headers,
                      title,
                      isMonthly,
                      totalExpenses: totalExpenses,
                      totalIncome: totalIncome,
                      totalBalance: totalBalance,
                    ),
                label: Text('Export as CSV'),
                icon: Image.asset('assets/images/csv.png', width: 25),
              ),
            ],
          ),
        ),
  );
}
