abstract class ResponseData {
  bool get isSuccess;
  dynamic get data;
  dynamic get error;
}

class ResponseDataImp extends ResponseData {
  ResponseDataImp(this._isSuccess,this._data,this._error);
  final bool _isSuccess;
  dynamic _data;
  dynamic _error;

  @override
  bool get isSuccess => _isSuccess;

  @override
  // TODO: implement data
  get data => _data;

  @override
  // TODO: implement error
  get error => _error;
}
 class AppException  implements Exception{

}

