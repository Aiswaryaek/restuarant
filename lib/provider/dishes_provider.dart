// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import '../core/live_data.dart';
import '../core/ui_state.dart';
import '../models/category_model.dart';
import '../repositories/category_repositories.dart';

class DishesProvider extends ChangeNotifier {
  CategoryRepository categoryRepository;
  DishesProvider({required this.categoryRepository});
//dishes
  List<TableMenuList>list = [];
  LiveData<UIState<TableMenuList>> getDishesDatas =
  LiveData<UIState<TableMenuList>>();

  LiveData<UIState<TableMenuList>> getDishesLiveData() {
    return this.getDishesDatas;
  }
   initialState()
  {
    getDishesDatas.setValue(Initial());
    notifyListeners();
  }

  Future<dynamic> checkGetDishes() async {
    try {
      getDishesDatas.setValue(IsLoading());
      list = await categoryRepository.getDishesData();
      if (list.isNotEmpty) {
        getDishesDatas.setValue(Success(TableMenuList()));
      } else {
        getDishesDatas.setValue(Failure(list.toString()));
      }
    } catch (ex) {
      getDishesDatas.setValue(Failure(ex.toString()));
    } finally {
      notifyListeners();
    }
    // return true;
  }
}