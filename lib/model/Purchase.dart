
import 'dart:ffi';

class PurchaseModel
{
  int? id;
   String purchaseDate;
   String invoiceNumber;
   int quantity;
   int amount;

  PurchaseModel({
    required this.amount,
    required this.invoiceNumber,
    required this.quantity,
    required this.purchaseDate,
    this.id
});

}