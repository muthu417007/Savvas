@isTest
private class testTerritoryAccountToAccountTeamMember {

    static testMethod void runPositiveTestCases() {
    	User firstStandardUser=[select Id from User where UserType='Standard' and IsActive=True limit 1];
    	Account testAccount=new Account(Name='Test TATATM');
    	Database.SaveResult asr = Database.insert(testAccount,false);
    	id accountid=asr.getId();
    	Territory__c testTerritory=new Territory__c(Name='XYZ');
    	Database.SaveResult tsr = Database.insert(testTerritory,false);
    	id territoryid=tsr.getId();
    	TerritoryUser__c testTerritoryUser=new TerritoryUser__c(Territory__c=territoryid,User__c=firstStandardUser.Id);
    	Database.SaveResult tusr = Database.insert(testTerritoryUser,false);
    	id territoryuserid=tusr.getId();
    	TerritoryAccount__c testTerritoryAccount=new TerritoryAccount__c(Territory__c=territoryid,Account__c=accountid);
    	Database.SaveResult tasr = Database.insert(testTerritoryAccount,false);
    	id territoryaccountid=tasr.getId();
    	testTerritoryAccount=[select Id from TerritoryAccount__c where Id=:territoryaccountid limit 1];
    	delete testTerritoryAccount;
    }
}