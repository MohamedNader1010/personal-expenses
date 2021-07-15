import 'package:flutter/material.dart';
import '../widgets/transaction_item.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;

  Function deleteTx;
  TransactionList({this.userTransactions, this.deleteTx});

  @override
  Widget build(BuildContext context) {
    return userTransactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Container(
                child: Column(
                  children: [
                    Text(
                      'No transactions added yet!',
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.1),
                    Container(
                      height: constraints.maxHeight * 0.7,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              );
            },
          )
        : ListView(
            children: userTransactions.map((tx) {
              return TransactionItem(
                key: ValueKey(tx.id),
                transaction: tx,
                deleteTx: deleteTx,
              );
            }).toList(),
          );

    // SingleChildScrollView doesnt work here , because the height of Column is not detected!!
    // we can wrap our column with Container( height: 300 for example), but we will face a problem that our keyboard
    // will overlay the container() that leads to the yellow/black bar. So for now we can wrap the body of Scaffold
    // with SingleChildScrollView(); ;)
    //     children: userTransactions.map((tx) {
    //       return Card(
    //         elevation: 5,
    //         child: Row(
    //           children: [
    //             Container(
    //               margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    //               padding: EdgeInsets.all(10),
    //               decoration: BoxDecoration(
    //                 border: Border.all(
    //                   color: Colors.purple,
    //                   width: 2,
    //                   style: BorderStyle.solid,
    //                 ),
    //               ),
    //               child: Text(
    //                 '\$${tx.amount}',
    //                 style: TextStyle(
    //                   color: Colors.purple,
    //                   fontWeight: FontWeight.bold,
    //                   fontSize: 15,
    //                 ),
    //               ),
    //             ),
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   tx.title,
    //                   style: TextStyle(
    //                     fontSize: 12,
    //                     color: Colors.black,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //                 Text(
    //                   DateFormat.yMMMd().format(tx.date),
    //                   style: TextStyle(
    //                     color: Colors.grey,
    //                     fontSize: 9,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       );
    //     }).toList(),
    //   ),
    // );
  }
}
