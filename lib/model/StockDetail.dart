

class StockDetail
{
  int? id;
  final String stockCode;
  final String description;
  String? invoiceNo;
  final int quantity;
  final int amount;
  final int price;

  StockDetail({required this.stockCode, required this.description, required this.quantity,
    required this.amount, required this.price,this.id, this.invoiceNo});

}