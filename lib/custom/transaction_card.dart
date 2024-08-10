import 'package:diamanteblockchain/models/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatefulWidget {
  TransactionCard({required this.tm});
  TransModel tm;

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    return  Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              child: Column(
                children: [
                  Text(
                    'Operation',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${widget.tm.operationType}'),
                ],
              ),
            ),
            Spacer(),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${widget.tm.funder_account}'),
                ],
              ),
            ),
            Spacer(),
            Container(
              child: Column(
                children: [
                  Text('To',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${widget.tm.account}'),
                ],
              ),
            ),
            Spacer(),
            Container(
              child: Column(
                children: [
                  Text('DATE',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${widget.tm.create_date}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
