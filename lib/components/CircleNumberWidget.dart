import 'package:flutter/material.dart';

class CircleNumberWidget extends StatelessWidget {
  final int number;
  final String text;

  CircleNumberWidget({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70, // Adjust the circle size as needed
          height: 70, // Adjust the circle size as needed
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.blue[800]!, Color(0xFF50D8D7)], // Use a gradient from #48DBFB to #D3D3D3
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 24, // Adjust the number's font size as needed
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
        SizedBox(height: 8), // Add some space between the number and text
        Text(
          text,
          style: TextStyle(
            fontSize: 14, // Adjust the text's font size as needed
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}