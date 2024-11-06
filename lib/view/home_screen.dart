import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:pdf_station/widgets/main_drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

import 'create_pdf_screen.dart';
import 'view_pdf_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _pdfFiles = [];
  List<String> _filteredFiles = [];
  bool _isSearching = false;

  //? filePickerResult;


  @override
  void initState() {
    super.initState();
    baseDirectory();
  }

  //For Get File Permission and Root Directory to  Get all PDF
  Future<void> baseDirectory() async {
    PermissionStatus permissionStatus = await Permission.manageExternalStorage.request();
    if(permissionStatus.isGranted) {
      var rootDirectory = await ExternalPath.getExternalStorageDirectories();
      await getFiles(rootDirectory.first);
    }
  }

  //For Get All PDF Files from any Folders/Directory
  Future<void> getFiles(String directoryPath) async {
    try{
      var rootDirectory = Directory(directoryPath);
      var directories = rootDirectory.list(recursive: false);

      await for (var item in directories){
        if(item is File){
          if(item.path.endsWith('.pdf')){
            setState(() {
              _pdfFiles.add(item.path);
              _filteredFiles = _pdfFiles;
            });
          }
        } else {
          await getFiles(item.path);
        }
      }
    }catch(e){
      print("-> : $e");
    }
  }

  //For Searching....
  void _filterFiles(String qry) {
    if(qry.isEmpty) {
      setState(() {
        _filteredFiles = _pdfFiles;
      });
    } else {
      setState(() {
        _filteredFiles = _pdfFiles.where((file) =>
        file.split('/').last.toLowerCase().contains(qry.toLowerCase())
        ).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      drawer: const MainDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: !_isSearching ? const Text('PDF Station Pro',style: TextStyle(color: Colors.white,),)
            :
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search PDFs....',
                filled: true,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white)
              ),
              onChanged: (val) {
                _filterFiles(val);
              },
            ),
        backgroundColor: const Color(0xFF3480ff),
        actions: [
          IconButton(
            iconSize: 30,
            onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              _filteredFiles = _pdfFiles;
            });
          },
              icon: Icon(_isSearching ? Icons.close:Icons.search,color: Colors.white,),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: ListView(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.center,
                      color: Colors.indigo,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Recent view files',style: TextStyle(fontSize: 18,color: Colors.white30),),
                          const SizedBox(height: 12,),
                          Container(
                            height: size.height * 0.22,
                            padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: ((context,index) {
                                return ListTile(
                                  leading: Image.asset('assets/img/pdf.png', width: 35, height: 30,),
                                  title: const Text('File Name',style: TextStyle(color: Colors.black87),),
                                  subtitle: const Text('Path to file'),
                                  trailing: IconButton(
                                    onPressed: () {
                                      //
                                    },
                                    icon: const Icon(Icons.cancel),
                                  ),
                                );
                              }),
                              separatorBuilder: (context, index) => const Divider(color: Colors.white,),
                              itemCount: 5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      color: Colors.indigoAccent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: size.height * 0.11,
                            child: Row(
                              children: [
                                buttonWidget(
                                  color: Colors.white24,
                                  onTap : () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePDFScreen(index: 1,)),);
                                  },
                                  path: 'assets/img/open.png',
                                  title: 'Open URL',
                                ),
                                const SizedBox(width: 12,),
                                buttonWidget(
                                  color: Colors.white54,
                                  onTap : () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePDFScreen(index: 1,)),);
                                  },
                                  path: 'assets/img/create.png',
                                  title: 'Create PDF',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18,),
                          const Text('All PDFs below from your device...',)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: _filteredFiles.isEmpty ?
            const Center(child: Text('PDFs not found here'),)
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: _filteredFiles.length,
              itemBuilder: (context, index) {
                String pdfFilePath = _filteredFiles[index];
                String pdfFileName = path.basename(pdfFilePath);
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                      title: Text(pdfFileName,style: const TextStyle(fontWeight: FontWeight.w400),),
                      leading: const Icon(Icons.picture_as_pdf,color: Colors.redAccent,size: 30,),
                      trailing: const Icon(Icons.arrow_forward_ios,size: 18,),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPDFScreen(
                            pdfFilePath: pdfFilePath,
                            pdfFileName: pdfFileName)),
                        );
                      }
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            baseDirectory(); //To Refresh List of PDF
          },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.refresh),
      ),
    );
  }


  Widget buttonWidget({color, path, title, onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('$path',height: 45,),
              Text('$title',style: const TextStyle(color: Colors.black87),),
            ],
          ),
        ),
      ),
    );
  }
}
