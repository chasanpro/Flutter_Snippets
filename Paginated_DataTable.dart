//Here is a possible code for a PaginatedDataTable widget in Flutter having multiple columns and checkboxes. I used the official documentation and some online examples as references. You may need to modify it according to your needs.


import 'package:flutter/material.dart';

class PaginatedDataTableExample extends StatefulWidget {
  const PaginatedDataTableExample({Key? key}) : super(key: key);

  @override
  _PaginatedDataTableExampleState createState() =>
      _PaginatedDataTableExampleState();
}

class _PaginatedDataTableExampleState extends State<PaginatedDataTableExample> {
  // Define the data source for the table
  final List<User> users = List.generate(
    100,
    (index) => User('User $index', 'user$index@example.com', index + 18),
  );

  // Define the columns for the table
  final List<DataColumn> columns = [
    DataColumn(label: Text('Name')),
    DataColumn(label: Text('Email')),
    DataColumn(label: Text('Age')),
  ];

  // Define a function to get the rows for the table
  List<DataRow> getRows(int startIndex, int endIndex) {
    return users
        .sublist(startIndex, endIndex)
        .map(
          (user) => DataRow(
            // Add a checkbox for each row
            onSelectChanged: (value) {
              setState(() {
                user.selected = value!;
              });
            },
            selected: user.selected,
            cells: [
              DataCell(Text(user.name)),
              DataCell(Text(user.email)),
              DataCell(Text(user.age.toString())),
            ],
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PaginatedDataTable Example'),
      ),
      body: SingleChildScrollView(
        child: PaginatedDataTable(
          // Set the header for the table
          header: Text('Users'),
          // Set the number of rows per page
          rowsPerPage: 10,
          // Set the columns for the table
          columns: columns,
          // Set the source for the table
          source: UserDataSource(users, getRows),
        ),
      ),
    );
  }
}

// Define a class to represent a user
class User {
  final String name;
  final String email;
  final int age;
  bool selected;

  User(this.name, this.email, this.age, {this.selected = false});
}

// Define a class to implement the data source for the table
class UserDataSource extends DataTableSource {
  final List<User> users;
  final Function getRows;

  UserDataSource(this.users, this.getRows);

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= users.length) return null!;
    return getRows(index, index + 1).first;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount =>
      users.where((user) => user.selected).length;
}

