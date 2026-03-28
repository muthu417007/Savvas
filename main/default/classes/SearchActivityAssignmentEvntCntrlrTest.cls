@isTest
private class SearchActivityAssignmentEvntCntrlrTest {
   
    
    @isTest(SeeAllData=true)
    static void testActivityRetrieval(){
        string eventNumber;
        String eventId ;
        string resource;
        string workshopName;
        string accName;
        string accCity;
        string accState;
        string svcType;
        Date eventDate;        
        
        KimbleOne__ActivityAssignment__c actAssignInfo = [select ID,Event_ID__c,Resource_Name__c,KimbleOne__ResourceUser__c,Delivery_Date__c,Workshop_Name__r.Name,Service_Type__c,Opportunity__r.AccountId,Opportunity__r.Account.billingcity,Opportunity__r.Account.Name,Opportunity__r.Account.billingState from KimbleOne__ActivityAssignment__c where event_ID__c!=null limit 1];
        resource = actAssignInfo.Resource_Name__c;
        eventNumber = actAssignInfo.Event_ID__c; 
        eventDate = actAssignInfo.Delivery_Date__c;
        accName = actAssignInfo.Opportunity__r.Account.Name;
        accCity = actAssignInfo.Opportunity__r.Account.billingcity;
        accState = actAssignInfo.Opportunity__r.Account.billingState;
        svcType = actAssignInfo.Service_Type__c;
        workshopName = actAssignInfo.Workshop_Name__c;
        System.Debug('pre test run ');
        
        Test.startTest();

        SearchActivityAssignmentEventController testCtrl = new SearchActivityAssignmentEventController();
        testCtrl.actAssignment = actAssignInfo;
        
        testCtrl.eventId = eventNumber;
        testCtrl.showEventInfo = false;
        testCtrl.showInput = true;
        testCtrl.resource = resource; 
        testCtrl.workshopName = workshopName; 
        testCtrl.accName = accName; 
        testCtrl.accCity = accCity; 
        testCtrl.accState = accState; 
        testCtrl.svcType = svcType; 
        testCtrl.eventDate = eventDate; 

        testCtrl.getActAssignment();
        testCtrl.clear();
        
        Test.stopTest();
        
        System.Debug('post test run ');
        
        System.Debug('testCtrl.showEventInfo' + testCtrl.showEventInfo);
        System.Debug('testCtrl.Id,' + testCtrl.eventId);
        System.Debug('testCtrl.resource,' + testCtrl.resource);
        System.Debug('testCtrl.eventDate,' + testCtrl.eventDate);
        System.Debug('testCtrl.accName,' + testCtrl.accName);
        System.Debug('testCtrl.Id,' + testCtrl.accCity);
        System.Debug('testCtrl.accCity,' + testCtrl.accState);
        System.Debug('testCtrl.svcType,' + testCtrl.svcType);
        System.Debug('testCtrl.workshopName,' + testCtrl.workshopName);
        
        
    }
}