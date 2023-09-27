import 'package:flutter/material.dart';

class MyBox extends StatelessWidget {
  final String iconData;
  final double iconSize;
  final String textData;
  final String changedData;
  final Color col;

  MyBox({
    required this.iconData,
    required this.iconSize,
    required this.textData,
    required this.changedData,
    required this.col,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.black, width: 0.5),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4383E5), Color(0xFF1B3E74)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 5, // Blur radius
              offset: Offset(0, 3), // Offset in the positive Y direction (for bottom shadow)
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        iconData,
                        width: iconSize,
                        height: iconSize,
                        color: Colors.white,
                      ),
                      SizedBox(height: 20), // Add spacing between image and number
                      Text(
                        changedData,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Akhar',
                        ),
                      ),
                      SizedBox(height: 5), // Add spacing between number and text
                      Text(
                        textData,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Akhar',
                        ),
                      ),
                    ],
                  ),
        ),
        ),
    );
  }
}
