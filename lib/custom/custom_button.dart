// ignore: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class TestButton extends StatelessWidget {
  final String login;

  const TestButton({super.key, required this.login});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: MaterialButton(
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.rightSlide,
            title: 'Dialog Title',
            desc: 'Fetching data from the server...',
            btnCancelOnPress: () {},
            btnOkOnPress: () async {
              try {
                final response = await http
                    .get(
                      Uri.parse("https://jsonplaceholder.typicode.com/posts"),
                    )
                    .timeout(
                      const Duration(seconds: 10),
                      onTimeout: () {
                        throw Exception("Request timed out");
                      },
                    );

                if (response.statusCode == 200) {
                  final responseBody = jsonDecode(response.body);

                  if (responseBody is List && responseBody.isNotEmpty) {
                    if (kDebugMode) {
                      print("First Title: ${responseBody[0]['title']}");
                    }
                  } else {
                    if (kDebugMode) {
                      print("No data found.");
                    }
                  }
                } else {
                  if (kDebugMode) {
                    print("Server error: ${response.statusCode}");
                  }
                }
              } catch (e) {
                if (kDebugMode) {
                  print("Error occurred: $e");
                }
              }
            },
          ).show();
        },
        child: Text(
          login,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  jsonDecode(String body) {}
}
