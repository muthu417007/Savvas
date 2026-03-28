@isTest (SeeAllData=true)
public class testMassSampling {
    static testMethod void myUnitTestMassSample(){
        Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(1,0,1);
        SampleRequest__c sample = new SampleRequest__c();
        insert sample;
        contact cont=[Select ID from contact where accountid=:accts[0].Id];
        SampleRequestContact__c msc=new SampleRequestContact__c(Account__c=accts[0].Id,contact__c=cont.Id,SampleRequest__c=sample.Id);
        insert msc;
        PageReference pageRef = Page.MassSampleOverRide;
      	Test.setCurrentPage(pageRef);
        Test.startTest();
      	ApexPages.standardcontroller sampleSc = new apexpages.StandardController(sample);
      	MassSampleOverRideController controller = new MassSampleOverRideController(sampleSc);
        ApexPages.currentPage().getParameters().put('Id',Sample.id);
        controller.launchMassSample();
    }
    
        static testMethod void myUnitTestMassSample2(){
        Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(1,0,1);
        SampleRequest__c sample = new SampleRequest__c();
        insert sample;
        contact cont=[Select ID from contact where accountid=:accts[0].Id];
        PageReference pageRef = Page.MassSampleOverRide;
      	Test.setCurrentPage(pageRef);
        Test.startTest();
      	ApexPages.standardcontroller sampleSc = new apexpages.StandardController(sample);
      	MassSampleOverRideController controller = new MassSampleOverRideController(sampleSc);
        ApexPages.currentPage().getParameters().put('Id',Sample.id);
        controller.launchMassSample();
    }

    static testMethod void myUnitTestSingleMassSample1(){
        Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(1,0,1);
        SampleRequest__c sample = new SampleRequest__c();
        insert sample;
        contact cont=[Select ID from contact where accountid=:accts[0].Id];
        SampleRequestContact__c msc=new SampleRequestContact__c(Account__c=accts[0].Id,contact__c=cont.Id,SampleRequest__c=sample.Id);
        insert msc;
        Mass_Sample_Generic_Contacts__c msgc=new Mass_Sample_Generic_Contacts__c(Account__c=accts[0].Id,Mass_Sample_Generic__c=sample.Id,Generic_Contact__c='Teacher');
        insert msgc;
        PageReference pageRef = Page.Single_Mass_Sample;
      	Test.setCurrentPage(pageRef);
        Test.startTest();
      	ApexPages.standardcontroller sampleSc = new apexpages.StandardController(sample);
      	SingleMassSampleController controller = new SingleMassSampleController(sampleSc);
        controller.redirect();
    }

}