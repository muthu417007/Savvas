@istest
public class testQueryAssetsFromParentAccController {
    public static testMethod void testQueryAssetController(){
      PageReference pageRef = Page.QueryAssetsFromParentAccountPage;
      Test.setCurrentPage(pageRef);
      List<account> acclist = new List<account>();
      
      //Call the testDataFactory which creates 6 accounts and 1 contact for each account
      Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(6,0,1);
      list<account> accUpdate = new list<account>();
      list<asset> assetList = new list<asset>();
      
      //Creates the account hierarchy
      for(Integer i=1;i<6;i++){
                accts[i].ParentId=accts[i-1].Id;
            	accts[i].BillingState='CA';
            	accts[i].BillingPostalCode='94560';
            	accts[i].BillingCountry='United States';
                accUpdate.add(accts[i]);

      }
      update accUpdate;
    
      //Create assets on Parent Account
      for(Integer a=0;a<5;a++){
          Asset asst=new asset(Name = 'Product Asset '+a,Accountid=accts[0].Id);
          assetList.add(asst);
        }
      insert assetList;
      
      //Start Test Context, It will reset all Governor limits
      Test.startTest();
      
      //Intialize new objects
      QueryAssetsFromParentAccountController cont = new QueryAssetsFromParentAccountController();
      //Pass the ID of the child account
      ApexPages.currentPage().getParameters().put('id',accts[5].Id);
      QueryAssetsFromParentAccountController Controller = new QueryAssetsFromParentAccountController();
	        
      list<Asset> asst=Controller.getAccountAssets();
        
      //Check to see that same number of asset is returned
      system.assertEquals(5, asst.size());
      integer pageNum=Controller.pageNumber;
      integer rSize=Controller.ResultSize;
      integer pSize=Controller.ResultPageSize;
      boolean nextPage=Controller.hasNext;
      Controller.next();
      boolean prevPage=Controller.hasPrevious;
      Controller.previous();
      Controller.first();
      Controller.last();
      Controller.cancel();
      Controller.resetFilter();
      controller.filterProdSearch='Prod';
      controller.getAccountAssets();
     
      Test.stopTest();
    }
    public static testMethod void testQueryAssetControllerWithFilter(){
      PageReference pageRef = Page.QueryAssetsFromParentAccountPage;
      Test.setCurrentPage(pageRef);

      //Create an Account
	  Account acc=new Account(Name='Test Account',
            	BillingState='CA',
            	BillingPostalCode='94560',
            	BillingCountry='United States');
      insert acc;
        
      //Create a Contact
	  Contact cont=new Contact(FirstName='Joe',LastName='Doe',Email='j.doe@test.com',accountid=acc.Id);
      insert cont;
      
      //Create a Product
      Product2 newProd = new Product2(PRODUCTCODE='Prod1',Name='Product',ISACTIVE=TRUE,CURRENCYISOCODE='USD');
      insert newProd;
        
      //Create an Asset
      Asset asst=new asset(Name = 'Product Asset 2: ',Accountid=acc.id,Product2Id=newProd.id,contactId=cont.id);
      insert asst;
      
      //Start Test Context, It will reset all Governor limits
      Test.startTest();
      
      //Pass the ID of the child account
      ApexPages.currentPage().getParameters().put('id',acc.Id);
      QueryAssetsFromParentAccountController Controller = new QueryAssetsFromParentAccountController();
	  controller.filterProdSearch='Product';      
      list<Asset> asstList=Controller.getAccountAssets();

      //Check to see that same number of asset is returned
      system.assertEquals(1, asstList.size());    
     
      Test.stopTest();
    }
}