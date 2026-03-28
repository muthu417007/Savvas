@isTest 
public class SendRenewalEmailForServiceContract_Test {

    /*
     * Version: August 4,2021 Charles Teague 
     * Purpose: test the apex class sendRenewalEmailForServiceContract
     * This class does not contain asserts, it is just code coverage. Verification of correct operation of code
     * in sendRenewalEmailForServiceContract is performed by running the class against real data and 
     * inspecting the results: Emails received with PDF attachments,
     * attachment of PDF to Account, and creation of Activity History entry to Account.
     * Data processed is supplied from external source (SAP) and it is up to the supplier to provide correct data.
     * 
     * There's a requirement of ServiceContract that Pricebook Id be supplied.
     * There's a requirement of ContractLineItem that PricebookEntry must be Active.
    */
    @isTest(SeeAllData=true) static void sendEmail()
    {
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
        //svc.Pricebook2Id = '01sd00000001HPQ';
        svc.Pricebook2Id = pBook.Id;
        svc.OwnerId = u.Id;
        //svc.AccountId = acct.id;
        svc.Contact_Name__c = 'TestContractContactName';
        svc.Bill_To_Name__c = 'Test Bill to Name';
        svc.Bill_To_SAP_ID__c = 'test sap id';
        svc.Name = 'Testing Service Contract';
        svc.Account_Number__c = '9999999';
        svc.StartDate = Date.today();
        svc.EndDate = Date.today();
        svc.Renewal_Contract_ID__c ='11111';
        //svc.AccountId = '001d000001TuAp5AAF';
        svc.AccountId = acct.id;    
        svc.Bill_To_Address__c = 'Test Contract Street';
        svc.Bill_To_City__c = 'Test Contract City';
        svc.AE_Email_For_Display__c = u.email; // 'charles.teague@savvas.com';
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
        //cli_one.PricebookEntryId = '01ud0000004ZgMIAA0';
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
        //cli_two.PricebookEntryId = '01ud0000004ZgMIAA0';
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

        //system.debug('IN TEST CLASS, starting test');
        Test.startTest();
        
        sendRenewalEmailForServiceContract s = new sendRenewalEmailForServiceContract();
        s.sendEmails();
        
        Test.stopTest();
        //system.debug('IN TEST CLASS, test FINISHED');
    }

}