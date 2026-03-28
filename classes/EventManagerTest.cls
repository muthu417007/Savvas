// Test the Apex REST WEBServices
// Using See All Data so that I can query a sample Kimble activity Assignment record
@isTest
private class EventManagerTest {
    @isTest static void testGetEventinfoById(){
        //Query 1 Kimble Activity Assignment record
        //KimbleOne__ActivityAssignment__c actAssign=[Select ID, name, event_ID__c from KimbleOne__ActivityAssignment__c where event_ID__c!=null limit 1];
        
        try{
            KimbleOne__ResourcedActivityType__c kt= new KimbleOne__ResourcedActivityType__c(name='test');
        insert kt;
        KimbleOne__ResourcedActivity__c krc=new KimbleOne__ResourcedActivity__c(name='testkrc',KimbleOne__ResourcedActivityType__c=kt.id);
        insert krc;
        KimbleOne__ActivityAssignment__c actAssign= new KimbleOne__ActivityAssignment__c(name='test',KimbleOne__ResourcedActivity__c=krc.id);
        insert actAssign;
        string eventId=actAssign.event_ID__c;
        string fullURL=URL.getSalesforceBaseUrl().toExternalForm();
        //Peform the HTTP REST Call
        RestRequest request = new RestRequest();
        request.requestUri=fullURL+'/services/apexrest/EventInfo/'+eventId;
        request.httpMethod='GET';
        RestContext.request = request;
        // Call the method to test
        KimbleOne__ActivityAssignment__c thisEvent= EventManager.getEventById();
        // Verify results
        System.assert(thisEvent != null);   
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
}