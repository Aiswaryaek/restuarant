
import '../services/category_services.dart';
import '../services/web_service.dart';

class CategoryRepository {
  var webService;

  CategoryRepository() {
    this.webService = Webservice();
  }


  Future getDishesData() => webService?.get(getDishesApi());

}
