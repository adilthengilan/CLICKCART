import 'package:clickcart/Model/collections.dart';
import 'package:clickcart/View/detailPage.dart';
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

class SearchList extends StatefulWidget {
  const SearchList({super.key});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  Collections filter = Collections();
  @override
  Widget build(BuildContext context) {
    final filter = Provider.of<fetchDatas>(context);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: filter.filteredProducts.length,
      itemBuilder: (context, index) {
        final filters = filter.filteredProducts[index];
        return GestureDetector(
          onTap: () {
            // collections.currentindex = index;
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => DetailPage(),
            //     ));
          },
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                        Name: filters.title,
                        Price: filters.price,
                        Rating: filters.rating,
                        Description: filters.description,
                        Brand: filters.brand,
                        Category: filters.category,
                        Discount: filters.discountPercentage,
                        Stock: filters.stock,
                        id: filters.id,
                        thumbnail: filters.thumbnail,
                        Images: filters.images),
                  ));
            },
            child: ListTile(
              title: Text(filter.filteredProducts[index].title),
              subtitle: Text('\$${filter.filteredProducts[index].price}'),
              leading: Container(
                  height: 50,
                  width: 50,
                  child:
                      Image.network(filter.filteredProducts[index].thumbnail)),
            ),
          ),
        );
      },
    );
  }
}
