
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../model/Purchase.dart';
import '../model/StockDetail.dart';
import '../service/DatabaseService.dart';

class PurchaseDetail extends StatefulWidget {
  final PurchaseModel stockDe;
  const PurchaseDetail({super.key, required this.stockDe});

  @override
  State<PurchaseDetail> createState() => _PurchaseDetailState();
}

class _PurchaseDetailState extends State<PurchaseDetail> {

  List<StockDetail> detail = [
  ];

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    getInitData();
  }

  void getInitData() async
  {
    var getData = await DatabaseService().getStockList(widget.stockDe.invoiceNumber);

    if( getData.isNotEmpty)
      {
        setState(() {
          detail = getData;
        });
      }
  }


  void addStock(StockDetail stock)
  {
    setState(() {
      detail.add(stock);
    });
  }
  @override
  Widget build(BuildContext context) {
    // return MyMenuBar(title: "Purchase Detail", bodyWidget: PurchaseStock(stockList: detail, detail: widget.stockDe, setListData: addStock,));
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text("Purchase Detail", style: TextStyle(
          // color: Colors.white,
        ),),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [

          TextButton(onPressed: () async {

            try
                {
                  await DatabaseService().removeStockList(invoiceNo: widget.stockDe.invoiceNumber);

                  await DatabaseService().insertStockList(detail, widget.stockDe.invoiceNumber);

                  widget.stockDe.quantity = detail.fold(0, (d,t) => t.quantity + d);
                  widget.stockDe.amount = detail.fold(0, (d,t) => t.amount + d);

                  await DatabaseService().updatePurchaseData(widget.stockDe);

                  Navigator.pop(context);

                }
                catch(e)
            {
              print("Error page :: $e");
            }

          }, child: Column(
            children: [
              Icon(Icons.save,color: Colors.white38,),
              Text("Save",style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),)
            ],
          )),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: PurchaseStock(stockList: detail, detail: widget.stockDe, setListData: addStock, ),
    );
  }
}

class PurchaseStock extends StatelessWidget {
  final List<StockDetail> stockList;
  final PurchaseModel detail;
  final setListData;

    PurchaseStock({super.key, required this.stockList, required this.detail, required this.setListData,});
   final OverlayPortalController _overlaycontroller = OverlayPortalController();

  @override
  Widget build(BuildContext context) {



    return Column(
      children: [
        Expanded(child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 120,child: Text("Date", style: TextStyle(fontSize: 20),)),
                                Container(
                                  width: 150,
                                  // height: 50,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: 1.0, color: Colors.black),
                                    ),
                                  ),
                                  child: Text(detail.purchaseDate,style: TextStyle(
                                    fontSize: 20
                                  ),)
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                SizedBox(width: 120,child: Text("Invoice No",style: TextStyle(fontSize: 20)),),
                                Container(
                                    width: 150,
                                    // height: 50,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(width: 1.0, color: Colors.black),
                                      ),
                                    ),
                                    child: Text(detail.invoiceNumber,style: TextStyle(
                                        fontSize: 20
                                    ),)
                                ),
                                SizedBox(width: 20,),
                                Icon(Icons.date_range,size: 30,),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 20,),
                        // ElevatedButton(onPressed: _overlaycontroller.toggle, child: OverlayPortal(controller: _overlaycontroller, overlayChildBuilder: (BuildContext context){
                        //
                        //   return Positioned(top: 300, left: 30,child: StockForm(stockListD: stockList, addStockDataList: setListData, formAction: _overlaycontroller,),);
                        // }, child: const Text("data")),),
                        TextButton(
                          onPressed: _overlaycontroller.toggle,style: TextButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          )
                        ),
                          child: OverlayPortal(controller: _overlaycontroller, overlayChildBuilder: (BuildContext context){

                            return Positioned(top: 300, left: 30,child: StockForm(stockListD: stockList, addStockDataList: setListData, formAction: _overlaycontroller,),);
                          }, child: const Text("Add Detail",style: TextStyle(
                              fontSize: 20,
                              color: Colors.white
                            ),),
                        //   child: const Text("Add Detail",style: TextStyle(
                        //   fontSize: 20,
                        //   color: Colors.white
                        // ),),
                        ),
                        ),
                      ],
                    )
                  ]
                ),
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StockListTable(detailList: stockList,)
                  ]
              )
            ],
          ),
        )),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
          color: Colors.grey[300],
          child:  Row(

            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total QTY"),
                  Text("Total Amount"),
                ],
              ),
              SizedBox(
                width: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(stockList.fold(0, (d,t)=> t.quantity + d).toString(),style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20
                  ),),
                  Text(
                  NumberFormat.decimalPatternDigits(
                    locale: 'en_us',
                  ).format(stockList.fold(0, (i,d) => d.amount + i))
                  ,style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20
                  )),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}


