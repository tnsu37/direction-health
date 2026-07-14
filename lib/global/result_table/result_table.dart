import 'package:boilerplate/common/common.dart';
import 'package:flutter/material.dart';
import 'rt_model.dart';

class ResultTable extends StatelessWidget {
  const ResultTable({super.key, required this.tableSet});

  final ResultTableSet tableSet;

  static const Color _headerBg = Color(0xFF1F3B68);
  static const Color _borderColor = Color(0xFFCCCCCC);
  static final double _labelColW = Common.bigSize.value ? 100.0 : 80;
  static final double _dataColW = Common.bigSize.value ? 85.0 : 65;
  static const double _rowH = 35;

  @override
  Widget build(BuildContext context) {
    final visibleTables = tableSet.tables.where((t) => !t.isEmpty).toList();
    if (visibleTables.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: visibleTables.indexed.map((entry) {
        final (i, model) = entry;
        return Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: _borderColor, width: 0.5),
                  top: BorderSide(color: _borderColor, width: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (model.groupHeaders != null)
                    _buildGroupRow(model.groupHeaders!),
                  _buildRow(model.headers, isHeader: true),
                  ...model.rows.map((row) => _buildRow(row, isHeader: false)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGroupRow(List<RtHeaderGroup> groups) {
    return Row(
      children: groups.asMap().entries.map((entry) {
        final i = entry.key;
        final g = entry.value;
        final w = i == 0 ? _labelColW * g.span : _dataColW * g.span;
        return _cell(
          g.label,
          width: w,
          isHeader: true,
          bold: true,
        );
      }).toList(),
    );
  }

  Widget _buildRow(List<RtCell> cells, {required bool isHeader}) {
    return Row(
      children: cells.asMap().entries.map((entry) {
        final i = entry.key;
        final cell = entry.value;
        final w = i == 0 ? _labelColW : _dataColW;
        return _cell(
          cell.text,
          width: w,
          isHeader: isHeader,
          bold: isHeader || cell.bold,
          textColor: cell.textColor,
        );
      }).toList(),
    );
  }

  Widget _cell(
    String text, {
    required double width,
    required bool isHeader,
    bool bold = false,
    Color? textColor,
  }) {
    return Container(
      width: width,
      height: _rowH,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isHeader ? _headerBg : null,
        border: Border(
          right: BorderSide(color: _borderColor, width: 0.5),
          bottom: BorderSide(color: _borderColor, width: 0.5),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: isHeader ? Colors.white : (textColor ?? Colors.black87),
          fontWeight: bold ? FontWeight.bold : FontWeight.w400,
        ),
      ),
    );
  }
}

// Convenience extension so callers can use (entry.key, entry.value) syntax
extension<T> on Iterable<T> {
  Iterable<(int, T)> get indexed sync* {
    var i = 0;
    for (final v in this) {
      yield (i++, v);
    }
  }
}
