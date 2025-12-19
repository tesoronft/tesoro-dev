class ConvertTimeToMinutes {
  static int convertTimeToMinutes(String date) {
    final fetchTime = DateTime.parse(date).toLocal();
    return fetchTime.day;
  }
}
