import 'package:flutter/material.dart';
import 'package:iam/pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import this for JSON decodingimport 'dart:math';

class InfoPage extends StatefulWidget {
  final String? token;
  final int idVisite;

  InfoPage({Key? key, this.token, required this.idVisite}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {

  Map<String, dynamic>? responseData; // Variable to store the parsed JSON data

  @override
  void initState() {
    super.initState();
    if (widget.token != null) {
      // If a token is available, make the GET request
      fetchData();
    }
  }

  Future<void> fetchData() async {
    try {
      // Define the headers with the authorization token
      Map<String, String> headers = {
        'Authorization': 'Bearer ${widget.token}', // Include the access token here
      };

      // Send a GET request to the API with headers
      final response = await http.get(
        Uri.parse('https://ospc.hashkey.ma/api/visites/${widget.idVisite}'),
        headers: headers, // Include the headers here
      );

      if (response.statusCode == 200) {
        // Handle a successful response, e.g., parse and display data
        print('GET request successful');
        // print(response.body);

        // Parse the JSON response and store it in the responseData variable
        final Map<String, dynamic> decodedData = jsonDecode(response.body)['data'];

        // Store the parsed data in the responseData variable
        setState(() {
          responseData = decodedData;
        });
      } else {
        // Handle errors here, e.g., show an error message
        print('Error making GET request. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle errors that occur during the request, e.g., network errors
      print('Error sending the GET request: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.token != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          title: Text('Page de détail'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            buildRowWithDivider(
              buildTextRow('N° Client', responseData?['client']?['numero_client'] ?? ''),
              buildTextRow('Raison sociale', responseData?['client']?['raison_social'] ?? ''),
            ),
            buildRowWithDivider(
              buildTextRow('Visite', responseData?['type_visite'] ?? ''),
              buildTextRow('Solution', responseData?['produit']?['nom'] ?? ''),
            ),
            buildTextRow('Type', responseData?['type_client'] ?? ''), // This will be alone
            Divider(height: 0.2, color: Colors.grey,),
            buildRowWithDivider(
              buildTextRow('Date de visite', responseData?['date_visite'] ?? ''),
              buildTextRow('Diagnistic', responseData?['diagnostic']?? '2023-08-11'),
            ),
            buildRowWithDivider(
              buildTextRow('Analyse', responseData?['analyse']?? '2023-08-11'),
              buildTextRow('Proposition', responseData?['proposition']?? '2023-10-11'),
            ),
            buildRowWithDivider(
              buildTextRow('Negociation', responseData?['negociation']?? '2023-01-11'),
              buildTextRow('Conclusion', responseData?['conclusion']?? '2023-08-19'),
            ),
            buildTextRow('Affaire perdus', responseData != null ? (responseData?['affaire_perdue'] == 0 ? 'No' : 'Yes') : ''),
            Divider(height: 0.2, color: Colors.grey,),
          ],
        )

      );
    } else {
      return LoginPage();
    }
  }

  Widget buildRowWithDivider(Widget leftWidget, Widget rightWidget) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: leftWidget),
    Container(
          height: 40.0,
          width: 1.0,
          color: Colors.grey,
          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        ),
            Expanded(child: rightWidget),
          ],
        ),
        Divider(
          height: 0.2,
          color: Colors.grey,
        ),
      ],
    );
  }


  Widget buildTextRow(String title, String content) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center text horizontally
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey
              ),
              textAlign: TextAlign.center, // Center text horizontally
            ),
            SizedBox(height: 5,),
            Text(
              content,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center, // Center text horizontally
            ),
          ],
        ),
      ),
    );
  }







  Widget buildDivider() {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Container(
        height: 0.2,
        color: Colors.grey,
      ),
    );
  }

  Widget buildWiderGradientButton(String buttonText, Color backgroundColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Expanded(
        child: Container(
          width: 180,
          height: 50,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              padding: EdgeInsets.all(16.0),
              elevation: 0,
              onPrimary: Colors.white,
            ),
            onPressed: () {
              // Handle button press
            },
            child: Text(
              buttonText,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}