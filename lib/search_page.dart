import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

//
// String url = 'https://en.wikipedia.org/w/api.php?action=query&prop=revisions&rvprop=content&titles=rainbow_flag&format=json';
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String text;
  StreamController _streamController;
  Stream _stream;
  TextEditingController _controller = TextEditingController();
  Map<String, dynamic> data;
   var userData;
  Future getData() async {
    http.Response response = await http.get('https://en.wikipedia.org/api/rest_v1/page/summary/$text');
    setState(() {
      data = jsonDecode(response.body);
      userData = data;
    });
    print(userData['extract']);
    print(userData['thumbnail']['source']);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Wikipedia'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(45),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 12, bottom: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24)),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        print(value.replaceAll(RegExp(r"\s"), "_"));
                        text = value.replaceAll(RegExp(r"\s"), "_");
                      });
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(32),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(32),
                          ),
                        ),
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: Colors.pink,
                        ),
                        suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                             getData();
                            }),
                        hoverColor: Colors.yellow,
                        filled: true,
                        focusColor: Colors.yellow),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount:  userData == null ? 0 : 1,
          itemBuilder: (BuildContext context,int index){
        return Column(
          children: [
            Image.network(userData['thumbnail']['source'],height: 200,width: 200,),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(userData['extract'],style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.left,),
            ),
          ],
        );
      })
    );
  }
}
