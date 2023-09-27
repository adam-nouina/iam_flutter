import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String textData1;
  final String textData2;

  InfoCard({required this.textData1, required this.textData2});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      width:  MediaQuery.of(context).size.width * 0.90, // Set the desired width here
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 5, // Blur radius
            offset: Offset(0, 3), // Offset in the positive Y direction (for bottom shadow)
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'N° Client',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12, // Increase the font size for the number
                    color: Colors.black,
                    fontFamily: 'Akhar', // Use 'Akhar' font for the number
                  ),
                ),
                Text(
                  textData2,
                  style: TextStyle(
                    fontSize: 20, // Decrease the font size for the text
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Akhar', // Use 'Akhar' font for the text
                  ),
                ),
              ],
            ),
          ),
          Text(
            'détail',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
