import 'package:flutter/material.dart';
import 'package:iam/pages/infopage.dart';

class InfoCard2 extends StatelessWidget {
  final String textData1;
  final String textData2;
  final int idVisite;
  final String token;

  InfoCard2({
    required this.textData1,
    required this.textData2,
    required this.idVisite,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          // Handle navigation to InfoPage here
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InfoPage(idVisite: idVisite,token: token,)),
          );
        },
        child: Container(
          padding: EdgeInsets.all(12.0),
          width: double.infinity, // Take up the entire width of the screen
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0), // Add right padding to the image
                child: Image.asset(
                  'images/visit2.png', // Replace with the actual path to your PNG image
                  width: 30.0, // Set the desired width of the image
                  height: 30.0, // Set the desired height of the image
                ),
              ),
              Column(
                children: [
                  Text(
                    'N° client',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                      fontFamily: 'Inter',
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    textData1, // Replace with your client number
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Date de visite',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                      fontFamily: 'Inter',
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    textData2, // Replace with your client number
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                'Detail',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14.0,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}