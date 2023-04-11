import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyDataTableSource extends DataTableSource {
  List<DataRow> _rows;

  MyDataTableSource(List<MyDataRow> dataRows) {
    _rows = dataRows.map((row) => row.build()).toList();
  }

  @override
  DataRow getRow(int index) {
    return _rows[index];
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rows.length;

  @override
  int get selectedRowCount => 0;
}

class MyDataRow {
  final String name;
  final String email;
  bool selected;

  MyDataRow({this.name, this.email, this.selected = false});

  DataRow build() {
    return DataRow(
      selected: selected,
      onSelectChanged: (value) {
        selected = value;
      },
      cells: [
        DataCell(Text(name)),
        DataCell(Text(email)),
      ],
    );
  }
}

class PaginatedDataTableWithCheckboxes extends StatefulWidget {
  final List<MyDataRow> dataRows;
  final String header;

  PaginatedDataTableWithCheckboxes({this.dataRows, this.header});

  @override
  _PaginatedDataTableWithCheckboxesState createState() =>
      _PaginatedDataTableWithCheckboxesState();
}

class _PaginatedDataTableWithCheckboxesState
    extends State<PaginatedDataTableWithCheckboxes> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;
  MyDataTableSource _dataTableSource;

  @override
  void initState() {
    super.initState();
    _dataTableSource = MyDataTableSource(widget.dataRows);
  }

  void _sort<T>(
      Comparable<T> getField(MyDataRow d), int columnIndex, bool ascending) {
    _dataTableSource._rows.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PaginatedDataTable(
        header: Text(widget.header),
        rowsPerPage: _rowsPerPage,
        onRowsPerPageChanged: (int value) {
          setState(() {
            _rowsPerPage = value;
          });
        },
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        onSelectAll: (value) {
          widget.dataRows.forEach((row) {
            row.selected = value;
          });
          setState(() {
            _dataTableSource = MyDataTableSource(widget.dataRows);
          });
        },
        columns: [
          DataColumn(
              label: Text('Name'),
              onSort: (columnIndex, ascending) {
                _sort<String>((d) => d.name, columnIndex, ascending);
              }),
          DataColumn(
              label: Text('Email'),
              onSort: (columnIndex, ascending) {
                _sort<String>((d) => d.email, columnIndex, ascending);
              }),
        ],
        source: _dataTableSource,
        checkboxHorizontalMargin: 8,
        showCheckboxColumn: true,
        initialFirstRowIndex: 0,
        availableRowsPerPage: [5, 10, 20, 50],
        onPageChanged: (pageIndex) {
          print('Page changed: $pageIndex');
        },
      ),
    );
  }
}

//Alternative to add more columns
//to add more columns to the table, you need to modify the columns list and the getRows function. For example, if you want to add a column for the user's age, you can do something like this:

//```dart
// Add a new field for the user's age
class User {
  final String name;
  final String email;
  final int age;
  bool selected;

  User(this.name, this.email, this.age, {this.selected = false});
}

// Add a new column for the user's age
final List<DataColumn> columns = [
    DataColumn(label: Text('Name')),
    DataColumn(label: Text('Email')),
    DataColumn(label: Text('Age')),
  ];

// Add a new cell for the user's age
List<DataRow> getRows(int startIndex, int endIndex) {
    return users
        .sublist(startIndex, endIndex)
        .map(
          (user) => DataRow(
            onSelectChanged: (value) {
              setState(() {
                user.selected = value!;
              });
            },
            selected: user.selected,
            cells: [
              DataCell(Text(user.name)),
              DataCell(Text(user.email)),
              DataCell(Text(user.age.toString())), // Add this line
            ],
          ),
        )
        .toList();
  }
```

