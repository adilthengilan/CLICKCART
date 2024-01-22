import 'package:clickcart/Model/collections.dart';
import 'package:clickcart/View/detailPage.dart';
import 'package:clickcart/ViewModel/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



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
