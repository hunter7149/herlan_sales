import 'package:get_storage/get_storage.dart';

class Pref {
  static final box = GetStorage('remark_herlan_data');

  //---Token related data-----//

  static var WEBSESSIONTOKEN = 'web_session_status_herlan_sales';


  static void writeData({required String key, required dynamic value}) =>
      box.write(key, value);

  static dynamic readData({required String key}) => box.read(key);

  static void removeData({required String key}) => box.remove(key);
}
