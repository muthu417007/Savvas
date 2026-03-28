public class eventTriggerHandler {
    public static void eventBeforeInsert(List<event> eventRecList){
        map<Id,event> activityAssignmentEvent=new Map<Id,event>();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        //Get the Prefix of the Kimble Activity Assignment Record ID's
        Schema.DescribeSObjectResult r = KimbleOne__ActivityAssignment__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        String Id;
        For(Event e:eventRecList){
            if(e.whatId!=null){
                Id=e.whatId;
                //If the event is related to Kimble Activity Assignment
                if(Id.startsWithIgnoreCase(keyPrefix)){
                    activityAssignmentEvent.put(e.WhatId,e);
                }
            }
        }
        
        //If there are Activity Assignment related to the event
        if(activityAssignmentEvent.size()>0){
            set<Id> activityAssignmentId=new set<Id>();
            activityAssignmentId=activityAssignmentEvent.keyset();
            
            For(KimbleOne__ActivityAssignment__c ka:[select ID, event_ID__c,name,Account_Name__c,Resource_Name__c,Service_Delivery_Full_Street_Address__c,Service_Type__c,KimbleOne__StartDate__c,Presentation_Start_Time__c,Presentation_End_Time__c,Workshop_Name__r.Name,Customer_Contact__r.Name,Customer_Contact_Email__c,Customer_Contact_Phone__c,KimbleOne__Notes__c,Assignment_Notes_Long_Text_Field__c from KimbleOne__ActivityAssignment__c where ID=:activityAssignmentId]){
                Event ev=activityAssignmentEvent.get(ka.Id);
                if(ev!=null){
                    ev.Description =
                        'Event ID: ' + ka.event_Id__c + '\n\n' +
                        'Confirmed Consultant/Specialist: ' + ka.Resource_Name__c + '\n\n' +
                        'Service Type: ' + ka.Service_Type__c + '\n\n' +
                        'Account Name: '+ka.Account_Name__c + '\n\n' +
                        'Service Delivery Address: '+ ka.Service_Delivery_Full_Street_Address__c + '\n\n' +
                        'Start Date: ' + ka.KimbleOne__StartDate__c + '\n' +
                        'Start Time : ' + ka.Presentation_Start_Time__c + '\n' +
                        'End Time : ' + ka.Presentation_End_Time__c + '\n\n' +
                        'Workshop: ' + ka.Workshop_Name__r.Name + '\n\n' +
                        'Contact Details: ' + ka.Customer_Contact__r.Name + ', ' + ka.Customer_Contact_Phone__c + ', ' + ka.Customer_Contact_Email__c + '\n\n' +                   
                        'Comments: ' + ka.KimbleOne__Notes__c +' '+ka.Assignment_Notes_Long_Text_Field__c+'\n\n'+
                        'For full details, use this link: ' + baseUrl + '/' + ka.Id;
                }
            }
        }
    }
}