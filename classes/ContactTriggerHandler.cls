public class ContactTriggerHandler {
    public static void handleAddressChange(List<Contact> contactList, Map<Id,Contact> oldMap) {
        List<Weather_Update__e> eventList = new List<Weather_Update__e>();
        for (Contact conObj : contactList) {
            Contact oldconRecord = oldMap.get(conObj.Id);
            if (conObj.MailingCity != oldconRecord.MailingCity ||conObj.MailingCountry != oldconRecord.MailingCountry) {
                Weather_Update__e eventObj = new Weather_Update__e();
                eventObj.ContactId__c = conObj.Id;
                eventList.add(eventObj);
            }
        }
        if(!eventList.isEmpty()){
          EventBus.publish(eventList);  
        }
        
    }
}