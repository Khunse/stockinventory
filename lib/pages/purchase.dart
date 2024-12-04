import 'package:flutter/material.dart';
import 'package:galaxysfassigment/pages/purchasedetail.dart';
import 'package:galaxysfassigment/service/DatabaseService.dart';
import 'package:sqflite/sqflite.dart';

import '../model/Purchase.dart';
import 'home.dart';

class Purchase extends StatefulWidget {
  const Purchase({super.key});
  @override
  State<Purchase> createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {

  List<PurchaseModel> listData = [
    // PurchaseModel(amount: 1200, invoiceNumber: "Rt-11", quantity: 12, purchaseDate: "${DateTime.now().day}/${DateTime.now().day}/${DateTime.now().day}"),
    // PurchaseModel(amount: 1300, invoiceNumber: "Rt-12", quantity: 13, purchaseDate: "${DateTime.now().day}/${DateTime.now().day}/${DateTime.now().day}"),
    // PurchaseModel(amount: 1400, invoiceNumber: "Rt-13", quantity: 14, purchaseDate: "${DateTime.now().day}/${DateTime.now().day}/${DateTime.now().day}"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  getDataList();

  }

  void emptyList()
  {
    print("empty data list data");
    setState(() {
      // listData = [];
      getDataList();
    });
  }

void getDataList() async
{
        var data = await DatabaseService().getPurchaseList();

        if(data.isNotEmpty)
          {
            setState(() {
              listData = data;
            });
          }

}
  @override
  Widget build(BuildContext context) {


    return MyMenuBar(
      title: "Purchase", bodyWidget: PurchaseListTable(listData: listData, listempty: emptyList,),);

    // return Scaffold(
    //   appBar: AppBar(
    //     title:  Text("title",style: const TextStyle(
    //       color: Colors.white,
    //     ),),
    //     backgroundColor: Colors.deepPurpleAccent,
    //     leading: const MyPopUpMenu(),
    //   ),
    //   body: PurchaseListTable(listData: listData,),
    // );

  }
}


class PurchaseListTable extends StatefulWidget {
  final List<PurchaseModel> listData;
  final listempty;
   PurchaseListTable({super.key, required this.listData, required this.listempty});

  @override
  State<PurchaseListTable> createState() => _PurchaseListTableState();
}

class _PurchaseListTableState extends State<PurchaseListTable> {
  String? selectIn;

  final OverlayPortalController _controller = OverlayPortalController();


  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: const [
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("Invoice No")),
              DataColumn(label: Text("QTY")),
              DataColumn(label: Text("Amount")),
            ],
              rows: widget.listData.map((e)=> DataRow(
                selected: selectIn == e.invoiceNumber,
                onSelectChanged: (isSelected){
                  setState(() {
                    selectIn = e.invoiceNumber;
                  });
                },
                  cells: [
                DataCell(Text( e.purchaseDate)),
                DataCell(Text( e.invoiceNumber )),
                DataCell(Text( e.quantity.toString() )),
                DataCell(Text( e.amount.toString() )),
              ])).toList(),
            ),
          ),
        ),
      ),
        Container(
          color: Colors.grey[400],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TextButton(onPressed: _controller.toggle, child:  Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add,size: 50,),
                      const Text("Add",style: TextStyle(color: Colors.white),),
                      OverlayPortal(controller: _controller, overlayChildBuilder: (BuildContext context){

                        return Positioned(top: 300, left: 30,child: PurchaseForm(controller: _controller, emptyDataList: widget.listempty,));
                      },
                        //   child: const Text("Add Detail",style: TextStyle(
                        //   fontSize: 20,
                        //   color: Colors.white
                        // ),),
                      ),
                    ],
                  )),
                  TextButton(onPressed: () async {
                    if(selectIn == null)
                      {

                      }
                    else
                      {
                        var ele = widget.listData.where((d) => d.invoiceNumber == selectIn).firstOrNull!;
                        var data = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => PurchaseDetail(stockDe: ele))
                        );

                        widget.listempty();
                      }
                  }, child: const Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit,size: 50,),
                      Text("Edit",style: TextStyle(color: Colors.white)),
                    ],

                  ))
                ],
              ),
              Column(
                children: [
                  Text("Total QTY"),
                  Text(widget.listData.fold(0, (t,a) => a.quantity + t).toString(),style: const TextStyle(
                    fontSize: 20
                  ),),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    Text("Total Amount"),
                    Text(widget.listData.fold(0, (t,a) => a.amount + t).toString(), style: TextStyle(
                      fontSize: 20
                    ),),
                  ],
                ),
              ),
            ],
          ),
        )
    ]
    );
}
}



class PurchaseForm extends StatefulWidget {
  final OverlayPortalController controller;
  final emptyDataList;
  const PurchaseForm({super.key, required this.controller, required this.emptyDataList});

  @override
  State<PurchaseForm> createState() => _PurchaseFormState();
}

class _PurchaseFormState extends State<PurchaseForm> {
  String invoiceNumber = "";
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
        child: Container(
          color: Colors.grey,
      padding: const EdgeInsets.all(20),
      width: 400,
      height: 400,
      child: Column(
        children: [
          Row(
            children: [
              Text("Invoice No",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white
              ),),
              SizedBox(
                width: 30,
              ),
              Container(
                width: 200,
                child: TextFormField(

                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                  validator: (val){
                    if(val == null || val.isEmpty)
                      {
                        return "Enter Something!";
                      }

                    return null;
                  },
                  onSaved: (val){
                    invoiceNumber = val!;
                  },
                ),
              )
            ],
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(onPressed: () async {

                if(formKey.currentState!.validate())
                  {
                    formKey.currentState!.save();
                    var purchaseData = PurchaseModel(amount: 0, invoiceNumber: invoiceNumber, quantity: 0, purchaseDate: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");

                    if( !await DatabaseService().checkDuplicatPurchase(invoiceNumber))
                      {
                        await DatabaseService().addPurchase(purchaseData);
                        widget.controller.hide();
                        widget.emptyDataList();
                      }
                    else
                      {
                        print("duplicate data!");
                      }


                  }
                else
                  {
                    print("Validation Fail!");
                  }

              }, child: Text("Add",style: TextStyle(
                color: Colors.white,
              ),),style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,minimumSize: Size(100, 50),
              ),),
              SizedBox(width: 30,),
              ElevatedButton(onPressed: (){
                widget.controller.hide();
              }, child: Text("Cancel",style: TextStyle(
                color: Colors.white,
              ),),style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,minimumSize: Size(100, 50),
              ),)
            ],
          )
        ],
      ),
    ));
  }
}
