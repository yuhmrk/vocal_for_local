class CustomFunction {
  String getCurrentTimeInInt() {
    String passDate = "";
    passDate = DateTime.now().toString();
    passDate = passDate.replaceAll(RegExp('[^0-9]'), '');
    return passDate;
  }
}
