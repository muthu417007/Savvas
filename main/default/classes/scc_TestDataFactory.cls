/*********************************************************** 
* @Class Name  - scc_TestDataFactory
* @description - common test data factory for scc
* @Created By  - CTS-Muthukumar
* @Created On - 2024-05-20
* **********************************************************/ 
@IsTest
public class scc_TestDataFactory {
    public static Account accountCreation(String name) {
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Schools Account'].Id;
        Account newacc= new Account();
        newacc.Name= name;
        newacc.RecordTypeId = strRecordTypeId;
        newacc.SAP_Account_Id__c ='TestSAN';
        insert newacc;
       return newacc;	
	}
        public static Account accountCreation2(String name) {
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Schools Account'].Id;
        Account newacc= new Account();
        newacc.Name= name;
        newacc.BillingPostalCode = '12345';
        newacc.BillingCountry = 'United States';
        newacc.BillingState = 'MH';
        newacc.MDR_PID__c = '9998877';
        newacc.Account_Status__c='Active';
        newacc.RecordTypeId = strRecordTypeId;
        newacc.SAP_Account_Id__c ='TestSAN';
        newacc.type ='public school';   
        insert newacc;
        return newacc;	
	}
    public static Contact contactCreation( Id accountId, String firstName, String LastName, String Email) {
        Contact cont = new Contact();
        cont.AccountId = accountId;
        cont.LastName = LastName;
        cont.Email = Email;
        cont.FirstName = firstName;
        insert cont;
        return cont;
        
    }
    public static User userCreation(Id contactId){
         //Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Login User' LIMIT 1];
           Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Savvas External Users Base Profile' LIMIT 1];
           User testUser = new User();
    		testUser.ProfileId=profileId.Id;          
            testUser.LastName = 'Test User';
            testUser.Email = 'testuser@example.com';
            testUser.Username = 'testuser@example.com' + System.currentTimeMillis();
            testUser.Alias = 'tuser';
            testUser.TimeZoneSidKey = 'America/Los_Angeles';
            testUser.LocaleSidKey = 'en_US';
            testUser.EmailEncodingKey = 'UTF-8';
            testUser.LanguageLocaleKey = 'en_US';
            testUser.ContactId=contactId;
        insert testUser;
        return testUser;
    }
    
    public static Product2 productCreation1(){
            Product2 produc = new Product2();
            produc.Name = 'Better Business';
            produc.Discipline__c = 'SPECIAL MARKETS';
            produc.ISBN10__c = '0134522745';
            produc.ISBN13__c = '9780134522746';
            produc.Description = 'BETTER BUSINESS';
            produc.Product_Sub_Type__c = 'Pupil Text Hardcover';
            produc.Grade_Level__c = 'CU';
            produc.Copyright_Year__c = '2023';
            produc.Product_Status__c = 'IN PRINT';
            produc.Net_Price__c = 124.99;
            produc.IsActive = true;
            produc.Material_Type_ID__c = 'ZSBN';  
            produc.Product_Type_ID__c ='SOL';
        	produc.ProductCode ='BB-001';
        	insert produc;
        return produc;
    }    
    public static Product2 productCreation2(){
            Product2 Produc2 = new Product2();
            Produc2.Name = 'Better Burst';
            Produc2.Discipline__c = 'SPECIAL MARKETS';
            Produc2.ISBN10__c = '0134522746';
            Produc2.Description = 'BETTER BURST1';
            Produc2.Product_Sub_Type__c = 'Pupil Text Hardcover';
            Produc2.Grade_Level__c = 'CU';
            Produc2.Copyright_Year__c = '2023';
            Produc2.Product_Status__c = 'IN PRINT';
        	Produc2.Program_Series__c ='NATL';
            Produc2.Net_Price__c = 129.99;
            Produc2.IsActive = true;
            Produc2.Material_Type_ID__c = 'ZSBN';
        	Produc2.ProductCode ='CC-001';
        	insert produc2;
        return produc2;
    }    
     public static void initialStorefrontSetup(Id  webStoreId,  Id accountId, String accountName) {
      
        BuyerGroup buyGrp = new BuyerGroup();
        buyGrp.Name = 'MySavvasOrders Buyer Group';
        insert buyGrp;
        
        WebStoreBuyerGroup webStrBuyerGrp = new WebStoreBuyerGroup();
        webStrBuyerGrp.WebStoreId = webStoreId;
        webStrBuyerGrp.BuyerGroupId = buyGrp.Id;
        insert webStrBuyerGrp;
        
        BuyerAccount buyrAcc = new BuyerAccount();
        buyrAcc.Name = accountName;
        buyrAcc.BuyerId = accountId;
        buyrAcc.IsActive = true;
        insert buyrAcc;  
        
        BuyerGroupMember buyGrpMem = new BuyerGroupMember();
        buyGrpMem.BuyerId = accountId;
        buyGrpMem.BuyerGroupId = buyGrp.Id;
        insert buyGrpMem;   
       
     }
    
     public static WebCart webCartCreation( Id accountId, Id userId, Id webstoreId) {
       WebCart webca = new WebCart(
                AccountId= accountId,
                IsSecondary = False,
                OwnerId = userId,
                Name = 'cart',
           		User_Cart_Name__c = 'cart1',
                WebStoreId = webstoreId,
           		BillingCountry='India',
           		Shipping_Country__c='India',
           		Shipping_State__c='Kerala',
           		Specify_One_Time_Shipping__c=false,
           		School_Or_District__c=false,
           		Status = 'Active'
            );
            insert webca;
         return webca;
             }
    
    public static WebCart webCartCreationIsSec( Id accountId, Id userId, Id webstoreId) {
       WebCart webca = new WebCart(
                AccountId= accountId,
                IsSecondary = true,
                OwnerId = userId,
                Name = 'cart',
                WebStoreId = webstoreId,
           		Status = 'Active'
            );
            insert webca;
         return webca;
             }
    
    public static CartDeliveryGroup cartDeliverGroupCreation(Id webcartId){
     CartDeliveryGroup newCDG= new CartDeliveryGroup(
                name=scc_constantHelper.DELIVERY_GROUP_SAVVAS,
                CartId=webcartId
            );
        insert newCDG;
        return newCDG;
    }
    
    public static CartItem cartItemCreation( Id cartId,Id productId,  Id cartDeliveryGroupId, String productNam) { 
          CartItem cartItems = new CartItem(
                CartId = cartId,
                Product2Id = productId,
                Quantity = 4,
                SalesPrice = 450,
                TotalPrice = 4*450,
                NetUnitPrice = 450.00,
                CartDeliveryGroupId = cartDeliveryGroupId,
                Name = productNam);
            insert cartItems;
        return  cartItems;
    }
    public static Account internationalAccountCreation(String name) {
    String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Schools Account'].Id;
    Account newAcc = new Account();
    newAcc.Name = name;
    newAcc.RecordTypeId = strRecordTypeId;
    newAcc.SAP_Account_Id__c = 'TestSAN';
    newAcc.Type = 'International School'; // Set the Type to 'International School'
    newAcc.BillingCountry = 'United Kingdom'; // Set a non-US country
    insert newAcc;
    return newAcc;
}
}