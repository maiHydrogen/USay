class ChatUser {
  ChatUser({
    required this.createdAt,
    required this.lastActive,
    required this.isOnline,
    required this.id,
    required this.Image,
    required this.pushToken,
    required this.email,
    required this.About,
    required this.Name,
  });
  late  String createdAt;
  late  String lastActive;
  late  bool isOnline;
  late  String id;
  late  String Image;
  late  String pushToken;
  late  String email;
  late  String About;
  late  String Name;

  ChatUser.fromJson(Map<String, dynamic> json){
    createdAt = json['createdAt'] ??'';
    lastActive = json['lastActive'] ??'';
    isOnline = json['isOnline'] ??'';
    id = json['id'] ??'';
    Image = json['Image'] ??'';
    pushToken = json['pushToken'] ??'';
    email = json['email'] ??'';
    About = json['About'] ??'';
    Name = json['Name'] ??'';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['lastActive'] = lastActive;
    data['isOnline'] = isOnline;
    data['id'] = id;
    data['Image'] = Image;
    data['pushToken'] = pushToken;
    data['email'] = email;
    data['About'] = About;
    data['Name'] = Name;
    return data;
  }
}