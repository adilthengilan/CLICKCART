import 'package:clickcart/Model/collections.dart';
import 'package:clickcart/View/search_page/seach_list.dart';
import 'package:clickcart/ViewModel/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Collections collections = Collections();

  final TextEditingController Searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final filter = Provider.of<fetchDatas>(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 249, 244, 244),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 14, left: 20),
              height: 40,
              width: MediaQuery.of(context).size.width / 1.11,
              child: TextField(
                onChanged: (value) {
                  filter.filtering(value);
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close)),
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.only(top: 10, left: 10),
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                controller: Searchcontroller,
              )),
          SizedBox(
            child: SearchList(),
            height: MediaQuery.of(context).size.height / 1.2,
            width: double.infinity,
          )
        ],
      ),
    );
  }

  // void filterSearchResults(String query) {
  //   setState(() {
  //     filtereditems = Provider.of<fetchDatas>(context)
  //         .products
  //         .where((item) => item.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   });
  // }
}
