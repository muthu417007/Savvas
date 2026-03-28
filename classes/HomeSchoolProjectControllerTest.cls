/* -----------------------------------------------------------------------------------------------------------------------
Name:        HomeSchoolProjectControllerTest
Description: Test class for HomeSchoolProjectController

Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
12/02/2022     1.0     Smitha Prabhu      Initial Release

----------------------------------------------------------------------------------------------------------------------*/
@isTest
public class HomeSchoolProjectControllerTest {
    @isTest(seeAllData = false)
    static void getTenDigitISBNTest(){		
        String strDesc = 'Do you already have an existing EasyBridge & Savvas Realize account?:'+
            +'- Yes - returning customer, needing to add products/renew'+
            +'Your Name: Lindsay Heal'+
            +'Your Email: lindsaylivvy@gmail.com'+
            +'Your Address:'+
            +'3464 F 3/4 Road'+
            +'Clifton, CO 81520'+
            +'United States'+
            +'Order Number: 1009193827'+
            +'Grade Level(s) of Purchased Program(s):'+
            +'- 7th Grade'+
            +'7th Grade Product(s) Purchased:'+
            +'- enVisionmath2.0 - 9780768597059'+
            +'- myWorld Interactive Geography - 9781418370725'+
            +'Who did you purchase from?: Pearson'+
            +'Confirm Agreement:'+
            +'- I acknowledge that I have read and accepted the terms listed above.';
			Id accountID = TestDataFactory.createAccount();
			Id contactID = TestDataFactory.createContact(accountID);
			Case caseRecord = TestDataFactory.createCase(accountID,contactID,strDesc);        
        
        ZNOC_Winshuttle__c WinshuttleToInsert = new ZNOC_Winshuttle__c();
        List<HomeSchoolProjectController.GetValueInputs> inputList = new List<HomeSchoolProjectController.GetValueInputs>();
        HomeSchoolProjectController.GetValueInputs inputFromFlow  = new HomeSchoolProjectController.GetValueInputs();
        inputFromFlow.Description = strDesc;
        inputFromFlow.winshuttle = WinshuttleToInsert;
        inputList.add(inputFromFlow);
        Test.startTest();     
        HomeSchoolProjectController.getTenDigitISBN(inputList);
        List<ZNOC_Winshuttle__c> znocRec = [Select id from ZNOC_Winshuttle__c];
        system.assert(znocRec.size() > 0);
        Test.stopTest();
    }
}