class StockListTable extends StatelessWidget {
  final List<StockDetail> detailList;

   StockListTable({super.key, required this.detailList});

  final ScrollController _scrollController = ScrollController();
  int listId = 1;
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      trackVisibility: true,
      thumbVisibility: true,
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: DataTable(
          border: TableBorder.all(
            width: 1.5,
            color: Colors.blueGrey,


          ),
          headingRowColor: WidgetStateColor.resolveWith( (states) {
            return Colors.grey;
          },),
            columns: [
              DataColumn(label: Center(child: Text("Sr"))),
              DataColumn(label: Center(child: Text("Stock Code"))),
              DataColumn(label: Center(child: Text("Description"))),
              DataColumn(label: Center(child: Text("Qty"))),
              DataColumn(label: Center(child: Text("Price"))),
              DataColumn(label: Center(child: Text("Amount",))),
            ],
            rows: detailList.map((d){
              return DataRow(cells: [
                    DataCell(Text("${listId++}")),
                    DataCell(Text(d.stockCode)),
                    DataCell(Text(d.description)),
                    DataCell(Text("${d.quantity}")),
                    DataCell(Text("${d.price}")),
                    DataCell(Text("${d.amount}")),
              ]);
            }
            ).toList()

        ),
      ),
    );
  }
}

class StockForm extends StatefulWidget {
  final List<StockDetail> stockListD;
  final addStockDataList;
  final OverlayPortalController formAction;

  const StockForm({super.key, required this.stockListD, required this.addStockDataList, required this.formAction,});


  @override
  State<StockForm> createState() => _StockFormState();
}

class _StockFormState extends State<StockForm> {
  final _formKey = GlobalKey<FormState>();
  String invoiceNo = "";
  DateTime dateT = DateTime.now();
  String code = "";
  String description = "";
  int qty = 0;
  int price = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
        child: Container(
      color: Colors.grey[400],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: 350,
        height: 600,
        color: Colors.grey,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 100,
                    child: const Text("Invoice No", style: TextStyle(
                      fontSize: 15,
                    ),),
                ),
                Container(
                  width: 150,
                  child: TextFormField(
                    validator: (value) {
                      if(value == null || value.isEmpty)
                      {
                        return "enter something";
                      }
                      return null;
                    },
                    onSaved: (value){
                      invoiceNo = value!;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 100,
                  child: const Text("Date", style: TextStyle(
                    fontSize: 15,
                  ),),
                ),
                Container(
                  width: 150,
                  child: TextFormField(
                    validator: (value) {

                      if(value == null || value.isEmpty)
                      {
                        return "enter something";
                      }
                      else{
                        var val = DateTime.tryParse(value);

                        if(val == null)
                        {
                          return "Invalid Date format : {YY-MM-DD}";
                        }
                      }
                      return null;
                    },
                    onSaved: (v){
                      dateT = DateTime.parse(v!);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 100,
                  child: const Text("Code", style: TextStyle(
                    fontSize: 15,
                  ),),
                ),
                Container(
                  width: 150,
                  child: TextFormField(
                    validator: (value) {
                      if(value == null || value.isEmpty)
                      {
                        return "enter something";
                      }
                      return null;
                    },
                    onSaved: (v){
                      code = v!;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 100,
                  child: const Text("Description", style: TextStyle(
                    fontSize: 15,
                  ),),
                ),
                Container(
                  width: 150,
                  child: TextFormField(
                    validator: (value) {
                      if(value == null || value.isEmpty)
                      {
                        return "enter something";
                      }
                      return null;
                    },
                    onSaved: (v){
                      description = v!;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 100,
                  child: const Text("QTY", style: TextStyle(
                    fontSize: 15,
                  ),),
                ),
                Container(
                  width: 150,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if(value == null || value.isEmpty)
                      {
                        return "enter something";
                      }
                      return null;
                    },
                    onSaved: (v){
                      qty = int.parse(v!);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 100,
                  child: const Text("Price", style: TextStyle(
                    fontSize: 15,
                  ),),
                ),
                Container(
                  width: 150,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if(value == null || value.isEmpty)
                      {
                        return "enter something";
                      }
                      return null;
                    },
                    onSaved: (v){
                      price = int.parse(v!);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(onPressed: (){


              if(_formKey.currentState!.validate() )
                {
                  _formKey.currentState!.save();

                  print("invoice number is $code");
                  print(description);
                  print(qty);
                  print(price);

                 widget.addStockDataList(
                     StockDetail(stockCode: code, description: description, quantity: qty, amount: ( qty * price ), price: price)
                 );

                  widget.formAction.hide();

                }
              else
                {
                  print("Validation fail!");
                }


            }, child: Text("Validation"))
          ],
        )
      ),
    ));
  }
}
