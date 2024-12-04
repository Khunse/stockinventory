import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyMenuBar(title: "Galaxy Assignment", bodyWidget: Text(""));
  }
}

class MyMenuBar extends StatelessWidget {
  final String title;
  final Widget bodyWidget;
  const MyMenuBar({super.key, required this.title, required this.bodyWidget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(title,style: const TextStyle(
          color: Colors.white,
        ),),
        backgroundColor: Colors.deepPurpleAccent,
        leading: const MyPopUpMenu(),
      ),
      body: Row(
          children: [Expanded(child: bodyWidget)]),
    );
  }
}

class MyPopUpMenu extends StatelessWidget {
  const MyPopUpMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return IconButton(
          tooltip: "Show Menu",
          icon: const Icon(Icons.menu,color: Colors.white,),
          onPressed: (){
            if(controller.isOpen)
              {
                controller.close();
              }
            else
              {
                controller.open();
              }
          },
        );
        },
      menuChildren: [
        Container(
          width: 100,
          child: MenuItemButton(
            onPressed: (){
              Navigator.pushReplacementNamed(context, "/");
            },

            child: const Text("Setup",),
          ),
        ),
        Container(
          width: 100,
          child: MenuItemButton(
            onPressed: (){
              Navigator.pushReplacementNamed(context, "/Purchase");
            },

            child: const Text("Purchase",),
          ),
        ),
        Container(
          width: 100,
          child: MenuItemButton(
            onPressed: (){
              Navigator.pushReplacementNamed(context, "/");
            },

            child: const Text("Sales",),
          ),
        ),
        Container(
          width: 100,
          child: MenuItemButton(
            onPressed: (){
              Navigator.pushReplacementNamed(context, "/");
            },

            child: const Text("Report",),
          ),
        ),
    ],
    );
  }
}

