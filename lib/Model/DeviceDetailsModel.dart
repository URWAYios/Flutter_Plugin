class DeviceDetailsModel
{
  String? devicemodel ="";
  String? deviceVersion ="";
  String? devicePlatform ="";
  String? pluginName="";
  String? pluginVersion="";
  String? pluginPlatform="";

  DeviceDetailsModel({required this.devicemodel, required this.deviceVersion,required this.devicePlatform,
    required this.pluginName,required this.pluginVersion,required this.pluginPlatform});


  factory DeviceDetailsModel.fromJson(Map<String, dynamic> json)
  {
    DeviceDetailsModel pay;
    pay=DeviceDetailsModel(
        devicemodel:json['devicemodel'] as String,
        deviceVersion:json['deviceVersion'] as String,
        devicePlatform:json['devicePlatform'] as String,
        pluginName:json['pluginName'] as String,

        pluginVersion:json['pluginVersion'] as String,
        pluginPlatform:json['pluginPlatform'] as String,


    );
    return pay;
  }


  Map toMap() {
    var map = new Map<String, dynamic>();
    map["devicemodel"] = devicemodel;
    map["deviceVersion"] = deviceVersion;
    map["devicePlatform"]= devicePlatform;
    map["pluginName"]=pluginName;
    map["pluginVersion"]=pluginVersion;
    map["pluginPlatform"]=pluginPlatform;
    return map;
  }


}