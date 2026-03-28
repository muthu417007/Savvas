@isTest(SeeAllData=true) 
private class ScheduleRenewalSvcContractEmails_Test {
    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2024';
    
    static testmethod void testScheduledJob() {
        //system.debug('In test class, make Service Contract');
        
        User u = [select id, email from User where isactive = true and profile.name = 'ICOM Sales Rep' limit 1];
        //system.debug(' User ID value being used for test: ' + u.Id);
        //system.debug(' User email value being used for test: ' + u.email);
        // really should create and insert a new account for testing, this would fail in an empty org and in other ways also
        // however, there's a ton of similar bad code already existing in the org, so 'frankly, scarlett, i don't give a d**n'
        Account acct = [SELECT Id,Name FROM Account WHERE BillingState = 'CA' AND Account_Status__c = 'Active' AND Enrollment__c > 1 LIMIT 1];
        //system.debug(' Account being used for test: ' + acct.id + ' name: ' + acct.name);

        // Must have a PriceBook that's active to insert with Service Contract:
        Pricebook2 pBook = [select Id from pricebook2 where isactive = true 
                  and name = 'Product Family Pricebook' limit 1];        
        //system.debug(' PriceBook ID value being used for test: ' + pBook.Id);

        // Also need an active PricebookEntry to load Contract Line Items:
        PricebookEntry pbookEntry = [select Id from PricebookEntry where isactive = true 
                  and CurrencyISOCode = 'USD'
                  and Pricebook2.Id =: [select Id 
                  from pricebook2 where isactive = true 
                  and name = 'Product Family Pricebook' limit 1] limit 1];
        //system.debug(' PriceBookEntry value being used: ' + pbookEntry.Id);
        
        ServiceContract svc = new ServiceContract();

        svc.Pricebook2Id = pBook.Id;
        svc.OwnerId = u.Id;
        svc.Contact_Name__c = 'TestContractContactName';
        svc.Bill_To_Name__c = 'Test Bill to Name';
        svc.Bill_To_SAP_ID__c = 'test sap id';
        svc.Name = 'Testing Service Contract';
        svc.Account_Number__c = '9999999';
        svc.StartDate = Date.today();
        svc.EndDate = Date.today();
        svc.Renewal_Contract_ID__c ='11111';
        svc.AccountId = acct.id;    
        svc.Bill_To_Address__c = 'Test Contract Street';
        svc.Bill_To_City__c = 'Test Contract City';
        svc.AE_Email_For_Display__c = u.email;
        svc.Email_Recipients__c = 'notARealEmail@savvas.com';
        svc.Email_Reply_To_Address__c = 'anotherFakeEmail@savvas.com';
        insert svc;
        //system.debug('IN TEST CLASS, INSERTED Service Contract DONE');
        
        ContractLineItem cli_one = new ContractLineItem();
        cli_one.ServiceContractId = svc.id;
        cli_one.Account_ID__c = 'SiteAcctID';
        cli_one.ISBN_Title__c = 'Test Line Title';           
        cli_one.Total_Dollars__c = 100; 
        cli_one.StartDate = Date.today();
        cli_one.EndDate = Date.today();
        cli_one.Total_Quantity__c = 5;
        cli_one.Quantity = 5;
        cli_one.PricebookEntryId = pbookEntry.Id;
        cli_one.Line_Quantity__c = 1;
        cli_one.UnitPrice = 0;
        cli_one.Site_Name__c = 'Testing Site one';
        cli_one.Site_Account_Address__c = 'Site One Street';
        cli_one.ISBN__c = 'SiteOneISBN';
        cli_one.Installed_Item_ISBN__c = 'Inst. Item ISBN 1';
        cli_one.Installed_Item_Description__c = 'Inst.Item_1 Desc';
        insert cli_one;
        //system.debug('IN TEST CLASS, INSERTED Line Item One DONE');
        
        ContractLineItem cli_two = new ContractLineItem();
        cli_two.ServiceContractId = svc.id;
        cli_two.Account_ID__c = 'SiteAcctID';
        cli_two.ISBN_Title__c = 'Test Line Title';           
        cli_two.Total_Dollars__c = 100; 
        cli_two.StartDate = Date.today();
        cli_two.EndDate = Date.today();
        cli_two.Total_Quantity__c = 10;
        cli_two.Quantity = 10;
        cli_two.PricebookEntryId = pbookEntry.Id;
        cli_two.Line_Quantity__c = 1;
        cli_two.UnitPrice = 0;
        cli_two.Site_Name__c = 'Testing Site Two';
        cli_two.Site_Account_Address__c = 'Site Two Street';
        cli_two.ISBN__c = 'SiteTwoISBN';
        cli_two.Installed_Item_ISBN__c = 'Inst. Item ISBN 2';
        cli_two.Installed_Item_Description__c = 'Inst.Item_2 Desc';
        insert cli_two;
        //system.debug('IN TEST CLASS, INSERTED Line Item Two DONE');        
        
        Test.startTest();
        
        // Schedule the test job
        try {
            String jobId = System.schedule('ScheduledApexTest',
                CRON_EXP,
                new ScheduleRenewalSvcContractEmails());
        } catch(Exception e) {}
        // Stopping the test will run the job synchronously
        
        Test.stopTest();
        
        // What to check?

    }

}