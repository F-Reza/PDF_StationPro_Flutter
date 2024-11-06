

import 'package:flutter/material.dart';
import 'package:pdf_station/view/create_pdf_screen.dart';
import 'package:pdf_station/view/home_screen.dart';

class MainDrawer extends StatefulWidget {
  static const String routeName = '/sidebar';
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueAccent,
      child: ListView(
        children: [
          Container(
            height: 200,
            color: Colors.black38,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(55),
                  child: Image.asset('assets/img/app_logo.png',
                      height: 110, width: 110, fit: BoxFit.cover),
                ),
                const SizedBox(height: 10,),
                //AuthService.user!.email!
                const Text("pdfstationpro@gmail.com",
                  style: TextStyle(fontSize: 16,color: Colors.white),),
              ],
            ),
          ),
          ListTile(
            onTap: () => Navigator.pushReplacementNamed(context, HomeScreen.routeName),
            leading: const Icon(Icons.dashboard,color: Colors.white,),
            title: const Text('Home',style: TextStyle(color: Colors.white),),
          ),
          const ListTile(
            //onTap: () => Navigator.pushNamed(context, QrScanner.routeName),
            leading: Icon(Icons.video_stable,color: Colors.white,),
            title: Text('Recent View',style: TextStyle(color: Colors.white),),
          ),
          ListTile(
            //onTap: () => Navigator.pushNamed(context, CreatePDFScreen.routeName,),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder:(context) => const CreatePDFScreen(index: 1,))),
            leading: const Icon(Icons.create_new_folder,color: Colors.white,),
            title: const Text('Create PDF',style: TextStyle(color: Colors.white),),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder:(context) => const CreatePDFScreen(index: 1,)));
            },
            leading: const Icon(Icons.webhook,color: Colors.white,),
            title: const Text('Open With URL',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}
