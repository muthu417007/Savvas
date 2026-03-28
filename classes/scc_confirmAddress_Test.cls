/*********************************************************** 
* @Class Name  - scc_confirmAddress_Test
* @description - Test class for scc_confirmAddress
* @Created By  - CTS-Muthukumar
* @Created On - 2024-04-26 
* **********************************************************/ 

@istest
public class scc_confirmAddress_Test {
    
    public static List<User> userList=new List<User>();
    @isTest
    static void confirmaddresstest(){
         TEST.StartTest();

         Account acc= scc_TestDataFactory.accountCreation('testAccount4');
         Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
         User testUser= scc_TestDataFactory.userCreation(con.Id);
        
        // Create test data for Affiliation__c
        Affiliation__c testAffiliation = new Affiliation__c(
            Parent_Account__c = acc.Id
            //Child_Account__c = acc.Id         
            
        );
        insert testAffiliation;
        
        
        // Create test data for Account_Addresses__c
        Account_Addresses__c testAccountAddress = new Account_Addresses__c(
            Account__c = acc.Id,
            ERP_Account_Name__c='school2',
            Address_1__c='street1',
            Address_Type__c='Billing',
            City__c='c1',
            County__c='country1c',
            ERP_Account_Number__c='8769',
            State__c='state1',
            Zip_Code__c='123' 
        );
        insert testAccountAddress;
        
        Account_Addresses__c testAccountAddress1 = new Account_Addresses__c(
            Account__c = acc.Id,
            ERP_Account_Name__c='school2',
            Address_1__c='street1',
            Address_Type__c='Billing',
            City__c='c1',
            County__c='country1c',
            ERP_Account_Number__c='8769',
            State__c='state1',
            Zip_Code__c='123' 
        );
        insert testAccountAddress1;
        
        Account_Addresses__c testAccountShipAddress = new Account_Addresses__c(
            Account__c = acc.Id,
            ERP_Account_Name__c='school2',
            Address_1__c='street1',
            Address_Type__c='Shipping',
            City__c='c1',
            County__c='country1c',
            ERP_Account_Number__c='8769',
            State__c='state1',
            Zip_Code__c='123' );
        
        insert testAccountShipAddress;
        
        Id account1=acc.Id;
        Id shipaddr=testAccountAddress.Id;
        Id billaddr= testAccountAddress1.Id;
        Id accuserid = testUser.AccountId;
        Id usrId=testUser.Id;
        
        WebStore webStr = new WebStore();
        webStr.Name = 'MySavvasOrders';
        webStr.PricingStrategy = 'LowestPrice';
        insert webStr;
        
        
        System.runAs(testUser){
           // scc_confirmAddress.getCurrentUserBillingAddress();
             scc_confirmAddress.getUserShippingAddress();
            scc_confirmAddress.getUserBillingAddress();
        }
        
        WebCart activeCart =scc_TestDataFactory.webCartCreation(account1, usrId, webStr.Id);
       
        scc_confirmAddress.getCurrentUserBillingAddress(account1);
        scc_confirmAddress.getCurrentUserBillingAddress('');
        scc_confirmAddress.getAllowDropShip();
        scc_confirmAddress.getCurrentUserShippingAddress(accuserid);
        scc_confirmAddress.getCurrentUserShippingAddress('');
        scc_confirmAddress.guestCartDetails(activeCart.Id);
        scc_confirmAddress.getCurrentUserAllShippingAddress();
        scc_confirmAddress.IsEusageOnly();
        Test.stopTest();
        
    }
    /*@isTest
    public static void getSurveyInvitationLinkTest(){
        scc_confirmAddress.getSurveyInvitationLink();
    }*/
}