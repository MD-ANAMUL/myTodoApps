class TodoModel{
   final int? id;
  final String? titles;
  final String? desc;
  final String? dateandtime;

  TodoModel({
    this.id,
    this.titles,
    this.desc,
    this.dateandtime,
});

  TodoModel.fromMap(Map <String, dynamic>res)
  : id =res['id'],
   titles = res['titles'],
   desc = res['desc'],
   dateandtime = res['dateandtime'];

  Map <String, Object?>toMap(){
   return{ "id":id,
    "titles":titles,
    "desc":desc,
    "dateandtime":dateandtime,};
  }

}