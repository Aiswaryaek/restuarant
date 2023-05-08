import 'dart:convert';
import '../models/category_model.dart';
import '../utilities/api_helpers.dart';


Resource<List<TableMenuList>> getDishesApi() {
  return Resource(
      url:
      'v2/5dfccffc310000efc8d2c1ad',
      parse: (response) {
        // print(response.body);
        var listMap = jsonDecode(response.body.toString());
        Iterable list = listMap[0]["table_menu_list"];
        List<TableMenuList> data =
        list.map((model) => TableMenuList.fromJson(model)).toList();
        return data;
      });
}