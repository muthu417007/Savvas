@isTest
public class TestSearchContactMassSample {
    static Testmethod void AddRecords(){
     
         //Start Test Context, It will reset all Governor limits
        Test.startTest();
        
        //Inform Test Class to set current page as your Page where Extension is used
        PageReference pageRef=Page.SearchContactMassSamplePage;
        
        SampleRequest__c sample = new SampleRequest__c();
        insert sample;
        
        //Calls Data Factory that create's 2 accounts with each account having 2 contacts
        list<account> acctList = TestDataFactory.createAccountsWithOppsAndCont(2,0,2);
        List<Contact> contList=[Select Id, Name, Phone from Contact where accountid IN: acctList];
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('sampleId',sample.Id);
        //Instantiate object of "ApexPages.StandardSetController" by passing array of record  
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(contList);
        
        //Now, create Object of your Controller extension with no arguments
        SearchContactMassSampleController s=new SearchContactMassSampleController();
        
        //Now, create Object of your Controller extension by passing object of standardController
        SearchContactMassSampleController scms=new SearchContactMassSampleController(stdSetController);
        
        SelectOption[] selOptions = scms.getContactExistingViews();
        system.assertNotEquals(0, selOptions.size());
        
        scms.firstPage();
        list<SearchContactMassSampleController.wrapContacts> wContList = scms.getContacts();
        system.assertEquals(4, wContList.size());
        
        scms.next();
        Boolean nextPage=scms.hasNext;
        scms.prev();
        scms.resetFilter();
        scms.lastPage();
        Boolean prevPage=scms.hasPrevious;
        scms.toggleSelectAll();
        scms.runSelectedQuery();
        
        wContList[0].isSelected=false;   //Unselect the first Contact
        scms.runSelectedQuery();
        scms.toggleSelectAll();
        scms.runSelectedQuery();
        scms.Add();        
        scms.Cancel();
        Test.stopTest();
    }
}