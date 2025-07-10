import 'package:injectable/injectable.dart';

import '../../../../core/data/base_remote_data_source.dart';
import '../models/user_model.dart';

abstract class DashboardRemoteDataSource {
  Future<UserModel> getCurrentUser();
}

@LazySingleton(as: DashboardRemoteDataSource)
class DashboardRemoteDataSourceImpl extends BaseRemoteDataSource
    implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl(super.client);

  @override
  Future<UserModel> getCurrentUser() async {
    return safeApiCall(() async {
      return await getRequest(
        '/user/GetCurrentUser',
        (json) => UserModel.fromJson(json),
      );
    });
  }
}
