@isTest
public class testLeadAccountSearchController {
    //test method for LeadAccountSearchController
    public static testMethod void testsearchcontroller() {
      PageReference pageRef = Page.LeadAccountSearchPage;
      Test.setCurrentPage(pageRef);
      List<account> acclist = new List<account>();
      lead ld=new lead(Company='TestAccount',state='CA',firstname = 'John',LastName='test',PostalCode='94560',status='Unqualified',LeadSource='Web Lead',email='Test@test.com');
      insert ld;
      Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(6,3,0);
        list<account> accUpdate = new list<account>();
        
        //Creates the account hierarchy
        for(Integer i=1;i<6;i++){
                accts[i].ParentId=accts[i-1].Id;
            	accts[i].BillingState='CA';
            	accts[i].BillingPostalCode='94560';
            	accts[i].BillingCountry='United States';
                accUpdate.add(accts[i]);
        }
      update accUpdate;  
        
      Test.startTest();
      ApexPages.standardcontroller ldsc = new apexpages.StandardController(ld);
      LeadAccountSearchController controller = new LeadAccountSearchController(ldsc);
      controller.searchAccNameSt();
      controller.searchZip();
      controller.accId=accts[5].Id;
      controller.searchRecords();
      controller.next();
      controller.previous();
      controller.lastPage();
      controller.firstPage();
      controller.getprev();
      controller.getnxt();
      controller.accTab();
      controller.oppTab();
      controller.next();
      controller.previous();
      controller.lastPage();
      controller.firstPage();
      controller.getprev();
      controller.getnxt();
      Test.stopTest();
    }
    
    //test method for LeadAccountSearchController2
    public static testMethod void testsearchcontroller2() {
      PageReference pageRef = Page.LeadAccountSearchPage;
      Test.setCurrentPage(pageRef);
      List<account> acclist = new List<account>();
      lead ld2=new lead(Company='Test\'Account',state='C\'A',firstname = 'Jane',LastName='test',PostalCode='94560',status='Unqualified',LeadSource='Web Lead',email='Test2@test.com');
      insert ld2;
      Test.startTest();
      ApexPages.standardcontroller ldsc = new apexpages.StandardController(ld2);
      LeadAccountSearchController controller = new LeadAccountSearchController(ldsc);
      controller.searchAccNameSt();
      controller.searchZip();
      Test.stopTest();
    }
        //test method for LeadAccountSearchController3
    public static testMethod void testsearchcontroller3() {
      PageReference pageRef = Page.LeadAccountSearchPage;
      Test.setCurrentPage(pageRef);
      List<account> acclist = new List<account>();
      lead ld2=new lead(Company='Test Account 3',firstname = 'Jane',LastName='test',status='Unqualified',LeadSource='Web Lead',email='Test2@test.com');
      insert ld2;
      Test.startTest();
      ApexPages.standardcontroller ldsc = new apexpages.StandardController(ld2);
      LeadAccountSearchController controller = new LeadAccountSearchController(ldsc);
      controller.searchAccNameSt();
      controller.searchZip();
      Test.stopTest();
    }
}