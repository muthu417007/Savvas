/* -----------------------------------------------------------------------------------------------------------------------
Name:        HomeSchoolCaseCreationControllerTest
Description: This is test class for HomeSchoolCaseCreationController.
Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
02/22/2022     1.0     Soundhariya      Initial Release
-------------------------------------------------------------------------------------------------------------------------- */
@isTest
public class HomeSchoolCaseCreationControllerTest {
	@testsetup	
	public static void createCase(){
		ID accID = TestDataFactory.createAccount();
		ID conID = TestDataFactory.createContact(accID);	
		String caseDesc = caseDescription();	
		Case cseRec = TestDataFactory.createCase(accID,conID, caseDesc);
		
		Contact newCont = new Contact();
		newCont.LastName = 'Test1';
        newCont.FirstName = 'Homeschool1';
        newCont.AccountId = accID;
        newCont.Email = 'test@gmail.com';
        newCont.Phone = '1234';
        insert newCont;
		
		Account accRec = new Account();
		accRec.Name = 'Savvas Homeschool Customers';
        accRec.BillingCity = 'BCity';
        accRec.BillingCountry = 'BCountry';
        accRec.BillingStreet = 'BStreet';
        accRec.BillingState = 'BState';
        accRec.BillingPostalCode = '23201';
        insert accRec;
	}
	@isTest(seeAllData = false)
	public static String caseDescription(){
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
		return strDesc;
	}
	
	@isTest(seeAllData = false)
	public static void createCaseForNewCustomer(){
		Case testCaseRec = new Case();
		testCaseRec.Origin = 'Web';
		testCaseRec.Status = 'New';
		testCaseRec.Priority = '4 (medium)';
        testCaseRec.Description = caseDescription();

		String oldCaseNumber = [Select id,CaseNumber from Case limit 1].CaseNumber;
		
        List<HomeSchoolCaseCreationController.GetCaseInputs> inputList = new List<HomeSchoolCaseCreationController.GetCaseInputs>();
        HomeSchoolCaseCreationController.GetCaseInputs inputFromFlow  = new HomeSchoolCaseCreationController.GetCaseInputs();
		inputFromFlow.oldAccount = false;
		inputFromFlow.parentCase = oldCaseNumber;
		inputFromFlow.contactFirstname = 'Test';
		inputFromFlow.contactLastname = 'Homeschool';
		inputFromFlow.contactEmail = 'Abc@gmail.com';
		inputFromFlow.contactPhone = '91333467990';
		inputFromFlow.contactExists = false;
		inputFromFlow.caseRec = testCaseRec;
		inputFromFlow.caseType = 'Customer Service';
        inputList.add(inputFromFlow);
		
        Test.startTest();     
        HomeSchoolCaseCreationController.getCaseDetails(inputList);
		List<Case> newCaseDetails = [Select id from Case where Origin = 'Web'];
		system.assert(newCaseDetails.size()>0);
        Test.stopTest();
	}
	@isTest(seeAllData = false)
	public static void createCaseForNewCustomerWithManyContacts(){		
		ID accID = TestDataFactory.createAccount();
		Contact newCont = new Contact();
		newCont.LastName = 'Test1';
        newCont.FirstName = 'Homeschool1';
        newCont.AccountId = accID;
        newCont.Email = 'Abc@gmail.com';
        newCont.Phone = '1234';
        insert newCont;		
		
		Case testCaseRec = new Case();
		testCaseRec.Origin = 'Web';
		testCaseRec.Status = 'New';
		testCaseRec.Priority = '4 (medium)';	
        testCaseRec.Description = caseDescription();
        testCaseRec.subject = 'Test {caseNum}';

		String oldCaseNumber = [Select id,CaseNumber from Case limit 1].CaseNumber;
		
        List<HomeSchoolCaseCreationController.GetCaseInputs> inputList = new List<HomeSchoolCaseCreationController.GetCaseInputs>();
        HomeSchoolCaseCreationController.GetCaseInputs inputFromFlow  = new HomeSchoolCaseCreationController.GetCaseInputs();
		inputFromFlow.oldAccount = true;
		inputFromFlow.parentCase = oldCaseNumber;
		inputFromFlow.caseRec = testCaseRec;
		inputFromFlow.selectedConID = newCont.Id;
		inputFromFlow.contactExists = true;
		inputFromFlow.caseType = 'Technical Support';
        inputList.add(inputFromFlow);

        Test.startTest();     
        HomeSchoolCaseCreationController.getCaseDetails(inputList);
		List<Case> newCaseDetails = [Select id from Case where Origin = 'Web'];
		system.assert(newCaseDetails.size()>0);
        Test.stopTest();
	}
	@isTest(seeAllData = false)
	public static void createCaseForOldCustomer(){
		Case testCaseRec = new Case();
		testCaseRec.Origin = 'Web';
		testCaseRec.Status = 'New';
		testCaseRec.Priority = '4 (medium)';
        testCaseRec.Description = caseDescription();

		String oldCaseNumber = [Select id,CaseNumber from Case limit 1].CaseNumber;
		
        List<HomeSchoolCaseCreationController.GetCaseInputs> inputList = new List<HomeSchoolCaseCreationController.GetCaseInputs>();
        HomeSchoolCaseCreationController.GetCaseInputs inputFromFlow  = new HomeSchoolCaseCreationController.GetCaseInputs();
		inputFromFlow.oldAccount = true;
		inputFromFlow.parentCase = oldCaseNumber;
		inputFromFlow.contactFirstname = 'Test';
		inputFromFlow.contactLastname = 'Homeschool';
		inputFromFlow.contactEmail = 'Abc@gmail.com';
		inputFromFlow.contactPhone = '91333467990';
		inputFromFlow.contactExists = false;
		inputFromFlow.caseRec = testCaseRec;
		inputFromFlow.caseType = 'Customer Service';
        inputList.add(inputFromFlow);
		
        Test.startTest();     
        HomeSchoolCaseCreationController.getCaseDetails(inputList);
		List<Case> newCaseDetails = [Select id from Case where Origin = 'Web'];
		system.assert(newCaseDetails.size()>0);
        Test.stopTest();
	}
}