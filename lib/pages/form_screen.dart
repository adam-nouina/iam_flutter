import 'package:flutter/material.dart';
import 'package:iam/pages/Home2.dart';
import 'package:iam/pages/login_page.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormScreen extends StatefulWidget {
  final String? token; // Define the token property
  const FormScreen({Key? key, this.token}) : super(key: key);
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  late String client_id ;
  late String solution;
  late String type_visite;
  late String type_client;
  late String affaire_perdue;
  late String unite = '';
  late String description = '';

  DateTime? date_visite;
  DateTime? conclusiondans;
  DateTime? proposition;
  DateTime? conclusion;
  DateTime? Diagnostic;
  DateTime? analyse;
  DateTime? negociation;

  bool showDiagnostic = false;
  bool showAnalyse = false;
  bool showProposition = false;
  bool showNegociation = false;
  bool showConclusion = false;

  final _formKey = GlobalKey<FormState>();

  // Create an empty list to store client data
  List<Map<String, dynamic>> clientDataList = [];
  List<Map<String, dynamic>> solutionDataList = [];

   @override
   void initState() {
     super.initState();

     // Fetch the client data when the page is first loaded
     fetchClientData().then((data) {
       setState(() {clientDataList = data;});
     });
     fetchSlutionData().then((data) {
       setState(() {solutionDataList = data;});
     });
   }

  Future<List<Map<String, dynamic>>> fetchClientData() async {
    final headers = {
        'Authorization': 'Bearer ${widget.token}',
      };
    final response = await http.get(Uri.parse('https://ospc.hashkey.ma/api/clients'), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['clients'];
      return data.map((client) {
        return {
          'value': client['id'], // Replace 'clientId' with the actual key in your API response for the client ID
          'text': '${client['numero_client']} - ${client['raison_social']}', // Concatenate the two values
        };
      }).toList();
    } else {
      throw Exception('Failed to load client data');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSlutionData() async {
    final headers = {
        'Authorization': 'Bearer ${widget.token}',
      };
    final response = await http.get(Uri.parse('https://ospc.hashkey.ma/api/produits'), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['produits'];
      return data.map((client) {
        return {
          'value': client['id'], // Replace 'clientId' with the actual key in your API response for the client ID
          'text': client['nom'], // Replace 'clientName' with the actual key in your API response for the client name
        };
      }).toList();
    } else {
      throw Exception('Failed to load solution data');
    }
  }

  Widget _buildShowDiagnosticCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: showDiagnostic,
          onChanged: (bool? newValue) {
            setState(() {
              showDiagnostic = newValue ?? false;
            });
          },
        ),
        Text('Diagnostic'),
      ],
    );
  }

  Widget _buildShowAnalyeCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: showAnalyse,
          onChanged: (bool? newValue) {
            setState(() {
              showAnalyse = newValue ?? false;
            });
          },
        ),
        Text('Analyse'),
      ],
    );
  }

  Widget _buildShowDatePropositionCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: showProposition,
          onChanged: (bool? newValue) {
            setState(() {
              showProposition = newValue ?? false;
            });
          },
        ),
        Text('Proposition'),
      ],
    );
  }

  Widget _buildShowNegociationCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: showNegociation,
          onChanged: (bool? newValue) {
            setState(() {
              showNegociation = newValue ?? false;
            });
          },
        ),
        Text('Negociation'),
      ],
    );
  }

  Widget _buildShowDateConclusionCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: showConclusion,
          onChanged: (bool? newValue) {
            setState(() {
              showConclusion = newValue ?? false;
            });
          },
        ),
        Text('Conclusion'),
      ],
    );
  }

  Widget _buildClient() {
    if (clientDataList.isEmpty) {
      // Data is still loading, show a loading indicator
      return CircularProgressIndicator();
    } else {
      return DropdownButtonFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
        ),
        value: '-1', // Set the selected value
        onChanged: (String? newValue) {
          setState(() {
            client_id = newValue ?? ''; // Update the selected value
          });
        },
        items: [
          DropdownMenuItem(
            child: Text(
              'Veuillez sélectionner un Client',
              style: TextStyle(fontFamily: 'Inter', color: Colors.grey[600]),
            ),
            value: '-1',
          ),
          for (var clientData in clientDataList)
            DropdownMenuItem(
              child: Text(
                clientData['text'].toString(),
                style: TextStyle(fontFamily: 'Inter', color: Colors.black),
              ),
              value: clientData['value'].toString(),
            ),
        ],
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Client is Required';
          }
          return null;
        },
        onSaved: (String? value) {
          client_id = value ?? '';
        },
      );
    }
  }

  Widget _buildSolution(){
    if (solutionDataList.isEmpty) {
          // Data is still loading, show a loading indicator
          return CircularProgressIndicator();
        } else {
          return DropdownButtonFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
            ),
            value: '-1', // Set the selected value
            onChanged: (String? newValue) {
              setState(() {
                solution = newValue ?? ''; // Update the selected value
              });
            },
            items: [
              DropdownMenuItem(
                child: Text(
                  'Veuillez sélectionner une solution',
                  style: TextStyle(fontFamily: 'Inter', color: Colors.grey[600]),
                ),
                value: '-1',
              ),
              for (var solutionData in solutionDataList)
                DropdownMenuItem(
                  child: Text(
                    solutionData['text'].toString(),
                    style: TextStyle(fontFamily: 'Inter', color: Colors.black),
                  ),
                  value: solutionData['value'].toString(),
                ),
            ],
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Solution is Required';
              }
              return null;
            },
            onSaved: (String? value) {
              solution = value ?? '';
            },
          );
        }
  }

  Widget _buildVisite(){
      return DropdownButtonFormField(
          decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue, // Change the border color when focused
                    width: 2.0, // Adjust the border width as needed
                  ),
                ),
              ),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.0, // Set the desired font size for the hint text
            ),
            value: '-1',
            items: [
              DropdownMenuItem(child: Text('Veuillez selectionner le type de Visite',style: TextStyle(fontFamily: 'Inter',color: Colors.grey[600])), value: '-1',),
              DropdownMenuItem(child: Text('Reclamation',style: TextStyle(fontFamily: 'Inter',color: Colors.black)), value: 'Reclamation'),
              DropdownMenuItem(child: Text('Vente',style: TextStyle(fontFamily: 'Inter',color: Colors.black)), value: 'Vente'),
              DropdownMenuItem(child: Text('SAV',style: TextStyle(fontFamily: 'Inter',color: Colors.black)), value: 'SAV'),
            ],
            validator: (String? value) {
              if (value == null || value=='-1') {
                return 'Type de visite is Required';
              }
              return null;
            },
            onSaved: (String? value) {
              type_visite = value ?? '';
            },
            onChanged: (String? value) {
                type_visite = value ?? '';
            },

          );
    }

  Widget _buildType(){
    return DropdownButtonFormField(
          decoration: const InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue, // Change the border color when focused
                    width: 2.0, // Adjust the border width as needed
                  ),
                ),
              ),
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.0, // Set the desired font size for the hint text
          ),
          value: '-1',
          items: [
            DropdownMenuItem(child: Text('Veuillez selectionner le type de client',style: TextStyle(fontFamily: 'Inter',color: Colors.grey[600])), value: '-1',),
            DropdownMenuItem(child: Text('client_produit',style: TextStyle(fontFamily: 'Inter',color: Colors.black)), value: 'client_produit',),
            DropdownMenuItem(child: Text('prospect_produit',style: TextStyle(fontFamily: 'Inter',color: Colors.black)), value: 'prospect_produit',),
          ],
          validator: (String? value) {
            if (value == null || value=='-1') {
              return 'Type de client is Required';
            }
            return null;
          },
          onSaved: (String? value) {
            type_client = value ?? '';
          },
          onChanged: (String? value) {
              type_client = value ?? '';
          },
        );
      }

  Widget _buildDateVisite() {
    return TextFormField(
        decoration: InputDecoration(
          hintText: 'Veuillez entrer la Date de la visite',
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue, // Change the border color when focused
              width: 2.0, // Adjust the border width as needed
            ),
          ),
        ),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14.0, // Set the desired font size for the hint text
        ),
        readOnly: true, // Make the field read-only
        controller: TextEditingController(
          // Use a TextEditingController to display the selected date
          text: date_visite == null ? '' : DateFormat('yyyy-MM-dd').format(date_visite!),
        ),
        onTap: () async {
          // Show the date picker dialog
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );

          if (pickedDate != null && pickedDate != date_visite) {
            // Update the selected date if a new date is picked
            setState(() {
              date_visite = pickedDate;
            });
          }
        },
        validator: (String? value) {
          if (date_visite == null) {
            return 'Date de la visite is Required';
          }
          return null;
        },
        onSaved: (String? value) {
          date_visite = value != null ? DateTime.parse(value) : null;
        },
      );
  }

  Widget _buildUnite() {
        return TextFormField(
                decoration: InputDecoration(
                  hintText: 'Veuillez entrer l\'unité',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue, // Change the border color when focused
                      width: 2.0, // Adjust the border width as needed
                    ),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.0, // Set the desired font size for the hint text
                ),
                validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Unité is Required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                      // Update the unite variable as the user types
                      unite = value ?? '';
                    },
                  onSaved: (String? value) {
                    unite = value ?? '';
                  },
                );
      }

  Widget _buildDateConclusiodans() {
     return TextFormField(
         decoration: InputDecoration(
           hintText: 'Veuillez entrer la Date de la conclusion',
           border: OutlineInputBorder(),
           focusedBorder: OutlineInputBorder(
             borderSide: BorderSide(
               color: Colors.blue, // Change the border color when focused
               width: 2.0, // Adjust the border width as needed
             ),
           ),
         ),
         style: TextStyle(
           fontFamily: 'Inter',
           fontSize: 14.0, // Set the desired font size for the hint text
         ),
         readOnly: true, // Make the field read-only
         controller: TextEditingController(
           // Use a TextEditingController to display the selected date
           text: conclusiondans == null ? '' : DateFormat('yyyy-MM-dd').format(conclusiondans!),
         ),
         onTap: () async {
           // Show the date picker dialog
           final pickedDate = await showDatePicker(
             context: context,
             initialDate: DateTime.now(),
             firstDate: DateTime(2000),
             lastDate: DateTime(2101),
           );

           if (pickedDate != null && pickedDate != conclusiondans) {
             // Update the selected date if a new date is picked
             setState(() {
               conclusiondans = pickedDate;
             });
           }
         },
         validator: (String? value) {
           if (conclusiondans == null) {
             return 'Date de la conclusion is Required';
           }
           return null;
         },
         onSaved: (String? value) {
           conclusiondans = value != null ? DateTime.parse(value) : null;
         },
       );
   }

  Widget _buildDiagnostic() {
    return showDiagnostic
        ? TextFormField(
            decoration: InputDecoration(
              hintText: 'Veuillez entrer la Date du diagnostic',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue, // Change the border color when focused
                  width: 2.0, // Adjust the border width as needed
                ),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.0, // Set the desired font size for the hint text
            ),
            readOnly: true, // Make the field read-only
            controller: Diagnostic == null
                ? TextEditingController()
                : TextEditingController(
                    // Use a TextEditingController to display the selected date
                    text: DateFormat('yyyy-MM-dd').format(Diagnostic!),
                  ),
            onTap: () async {
              // Show the date picker dialog
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: Diagnostic ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null && pickedDate != Diagnostic) {
                // Update the selected date if a new date is picked
                setState(() {
                  Diagnostic = pickedDate;
                });
              }
            },
            onSaved: (String? value) {
              Diagnostic = value?.isEmpty ?? true ? null : DateTime.parse(value!);
            },
          )
        : SizedBox.shrink(); // Hide the field when showDiagnostic is false
  }


  Widget _buildAnalye() {
    return showAnalyse
        ? TextFormField(
            decoration: InputDecoration(
              hintText: 'Veuillez entrer la Date de l\'analyse',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue, // Change the border color when focused
                  width: 2.0, // Adjust the border width as needed
                ),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.0, // Set the desired font size for the hint text
            ),
            readOnly: true, // Make the field read-only
            controller: TextEditingController(
              // Use a TextEditingController to display the selected date
              text: analyse == null ? '' : DateFormat('yyyy-MM-dd').format(analyse!),
            ),
            onTap: () async {
              // Show the date picker dialog
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null && pickedDate != analyse) {
                // Update the selected date if a new date is picked
                setState(() {
                  analyse = pickedDate;
                });
              }
            },
            onSaved: (String? value) {
              analyse = value != null ? DateTime.parse(value) : null;
            },
          )
        : SizedBox.shrink();
  }


  Widget _buildDateProposition() {
    return showProposition
        ? TextFormField(
            decoration: InputDecoration(
              hintText: 'Veuillez entrer la date de la proposition',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue, // Change the border color when focused
                  width: 2.0, // Adjust the border width as needed
                ),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.0, // Set the desired font size for the hint text
            ),
            readOnly: true, // Make the field read-only
            controller: TextEditingController(
              // Use a TextEditingController to display the selected date
              text: proposition == null ? '' : DateFormat('yyyy-MM-dd').format(proposition!),
            ),
            onTap: () async {
              // Show the date picker dialog
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null && pickedDate != proposition) {
                // Update the selected date if a new date is picked
                setState(() {
                  proposition = pickedDate;
                });
              }
            },
            onSaved: (String? value) {
              proposition = value != null ? DateTime.parse(value) : null;
            },
          )
        : SizedBox.shrink();
  }


  Widget _buildNegociation() {
    return showNegociation
        ? TextFormField(
            decoration: InputDecoration(
              hintText: 'Veuillez entrer la Date de la conclusion',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue, // Change the border color when focused
                  width: 2.0, // Adjust the border width as needed
                ),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.0, // Set the desired font size for the hint text
            ),
            readOnly: true, // Make the field read-only
            controller: TextEditingController(
              // Use a TextEditingController to display the selected date
              text: conclusion == null ? '' : DateFormat('yyyy-MM-dd').format(conclusion!),
            ),
            onTap: () async {
              // Show the date picker dialog
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null && pickedDate != conclusion) {
                // Update the selected date if a new date is picked
                setState(() {
                  conclusion = pickedDate;
                });
              }
            },
            onSaved: (String? value) {
              conclusion = value != null ? DateTime.parse(value) : null;
            },
          )
        : SizedBox.shrink();
  }


  Widget _buildDateConclusion() {
    return showConclusion
        ? TextFormField(
            decoration: InputDecoration(
              hintText: 'Veuillez entrer la Date de la conclusion',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue, // Change the border color when focused
                  width: 2.0, // Adjust the border width as needed
                ),
              ),
            ),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.0, // Set the desired font size for the hint text
            ),
            readOnly: true, // Make the field read-only
            controller: TextEditingController(
              // Use a TextEditingController to display the selected date
              text: conclusion == null ? '' : DateFormat('yyyy-MM-dd').format(conclusion!),
            ),
            onTap: () async {
              // Show the date picker dialog
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null && pickedDate != conclusion) {
                // Update the selected date if a new date is picked
                setState(() {
                  conclusion = pickedDate;
                });
              }
            },
            onSaved: (String? value) {
              conclusion = value != null ? DateTime.parse(value) : null;
            },
          )
        : SizedBox.shrink();
  }

  Widget _buildAffairePerdu(){
      return DropdownButtonFormField(
            decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue, // Change the border color when focused
                      width: 2.0, // Adjust the border width as needed
                    ),
                  ),
                ),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.0, // Set the desired font size for the hint text
            ),
            value: '-1',
            items: [
              DropdownMenuItem(child: Text('Veuillez selectionner l\'état',style: TextStyle(fontFamily: 'Inter',color: Colors.grey[600])), value: '-1',),
              DropdownMenuItem(child: Text('Oui',style: TextStyle(fontFamily: 'Inter',color: Colors.black)), value: '1',),
              DropdownMenuItem(child: Text('Non',style: TextStyle(fontFamily: 'Inter',color: Colors.black)), value: '0',),
            ],
            validator: (String? value) {
              if (value == null || value=='-1') {
                return 'L\'état is Required';
              }
              return null;
            },
            onSaved: (String? value) {
              affaire_perdue = value ?? '';
            },
            onChanged: (String? value) {
                affaire_perdue = value ?? '';
            },
          );
    }
  Widget _buildDesciption() {
      return Container(
        constraints: BoxConstraints(
          minHeight: 50, // Set a minimum height for the input
          maxHeight: 200, // Set a maximum height for the input
        ),
        child: TextField(
          controller: TextEditingController(),
          enabled: true,
          onChanged: (value) {
            description = value; // Update the description variable when the input changes
          },
          decoration: InputDecoration(
            hintText: 'Entrer une description',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue, // Change the border color when focused
                width: 2.0, // Adjust the border width as needed
              ),
            ),
          ),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.0, // Set the desired font size for the text
          ),
          minLines: 1, // Set minimum number of lines (1 for single-line input)
          maxLines: null, // Set maxLines to null for auto-expanding input
        ),
      );

    }


  bool isExpanded1 = false;
  Widget section1() {
    return Theme(
      data: Theme.of(context).copyWith(
        // Set highlightColor and splashColor to transparent to remove the grey background effect
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent, // Set hoverColor to transparent
      ),
      child: ExpansionTile(
        title: Text('Information du client'),
        onExpansionChanged: (value) {
          setState(() {
            isExpanded1 = value;
          });
        },
        children: [
          if (isExpanded1)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Align widgets to the left
                  children: [
                    SizedBox(width: 5,),
                    Text(
                      'N° de client',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14, // Adjust the font size as needed
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                _buildClient(),
                SizedBox(height: 20,),
                SizedBox(width: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Align widgets to the left
                  children: [
                    SizedBox(width: 5,),
                    Text(
                      'Type de client',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14, // Adjust the font size as needed
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                _buildType(),
              ],
            ),
        ],
      ),
    );
  }

  bool isExpanded2 = false;
  Widget section2() {
    return Theme(
      data: Theme.of(context).copyWith(
        // Set highlightColor and splashColor to transparent to remove the grey background effect
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent, // Set hoverColor to transparent
      ),
      child: ExpansionTile(
        title: Text('Information de la visite'),
        onExpansionChanged: (value) {
          setState(() {
            isExpanded2 = value;
          });
        },
        children: [
          if (isExpanded2)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Align widgets to the left
                    children: [
                      SizedBox(width: 5,),
                      Text(
                        'Date de visite',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14, // Adjust the font size as needed
                        ),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  _buildDateVisite(),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Align widgets to the left
                    children: [
                      SizedBox(width: 5,),
                      Text(
                        'Type de visite',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14, // Adjust the font size as needed
                        ),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  _buildVisite(),
                  SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Align widgets to the left
                  children: [
                    SizedBox(width: 5,),
                    Text(
                      'Conclusion dans',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14, // Adjust the font size as needed
                      ),),
                  ],
                ),
                SizedBox(height: 5,),
                _buildDateConclusiodans(),
                SizedBox(height: 20,),
                _buildShowDiagnosticCheckbox(),
                _buildDiagnostic(),
                SizedBox(height: 20,),
                _buildShowAnalyeCheckbox(),
                _buildAnalye(),
                SizedBox(height: 20,),
                _buildShowDatePropositionCheckbox(),
                _buildDateProposition(),
                SizedBox(height: 20,),
                _buildShowNegociationCheckbox(),
                _buildNegociation(),
                SizedBox(height: 20,),
                _buildShowDateConclusionCheckbox(),
                _buildDateConclusion(),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Align widgets to the left
                  children: [
                    SizedBox(width: 5,),
                    Text(
                      'L\'état',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14, // Adjust the font size as needed
                      ),),
                  ],
                ),
                SizedBox(height: 5,),
                _buildAffairePerdu(),
                SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Align widgets to the left
                    children: [
                      SizedBox(width: 5,),
                      Text(
                        'Description',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14, // Adjust the font size as needed
                        ),),
                    ],
                  ),
                SizedBox(height: 5),
                _buildDesciption(),
              ],
            ),
        ],
      ),
    );
  }

  bool isExpanded3 = false;
  Widget section3() {
      return Theme(
        data: Theme.of(context).copyWith(
          // Set highlightColor and splashColor to transparent to remove the grey background effect
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent, // Set hoverColor to transparent

        ),
        child: ExpansionTile(
          title: Text('Information du produit'),
          onExpansionChanged: (value) {
            setState(() {
              isExpanded3 = value;
            });
          },
          children: [
            if (isExpanded3)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Align widgets to the left
                    children: [
                      SizedBox(width: 5,),
                      Text(
                        'Solution',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14, // Adjust the font size as needed
                        ),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  _buildSolution(),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Align widgets to the left
                    children: [
                      SizedBox(width: 5,),
                      Text(
                        'Unité',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14, // Adjust the font size as needed
                        ),),
                    ],
                  ),
                  SizedBox(height: 5,),
                  _buildUnite(),
                ],
              ),
          ],
        ),
      );
    }

  String dropdownValue = 'One';
  @override
  Widget build(BuildContext context) {
    if (widget.token != null) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer une nouvelle visite',style: TextStyle(fontFamily: 'Inter')),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(24,20,24,0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                section1(),
                SizedBox(height: 30),
                section3(),
                SizedBox(height: 30),
                section2(),
                SizedBox(height: 30),
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      _formKey.currentState!.save();
                      String formatDate(DateTime? date) {
                        if (date == null) return '';
                        return DateFormat('yyyy-MM-dd').format(date);
                      }

                      Map<String, dynamic> formData = {
                        'client_id': client_id,
                        'type_client': type_client,
                        'date_visite': formatDate(date_visite),
                        'type_visite': type_visite,
                        'produit_id': solution,
                        'unite': unite,
                        'date_conclusion':formatDate(conclusiondans),
                        'Diagnostic': formatDate(Diagnostic),
                        'analyse': formatDate(analyse),
                        'proposition': formatDate(proposition),
                        'negociation': formatDate(negociation),
                        'conclusion': formatDate(conclusion),
                        'affaire_perdue': affaire_perdue,
                        'description':description,
                      };

                      print(formData);
                      print(widget.token);
                      // Define the URL
                      Uri url = Uri.parse('https://ospc.hashkey.ma/api/visites');

                      // Define the headers with the access token
                      Map<String, String> headers = {
                        'Authorization': 'Bearer ${widget.token}', // Include the access token here
                        'Content-Type': 'application/json', // Set the content type to JSON
                      };

                      // Send a POST request to the API with headers
                      http.post(
                        url,
                        headers: headers, // Include the headers here
                        body: jsonEncode(formData), // Convert formData to JSON format
                      ).then((response) {
                        if (response.statusCode == 200) {
                          // Handle a successful response, e.g., show a success message
                          print('Form submitted successfully');
                          // Navigate to the "home2" page here
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => Home2(token: widget.token), // Pass the token to the "home2" page
                          ));
                        } else {
                          // Handle errors here, e.g., show an error message
                          print('Error submitting the form. Status code: ${response.statusCode}');
                          print('Error message: ${response.body}');
                          // error message if applicable
                          final errorData = jsonDecode(response.body);
                          print('Error message: ${errorData['message']}');
                        }
                      }).catchError((error) {
                        // Handle errors that occur during the request, e.g., network errors
                        print('Error sending the request: $error');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[800], // Set the background color to blue
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24), // Adjust padding as needed
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8), // Set your desired top and bottom padding
                      child: Text(
                        'Ajouter',
                        style: TextStyle(
                          fontFamily: 'Inter', // Set the font family to Inter
                          fontSize: 16,
                          color: Colors.white, // Set the text color to white
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }else {
      return LoginPage();
    }
  }
}