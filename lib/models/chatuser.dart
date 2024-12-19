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
  late final String createdAt;
  late final String lastActive;
  late final bool isOnline;
  late final String id;
  late final String Image;
  late final String pushToken;
  late final String email;
  late final String About;
  late final String Name;

  ChatUser.fromJson(Map<String, dynamic> json){
    createdAt = json['createdAt'];
    lastActive = json['lastActive'];
    isOnline = json['isOnline'];
    id = json['id'];
    Image = json['Image'];
    pushToken = json['pushToken'];
    email = json['email'];
    About = json['About'];
    Name = json['Name'];
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