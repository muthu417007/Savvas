/*
Apex Test Class:scc_orderDetail_Controller_Test
Author: CTS (Vaibhav Saptal)
Created Date: 06/06/2024
Reason: Test class for scc_orderDetail_Controller
Modified Date: 06/06/2024
*/

@istest
public class scc_orderDetail_Controller_Test {
    public static List<User> userList=new List<User>();
    /**
*  Description: This method is test method that covers try block for getOrderStatusCodes,itemsStatushelper,getThirdPartyTrack
*				getOrderMethodCodes,itemsDueDate,getSign,getOrderCancelCode,getLogProStatus,getShipperLink
*  @name: testClassMethod
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testClassMethod(){
        test.startTest();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Schools Account'].Id;
        List<Account> acclist=new List<Account>();
        Account SchoolAccount = new Account();
        SchoolAccount.name='TestR';
        SchoolAccount.RecordTypeId = strRecordTypeId;
        SchoolAccount.SAP_Account_Id__c ='TestSAN';
        acclist.add(SchoolAccount);
        insert accList;
        
        List<Contact> cList=new List<Contact>();
        Contact cont = new Contact();
        cont.AccountId = accList[0].id;
        cont.LastName = 'Testing';
        cont.Email = 'abc@xyz.com';
        cont.FirstName = 'Test';
        cList.add(cont); 
        insert cList;
        
        Product2 prd = new Product2();
        prd.Name='Test';
        prd.ISBN10__c = '0123456789';
        prd.ISBN13__c = '0123456789101';
        prd.Item_Category_Group_ID__c = 'ZOS';
        prd.Product_Type_ID__c = 'OLS';
        prd.IsActive = true;
        insert prd;
        
        SAP_Package__c pckg = new SAP_Package__c();
        pckg.Tracking_Number__c='0134954661';
        pckg.ThirdParty_Tracking_Number__c='0134954661,0134954661,0134954661';
        pckg.Invoice_Number__c='7028493517';
        insert pckg;
        
        Account acc= scc_TestDataFactory.accountCreation('testAccount4');        
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
        Profile pd = [Select id From profile where name = 'Customer Community Plus Login User' limit 1];
        user us=[select id from user where profile.name= 'System Administrator' and id != :userinfo.getUserID() and isActive=true limit 1];
        
        User testUser=  scc_TestDataFactory.userCreation(con.Id);
        List<String> items = new List<String>{'0123456789'} ;
        List<String> items2 = new List<String>{'0134931149'};
        List<String> items2a = new List<String>{'328948756','032897305X'};
        List<String> items2b = new List<String>{'3289487561','0328973051X'};
        List<String> items3 = new List<String>{'OR'};
        List<String> items4 = new List<String>{'1234567890'};
        List<String> trackId1 = new List<String>{'1234567890'}; 
        String trackId = '1234567890'; 
        List<String> trackNumList = new List<String>{'28'};
        String shippername = '7013IND-FedEx Ground-PPD';
        System.runAs(testUser) {
            Logpro_status__c lgp = new Logpro_status__c();
            lgp.Name='abcd';
            lgp.ISBN10__c='328948756';
            lgp.Logpro_Status__c ='Fulfilled';
            lgp.SAP_Document_Number__c='abcd';
            insert lgp;
            System.assertNotEquals(null,scc_orderDetail_Controller.getOrderStatusCodes()); 
            System.assertNotEquals(null,scc_orderDetail_Controller.itemsStatushelper(items));
            System.assertNotEquals(null,scc_orderDetail_Controller.getOrderMethodCodes());
            System.assertNotEquals(null,scc_orderDetail_Controller.itemsDueDate(items2));
            System.assertNotEquals(null,scc_orderDetail_Controller.getSign(trackId1));
            System.assertNotEquals(null,scc_orderDetail_Controller.getOrderCancelCode(items3));
            System.assertNotEquals(null,scc_orderDetail_Controller.getLogProStatus(items2a,'abcd'));
            System.assertNotEquals(null,scc_orderDetail_Controller.getLogProStatus(items2b,'abcd'));
            System.assertNotEquals(null,scc_orderDetail_Controller.getShipperLink(trackId,shippername,false,trackNumList)); 
            System.assertNotEquals(null,scc_orderDetail_Controller.getThirdPartyTrack(pckg.Invoice_Number__c));             
        }   
        test.stopTest();
    }
    /**
*  Description: Below method is test method that covers catch exception block for itemsStatushelper
*  @name: itemsStatushelper_Exception
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/        
    @isTest
    static void itemsStatushelper_Exception() {
        Test.startTest();
        try {
            scc_orderDetail_Controller.itemsStatushelper(null);           
        } catch (AuraHandledException e) {
            System.assertEquals(e.getMessage().contains('abcd'), false);
        }
        Test.stopTest();
    } 
    /**
*  Description: Below method is test method that covers catch exception block for itemsDueDate
*  @name: itemsDueDate_Exception
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/     
    @isTest
    static void itemsDueDate_Exception() {
        Test.startTest();
        try {
            scc_orderDetail_Controller.itemsDueDate(null);           
        } catch (AuraHandledException e) {
            System.assertEquals(e.getMessage().contains('abcd'), false);
        }
        Test.stopTest();
    }
    /**
*  Description: Below method is test method that covers catch exception block for getOrderCancelCode
*  @name: getOrderCancelCode_Exception
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/    
    @isTest
    static void getOrderCancelCode_Exception() {
        Test.startTest();
        try {
            scc_orderDetail_Controller.getOrderCancelCode(null);           
        } catch (AuraHandledException e) {
            System.assertEquals(e.getMessage().contains('abcd'), false);
        }
        Test.stopTest();
    } 
    /**
*  Description: Below method is test method that covers catch exception block for getLogProStatus
*  @name: getLogProStatus_Exception
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/    
    @isTest
    static void getLogProStatus_Exception() {
        Test.startTest();
        try {
            scc_orderDetail_Controller.getLogProStatus(null,null);           
        } catch (AuraHandledException e) {
            System.assertEquals(e.getMessage().contains('abcd'), false);
        }
        Test.stopTest();
    } 
    /**
*  Description: Below method is test method that covers catch exception block for getShipperLink
*  @name: getShipperLink_Exception
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/
    @isTest
    static void getShipperLink_Exception() {
        Test.startTest();
        try {
           scc_orderDetail_Controller.getShipperLink(null,null,false,null);           
        } catch (AuraHandledException e) {
            System.assertEquals(e.getMessage().contains('abcd'), false);
        }
        Test.stopTest();
    }
}