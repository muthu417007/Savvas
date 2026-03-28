/**************************************************************************************** 
* @Class Name  - scc_checkAccessCodeCalloutTest
* @description - This class will test class scc_checkAccessCode
* @Created By  - CTS-Sameer Pujari
* @Created On - 2024-05-16 
* ***************************************************************************************/ 
@isTest
public class scc_checkAccessCodeCalloutTest {
    
    @TestSetup
    static void setupTestData() {
        Account acc= scc_TestDataFactory.accountCreation('testAccount4');
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
        Contact con1 = scc_TestDataFactory.contactCreation( acc.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
        Profile pd2 = [Select id From profile where name =: scc_constantHelper.MY_SAVVAS_ORDERS_PROFILE limit 1]; 
        Profile pd1 = [Select id From profile where name =: scc_constantHelper.SAVVAS_EXTERNAL_USERS_BASE_PROFILE limit 1];  
        
        List<User> usr = new List<User>();
        User testUser1 = new User();
        testUser1.ProfileId=pd1.Id;          
        testUser1.LastName = 'Test User';
        testUser1.Email = 'testemail1@abc.com';
        testUser1.Username = 'testuser@example.com' + System.currentTimeMillis();
        testUser1.Alias = 'tuser';
        testUser1.TimeZoneSidKey = 'America/Los_Angeles';
        testUser1.LocaleSidKey = 'en_US';
        testUser1.EmailEncodingKey = 'UTF-8';
        testUser1.LanguageLocaleKey = 'en_US'; 
        testUser1.ContactId = con.Id;
        usr.add(testUser1);
        
        User testUser2 = new User();
        testUser2.ProfileId=pd2.Id;          
        testUser2.LastName = 'Test User';
        testUser2.Email = 'testuser@example.com';
        testUser2.Username = 'testuser1@example.com' + System.currentTimeMillis();
        testUser2.Alias = 'tuser';
        testUser2.TimeZoneSidKey = 'America/Los_Angeles';
        testUser2.LocaleSidKey = 'en_US';
        testUser2.EmailEncodingKey = 'UTF-8';
        testUser2.LanguageLocaleKey = 'en_US';
        //testUser2.ContactId = con1.Id;
        usr.add(testUser2);
        insert usr;
        
    }
    
    @isTest static void checkAccessCodeCalloutTest(){
        User testUser1 = [SELECT Id FROM User WHERE Email = 'testemail1@abc.com'][0];
        system.runas(testUser1){
            Test.startTest();                               
            String searchAccessCode1 = 'WSEMMC-JAHID-OVARY-CLXIX-SPEIR-PRISE';
            Test.setMock(HttpCalloutMock.class, new scc_checkAccessCodeMockResponse());
            scc_checkAccessCode.accessCodeRespWrapper response = scc_checkAccessCode.checkAccessCode(searchAccessCode1);                                    
            Test.stopTest();  
        }         
        
    }  
    
    /* expired access code */
    @isTest static void checkAccessCodeCalloutTestExpired(){        
        User testUser1 = [SELECT Id FROM User WHERE Email = 'testuser@example.com'][0];
        system.runas(testUser1){
        Test.startTest();                      
        
        String searchAccessCode1 = 'WSEMMC-JAHID-OVARY-CLXIX-SPEIR-PRISA';
        Test.setMock(HttpCalloutMock.class, new scc_checkAccessCodeMockResponse());
        scc_checkAccessCode.accessCodeRespWrapper response = scc_checkAccessCode.checkAccessCode(searchAccessCode1);                                  
        Test.stopTest(); 
        }
    }
    
    /* Code has not been activated */
    @isTest static void checkAccCodeCallNotAct(){        
        
        Test.startTest();                      
        
        String searchAccessCode1 = 'WSEMMC-JAHID-OVARY-CLXIX-SPEIR-PRISB';
        Test.setMock(HttpCalloutMock.class, new scc_checkAccessCodeMockResponse());
        scc_checkAccessCode.accessCodeRespWrapper response = scc_checkAccessCode.checkAccessCode(searchAccessCode1);                                
        Test.stopTest();        
    }
    
    @isTest static void checkAccessCodeCalloutTest1(){        
        Test.startTest();                            
        
        String searchAccessCode2 = 'SSSRCC-CINHK-NATCH-PAMPA-GIBBY-DICES';
        Test.setMock(HttpCalloutMock.class, new scc_checkAccessCodeMockResponse());
        scc_checkAccessCode.accessCodeRespWrapper response = scc_checkAccessCode.checkAccessCode(searchAccessCode2);            
        
        Test.stopTest();        
    }
    
    @isTest static void checkAccessCodeCalloutTest2(){        
        Test.startTest();                              
        
        String searchAccessCode3 = 'WSEMMC-JEDDA-OVARY-CLXIX-AFOOT-HEARD';
        Test.setMock(HttpCalloutMock.class, new scc_checkAccessCodeMockResponse());
        scc_checkAccessCode.accessCodeRespWrapper response = scc_checkAccessCode.checkAccessCode(searchAccessCode3); 
        
        
        Test.stopTest();        
    }
    
    @isTest static void checkAccessCodeCalloutTest3(){                
        Test.startTest();                              
        
        String searchAccessCode4 = 'invalidAccessCode';
        Test.setMock(HttpCalloutMock.class, new scc_checkAccessCodeMockResponse());
        scc_checkAccessCode.accessCodeRespWrapper response = scc_checkAccessCode.checkAccessCode(searchAccessCode4); 
        
        Test.stopTest();        
    }
    
    /* status code 300 */
    @isTest static void checkAccessCodeCalloutTest4(){                
        Test.startTest();                              
        
        String searchAccessCode4 = 'statuscode300';
        Test.setMock(HttpCalloutMock.class, new scc_checkAccessCodeMockResponse());
        scc_checkAccessCode.accessCodeRespWrapper response = scc_checkAccessCode.checkAccessCode(searchAccessCode4); 
        
        Test.stopTest();        
    }
    
    /* cashedInDate and expirationDate as null */
    @isTest static void cashIndtExpiDtAsNull(){                
        Test.startTest();                              
        
        String searchAccessCode4 = 'cashedInDateexpirationDateasnull';
        Test.setMock(HttpCalloutMock.class, new scc_checkAccessCodeMockResponse());
        scc_checkAccessCode.accessCodeRespWrapper response = scc_checkAccessCode.checkAccessCode(searchAccessCode4); 
        
        Test.stopTest();        
    }
}