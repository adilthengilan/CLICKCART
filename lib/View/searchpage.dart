import 'package:clickcart/Model/collections.dart';
import 'package:clickcart/View/detailPage.dart';
import 'package:clickcart/ViewModel/filter.dart';
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
    Filter filter = Filter();

  final TextEditingController Searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<fetchDatas>(context);
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
                  filter.filterProducts(value);
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.only(top: 10, left: 10),
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                controller: Searchcontroller,
              )),
          SizedBox(
            child: SearchList(),
            height: 600,
            width: 300,
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

class SearchList extends StatefulWidget {
  const SearchList({super.key});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  Collections collections = Collections();
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<fetchDatas>(context);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: collections.filteredProducts.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            collections.currentindex = index;
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => DetailPage(),
            //     ));
          },
          child: ListTile(
            title: Text(collections.filteredProducts[index]['title']),
            subtitle: Text('\$${collections.filteredProducts[index]['price']}'),
            leading: Container(
                height: 50,
                width: 50,
                child:
                    Image.network(collections.filteredProducts[index]['thumbnail'])),
          ),
        );
      },
    );
  }
}
