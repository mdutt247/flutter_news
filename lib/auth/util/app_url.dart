class AppUrl {
  static const String liveBaseURL = "https://mditech-laravel-news.herokuapp.com/api";
  static const String localBaseURL = "http://10.0.2.2:8000/api";

  static const String baseURL = liveBaseURL;
  static const String login = baseURL + "/login";
  static const String logout = baseURL + "/logout";
  static const String register = baseURL + "/registration";
  static const String forgotPassword = baseURL + "/forgot-password";
  static const String getDept = baseURL + "/get-dept";
// Live user: md@gmail.com  password: password
// Start API  https://github.com/mdutt247/laravel-news
}