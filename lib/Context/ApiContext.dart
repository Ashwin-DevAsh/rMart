class ApiContext{
  static String getUrl(subDomain){
      return "https://$subDomain.rajalakshmimart.com";
  }
  static String profileURL = getUrl("profile"); 
  static String martURL = getUrl("mart"); 
  static String syncURL = getUrl("sync"); 
  static String productImageURL = "$martURL/getProductPictures/";
  static String imagePath = "lib/assets/Images/Categories/";

}