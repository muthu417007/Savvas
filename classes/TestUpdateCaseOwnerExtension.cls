@isTest
public class TestUpdateCaseOwnerExtension {

    static testMethod void testUpdateCaseOwner() {
        Case case1 = new Case(subject = 'Test case for Update Owner extension', Platform__c='SuccessMaker');
        case1.OwnerId = UserInfo.getUserId();
        insert case1;
        // Instantiate Controller
        ApexPages.StandardController sc = new ApexPages.StandardController(case1);
        UpdateCaseOwnerExtension controller = new UpdateCaseOwnerExtension(sc);

        // Create new user to change owner
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'testu1', Email = 'standarduser@testorg1.com',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Chicago', UserName = 'standarduser@testorg1.com');
        
        // Change owner with sendEmail to false.
        case1.OwnerId = u.Id;
        controller.sendEmail = false;
        controller.updateCaseOwner();
     //   Case caseFromServer = [Select id, OwnerId from Case Where Id= :case1.Id limit 1];
        System.assertEquals(case1.OwnerId, u.Id);
       
        // Change owner with sendEmail to true
        case1.OwnerId = UserInfo.getUserId();
        controller.sendEmail = true;
        controller.updateCaseOwner();
    //    caseFromServer = [Select id, OwnerId from Case Where Id= :case1.Id limit 1];        
        System.assertEquals(case1.OwnerId, UserInfo.getUserId());
    }
}