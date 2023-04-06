import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Data Table Example'),
        ),
        body: DataTableDemo(),
      ),
    );
  }
}

class DataTableDemo extends StatefulWidget {
  @override
  _DataTableDemoState createState() => _DataTableDemoState();
}

class _DataTableDemoState extends State<DataTableDemo> {
  // A list of sample data to display in the table
  List<Map<String, dynamic>> data = [
    {'id': 1, 'name': 'Alice', 'age': 20},
    {'id': 2, 'name': 'Bob', 'age': 25},
    {'id': 3, 'name': 'Charlie', 'age': 30},
    {'id': 4, 'name': 'David', 'age': 35},
    {'id': 5, 'name': 'Eve', 'age': 40},
  ];

  // A function to create a list of DataColumns from the keys of the data map
  List<DataColumn> _createColumns() {
    return data[0].keys.map((key) => DataColumn(label: Text(key))).toList();
  }
  
  // A function to create a list of DataRows from the values of the data map
  List<DataRow> _createRows() {
    return data.map((row) {
      return DataRow(
        cells: row.values.map((value) => DataCell(Text(value.toString()), showEditIcon: true)).toList(),
      );
    }).toList();
  }

  // A function to create a MaterialStateProperty<Color> for the cell color
  MaterialStateProperty<Color> _getCellColor(Set<MaterialState> states) {
    // Define the interactive states that affect the cell color
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
      MaterialState.selected,
    };
 // Return a different color depending on the state
    if (states.any(interactiveStates.contains)) {
      // The cell is interactive
      if (states.contains(MaterialState.selected)) {
        // The cell is selected
        return Colors.blue.shade100;
      } else {
        // The cell is hovered, pressed, or focused
        return Colors.blue.shade50;
      }
    } else {
      // The cell is not interactive
      return Colors.white;
    }
  }
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: _createColumns(),
      rows: _createRows(),
      // Use the resolveWith method to set the cell color property
      dataRowColor: MaterialStateProperty.resolveWith(_getCellColor),
    );
  }
}
