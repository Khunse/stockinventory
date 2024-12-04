import 'package:galaxysfassigment/model/Purchase.dart';
import 'package:galaxysfassigment/model/StockDetail.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database? _database;

class DatabaseService
{

  Future get database async
  {
    if( _database != null) return _database;

    _database = await _initDB("mylocaldb.db");
    return _database;
  }

  Future _initDB(String filename) async
  {
    final path = await getDatabasesPath();
    final db = join(path,filename);

    print("DB path : $db");
    return await openDatabase(
      db,
      version: 1,
      onCreate: _onCreate,
    );

  }

  Future _onCreate(Database db, int version) async
  {
     await db.execute('''
        CREATE TABLE purchase(
          id INTEGER PRIMARY KEY,
          invoiceNumber TEXT NOT NULL,
          quantity INTEGER NOT NULL,
          amount INTEGER NOT NULL,
          purchaseDate TEXT NOT NULL
      )
     ''');

     await db.execute('''
     CREATE TABLE stockdetail(
          id INTEGER PRIMARY KEY,
          stockCode TEXT NOT NULL,
          description TEXT NOT NULL,
          invoiceNo TEXT NOT NULL,
          quantity INTEGER NOT NULL,
          amount INTEGER NOT NULL,
          price INTEGER NOT NULL
      )
     ''');
  }

  Future addPurchase(PurchaseModel purchase) async{

    final db = await database;
    await db.insert("purchase",{
      "invoiceNumber" : purchase.invoiceNumber,
      "quantity"  : purchase.quantity,
      "amount"  : purchase.amount,
      "purchaseDate"  : purchase.purchaseDate
  });

    print("${purchase.invoiceNumber} data is added!");
    return "Data Added!";
  }

  Future addStock(StockDetail stock) async
  {
    final db = await database;

    await db.insert("stockdetail",{
      "stockCode" : stock.stockCode,
      "description" : stock.description,
      "quantity" : stock.quantity,
      "invoiceNo" : stock.invoiceNo,
      "amount" : stock.amount,
      "price" : stock.price
    });

    return "Data Added!";

  }


  Future<List<StockDetail>> getStockList(String invoiceNo) async
  {

    List<StockDetail> stockList = [];
    try
        {

          final db = await database;

          // final List<Map<String, Object?>> datalist = await db.rawQuery(
          //   "SELECT * FROM stockdetail WHERE stockCode = $invoiceNo"
          // );

          final List<Map<String, Object?>> datalist = await db.query(
              'stockdetail',
              where: 'invoiceNo = ?',
              whereArgs : [invoiceNo]
          );

          stockList.addAll(
            [
            for(final {
            'id' : id as int,
            'stockCode' : stockCode as String,
            'quantity'  : quantity as int,
            'amount'  : amount as int,
            'price' : price as int,
            'description' : description as String
            } in datalist) StockDetail(id: id,stockCode: stockCode, description: description, quantity: quantity, amount: amount, price: price)
          ]
          );

          return stockList;

        }
        catch(e)
    {
      print("Error DB: $e");
    }

    return stockList;

  }

  Future<bool> checkDuplicatPurchase(String invoiceNo ) async
  {
    try
        {
          final db = await database;
          final List<Map<String, Object?>> dataList = await db.query(
            'purchase',
            where: 'invoiceNumber = ?',
            whereArgs : [invoiceNo]
          );

          return dataList.length > 0;
        }
        catch(e)
    {
      print("Error DB: $e");
    }

    return false;
  }

  Future<List<PurchaseModel>> getPurchaseList() async
  {
    List<PurchaseModel> dataList = [];
    try
        {
          final db = await database;
          final List<Map<String,Object?>> purchaseList = await db.query('purchase');

          dataList.addAll(
              [ for(final {
                'id' : id as int,
                'purchaseDate' : purchaseDate as String,
              'invoiceNumber' : invoiceNumber as String,
                'quantity'  : quantity as int,
                'amount'  : amount as int,
                } in purchaseList) PurchaseModel(id: id, amount: amount, invoiceNumber: invoiceNumber, quantity: quantity, purchaseDate: purchaseDate)
              ]
          );

        }
        catch(e)
    {
      print("Error DB : $e");
    }

    return dataList;
  }

  Future removeStockList({invoiceNo}) async
  {
    final db = await database;

    await db.delete(
      'stockdetail',
      where : 'invoiceNo = ?',
      whereArgs : [invoiceNo]
    );
  }

  Future insertStockList(List<StockDetail> objs,String invoiceNum) async
  {
    final db = await database;

    for(var obj in objs)
      {
        await db.insert("stockdetail",{
          "stockCode" : obj.stockCode,
          "description" : obj.description,
          "invoiceNo" : invoiceNum,
          "quantity" : obj.quantity,
          "amount" : obj.amount,
          "price" : obj.price
        });
      }

    return "Stock List Data added!";
  }

  Future updatePurchaseData(PurchaseModel obj) async
  {

    try
        {
          print("obj quantity : ${obj.quantity}");
          print("obj quantity : ${obj.amount}");
          print("obj quantity : ${obj.id}");

          final db = await database;

          await db.rawQuery('''
          UPDATE purchase
          SET quantity = ?, amount = ?
          WHERE id = ?
          ''',[obj.quantity,obj.amount,obj.id]);

          // await db.update(
          //   'purchase',
          //   set : 'quantity = ?, amount = ?',
          //   where : 'id = ?',
          //   setArgs : [obj.quantity,obj.amount],
          //   whereArgs : [obj.id]
          // );

          print("updated success!");
        }
        catch(e)
    {
      print("Error DB: $e");
    }
  }
}