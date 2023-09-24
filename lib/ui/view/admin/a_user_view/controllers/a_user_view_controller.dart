import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_order_food/core/model/user_app.dart';
import 'package:project_order_food/core/service/api.dart';
import 'package:project_order_food/ui/base_app/base_controller.dart';
import 'package:project_order_food/ui/base_app/base_table.dart';

class AUserViewController extends BaseController {
  final Api _api = Api(BaseTable.user);
  // final CollectionReference _usersCollection =
  //     FirebaseFirestore.instance.collection('users');

  List<UserApp> get listUser => data.map((e) => UserApp(e)).toList();

  @override
  Stream<QuerySnapshot<Object?>?>? loadDataStream() {
    return _api.streamDataCollection();
  }
}
