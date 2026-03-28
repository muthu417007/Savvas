@isTest
public class UpdateDoNotContactDetailsTest {
	
	@testSetup static void setup() {
		List<Account> childAccList = new List<Account>();
		Integer rand=math.round(Math.random()*1000);
		Account parentAcc = new Account(Name='TestParentAccount',type='Public District',BillingCity='New York',BillingStreet='100 Hudson Street',BillingPostalCode='10013',BillingState='NY',BillingCountry='United States',Do_Not_Contact__c = true,Do_Not_Contact_End_Date__c=system.today(),Do_Not_Contact_Reason__c='test');
		insert parentAcc;
		for(Integer i=0;i<100;i++){
			Account childAcc = new Account(Name='TestChildAccount '+i,type='Public District',BillingCity='New York',BillingStreet= String.valueOf(rand)+'Hudson Street',BillingPostalCode='10013',BillingState='NY',BillingCountry='United States',ParentId = parentAcc.Id);
			childAccList.add(childAcc);
		}
		Insert childAccList;
	}
		
	 public static testMethod void mainMethod(){
		doNotContactTrue();
		doNotContactFalse();
	 }
	
	 public static void doNotContactTrue(){	
		 Account acc = [Select id,Do_Not_Contact__c from account where name = 'TestParentAccount' and Do_Not_Contact__c = true and type='Public District'];	
		 acc.Do_Not_Contact__c = true;
		 acc.Do_Not_Contact_End_Date__c=system.today();
		 acc.Do_Not_Contact_Reason__c='test';
		 update acc;
		 UpdateDoNotContactDetails.FlowInputs firstInput = new UpdateDoNotContactDetails.FlowInputs();
		 firstInput.parentAccId = acc.ID;
		 firstInput.isBlackout = true;
		 
		 Test.startTest();
		 UpdateDoNotContactDetails.updateChildAccounts(new List<UpdateDoNotContactDetails.FlowInputs>{firstInput});
		 Test.stopTest();
	 }
	
	 
	 public static void doNotContactFalse() {
		Account acc = [Select id,Do_Not_Contact__c from account where name = 'TestParentAccount' and Do_Not_Contact__c = true and type='Public District'];
		acc.Do_Not_Contact__c = false;
		update acc;
		
	 }

}