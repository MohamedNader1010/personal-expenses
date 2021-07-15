import 'dart:math';

import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;
  @override
  void initState() {
    const availableColors = [
      Colors.red,
      Colors.yellow,
      Colors.green,
      Colors.purple,
      Colors.grey,
    ];
    _bgColor = availableColors[Random().nextInt(5)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: ListTile(
          leading: CircleAvatar(
              backgroundColor: _bgColor,
              radius: 30,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: FittedBox(
                  child: Text('\$${widget.transaction.amount}'),
                ),
              )),
          title: Text(
            widget.transaction.title,
            style: Theme.of(context).textTheme.title,
          ),
          subtitle: Text(
            '${DateFormat.yMMMd().format(widget.transaction.date)}',
          ),
          trailing: MediaQuery.of(context).size.width > 350
              ? FlatButton.icon(
                  label: Text('delete'),
                  onPressed: () => widget.deleteTx(
                        widget.transaction.id,
                      ),
                  icon: Icon(Icons.delete),
                  textColor: Theme.of(context).errorColor)
              : IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () {
                    widget.deleteTx(widget.transaction.id);
                  },
                )),
    );
  }
}
