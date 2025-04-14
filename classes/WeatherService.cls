public with sharing class WeatherService {
    public static WeatherResponse getWeather(String city, String country) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.weatherapi.com/v1/current.json?key=acfa967b0f4640e98ea73823251404&q='+EncodingUtil.urlEncode(city + ',' + country, 'UTF-8'));
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
                        system.debug(response.getBody());
            return (WeatherResponse)JSON.deserialize(response.getBody(), WeatherResponse.class);
        } else {
            throw new CalloutException('Weather API error: ' + response.getBody());
        }
    }
    
    public class WeatherResponse {
        public Location location;
        public Current current;
    }
    
    public class Location {
        public String name;
        public String region;
        public String country;
    }
    
    public class Current {
        public Decimal temp_c;
        public Condition condition;
    }
    
    public class Condition {
        public String text;
        public String icon;
    }
}