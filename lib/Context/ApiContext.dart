class ApiContext{
  static String getUrl(subDomain){
      return "http://$subDomain.rajalakshmimart.com";
  }
  static String profileURL = getUrl("profile"); 
  static String martURL = getUrl("mart"); 
  static String syncURL = getUrl("sync"); 
  static String productImageURL = "$martURL/getProductPictures/";

}