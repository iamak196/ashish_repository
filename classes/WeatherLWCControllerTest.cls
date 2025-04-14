@isTest
private class WeatherLWCControllerTest {
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
    
    @isTest
    static void testGetWeather() {
        Map<String, Object> conMap = new Map<String, Object>();
        Contact conRecord = [select id,MailingCity,MailingCountry from Contact limit 1];
        Test.setMock(HttpCalloutMock.class, new WeatherMockResponse());
        Test.startTest();
        WeatherLWCController.refreshWeather(conRecord.Id);
        conMap = WeatherLWCController.getWeatherForContact(conRecord.Id);
        Test.stopTest();
        System.assertEquals(14.0, conMap.get('temperature'));
    }
     @isTest
    static void tesUpdateContact() {
        Contact conRecord = [select id,MailingCity,MailingCountry from Contact limit 1];
        Test.startTest();
        conRecord.MailingCity = 'London';
        conRecord.MailingCountry = 'UK';
        update conRecord;
        Test.stopTest();
    }
}