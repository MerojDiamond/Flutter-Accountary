class Race {
  int id = 0;
  Race(this.id);
  Map<String, dynamic> toMap(){
    final map = Map<String, dynamic>();
    map['id'] = id;
    return map;
  }
  Race.fromMap(Map<String, dynamic> map) {
    id = map['id'];
  }
}