class RespDataModel
{
  String resKey ="";
  String resValue ="";


  RespDataModel({required this.resKey, required this.resValue});

/**
 * */
  @override
  String toString() {
    // TODO: implement toString
    return '{ ${this.resKey}, ${this.resValue} }';
  }




}