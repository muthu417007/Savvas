@isTest
public class EdCloudControllerTest {
    static testMethod void uniTest(){
        
        Account objAccount = new Account(Name = 'Test Account');   
        insert objAccount; 
        
        Ed_Cloud__c objEdCloud = new Ed_Cloud__c();
        objEdCloud.Account__c = objAccount.Id;
        insert objEdCloud;
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(objAccount);
        EdCloudController objEdCloudController = new EdCloudController(sc);
    } 
}