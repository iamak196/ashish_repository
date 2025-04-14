public with sharing class WeatherLWCController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getWeatherForContact(Id contactId) {
        Contact con = [SELECT Weather_Temperature__c, Weather_Condition__c, Weather_Icon_Url__c FROM Contact WHERE Id = :contactId LIMIT 1];
        return new Map<String, Object>{
            'temperature' => con.Weather_Temperature__c,
                'condition' => con.Weather_Condition__c,
                'iconUrl' => con.Weather_Icon_Url__c
                };
   }
    
    @AuraEnabled
    public static void refreshWeather(Id contactId) {
        Contact cont = [SELECT Id, MailingCity, MailingCountry FROM Contact WHERE Id = :contactId LIMIT 1];
        if (cont.MailingCity != null && cont.MailingCountry != null) {
            WeatherService.WeatherResponse res = WeatherService.getWeather(cont.MailingCity, cont.MailingCountry);
            cont.Weather_Temperature__c = res.current.temp_c;
            cont.Weather_Condition__c = res.current.condition.text;
            cont.Weather_Icon_Url__c = 'https:' + res.current.condition.icon;
            update cont;
        }
    }
}