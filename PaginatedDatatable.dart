import 'package:flutter/material.dart';

class MyPaginatedDataTable extends StatefulWidget {
  @override
  _MyPaginatedDataTableState createState() => _MyPaginatedDataTableState();
}

class _MyPaginatedDataTableState extends State<MyPaginatedDataTable> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;

  final List<Map<String, dynamic>> _dataList = [
    {'name': 'Alice', 'age': 25},
    {'name': 'Bob', 'age': 30},
    {'name': 'Charlie', 'age': 35},
    {'name': 'Dave', 'age': 40},
    {'name': 'Emma', 'age': 45},
    {'name': 'Frank', 'age': 50},
    {'name': 'George', 'age': 55},
    {'name': 'Hannah', 'age': 60},
    {'name': 'Isaac', 'age': 65},
    {'name': 'Jack', 'age': 70},
  ];

  List<Map<String, dynamic>> _sortedList;

  @override
  void initState() {
    super.initState();
    _sortedList = List<Map<String, dynamic>>.from(_dataList);
  }

  void _sort<T>(Comparable<T> Function(Map<String, dynamic> d) getField, int columnIndex, bool ascending) {
    _sortedList.sort((a, b) {
      if (!ascending) {
        final temp = a;
        a = b;
        b = temp;
      }
      final aValue = getField(a);
      final bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PaginatedDataTable Example'),
      ),
      body: SingleChildScrollView(
        child: PaginatedDataTable(
          header: Text('Header Text'),
          rowsPerPage: _rowsPerPage,
          availableRowsPerPage: [5, 10, 20],
          onRowsPerPageChanged: (int value) {
            setState(() {
              _rowsPerPage = value;
            });
          },
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          columns: [
            DataColumn(
              label: Text('Name'),
              onSort: (columnIndex, ascending) {
                _sort<String>((d) => d['name'], columnIndex, ascending);
              },
            ),
            DataColumn(
              label: Text('Age'),
              numeric: true,
              onSort: (columnIndex, ascending) {
                _sort<num>((d) => d['age'], columnIndex, ascending);
              },
            ),
          ],
          source: _MyDataSource(_sortedList),
        ),
      ),
    );
  }
}

class _MyDataSource extends DataTableSource {
  final List<Map<String, dynamic>> _dataList;
  _MyDataSource(this._dataList);

  @override
  DataRow getRow(int index) {
    final data = _dataList[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(data['name'])),
        DataCell(Text(data['age'].toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _dataList.length;

  @override
  int get selectedRowCount => 0;
}
