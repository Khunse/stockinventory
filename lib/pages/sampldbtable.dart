import 'package:flutter/material.dart';

class PurchaseTableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase'),
        backgroundColor: Colors.purple,
      ),
      body: Column(

        children: [
          // Table header and rows
          Expanded(
            child: SingleChildScrollView(
              // scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                // scrollDirection: Axis.vertical,
                child: DataTable(

                  headingRowColor:
                  MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
                  decoration: BoxDecoration(

                    border: Border.all(color: Colors.red)
                  ),
                  columns: const [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Invoice No')),
                    DataColumn(label: Text('QTY')),
                    DataColumn(label: Text('Amount')),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('30/01/2019')),
                      DataCell(Text('Inv-0001')),
                      DataCell(Text('15')),
                      DataCell(Text('12,500')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('30/01/2019')),
                      DataCell(Text('Inv-0002')),
                      DataCell(Text('10')),
                      DataCell(Text('5,000')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('30/01/2019')),
                      DataCell(Text('Inv-0003')),
                      DataCell(Text('10')),
                      DataCell(Text('10,000')),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          // Footer with summary
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(''),
                Text('35', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('27,500', style: TextStyle(fontWeight: FontWeight.bold,backgroundColor: Colors.pink)),
              ],
            ),
          ),
          // Buttons
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('New'),
                  style: ElevatedButton.styleFrom(iconColor: Colors.black),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(iconColor: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: PurchaseTableScreen(),
//   ));
// }
