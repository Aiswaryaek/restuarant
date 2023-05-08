// ignore_for_file: prefer_const_constructors, prefer_adjacent_string_concatenation

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/ui_state.dart';
import '../../models/category_model.dart';
import '../../provider/dishes_provider.dart';
import '../../provider/google_sign_in.dart';
import '../../repositories/category_repositories.dart';
import '../../styles/colors.dart';
import '../../styles/textstyles.dart';
import '../../utilities/shared_preferences.dart';
import '../auth/user_auth.dart';
import '../order/checkout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<_HomeScreenState> _homeScreenState = GlobalKey<_HomeScreenState>();
  DishesProvider dishesProvider =
  DishesProvider(categoryRepository: CategoryRepository());
  List<Cart> _cart = [];
  final user = FirebaseAuth.instance.currentUser;
  int selectedIndex = 0;
  var dishes;

  void _addToCart(id) {
    dynamic index = _cart.indexWhere((item) => item.id == id);
    if (index != -1) {
      _cart[index].qty = (_cart[index].qty! + 1);
    } else {
      _cart.add(Cart(id: id, qty: 1));
    }
    setState(() {
      _cart = _cart;
    });
    setCartData(_cart);
  }

  void _removeFromCart(id) {
    dynamic index = _cart.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (_cart[index].qty! > 1) {
        _cart[index].qty = (_cart[index].qty! - 1);
      } else {
        _cart.removeWhere((item) => item.id == id);
      }
      setState(() {
        _cart = _cart;
      });
      setCartData(_cart);
    }
  }

  int? _getCartProductQty(dynamic id) {
    dynamic index = _cart.indexWhere((item) => item.id == id);
    if (index != -1) {
      return _cart[index].qty;
    } else {
      return 0;
    }
  }

  List<CategoryDish> _getProducts(data) {
    List<CategoryDish> products = [];
    for (var item in data) {
      products = [...products, ...?item.categoryDishes];
    }
    return products;
  }

  setCartData(_cart) async {
    dynamic data = jsonEncode(_cart);
    await setValue('cart', data);
    getCartData();
  }

  getCartData() async {
    String data = await getValue('cart');
    dynamic cartData = jsonDecode(data) ?? [];
    setState(() {
      _cart = cartData.cast<Cart>();
    });
  }

  @override
  void initState() {
    super.initState();
    dishesProvider.checkGetDishes();
    getCartData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: whiteColor,
            drawer: Drawer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 188,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(10),
                            ),
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: const [
                                  greenLeftDrawerColor,
                                  greenRightDrawerColor
                                ])),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 33,
                              backgroundImage: NetworkImage(
                                  '${user?.photoURL}'),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${user?.displayName}',
                              style: drawerText,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'ID :' + '${user?.uid}',
                              style: categoryText,
                            )
                          ],
                        )),
                    SizedBox(
                      height: 25,
                    ),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(left: 25),
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: grayColor,
                              size: 24,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              'Logout',
                              style: subHeadText,
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        final provider = Provider.of<GoogleSignInProvider>(context,listen:false);
                        provider.logout();
                        await FirebaseAuth.instance.signOut();
                      },
                    )
                  ],
                )),
            appBar: AppBar(
              backgroundColor: whiteColor,
              elevation: 0,
              iconTheme: IconThemeData(
                size: 25, //change size on your need
                color: drawerColor, //change color on your need
              ),
              actions: <Widget>[
                _cart.length == 0
                    ? IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: drawerColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            CheckoutScreen(
                                cartList: _cart,
                                products: _getProducts(dishes),key: _homeScreenState),
                      ),
                    );
                  },
                )
                    : InkWell(
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            color: drawerColor,
                          ),
                          Positioned(
                            top: 1,
                            right: -2,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${_cart.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 17,
                      )
                    ],
                  ),
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            CheckoutScreen(
                                cartList: _cart,
                                products: _getProducts(dishes),key: _homeScreenState),
                      ),
                    );
                  },
                ),
                SizedBox(
                  width: 7,
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  dishWidget(),
                  categoryDishesWidget(),
                ],
              ),
            )));
  }

  Widget categoryDishesWidget() {
    return ChangeNotifierProvider<DishesProvider>(
      create: (ctx) {
        return dishesProvider;
      },
      child: Consumer<DishesProvider>(
        builder: (ctx, data, _) {
          var state = data.getDishesLiveData().getValue();
          // print(data.list);
          if (state is IsLoading) {
            return SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 1.3,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            );
          } else if (state is Initial) {
            return Center(
              child: Text('Items cannot be found'),
            );
          } else if (state is Success) {
            return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // scrollDirection: Axis.horizontal,
                itemCount: data.list[selectedIndex].categoryDishes!.length,
                separatorBuilder: (context, _) =>
                    Divider(
                      thickness: 0,
                      color: grayColor,
                    ),
                itemBuilder: (context, index) {
                  dishes = data.list;
                 return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          onTap: () {
                            //
                          },
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 0.0),
                          leading: Padding(
                            padding: EdgeInsets.only(left: 13),
                            child: Image.network(
                              // data.dishList[index].dishImage,
                                'https://qph.cf2.quoracdn.net/main-qimg-5667b229acf7393e62465dcd05c237f4.webp',
                                height: 15,
                                width: 15,
                                fit: BoxFit.contain),
                          ),
                          title: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Transform.translate(
                              offset: Offset(-22, -6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.list[selectedIndex]
                                        .categoryDishes?[index].dishName,
                                    style: subHeadText,
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'INR ' +
                                            '${data.list[selectedIndex]
                                                .categoryDishes?[index]
                                                .dishPrice}',
                                        style: subHeadText,
                                      ),
                                      Text(
                                          '${data.list[selectedIndex]
                                              .categoryDishes?[index]
                                              .dishCalories}' +
                                              ' calories',
                                          style: calorieText)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Transform.translate(
                              offset: Offset(-22, -6),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      Expanded(
                                        child: Text(
                                          data
                                              .list[selectedIndex]
                                              .categoryDishes?[index]
                                              .dishDescription,
                                          overflow: TextOverflow.fade,
                                          // style: index == 0  ? orderInProgress:
                                          // index == 1 ? orderDelivered :
                                          // orderCancel,
                                          style: categorySubtitleText,
                                        ),
                                      ),
                                      // Text(
                                      //   '',
                                      //   style: deliveryDateText,
                                      // )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // trailing: Transform.translate(
                          //   offset: Offset(-14, 0),
                          //   child: Image.network(
                          //       data.list[selectedIndex].categoryDishes?[index].nexturl,
                          //       // height: 82,
                          //       // width: 82,
                          //       fit: BoxFit.cover),
                          // ),
                          visualDensity: VisualDensity(vertical: 4),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30, bottom: 10),
                          child: Container(
                            width: 115,
                            height: 35,
                            decoration: BoxDecoration(
                              color: greenButtonColor,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: greenButtonColor,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                Center(
                                  child: IconButton(
                                    icon: Icon(Icons.remove,
                                        color: whiteColor, size: 17),
                                    onPressed: () {
                                      // int id = data.dishList[selectedIndex]?.dishId
                                      _removeFromCart(data.list[selectedIndex]
                                          .categoryDishes?[index].dishId);
                                    },
                                  ),
                                ),
                                Text(
                                  '${_getCartProductQty(data.list[selectedIndex]
                                      .categoryDishes?[index].dishId)}',
                                  style: countStyle,
                                ),
                                Center(
                                  child: IconButton(
                                    icon: Icon(Icons.add,
                                        color: whiteColor, size: 17),
                                    onPressed: () {
                                      _addToCart(data.list[selectedIndex]
                                          .categoryDishes?[index].dishId);
                                      print(_cart);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        data.list[selectedIndex].categoryDishes?[index]
                            .addonCat ==
                            []
                            ? SizedBox()
                            : Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            'Customizations Available',
                            style: customisationText,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ]);
                });
          } else if (state is Failure) {
            return SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  'No Dishes Found!!',
                  style: categoryText,
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget dishWidget() {
    return ChangeNotifierProvider<DishesProvider>(
      create: (ctx) {
        return dishesProvider;
      },
      child: Consumer<DishesProvider>(
        builder: (ctx, data, _) {
          var state = data.getDishesLiveData().getValue();
          if (state is IsLoading) {
            return SizedBox(
              child: Center(
                child: LinearProgressIndicator(
                  color: Colors.green,
                ),
              ),
            );
          } else if (state is Initial) {
            return Center(
              child: Text('Items cannot be found'),
            );
          } else if (state is Success) {
            return Card(
              elevation: 1,
              child: SizedBox(
                height: 45,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.list.length,
                    separatorBuilder: (context, _) => const SizedBox(width: 3),
                    itemBuilder: (context, index) {
                      return Container(
                          decoration: BoxDecoration(
                              color: whiteColor,
                              border: Border.all(color: whiteColor),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(4))),
                          height: 14,
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(3),
                                elevation: 0,
                                // primary: pressAttention ? Colors.grey : Colors.blue,
                                primary: whiteColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(4), // <-- Radius
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${data.list[index].menuCategory}',
                                    style: selectedIndex == index
                                        ? dishCategoriesText
                                        : unSeletedDishCategoryText,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  selectedIndex == index
                                      ? Container(
                                    height: 2,
                                    color: selectedIndex == index
                                        ? menuSelection
                                        : whiteColor,
                                    child: Text(
                                      '${data.list[index].menuCategory}',
                                      style: TextStyle(
                                          color: selectedIndex == index
                                              ? menuSelection
                                              : whiteColor),
                                    ),
                                  )
                                      : SizedBox()
                                ],
                              )));
                    }),
              ),
            );
          } else if (state is Failure) {
            return SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  'No Dishes Found!!',
                  style: categoryText,
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class Cart {
  String? id;
  int? qty;

  Cart({this.id, this.qty});
}
