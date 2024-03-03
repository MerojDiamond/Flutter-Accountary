class RaceTransaction {
  int? id = null;
  int race_id = 0;
  int type = 0;
  int amount = 0;
  String title = "";
  String description = "";
  String date = "";

  RaceTransaction(this.race_id, this.type, this.amount, this.title,
      this.description, this.date);

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['race_id'] = race_id;
    map['type'] = type;
    map['amount'] = amount;
    map['title'] = title;
    map['description'] = description;
    map['date'] = date;
    return map;
  }

  RaceTransaction.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    race_id = map['race_id'];
    type = map['type'];
    amount = map['amount'];
    title = map['title'];
    description = map['description'];
    date = map['date'];
  }
}
