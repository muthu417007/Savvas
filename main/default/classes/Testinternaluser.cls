public class Testinternaluser {

    /*@AuraEnabled(cacheable=true)
    public static String getOrderStatusData() {
         User currentUser = [SELECT Id,  Email,ProfileId 
                            FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        Boolean isInternalUser = currentUser.ProfileId == '00ed00000015q0VAAQ';
       if (isInternalUser) {
        List<User> usr = [select ID,Profile.Name, Contact.AccountID,contact.name,contact.Account.name from user where Profile.Name =:'Customer Community Plus Login User'];
        //List<User> usr = [select ID,Profile.Name, Contact.AccountID,contact.name,contact.Account.name from user where Contact.AccountID ='0015300000U1p4NAAR'];        
        List<Order> getOrderData = [SELECT OrderNumber,Order_Status_Code__c,ShipTo_Name__c,PoNumber__c,SAP_Document_Number__c,EffectiveDate,Account_PO_Number__c FROM Order WHERE AccountId=:usr[0].Contact.AccountID ORDER BY EffectiveDate DESC,Account_PO_Number__c DESC, SAP_Document_Number__c DESC LIMIT 10 ];              
        List<getOrderStatusDataWrapper> getOrderStatusDataWrap = new List<getOrderStatusDataWrapper>();
        for(Integer i=0;i<getOrderData.size();i++){
            getOrderStatusDataWrap.add(new getOrderStatusDataWrapper(getOrderData[i].OrderNumber,getOrderData[i].Order_Status_Code__c,getOrderData[i].Account_PO_Number__c,getOrderData[i].SAP_Document_Number__c,getOrderData[i].EffectiveDate,getOrderData[i].ShipTo_Name__c)); 
        }
       
       }
         return JSON.serialize(getOrderStatusDataWrap);
    }
    
     /*   // Fetch current user details
        User currentUser = [SELECT Id,  Email,ProfileId 
                            FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        // Determine if the user is an internal user
        //Boolean isInternalUser = currentUser.IsEmployee__c && currentUser.Email.endsWith('@savvas.com');
  	Boolean isInternalUser = currentUser.ProfileId == '00ed00000015q0VAAQ';
        system.debug(isInternalUser);
        List<Order> getOrderData;

        if (isInternalUser) {
            // Fetch recent orders viewed by external users
            // Assuming the orders viewed by external users are created by users with 'Customer Community' license
            getOrderData = [SELECT OrderNumber, Order_Status_Code__c, ShipTo_Name__c, PoNumber__c, SAP_Document_Number__c, EffectiveDate, Account_PO_Number__c 
                            FROM Order 
                            WHERE CreatedBy.Profile.Name = 'Customer Community Plus Login User' // Adjust this condition based on your criteria
                            ORDER BY EffectiveDate DESC, Account_PO_Number__c DESC, SAP_Document_Number__c DESC 
                            LIMIT 10];
            system.debug(getOrderData+'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
        } else {
            // Fetch recent orders for the logged-in external user's account
            getOrderData = [SELECT OrderNumber, Order_Status_Code__c, ShipTo_Name__c, PoNumber__c, SAP_Document_Number__c, EffectiveDate, Account_PO_Number__c 
                            FROM Order 
                            WHERE AccountId = :currentUser.Contact.AccountID 
                            ORDER BY EffectiveDate DESC, Account_PO_Number__c DESC, SAP_Document_Number__c DESC 
                            LIMIT 10];
        }

        // Prepare data wrapper
        List<getOrderStatusDataWrapper> getOrderStatusDataWrap = new List<getOrderStatusDataWrapper>();
        for (Order order : getOrderData) {
            getOrderStatusDataWrap.add(new getOrderStatusDataWrapper(order.OrderNumber, order.Order_Status_Code__c, order.Account_PO_Number__c, order.SAP_Document_Number__c, order.EffectiveDate, order.ShipTo_Name__c));
        }

        return JSON.serialize(getOrderStatusDataWrap);
    }*/
    

    @AuraEnabled(cacheable=true)
    public static String getOrderStatusData() {
        // Fetch current user details
        User currentUser = [SELECT Id, Email, ProfileId, Contact.AccountID 
                            FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        
        // Log current user details
        System.debug('Current User: ' + currentUser);

        Boolean isInternalUser = currentUser.ProfileId == '00ed0000000PDBqAAO'; 
        System.debug('Is Internal User: ' + isInternalUser);

        List<Order> getOrderData;
        List<getOrderStatusDataWrapper> getOrderStatusDataWrap = new List<getOrderStatusDataWrapper>();

        if (isInternalUser) {
            // Fetch orders viewed by users with 'ICOM Sales Rep Without Quoter' profile
            List<User> usr = [SELECT ID, Profile.Name,SAP_Account__c ,IsEmployee__c  FROM User 
                              WHERE Profile.Name = 'ICOM Sales Rep Without Quote' and  IsEmployee__c=true
                              LIMIT 1];
            
            // Log users fetched
            System.debug('Fetched Users withICOM Sales Rep Without Quoter: ' + usr);

            if (!usr.isEmpty()) {
                getOrderData = [SELECT OrderNumber, Order_Status_Code__c, ShipTo_Name__c, PoNumber__c, SAP_Document_Number__c, EffectiveDate, Account_PO_Number__c 
                                FROM Order 
                                WHERE AccountId = :usr[0].SAP_Account__c 
                                ORDER BY EffectiveDate DESC, Account_PO_Number__c DESC, SAP_Document_Number__c DESC 
                                LIMIT 10];
                
                // Log orders fetched for internal user
                System.debug('Fetched Orders for Internal User: ' + getOrderData);

                for (Order order : getOrderData) {
                    getOrderStatusDataWrap.add(new getOrderStatusDataWrapper(order.OrderNumber, order.Order_Status_Code__c, order.Account_PO_Number__c, order.SAP_Document_Number__c, order.EffectiveDate, order.ShipTo_Name__c));
                }
            } else {
                System.debug('No users found with Profile Customer Community Plus Login User.');
            }
        } else {
            // Fetch recent orders for the logged-in external user's account
            getOrderData = [SELECT OrderNumber, Order_Status_Code__c, ShipTo_Name__c, PoNumber__c, SAP_Document_Number__c, EffectiveDate, Account_PO_Number__c 
                            FROM Order 
                            WHERE AccountId = :currentUser.Contact.AccountID 
                            ORDER BY EffectiveDate DESC, Account_PO_Number__c DESC, SAP_Document_Number__c DESC 
                            LIMIT 10];
            
            // Log orders fetched for external user
            System.debug('Fetched Orders for External User: ' + getOrderData);

            for (Order order : getOrderData) {
                getOrderStatusDataWrap.add(new getOrderStatusDataWrapper(order.OrderNumber, order.Order_Status_Code__c, order.Account_PO_Number__c, order.SAP_Document_Number__c, order.EffectiveDate, order.ShipTo_Name__c));
            }
        }

        // Log the final wrapped data
        System.debug('Order Status Data Wrapper: ' + getOrderStatusDataWrap);

        return JSON.serialize(getOrderStatusDataWrap);
    }

   
 public class getOrderStatusDataWrapper{
       @AuraEnabled 
       public String OrderNumber {get;set;}
       @AuraEnabled 
       public String Status {get;set;}
       @AuraEnabled 
       public String PoNumber {get;set;}
       @AuraEnabled
       public String SAP_Document_Number {get;set;}
       @AuraEnabled 
       public String Account_PO_Number {get;set;}
       @AuraEnabled 
       public Date EffectiveDate;
       @AuraEnabled 
       public String ShipToName {get;set;}
            getOrderStatusDataWrapper(String OrderNumber,String Status,String PoNumber,String SAP_Document_Number,Date EffectiveDate,String ShipToName){
                this.OrderNumber = OrderNumber;
                this.Status = Status;
                this.PoNumber = PoNumber;
                this.SAP_Document_Number = SAP_Document_Number;
                this.Account_PO_Number = Account_PO_Number;
                this.EffectiveDate = EffectiveDate;
                this.ShipToName = ShipToName;
            }  
    }
   
}