// Using SeeAllData because using Kimble records
@isTest (SeeAllData=true)
public class testEventTrigger {
    static testMethod void createEventWithKimbleActivityAssignment(){
        KimbleOne__ActivityAssignment__c kActAssign=[Select ID, name from KimbleOne__ActivityAssignment__c limit 1];
        event newEvent=new event();
        newEvent.whatId=kActAssign.Id;
        newEvent.Subject='Testing Kimble Activity Assignment';
        newEvent.Type='Meeting';
        newEvent.StartDateTime=dateTime.Now();
        newEVent.EndDateTime=dateTime.Now()+10;
        insert newEvent;
    }
}