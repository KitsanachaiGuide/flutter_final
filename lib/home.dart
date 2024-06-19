import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homegame extends StatefulWidget {
  const Homegame({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomegameState();
  }
}

class _HomegameState extends State<Homegame> {
  List<dynamic> _attractions = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchAttractions();
  }

  Future<void> _fetchAttractions() async {
    try {
      final response = await http.get(
          Uri.parse('https://api.jsonbin.io/v3/b/6669561be41b4d34e4022e42'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _attractions = data['record'].map((attraction) {
            return {
              ...attraction,
              'hovered': false,
              'favorited': false,
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Game'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_hasError) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Game'),
        ),
        body: const Center(
          child: Text('Error loading attractions.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Game'),
      ),
      body: ListView.builder(
        itemCount: _attractions.length,
        itemBuilder: (context, index) {
          final attraction = _attractions[index];
          return MouseRegion(
            onEnter: (event) => setState(() => attraction['hovered'] = true),
            onExit: (event) => setState(() => attraction['hovered'] = false),
            child: Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    spreadRadius: 4.0,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      attraction['coverimage'],
                      width: double.infinity,
                      height: 250.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (attraction['hovered'] == true)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.black.withOpacity(0.6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                attraction['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                attraction['detail'],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    top: 10.0,
                    right: 10.0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          attraction['favorited'] = !attraction['favorited'];
                        });
                      },
                      child: Icon(
                        attraction['favorited']
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            attraction['favorited'] ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
