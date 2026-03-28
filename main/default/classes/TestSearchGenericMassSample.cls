@isTest

public class TestSearchGenericMassSample {
	static Testmethod void AddRecords(){
     
         //Start Test Context, It will reset all Governor limits
        Test.startTest();
        
        //Inform Test Class to set current page as your Page where Extension is used
        PageReference pageRef=Page.SearchAccountGenericMassSamplePage;
        
        SampleRequest__c sample = new SampleRequest__c();
		insert sample;
        
        //Calls Data Factory that create's 2 accounts
        list<account> acctList = TestDataFactory.createAccountsWithOppsAndCont(2,0,0);
        Test.setCurrentPage(pageRef);

        //Instantiate object of "ApexPages.StandardSetController" by passing array of record  
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(acctList);
		
        //Now, create Object of your Controller extension with no arguments
        SearchAccountGenericMassSampleController s=new SearchAccountGenericMassSampleController();
        
        //Now, create Object of your Controller extension by passing object of standardController
		SearchAccountGenericMassSampleController sagms=new SearchAccountGenericMassSampleController(stdSetController);

        ApexPages.currentPage().getParameters().put('sampleId',sample.Id);
        
        SelectOption[] selOptions = sagms.getAccountExistingViews();
		system.assertNotEquals(0, selOptions.size());
        
        sagms.firstPage();
        sagms.genericContact='Teacher';
        list<SearchAccountGenericMassSampleController.wrapAccount> wAccList = sagms.getAccounts();
        system.assertEquals(2, wAccList.size());
        
        sagms.next();
        Boolean nextPage=sagms.hasNext;
        sagms.prev();
        sagms.resetFilter();
        sagms.lastPage();
        Boolean prevPage=sagms.hasPrevious;
        sagms.toggleSelectAll();
        sagms.runSelectedQuery();
        
        wAccList[0].isSelected=false;	//Unselect the first Account
        sagms.runSelectedQuery();
		sagms.toggleSelectAll();
        sagms.runSelectedQuery();
		sagms.Add();        
        sagms.Cancel();
        Test.stopTest();
    }

	    
    static Testmethod void noGenericContact(){
     
        //Start Test Context, It will reset all Governor limits
        Test.startTest();
        
        //Inform Test Class to set current page as your Page where Extension is used
        PageReference pageRef=Page.SearchAccountGenericMassSamplePage;
        
        SampleRequest__c sample = new SampleRequest__c();
		insert sample;
        
        //Calls Data Factory that create's 1 accounts
        list<account> acctList = TestDataFactory.createAccountsWithOppsAndCont(1,0,0);
        Test.setCurrentPage(pageRef);

        //Instantiate object of "ApexPages.StandardSetController" by passing array of record  
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(acctList);
		
        //Now, create Object of your Controller extension with no arguments
        SearchAccountGenericMassSampleController s=new SearchAccountGenericMassSampleController();
        
        //Now, create Object of your Controller extension by passing object of standardController
		SearchAccountGenericMassSampleController sagms=new SearchAccountGenericMassSampleController(stdSetController);

        ApexPages.currentPage().getParameters().put('sampleId',sample.Id);
        
        SelectOption[] selOptions = sagms.getAccountExistingViews();
		system.assertNotEquals(0, selOptions.size());
        
        sagms.firstPage();
        list<SearchAccountGenericMassSampleController.wrapAccount> wAccList = sagms.getAccounts();
        system.assertEquals(1, wAccList.size());
		sagms.toggleSelectAll();
        sagms.runSelectedQuery();
		sagms.Add();        
        Test.stopTest();
    }
}