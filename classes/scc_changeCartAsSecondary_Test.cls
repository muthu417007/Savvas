/*********************************************************** 
* @Class Name  - scc_changeCartAsSecondary_Test
* @description - Test class for scc_changeCartAsSecondary
* @Created By  - CTS-Muthukumar
* @Created On - 2024-05-20
* **********************************************************/ 
@IsTest
public class scc_changeCartAsSecondary_Test {
     @isTest
    static void testClassMethod(){
        
        Account acc= scc_TestDataFactory.accountCreation('testAccount3');
        Contact con = scc_TestDataFactory.contactCreation( acc.Id, 'firstname3', 'testlastname3', 'testemail@abc.com');
        User testUser= scc_TestDataFactory.userCreation(con.Id);
        
        WebStore webStr = new WebStore();
        webStr.Name = 'MySavvasOrders';
        webStr.PricingStrategy = 'LowestPrice';
        insert webStr;
       
        scc_TestDataFactory.initialStorefrontSetup(webStr.Id, acc.Id, acc.Name);
        
        Product2 prod1 = scc_TestDataFactory.productCreation1();
        Product2 prod2 = scc_TestDataFactory.productCreation2();
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        system.debug('current user id is'+thisUser.Id);
        PermissionSet ps =[SELECT Id FROM PermissionSet WHERE Label = 'buyer' OR  Name = 'B2BBuyer' LIMIT 1];
        User testUserr = [SELECT Id FROM User WHERE Email = 'testuser@example.com' LIMIT 1];

        System.runAs (thisUser) {
      
                PermissionSetAssignment   psAssignment = new PermissionSetAssignment();
                psAssignment.PermissionSetId = ps.Id;
                psAssignment.AssigneeId = testUserr.Id;
                insert psAssignment;
             
        }
       TEST.StartTest();
 
        User testUser1 = [SELECT Id FROM User WHERE Email = 'testuser@example.com' LIMIT 1];
        system.debug('run useras'+testUser1.Id);
        System.runAs(testUser1){
            
            WebCart webca=scc_TestDataFactory.webCartCreation( acc.Id, testUser1.Id, webStr.Id);
            CartDeliveryGroup cDG=scc_TestDataFactory.cartDeliverGroupCreation(webca.Id);
            CartItem cartItems =scc_TestDataFactory.cartItemCreation(webca.Id, prod1.Id,  cDG.Id, prod1.Name);
   			scc_changeCartAsSecondary.changeActiveCartAsSecondary(acc.Id);
            scc_changeCartAsSecondary.changeHeldToActiveCart(webca.Id);
             scc_changeCartAsSecondary.clearPromoCode(webca.Id);
	     }
         Test.stopTest();
    }
}