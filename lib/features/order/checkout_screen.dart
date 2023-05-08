// ignore_for_file: prefer_const_constructors, unnecessary_new, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:restaurant/models/category_model.dart';

import '../../styles/colors.dart';
import '../../styles/textstyles.dart';
import '../home/home_page.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Cart> cartList;
  final List<CategoryDish> products;
  CheckoutScreen({Key? key, required this.cartList, required this.products})
      : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int? index;


  _getTotalAmount(){
    double totalAmount = 0;
    for(var item in widget.cartList){
      totalAmount += _getTotalItemPrice(item.id,item.qty);
    }
    return totalAmount;
  }

  double _getTotalItemPrice(id, qty) {
    int index = widget.products.indexWhere((element) => element.dishId == id);
    if (index != -1) {
      CategoryDish product = widget.products[index];
      return product.dishPrice * qty;
    }
    return 0;
  }

  _getProductByField(id, field) {
    int index = widget.products.indexWhere((element) => element.dishId == id);
    if (index != -1) {
      CategoryDish product = widget.products[index];
      switch (field) {
        case 'dishName':
          return product.dishName;
        case 'dishPrice':
          return product.dishPrice;
        case 'dishCalories':
          return product.dishCalories;
      }
    }
  }

  _getItemCount() {
    int totalItems = 0;
    for (var item in widget.cartList) {
      totalItems += item.qty!;
    }
    return totalItems;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: widget.cartList.length == 0?Scaffold(
            appBar: AppBar(
              backgroundColor: whiteColor,
              elevation: 1,
              iconTheme: const IconThemeData(
                size: 25, //change size on your need
                color: drawerColor, //change color on your need
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: grayColor),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                'Order Summary',
                style: appBarText,
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text('Cart is Empty',style: subHeadText,textAlign: TextAlign.center,),)
              ],
            )):Scaffold(
            appBar: AppBar(
              backgroundColor: whiteColor,
              elevation: 1,
              iconTheme: const IconThemeData(
                size: 25, //change size on your need
                color: drawerColor, //change color on your need
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: grayColor),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                'Order Summary',
                style: appBarText,
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(3, 3, 3, 3),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: checkoutButtonColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                            '${widget.cartList.length} Dishes - ${_getItemCount()} Items',
                            style: btnTextStyle,
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.cartList.length,
                        separatorBuilder: (context, _) => Divider(
                          thickness: 0,
                          color: grayColor,
                        ),
                        itemBuilder: (context, index) => ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 0.0),
                          leading: Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Image.network(
                                'https://qph.cf2.quoracdn.net/main-qimg-5667b229acf7393e62465dcd05c237f4.webp',
                                height: 15,
                                width: 15,
                                fit: BoxFit.contain),
                          ),
                          title: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Transform.translate(
                                offset: Offset(-26, -6),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _getProductByField(
                                            widget.cartList[index].id,
                                            'dishName'),
                                        style: calorieText,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                    SizedBox(width: 1),
                                    Container(
                                      width: 96,
                                      height: 29,
                                      decoration: BoxDecoration(
                                        color: checkoutButtonColor,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: checkoutButtonColor,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Center(
                                            child: InkWell(
                                              child: Icon(Icons.remove,
                                                  color: whiteColor, size: 16),
                                              onTap: () {
                                                // widget._homeScreenState.currentState._removeFromCart(widget.cartList[index].id);
                                              },
                                            ),
                                          ),
                                          Text(
                                            '${widget.cartList[index].qty}',
                                            style: countStyle,
                                          ),
                                          Center(
                                            child: InkWell(
                                              child: Icon(Icons.add,
                                                  color: whiteColor, size: 16),
                                              onTap: () {
                                                // widget.key.currentState._addToCart(widget.cartList[index].id);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                        'INR ' +
                                            '${_getTotalItemPrice(widget.cartList[index].id, widget.cartList[index].qty)}',
                                        style: calorieText)
                                  ],
                                )),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Transform.translate(
                              offset: Offset(-22, -6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'INR ' +
                                        '${_getProductByField(widget.cartList[index].id, 'dishPrice')}',
                                    style: inrText,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    '${_getProductByField(widget.cartList[index].id, 'dishCalories')}'
                                    ' calories',
                                    style: inrText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 0,
                        color: grayColor,
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount',
                              style: totalText,
                            ),
                            Text(
                              'INR ${_getTotalAmount()}',
                              style: totalInrText,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Expanded(
                          child: AlertDialog(
                            title: Text(
                              'Alert',
                              style: dishCategoriesText,
                            ),
                            content: Text(
                              'Order successfully placed',
                              style: calorieText,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Ok',
                                  style: calorieText,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(2),
                    child: Center(
                        child: Text('Place Order', style: buttonOrderStyle)),
                  ),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23)),
                    backgroundColor: greenLeftDrawerColor,
                  ),
                ),
              ),
            )));
  }
}
