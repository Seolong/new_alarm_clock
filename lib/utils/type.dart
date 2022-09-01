class AlarmIdType {
  //problem: after kill process, globalId will be initialized
  //삭제 후 정렬, 삭제 후 아이디 할당 문제, 순서를 숫자로 넣어줄까?
  //순서 리스트를 만들고 거기 value에 1, 2, 3, 4... 이런 식으로 순서를 넣을까?
  static int globalId = 0;

  /*int id;

  int getId(){
    return id;
  }*/

  int newId() {
    return globalId++;
  }

  void decreaseIdNum() {
    globalId--;
  }
}
