// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) => List<CategoryModel>.from(json.decode(str));

String categoryModelToJson(List<CategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  dynamic restaurantId;
  dynamic restaurantName;
  dynamic restaurantImage;
  dynamic tableId;
  dynamic tableName;
  dynamic branchName;
  dynamic nexturl;
  List<TableMenuList>? tableMenuList;

  CategoryModel({
    this.restaurantId,
    this.restaurantName,
    this.restaurantImage,
    this.tableId,
    this.tableName,
    this.branchName,
    this.nexturl,
    this.tableMenuList,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    restaurantId: json["restaurant_id"],
    restaurantName: json["restaurant_name"],
    restaurantImage: json["restaurant_image"],
    tableId: json["table_id"],
    tableName: json["table_name"],
    branchName: json["branch_name"],
    nexturl: json["nexturl"],
    tableMenuList: List<TableMenuList>.from(json["table_menu_list"].map((x) => TableMenuList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "restaurant_id": restaurantId,
    "restaurant_name": restaurantName,
    "restaurant_image": restaurantImage,
    "table_id": tableId,
    "table_name": tableName,
    "branch_name": branchName,
    "nexturl": nexturl,
    "table_menu_list": List<dynamic>.from(tableMenuList!.map((x) => x.toJson())),
  };
}

class TableMenuList {
  dynamic menuCategory;
  dynamic menuCategoryId;
  dynamic menuCategoryImage;
  dynamic nexturl;
  List<CategoryDish>? categoryDishes;

  TableMenuList({
    this.menuCategory,
    this.menuCategoryId,
    this.menuCategoryImage,
    this.nexturl,
    this.categoryDishes,
  });

  factory TableMenuList.fromJson(Map<String, dynamic> json) => TableMenuList(
    menuCategory: json["menu_category"],
    menuCategoryId: json["menu_category_id"],
    menuCategoryImage: json["menu_category_image"],
    nexturl: json["nexturl"],
    categoryDishes: List<CategoryDish>.from(json["category_dishes"].map((x) => CategoryDish.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "menu_category": menuCategory,
    "menu_category_id": menuCategoryId,
    "menu_category_image": menuCategoryImage,
    "nexturl": nexturl,
    "category_dishes": List<dynamic>.from(categoryDishes!.map((x) => x.toJson())),
  };
}

class AddonCat {
  dynamic addonCategory;
  dynamic addonCategoryId;
  dynamic addonSelection;
  dynamic nexturl;
  // List<CategoryDish>? addons;

  AddonCat({
    this.addonCategory,
    this.addonCategoryId,
    this.addonSelection,
    this.nexturl,
    // this.addons,
  });

  factory AddonCat.fromJson(Map<String, dynamic> json) => AddonCat(
    addonCategory: json["addon_category"],
    addonCategoryId: json["addon_category_id"],
    addonSelection: json["addon_selection"],
    nexturl: json["nexturl"],
    // addons: List<CategoryDish>.from(json["addons"].map((x) => CategoryDish.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "addon_category": addonCategory,
    "addon_category_id": addonCategoryId,
    "addon_selection": addonSelection,
    "nexturl": nexturl,
    // "addons": List<dynamic>.from(addons!.map((x) => x.toJson())),
  };
}

class CategoryDish {
  dynamic dishId;
  dynamic dishName;
  dynamic dishPrice;
  dynamic dishImage;
  dynamic dishCurrency;
  dynamic dishCalories;
  dynamic dishDescription;
  dynamic dishAvailability;
  dynamic dishType;
  dynamic nexturl;
  List<AddonCat>? addonCat;

  CategoryDish({
    this.dishId,
    this.dishName,
    this.dishPrice,
    this.dishImage,
    this.dishCurrency,
    this.dishCalories,
    this.dishDescription,
    this.dishAvailability,
    this.dishType,
    this.nexturl,
    this.addonCat,
  });

  factory CategoryDish.fromJson(Map<String, dynamic> json) => CategoryDish(
    dishId: json["dish_id"],
    dishName: json["dish_name"],
    dishPrice: json["dish_price"],
    dishImage: json["dish_image"],
    dishCurrency: json["dish_currency"],
    dishCalories: json["dish_calories"],
    dishDescription: json["dish_description"],
    dishAvailability: json["dish_Availability"],
    dishType: json["dish_Type"],
    nexturl: json["nexturl"],
    addonCat:  List<AddonCat>.from(json["addonCat"].map((x) => AddonCat.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "dish_id": dishId,
    "dish_name": dishName,
    "dish_price": dishPrice,
    "dish_image": dishImage,
    "dish_currency": dishCurrency,
    "dish_calories": dishCalories,
    "dish_description": dishDescription,
    "dish_Availability": dishAvailability,
    "dish_Type": dishType,
    "nexturl": nexturl,
    "addonCat": List<dynamic>.from(addonCat!.map((x) => x.toJson())),
  };
}
