global class HourlyWeatherUpdate implements Schedulable {
    global void execute(SchedulableContext sc) {
        WeatherCheckAPI();
        
    }
    @future(callout=true)
    public static void weatherCheckAPI(){
        List<Contact> contactsToUpdate = new List<Contact>();
        contactsToUpdate = [SELECT Id, MailingCity, MailingCountry FROM Contact WHERE MailingCity != null AND MailingCountry != null limit 50000];
        List<Contact> updatedContacts = new List<Contact>();
        
        for (Contact con : contactsToUpdate) {
            try {
                WeatherService.WeatherResponse res = WeatherService.getWeather(con.MailingCity, con.MailingCountry);
                system.debug('res'+res);
                con.Weather_Temperature__c = res.current.temp_c;
                con.Weather_Condition__c = res.current.condition.text;
                con.Weather_Icon_Url__c = 'https:' + res.current.condition.icon;
                con.Weather_Last_Updated__c = System.now();
                updatedContacts.add(con);
            } catch (Exception e) {
                system.debug('Exception'+e.getmessage());
            }
        }
        if(!updatedContacts.isEmpty()){
          update updatedContacts;  
        }
    }
}