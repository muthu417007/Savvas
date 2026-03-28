/*
Apex Test Class:scc_profileDetailControllerTest
Author: CTS (Varshaa)
Created Date: 18/10/2024
Reason: This test class is for class scc_profileDetailController
Modified Date: 16/04/2024
*/
@isTest
public class scc_profileDetailControllerTest {
    /**
*  Description: Below method will get user details in wrapper
*  @name: testClassMethod
*  @param:NA
*  @return: NA
*  @throws exception- NA
*/ 
    @isTest
    static void testClassMethod(){
        Account acc= scc_TestDataFactory.accountCreation('testAccount4');
        
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname4', 'testlastname4', 'testemail1@abc.com');
        User testUser=  scc_TestDataFactory.userCreation(con.Id);
        
        System.runAs(testUser) {
            scc_profileDetailController.getUserDetails();            
        }
    }
    
}