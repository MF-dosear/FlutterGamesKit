
class Result{

  bool flag;
  dynamic data;
  String msg;
  int code;

  Result(this.flag,this.data,this.msg,this.code);

  Result.success(this.data, this.code ,{this.flag = true, this.msg = '请求成功'});

  Result.fail(this.msg, this.code, {this.flag = false, this.data = '请求失败'});
}