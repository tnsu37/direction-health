import 'package:flutter/material.dart';

class RtCell {
  final String text;
  final bool bold;
  final Color? textColor;

  const RtCell(this.text, {this.bold = false, this.textColor});
}

class RtHeaderGroup {
  final String label;
  final int span;

  const RtHeaderGroup(this.label, this.span);
}

// groupHeaders: optional merged header row (for period+subHeader layout)
// headers: always-present column header row
// rows: data rows
class ResultTableModel {
  final List<RtHeaderGroup>? groupHeaders;
  final List<RtCell> headers;
  final List<List<RtCell>> rows;

  const ResultTableModel({
    this.groupHeaders,
    required this.headers,
    required this.rows,
  });

  bool get isEmpty => rows.isEmpty;
}

class ResultTableSet {
  final List<ResultTableModel> tables;

  const ResultTableSet(this.tables);

  factory ResultTableSet.single(ResultTableModel model) =>
      ResultTableSet([model]);

  bool get isEmpty => tables.every((t) => t.isEmpty);
}
