class Events {
  final String eventId;
  final String creatorId;
  final String eventName;
  final String location;
  final String description;
  List<String> playersId;
  final DateTime dateTime;

  Events(
      {this.eventId,
      this.creatorId,
      this.eventName,
      this.location,
      this.description,
      this.playersId,
      this.dateTime});
}

//you can use the constructor as Event = new Events()
