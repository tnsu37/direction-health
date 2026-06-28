import 'package:flutter/material.dart';

class HealthEffectsTable extends StatelessWidget {
  const HealthEffectsTable({super.key, required this.tableData});

  final List tableData;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Year')),
        DataColumn(label: Text('Expression Coeff'))
      ],
      rows: tableData.map((data) {
        return DataRow(cells: [
          DataCell(Text(data['year'].toString())),
          DataCell(Text(data['exp_coef'].toString())),
        ]);
      }).toList(),
    );
  }
}
