import 'package:unite/core/models/app_user.dart';

abstract class UserRepository {
  Future<List<AppUser>> searchUsersByName(String nameQuery);
  Future<List<AppUser>> fetchUsersByIds(List<String> uids);
}
