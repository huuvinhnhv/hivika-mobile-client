class GameController {
  int? score;
  int gameId;
  int eventId;
  String gameName;
  String eventName;
  DateTime endDate;

  // Tạo một private constructor
  GameController._privateConstructor()
      : gameId = 0,
        eventId = 0,
        gameName = '',
        eventName = '',
        endDate = DateTime.now();

  // Tạo một instance duy nhất của GameController
  static final GameController _instance = GameController._privateConstructor();

  // Getter để lấy instance của GameController
  static GameController get instance => _instance;

  // Setter để cập nhật giá trị các biến toàn cục
  void updateVariables({
    int? score,
    required int gameId,
    required int eventId,
    required String gameName,
    required String eventName,
    required DateTime endDate,
  }) {
    this.score = score;
    this.gameId = gameId;
    this.eventId = eventId;
    this.gameName = gameName;
    this.eventName = eventName;
    this.endDate = endDate;
  }
}
