import 'package:flutter/material.dart';

class MyTile extends StatelessWidget {
  final String numeroClient;
  final String dateVisite;

  MyTile({
    required this.numeroClient,
    required this.dateVisite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Add some shadow to the card
      margin: EdgeInsets.all(16),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Adjust the radius as needed
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Numero de client:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(numeroClient),
                  ],
                ),
                SizedBox(width: 26),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date visite:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(dateVisite),
                  ],
                ),
                SizedBox(width: 86),
                Icon(
                  Icons.arrow_forward, // Add the arrow icon
                  size: 36, // Adjust the size of the icon as needed
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
