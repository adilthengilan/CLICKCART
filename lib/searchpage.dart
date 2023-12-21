import 'package:clickcart/detailPage.dart';
import 'package:clickcart/functions/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
                  data.filterProducts(value);
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
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<fetchDatas>(context);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.filteredProducts.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            data.currentindex = index;
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(),
                ));
          },
          child: ListTile(
            title: Text(data.filteredProducts[index]['title']),
            subtitle: Text('\$${data.filteredProducts[index]['price']}'),
            leading: Container(
                height: 50,
                width: 50,
                child:
                    Image.network(data.filteredProducts[index]['thumbnail'])),
          ),
        );
      },
    );
  }
}
