import 'package:injectable/injectable.dart';

import '../../../../core/data/base_remote_data_source.dart';
import '../models/vital_sign_model.dart';

abstract class VitalSignRemoteDataSource {
  Future<VitalSignModel> getLatestVitalSign(String userId);
}

@LazySingleton(as: VitalSignRemoteDataSource)
class VitalSignRemoteDataSourceImpl extends BaseRemoteDataSource
    implements VitalSignRemoteDataSource {
  VitalSignRemoteDataSourceImpl(super.client);

  @override
  Future<VitalSignModel> getLatestVitalSign(String userId) async {
    return safeApiCall(() async {
      return await getRequest(
        '/VitalSign/GetLatestVitalSign/$userId',
        (json) => VitalSignModel.fromJson(json),
      );
    });
  }
}
