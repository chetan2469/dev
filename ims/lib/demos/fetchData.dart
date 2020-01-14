import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FetchData extends StatefulWidget {
  @override
  _FetchDataState createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  List<Fact> list = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
  }

  void fetch() async {
    String link = "http://numbersapi.com/";

    for (var i = 0; i < 5; i++) {
      final response = await http.get(link + "" + i.toString());

      setState(() {
        list.add(Fact(num: i, info: response.body.toString()));
      });
      print('.');
    }

    List jsonList = Fact.encondeToJson(list);
      print("numFact: ${jsonList}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text(list[index].num.toString()),
              title: Text(list[index].info),
            );
          },
        ),
      ),
    );
  }
}

class Fact {
  final int num;
  final String info;

  Fact({this.num, this.info});

  Map<String, dynamic> toJson() {
    return {
      "num": this.num,
      "info": this.info,
    };
  }

  static List encondeToJson(List<Fact> list) {
    List jsonList = List();
    list.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }
}
