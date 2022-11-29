import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_provider/helpers/db_helper.dart';
import 'package:flutter_shopping_cart_provider/models/cart_model.dart';

import 'package:flutter_shopping_cart_provider/providerState/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
// Initialize the created DB
// for the issue of NULL safety
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
//  Call Provider Package
    final providerForCart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
        actions: [
          Center(
            child: Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(
// '0',
                    value.getCounter().toString(),
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
              animationDuration: const Duration(milliseconds: 300),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
// const Icon(Icons.shopping_bag_outlined),
          ),
          const SizedBox(
            width: 20.8,
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: providerForCart.getCartData(),
            builder: ((context, AsyncSnapshot<List<CartModel>> snapshot) {
              if (snapshot.hasData) {
//  Start
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: ((context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    (index + 1).toString(),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Image(
                                    height: 100,
                                    width: 100,
                                    image: NetworkImage(
                                        snapshot.data![index].image.toString()),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
// Column(
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data![index].productName
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                print('delete icon');
                                                dbHelper!.deleteProduct(
                                                    snapshot.data![index].id!);
// After delete
                                                providerForCart.removeCounter();
                                                providerForCart
                                                    .removeTotalPrice(
                                                        double.parse(snapshot
                                                            .data![index]
                                                            .productPrice
                                                            .toString()));
                                              },
                                              child: const Icon(
                                                  Icons.delete_forever),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          snapshot.data![index].unitTag
                                                  .toString() +
                                              " " +
                                              r"$" +
                                              snapshot.data![index].productPrice
                                                  .toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),

// update to cart
// Container(
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {
                                              print('Tap Cart Btn');
                                            },
                                            child: Container(
                                              height: 35,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      child: const Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                      ),
                                                      onTap: () {
                                                        int quantity = snapshot
                                                            .data![index]
                                                            .quantity!;
                                                        int price = snapshot
                                                            .data![index]
                                                            .initialPrice!;
                                                        quantity--;
                                                        int? newPrice =
                                                            price * quantity;

                                                        if (quantity > 0) {
                                                          dbHelper!
                                                              .updateQuantity(
                                                                  CartModel(
                                                            id: snapshot
                                                                .data![index]
                                                                .id!,
                                                            productId: snapshot
                                                                .data![index]
                                                                .id!
                                                                .toString(),
                                                            productName: snapshot
                                                                .data![index]
                                                                .productName!
                                                                .toString(),
                                                            initialPrice: snapshot
                                                                .data![index]
                                                                .initialPrice!,
                                                            productPrice:
                                                                newPrice,
                                                            quantity: quantity,
                                                            unitTag: snapshot
                                                                .data![index]
                                                                .unitTag
                                                                .toString(),
                                                            image: snapshot
                                                                .data![index]
                                                                .image
                                                                .toString(),
                                                          ))
                                                              .then((value) {
                                                            newPrice = 0;
                                                            quantity = 0;
                                                            providerForCart.removeTotalPrice(
                                                                double.parse(snapshot
                                                                    .data![
                                                                        index]
                                                                    .initialPrice!
                                                                    .toString()));
                                                          }).onError((error,
                                                                  StackTrace) {
                                                            print(
                                                                'Update Err remove-> ${error.toString()}');
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data![index].quantity
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        int quantity = snapshot
                                                            .data![index]
                                                            .quantity!;
                                                        int price = snapshot
                                                            .data![index]
                                                            .initialPrice!;
                                                        quantity++;
                                                        int? newPrice =
                                                            price * quantity;
                                                        dbHelper!
                                                            .updateQuantity(
                                                                CartModel(
                                                          id: snapshot
                                                              .data![index].id!,
                                                          productId: snapshot
                                                              .data![index].id!
                                                              .toString(),
                                                          productName: snapshot
                                                              .data![index]
                                                              .productName!
                                                              .toString(),
                                                          initialPrice: snapshot
                                                              .data![index]
                                                              .initialPrice!,
                                                          productPrice:
                                                              newPrice,
                                                          quantity: quantity,
                                                          unitTag: snapshot
                                                              .data![index]
                                                              .unitTag
                                                              .toString(),
                                                          image: snapshot
                                                              .data![index]
                                                              .image
                                                              .toString(),
                                                        ))
                                                            .then((value) {
                                                          newPrice = 0;
                                                          quantity = 0;
                                                          providerForCart.addTotalPrice(
                                                              double.parse(snapshot
                                                                  .data![index]
                                                                  .initialPrice!
                                                                  .toString()));
                                                        }).onError((error,
                                                                StackTrace) {
                                                          print(
                                                              'Update Err-> ${error.toString()}');
                                                        });
                                                      },
                                                      child: const Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                );

// End
              }
              return const Text('');
            }),
          ),
//  Add Reusable Widget
          Consumer<CartProvider>(builder: (context, value, child) {
            return Visibility(
              visible: value.getTotalPrice().toStringAsFixed(2) == "0.00"
                  ? false
                  : true,
              child: Column(
                children: [
                  ReusableWidget(
                    title: 'Sub Total',
                    value: r'$' + value.getTotalPrice().toStringAsFixed(2),
                  ),
                  const ReusableWidget(
                    title: 'Discout 5%',
                    value: r'$' '20',
                  ),
                  ReusableWidget(
                    title: 'Total',
                    value: r'$' + value.getTotalPrice().toStringAsFixed(2),
                  )
                ],
              ),
            );
          }),
// Reusable Widget End
        ],
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
// padding: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const Spacer(),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const SizedBox(
            height: 20.8,
          ),
        ],
      ),
    );
  }
}
