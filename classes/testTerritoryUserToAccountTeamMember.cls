/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class testTerritoryUserToAccountTeamMember {

    static testMethod void runPositiveTestCases() {
    	User firstStandardUser=[select Id from User where UserType='Standard' and IsActive=True limit 1];
    	Account testAccount=new Account(Name='Test TATATM');
    	Database.SaveResult asr = Database.insert(testAccount,false);
    	id accountid=asr.getId();
    	Territory__c testTerritory=new Territory__c(Name='XYZ');
    	Database.SaveResult tsr = Database.insert(testTerritory,false);
    	id territoryid=tsr.getId();
    	TerritoryAccount__c testTerritoryAccount=new TerritoryAccount__c(Territory__c=territoryid,Account__c=accountid);
    	Database.SaveResult tasr = Database.insert(testTerritoryAccount,false);
    	id territoryaccountid=tasr.getId();
    	TerritoryUser__c testTerritoryUser=new TerritoryUser__c(Territory__c=territoryid,User__c=firstStandardUser.Id);
    	Database.SaveResult tusr = Database.insert(testTerritoryUser,false);
    	id territoryuserid=tusr.getId();
    	testTerritoryUser=[select Id from TerritoryUser__c where Id=:territoryuserid limit 1];
    	delete testTerritoryUser;
    }
    
    
}