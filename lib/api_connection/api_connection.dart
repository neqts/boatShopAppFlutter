class API
{
static const hostConnect = "http://192.168.55.103/api_boats_store";
static const hostConnectUser="$hostConnect/user";
static const hostConnectAdmin="$hostConnect/admin";
static const hostConnectUpload="$hostConnect/boats";
static const hostConnectTrending="$hostConnect/trendingBoat";

//signUp-login user
  static const validateEmail = "$hostConnectUser/validate_email.php";
static const signUp = "$hostConnectUser/signup.php";
  static const login = "$hostConnectUser/login.php";
  //admin login
  static const adminLogin = "$hostConnectAdmin/login.php";

  //upload boats
  static const uploadNewBoat = "$hostConnectUpload/upload.php";

  //Boats
  static const getTrendingBoats = "$hostConnectTrending/trending.php";


}