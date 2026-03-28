@IsTest(SeeAllData=true) 
private class SpendRequestTestClass {

    static testMethod void validateBeforeInsertTrigger() {
        System.AssertEquals(true, true);
        /* 2020-02-13 Charles Teague: commented out entire class because the application itself is unused and to be decommissioned.

       User testUser = TestUserFactory.getOneTestUser('MGM_Pacific', 'ICOM Sales Mgr','test@pearson.com');
       User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) 
        {
            insert testUser;
        }


       Gifting_Request__c gr = new Gifting_Request__c(Department__c = 'Marketing', Type_of_Event__c = 'Individual Meal', Event_Venue__c ='Test',  Date_of_Event__c= Date.TODAY(), Amount_per_person__c = 15.00, Rationale_for_supporting__c='Test', Communications_restriction__c='No');
       //System.debug('1-grSpend Request before inserting new Mkg request gr: ' + gr.MGM__c);

       // Insert Spend Request
       insert gr;
    
       // Retrieve the new request MGM
       gr = [SELECT Name, MGM__c FROM Gifting_Request__c WHERE Id =:gr.Id];
       //System.debug('2-gr MGM for Marketing after insert trigger fired: ' + gr.MGM__c + ' and name= ' + gr.Name);

       // Test that the trigger correctly updated the approvers
       System.assertEquals(false, String.isBlank(gr.MGM__c));
       
        //Inserting a sales even
        Gifting_Request__c gr2 = new Gifting_Request__c(Department__c = 'Sales', Sales_Market__c = 'Pacific', State__c = 'Test', School_District__c = 'Test', Type_of_Event__c = 'Individual Meal', Event_Venue__c ='Test',  Date_of_Event__c=Date.TODAY(),  Amount_per_person__c = 15.00, Rationale_for_supporting__c='Test',Communications_restriction__c='No');
       //System.debug('1-gr2 - Spend Request before inserting new Sales request gr2: ' + gr2.MGM__c);

       // Insert Spend Request
       insert gr2;
    
       // Retrieve the new request MGM
       gr2 = [SELECT Name, MGM__c FROM Gifting_Request__c WHERE Id =:gr2.Id];
       //System.debug('2-gr2 MGM for Sales after insert trigger fired: ' + gr2.MGM__c + ' and name= ' + gr2.Name);

       // Test that the trigger correctly updated the approvers
       System.assertEquals(false, String.isBlank(gr2.MGM__c));
       
      
       //Updating and testing Update trigger
       gr.Department__c = 'Sales';
       gr.Sales_Market__c = 'Pacific'; 
       gr.State__c = 'Test';
       gr.School_District__c = 'Test';
       
       update gr;
      
       //System.debug('3-gr after update gr from Marketing to Sales trigger fired: ' + gr.MGM__c + ' and name= ' + gr.Name);

       // Test that the trigger correctly updated the approvers
       System.assertEquals(false, String.isBlank(gr.MGM__c));
       
       gr2.Department__c = 'Marketing';
       update gr2;
       //System.debug('3-gr2 after update grs2 from Sales to marketing  trigger fired: ' + gr2.MGM__c + ' and name= ' + gr2.Name);

       // Test that the trigger correctly updated the approvers
       System.assertEquals(false, String.isBlank(gr2.MGM__c));
       
      
       //testing After update trigger
       Gifting_Request__c gr3 = new Gifting_Request__c(Department__c = 'Sales', Sales_Market__c = 'Northwest', State__c = 'Test', School_District__c = 'Test', Type_of_Event__c = 'Sponsorship', Event_Venue__c ='Test', Automatic_MGM_Approval__c=TRUE, Date_of_Event__c= Date.TODAY(), Amount_per_person__c = 15.00, Rationale_for_supporting__c='Test', Communications_restriction__c='No', Expected_Number_of_Participants__c=5);
       insert gr3;
              
       approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();  
       req1.setObjectId(gr3.id);
       approval.ProcessResult result = Approval.process(req1);
       
       gr3.MGM_Approval__c= 'Submitted';
       gr3.request_Status__c='Submitted';
       
       //System.debug ('2- gr3 before  update for kickoff approval -  trigger NOT fired: ' +  gr3.MGM_Approval__c + ' and Automatic_MGM_Approval= ' + gr3.Automatic_MGM_Approval__c + ' and request status= ' + gr3.request_Status__c);
       update gr3;
       
       
       //System.debug('3- gr3 after gr3 update for kickoff approval -  trigger fired: ' +  gr3.MGM_Approval__c + ' and Automatic_MGM_Approval= ' + gr3.Automatic_MGM_Approval__c + ' and request status= ' + gr3.request_Status__c);
       
       
       
       gr.request_Status__c = 'Submitted';
       gr.Type_of_Event__c='Individual Meal'; 
       
      try
        {
           
            update gr;
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Please add the Participants to the Event.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        } 
	*/
       
     }      
}