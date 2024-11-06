import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

class CreatePDFScreen extends StatefulWidget {
  static const String routeName = '/create_pdf';
  final int? index;
  final String? path;
  const CreatePDFScreen({super.key, this.index, this.path});

  @override
  State<CreatePDFScreen> createState() => _CreatePDFScreenState();
}

class _CreatePDFScreenState extends State<CreatePDFScreen> {
  //late PdfController pdfController;
  late PdfControllerPinch pdfPinchController;
  var url = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';

  loadController() async {
    switch (widget.index) {
      case 0:
        pdfPinchController = PdfControllerPinch(document: PdfDocument.openAsset('assets/sample.pdf'));
        break;
      case 1:
        pdfPinchController = PdfControllerPinch(document: PdfDocument.openData(InternetFile.get(url)));
        break;
      case 2:
        pdfPinchController = PdfControllerPinch(document: PdfDocument.openFile(widget.path.toString()));
        break;

      default:
    }
    //pdfController = PdfController(document: PdfDocument.openAsset('assets/sample.pdf'));
    Future.delayed(const Duration(seconds: 2), (){
      setState(() {});
    });
  }
  @override
  void initState() {
    loadController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filename'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Center(child: Text(pdfPinchController.pagesCount == null ? '' : 'Pages: ${pdfPinchController.pagesCount}')),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: PdfViewPinch(
        controller: pdfPinchController,
      ),
    );
  }
}
