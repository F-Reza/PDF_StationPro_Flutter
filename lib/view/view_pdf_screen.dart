import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ViewPDFScreen extends StatefulWidget {
  static const String routeName = '/view_pdf';
  final String pdfFilePath;
  final String pdfFileName;
  const ViewPDFScreen({super.key, required this.pdfFilePath, required this.pdfFileName});

  @override
  State<ViewPDFScreen> createState() => _ViewPDFScreenState();
}

class _ViewPDFScreenState extends State<ViewPDFScreen> {
  int totalPages = 0;
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3480ff),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF3480ff),
        title: Text(widget.pdfFileName,style: const TextStyle(color: Colors.white,),),
      ),
      body: PDFView(
        filePath: widget.pdfFilePath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        backgroundColor: Colors.grey,
        onRender: (pages) {
          setState(() {
            totalPages = pages!;
            //isReady = true;
          });
        },
        onPageChanged: (page, total) {
          setState(() {
            currentPage = page!;
          });
        },
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
        onViewCreated: (PDFViewController pdfViewController) {
          //_controller.complete(pdfViewController);
        },


      ),
    );
  }
}
