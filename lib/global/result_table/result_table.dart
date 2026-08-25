import 'package:boilerplate/common/common.dart';
import 'package:flutter/material.dart';
import 'rt_model.dart';

class ResultTable extends StatelessWidget {
  const ResultTable({
    super.key,
    required this.tableSet,
    this.headerH,
  });

  final ResultTableSet tableSet;
  final double? headerH;

  static const Color _headerBg = Color(0xFF1F3B68);
  static const Color _borderColor = Color(0xFFCCCCCC);

  bool get _isBig => Common.bigSize.value;

  double get _labelColW => _isBig ? 118 : 90;

  double get _rowH => _isBig ? 35 : 32;

  double get _fontSize => _isBig ? 13 : 11;

  double get _horizontalPadding => _isBig ? 8 : 4;
  double get _verticalPadding => _isBig ? 3.2 : 2;

  bool _isMonthlyWideTable(ResultTableModel model) {
    final monthHeaderCount = model.headers.where((cell) {
      return RegExp(r'^\d{1,2}월$').hasMatch(cell.text);
    }).length;

    // 여러 개의 월이 열 방향으로 배치된 경우
    return monthHeaderCount >= 3;
  }

  double _dataColWidth(ResultTableModel model) {
    if (_isMonthlyWideTable(model)) {
      return _isBig ? 70 : 50;
    }
    return _isBig ? 116 : 73;
  }

  @override
  Widget build(BuildContext context) {
    final visibleTables = tableSet.tables.where((t) => !t.isEmpty).toList();

    if (visibleTables.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: visibleTables.indexed.map((entry) {
        final (i, model) = entry;
        final dataColW = _dataColWidth(model);
        return Padding(
          padding: EdgeInsets.only(
            top: i == 0 ? 0 : (_isBig ? 16 : 10),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: _borderColor, width: 0.5),
                  top: BorderSide(color: _borderColor, width: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (model.groupHeaders != null)
                    _buildGroupRow(model.groupHeaders!, dataColW),
                  _buildRow(model.headers, dataColW: dataColW, isHeader: true),
                  ...model.rows.map(
                    (row) =>
                        _buildRow(row, dataColW: dataColW, isHeader: false),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGroupRow(List<RtHeaderGroup> groups, double dataColW) {
    return Row(
      children: groups.asMap().entries.map((entry) {
        final i = entry.key;
        final g = entry.value;

        final width = i == 0 ? _labelColW * g.span : dataColW * g.span;

        return _cell(
          g.label,
          width: width,
          height: _rowH,
          isHeader: true,
          bold: true,
        );
      }).toList(),
    );
  }

  Widget _buildRow(
    List<RtCell> cells, {
    required double dataColW,
    required bool isHeader,
  }) {
    return Row(
      children: cells.asMap().entries.map((entry) {
        final i = entry.key;
        final cell = entry.value;

        final w = i == 0 ? _labelColW : dataColW;

        return _cell(
          cell.text,
          width: w,
          height: isHeader ? headerH ?? _rowH : _rowH,
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
    required double height,
    bool bold = false,
    Color? textColor,
  }) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      decoration: BoxDecoration(
        color: isHeader ? _headerBg : null,
        border: const Border(
          right: BorderSide(
            color: _borderColor,
            width: 0.5,
          ),
          bottom: BorderSide(
            color: _borderColor,
            width: 0.5,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: _fontSize,
          height: 1.15,
          color: isHeader ? Colors.white : (textColor ?? Colors.black87),
          fontWeight: bold ? FontWeight.bold : FontWeight.w400,
        ),
      ),
    );
  }
}
