import 'package:intl/intl.dart';

class Val{
  static String ValidateTitle(String val){
    return(val != null && val != '') ? null : "Title cannot be empty";
  }

  static String GetExpiryString(String expires){
    var timeToExpire = DateUtils.convertToDate(expires);
    var todayTime = new DateTime.now();

    Duration diff = timeToExpire.difference(todayTime);
    int dd = diff.inDays + 1;
    return(dd > 0) ? dd.toString() : "0";
  }
  static bool StrToBool(String str) {
    return (int.parse(str) > 0) ? true : false;
  }
  static bool IntToBool(int val) {
    return (val > 0) ? true : false;
  }
  static String BoolToStr(bool val) {
    return (val == true) ? "1" : "0";
  }
  static int BoolToInt(bool val) {
    return (val == true) ? 1 : 0;
  }
}

class DateUtils{
  static convertToDate(String input){
    try{
      var date = new DateFormat("yyyy-MM-dd").parseStrict(input);
      return date;
    }
    catch (e){
      return null;
    }
  }

  static String convertToDateFull(String input){
    try{
      var date =  DateFormat("yyyy-MM-dd").parseStrict(input);
      var formatter = new DateFormat("dd MMM yyyy");
      return formatter.format(date);
    }
    catch(e){
      return null;
    }

  }


  static String convertToFullDate(DateTime input){
    try{
      var formatter = new DateFormat('dd MMM yyyy');
      return formatter.format(input);
    }
    catch(e){
      return null;
    }
  }


  static bool isDate(String date){
    try{
      var d = new DateFormat("yyyy-MM-dd").parseStrict(date);
      return true;
    }
    catch(e){
      return false;
    }
  }

  static bool isValidDate(String date){
    if (date.isEmpty || !date.contains("-") || date.length < 10) return false;

    List<String> dateItems = date.split("-");
    var d = DateTime(int.parse(dateItems[0]),
        int.parse(dateItems[1]), int.parse(dateItems[2]));

    return d != null && isDate(date) && d.isAfter(new DateTime.now());
  }

  // String function
  static String daysAheadAsString(int daysAhead){
    var now = new DateTime.now();
    DateTime ft = now.add(new Duration(days: daysAhead));
  return ftDateAsString(ft);
}

static String ftDateAsString(DateTime ft){
    return ft.year.toString() + "-" + ft.month.toString().padLeft(2, "0") + "-" +
    ft.day.toString().padLeft(2, "0");
}

static String TrimDate(String dt){
    if (dt.contains(" ")){
      List<String> p = dt.split(" ");
      return p[0];
    }
    else
      return dt;
}
}