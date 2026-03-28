@isTest
public class TestAssetTrigger {
    public static testMethod void testQueryAssetController(){ 
        
    	List<account> acclist = new List<account>();
        list<Product2> newProdList= new List<Product2>();
      
      	//Call the testDataFactory which creates 6 accounts and 1 contact for each account
      	Account[] accts = TestDataFactory.createAccountsWithOppsAndCont(1,0,1);
        
       contact cont=[Select ID, Name, email,MDR_Job_Code__c,Status__c from contact where accountid=:accts[0].id];
       cont.status__c='Active';
       cont.MDR_Job_Code__c='204';
       cont.Inactive__c=FALSE;
       cont.MDR_ID__c='00001-00002';
       update cont;
        
        //Create custom Settings record
        Product_List_CS__c prod=new Product_List_CS__c(Name='PRECALCULUS',ISBN13__c='9780133541342',Product__c='MathXL');
        insert prod;
        
       
       //Create EasyBridge and MathXl Products Product
       Product2 EZBridgeProd=new Product2(Name='EasyBridgePlus',ProductCode='EasyBridge Basic',isActive=True);
       insert EZBridgeProd;
       Product2 mathXlProd=new Product2(Name='PRECALCULUS',ProductCode='9780133541342',isActive=True);
       insert mathXlProd;
        
       Test.startTest();
       //Create assets on Parent Account
       Asset asst=new asset(Name = 'EasyBridge Auto',Accountid=accts[0].Id,product2id=EZBridgeProd.Id);
	   insert asst;
       Asset mathXLAsst=new asset(Name = 'MathXL Asset',Accountid=accts[0].Id,product2id=mathXlProd.Id);
	   insert mathXLAsst;
       Asset mathXLAsst2=new asset(Name = 'MathXL Asset 2',Accountid=accts[0].Id,product2id=mathXlProd.Id);
	   insert mathXLAsst2;
          
      Test.stopTest();
    }
}