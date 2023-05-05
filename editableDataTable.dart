class MyDataTable extends StatefulWidget {
  @override
  _MyDataTableState createState() => _MyDataTableState();
}

class _MyDataTableState extends State<MyDataTable> {
  bool _isEditing = false;

  // define your data source here
  List<Map<String, dynamic>> _data = [
    {'name': 'John', 'age': 30},
    {'name': 'Jane', 'age': 25},
  ];

  // define the columns for the data table
  final List<DataColumn> _columns = [
    DataColumn(label: Text('Name')),
    DataColumn(label: Text('Age')),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
          child: Text('Edit'),
        ),
        _isEditing
            ? DataTable(
                columns: _columns,
                rows: _data
                    .map(
                      (item) => DataRow(
                        cells: [
                          DataCell(TextFormField(
                            initialValue: item['name'],
                            onChanged: (value) {
                              setState(() {
                                item['name'] = value;
                              });
                            },
                          )),
                          DataCell(TextFormField(
                            initialValue: item['age'].toString(),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                item['age'] = int.tryParse(value) ?? 0;
                              });
                            },
                          )),
                        ],
                      ),
                    )
                    .toList(),
              )
            : DataTable(
                columns: _columns,
                rows: _data
                    .map(
                      (item) => DataRow(
                        cells: [
                          DataCell(Text(item['name'])),
                          DataCell(Text(item['age'].toString())),
                        ],
                      ),
                    )
                    .toList(),
              ),
      ],
    );
  }
}
