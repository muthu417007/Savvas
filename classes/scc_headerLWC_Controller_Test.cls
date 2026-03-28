/*
Apex Class:scc_headerLWC_Controller_Test
Author: CTS (Vaibhav Saptal)
Created Date: 26/03/2024
Reason: test class for scc_headerLWC_Controller
Modified Date: 
*/
@istest
public class scc_headerLWC_Controller_Test {    
    public static List<User> userList=new List<User>();
/**
*  Description: This method for getUserInformation and validateCartsData apex class methods.      
*  @name: testClassMethod
*  @param:NA
*  @return: NA
*  @throws exception- 
*/
    @isTest
    static void testClassMethod(){
        test.startTest();
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Schools Account'].Id;
        
        List<Account> acclist=new List<Account>();
        Account SchoolAccount = new Account();
        SchoolAccount.name='TestR';
        SchoolAccount.Type=scc_constantHelper.INTERNATIONAL_SCHOOL;
        SchoolAccount.RecordTypeId = strRecordTypeId;
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
        
        WebStore webStr = new WebStore();
        webStr.Name = 'MySavvasOrders';
        webStr.PricingStrategy = 'LowestPrice';
        insert webStr;
        
        Account acc= scc_TestDataFactory.accountCreation('testAccount4');
        
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
        Contact con1 = scc_TestDataFactory.contactCreation( acclist[0].Id, 'firstname5', 'testlastname90', 'testeASDmail@abc.com');
        
		String communityProfile = scc_constantHelper.CUSTOMER_COMMUNITY_PLUS_LOGIN_USER;
        Profile pd = [Select id From profile where name =:communityProfile limit 1];
        
        String adminProfile = scc_constantHelper.SYSTEM_ADMINISTRATOR_PROFILE;
        user us=[select id from user where profile.name=:adminProfile and id != :userinfo.getUserID() and isActive=true limit 1];
        
    	User testUser=  scc_TestDataFactory.userCreation(con.Id);
        
        Webcart wc = scc_TestDataFactory.webCartCreation(acc.Id, testUser.Id,webStr.Id);
        
        List<User> uList=new List<User>();
        Profile pd2 = [Select id From profile where name = :scc_constantHelper.MY_SAVVAS_ORDERS_PROFILE limit 1];
        User testUser1 = new User();
        testUser1.ProfileId=pd2.Id;          
        testUser1.LastName = 'Test User';
        testUser1.Email = 'testuser@example.com';
        testUser1.Username = 'testuser@example.com' + System.currentTimeMillis();
        testUser1.Alias = 'tuser';
        testUser1.TimeZoneSidKey = 'America/Los_Angeles';
        testUser1.LocaleSidKey = 'en_US';
        testUser1.EmailEncodingKey = 'UTF-8';
        testUser1.LanguageLocaleKey = 'en_US';
        insert uList;
        
        List<scc_CreateSupportCaseCategory__mdt> testCategories = new List<scc_CreateSupportCaseCategory__mdt>();
        testCategories.add(new scc_CreateSupportCaseCategory__mdt(MasterLabel = 'Category 1'));
        testCategories.add(new scc_CreateSupportCaseCategory__mdt(MasterLabel = 'Category 2'));                       
        
        System.runAs(testUser1) {
            System.assertNotEquals(null,Scc_headerLWC_Controller.getUserInformation());
        }
        
        
        System.runAs(us) {
            System.assertNotEquals(null,Scc_headerLWC_Controller.getUserInformation());
        }
        
        System.runAs(testUser) {
         	System.assertNotEquals(null,Scc_headerLWC_Controller.getUserInformation());
         	System.assertNotEquals(null,Scc_headerLWC_Controller.validateCartsData(acc.Id,wc.Id,''));
            System.assertNotEquals(null,Scc_headerLWC_Controller.getEnableConsoleLogsTrue());
            try{
                Scc_headerLWC_Controller.validateCartsData(acc.Id,acc.Id,acc.Id);
                Scc_headerLWC_Controller.getCreateCaseCategories();               
            }catch (Exception ex) {
               System.assertNotEquals('ex', ex.getMessage());
        	}            
        }       
        Test.stopTest();
    }
    
    @isTest
    static void testGetUserInformation_Exception() {
        Test.startTest();
        try {
            String result = Scc_headerLWC_Controller.getUserInformation();           
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Failed to get user details'), 'Exception message should contain "Failed to get user details"'); 
        }
        Test.stopTest();
    }   
    
}