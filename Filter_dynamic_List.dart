void main() {
  List<Map<String, dynamic>> products = [
    {'name': 'apple', 'price': 1.99, 'in_stock': true},
    {'name': 'banana', 'price': 0.99, 'in_stock': false},
    {'name': 'pear', 'price': 2.49, 'in_stock': true},
    {'name': 'orange', 'price': 1.49, 'in_stock': true}
  ];

  List<Map<String, dynamic>> filteredProducts =
      products.where((product) => product['in_stock']).toList();

  print(filteredProducts);
}

// output::
// [
//   {name: apple, price: 1.99, in_stock: true},
//   {name: pear, price: 2.49, in_stock: true},
//   {name: orange, price: 1.49, in_stock: true}
// ]
