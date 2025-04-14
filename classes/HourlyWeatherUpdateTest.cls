@isTest
private class HourlyWeatherUpdateTest {
    @testSetup 
    static void setup() {
        Account accObj = new Account();
        accObj.Name = 'test account';
        insert accObj;
        List<Contact> conList = new List<Contact>();
        for(Integer i = 0; i < 2; i++) {
            conList.add(new Contact(FirstName = 'test first'+i,LastName = 'test last'+i,MailingCity = 'Milton Keynes',MailingCountry = 'United Kingdom'));
        }
        insert conList;
    }
    @isTest static void testScheduledJob() {
        Test.setMock(HttpCalloutMock.class, new WeatherMockResponse());
        Test.startTest();
        String jobId = System.schedule('MyJob', '0 0 * * * ?', new HourlyWeatherUpdate()); 
        HourlyWeatherUpdate.weatherCheckAPI();
        Test.stopTest();
        Contact conRecord = [SELECT Id, Weather_Temperature__c FROM Contact limit 1];
        System.assertEquals(14.0, conRecord.Weather_Temperature__c);
    }
}