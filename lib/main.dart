// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:file_picker/file_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Business Card',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BusinessCard(),
    );
  }
}

class BusinessCard extends StatelessWidget {
  final ScreenshotController screenshotController = ScreenshotController();

  BusinessCard({super.key});

  Future<void> _captureAndSave() async {
    try {
      print('Waiting for widget to render...');
      await Future.delayed(const Duration(milliseconds: 500));

      print('Attempting to capture image...');
      final capturedImage = await screenshotController.capture();

      if (capturedImage == null) {
        print('Error: Image capture failed');
        return;
      }
      print('Image captured successfully');

      final result = await FilePicker.platform.getDirectoryPath();
      if (result == null) {
        print('No directory selected');
        return;
      }

      final filePath = '$result/business_card.png';
      final file = File(filePath);

      print('Saving file at: $filePath');
      await file.writeAsBytes(capturedImage);

      if (await file.exists()) {
        print('File saved successfully at: $filePath');
        Share.shareFiles([filePath], text: 'Here is my business card!');
      } else {
        print('File was not saved');
      }
    } catch (e) {
      print('Error capturing and saving the file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Card')),
      body: Center(
        child: Screenshot(
          controller: screenshotController,
          child: Card(
            elevation: 10,
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: AssetImage(
                      'assets/dmitri.jpg'), // Background image for the card
                  fit: BoxFit.cover,
                ),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Row to align the image and text side by side
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage('assets/profile.jpg'), // Profile image
                      ),
                      SizedBox(width: 10), // Space between image and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dmitri Dumas',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Flutter App Developer',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Email: dmitri@flutify.co.za',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Website: https://flutify.co.za',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Phone: +27 79 934 5962',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _captureAndSave,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
