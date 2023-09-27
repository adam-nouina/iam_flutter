import 'package:flutter/material.dart';
import 'package:iam/components/CircleNumberWidget.dart';
import 'package:iam/components/infocard2.dart';
import 'package:iam/constants.dart';
import 'package:iam/pages/form_screen.dart';
import 'package:iam/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // Import for JSON parsing

class Home2 extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final token;
  const Home2({@required this.token, Key? key}) : super(key: key);

  @override
  State<Home2> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<Home2> {

  List<Map<String, dynamic>> responseData = [];
  int visibleItemCount  = 10; // Number of items to display initially
  int totalItemCount = 0; // Total number of items available

  // Function to fetch data from the API and update cardData2
  Future<void> _fetchDataFromAPI() async {
      final apiUrl = 'https://ospc.hashkey.ma/api/visites';
      final headers = {
        'Authorization': 'Bearer ${widget.token}',
      };

      try {
        final response = await http.get(Uri.parse(apiUrl), headers: headers);

        if (response.statusCode == 200) {
          final List<dynamic> apiData = json.decode(response.body)['visites'];

          setState(() {
            responseData = apiData.cast<Map<String, dynamic>>();
            totalItemCount = responseData.length;
          });
        } else {
          print('Failed to fetch data. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }
    }

  final ScrollController _scrollController = ScrollController();

  String _searchQuery = ''; // Store the search query
  List<Map<String, dynamic>> _filteredData = []; // Store the filtered data

  bool _isSearching = false; // Flag to track whether a search is in progress

  Future<void> _fetchData() async {
    if (!_isSearching) {
      // Fetch more data when not in search mode
      await _fetchDataFromAPI();
    }
  }

  @override
  void initState() {
    super.initState();
    String token = widget.token;

    // Fetch data from the API when the widget initializes
    _fetchDataFromAPI();

    // Attach a listener to the scroll controller to detect when the user reaches the end of the list
    _scrollController.addListener(() {
      if (!_isSearching && _scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // User has scrolled to the end, load more data
        _fetchData();
      }
    });
  }

  // Function to filter data based on the search query
  void _filterData(String query) {
    setState(() {
      _searchQuery = query;
      _filteredData = responseData
          .where((data) =>
          data['client']['numero_client'].toLowerCase().contains(query.toLowerCase()) ||
          data['date_visite'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
    // Update the searching flag based on whether a search is in progress
    _isSearching = query.isNotEmpty;
  }

  void logoutUserAndNavigateToLogin() async {
    // Clear the user's token or session
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token'); // Replace 'token' with the key used to store the token

    // Navigate to the login page
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LoginPage(),
    ));
  }

  // Function to load more items
  void _loadMoreItems() {
    setState(() {
      visibleItemCount  += 10; // Increase the number of items to display
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.token != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          centerTitle: false,
          title: TextField(
            onChanged: _filterData,
            decoration: InputDecoration(
              hintText: 'Recherche',
              border: InputBorder.none,
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor: Colors.grey[300],
          elevation: 0,
          child: Column(
            children: [
              DrawerHeader(
                child: Image.asset(
                  'images/logo.png',
                  width: 90, // Set the width and height as needed
                  height: 90,
                ),
              ),
              Padding(
                padding: tilePadding,
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                    'A B O U T',
                    style: drawerTextColor,
                  ),
                ),
              ),
              Padding(
                padding: tilePadding,
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    'L O G O U T',
                    style: drawerTextColor,
                  ),
                  onTap: () {
                    // navigate to the login page
                    logoutUserAndNavigateToLogin();
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FormScreen(token: widget.token)),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue[800],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleNumberWidget(number: 30,
                      text: 'Visite\nConclus',
                      ),
                  CircleNumberWidget(number: 22,
                      text: 'Visite\nen cours',
                      ),
                  CircleNumberWidget(number: 34,
                      text: 'Visite\nNon conclus',
                      ),
                  CircleNumberWidget(number: 49,
                      text: 'Affaire\nPerdus',
                      ),
                ],
              ),
            ),
        Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: (_isSearching ? _filteredData.length : responseData.length) < visibleItemCount
                    ? (_isSearching ? _filteredData.length : responseData.length)
                    : visibleItemCount, // Display up to `visibleItemCount` items
                itemBuilder: (context, index) {
                  final data = _isSearching
                      ? _filteredData[index]
                      : responseData[index];

                  return Column(
                    children: [
                      InfoCard2(
                        textData1: data['client']['numero_client'],
                        textData2: data['date_visite'],
                        idVisite: data['id'],
                        token: widget.token,
                      ),
                      Container(
                        height: 1.0,
                        color: Colors.grey[300],
                      ),
                      if (index == visibleItemCount - 1 &&
                          visibleItemCount < (_isSearching ? _filteredData.length : responseData.length))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextButton(
                            onPressed: _loadMoreItems,
                            child: Text('Afficher plus'),
                          ),
                        ),
                    ],
                  );
                },
              )
            ),
          ],
        ),
      );
    } else {
      // Redirect the user to the login page
      return LoginPage();
    }
  }
}