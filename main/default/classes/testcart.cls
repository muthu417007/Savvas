public  class testcart {
  
    public class reviewCartWrapper{
        
        @AuraEnabled public Id cartId;
        @AuraEnabled public String description;
        @AuraEnabled public String isbn;
        @AuraEnabled public String copyRight;
        @AuraEnabled public String gradeLevel;
        @AuraEnabled public Decimal price;
        @AuraEnabled public String status;
        @AuraEnabled public String stockAvailability;
        @AuraEnabled public decimal quantity;
         @AuraEnabled public decimal totalPrice;
      
        
    }
     @AuraEnabled 
    public static  void getActiveCartItems(){
        
      WebCart webca= new WebCart(
            id='0a6W40000000zbNIAQ',
            IsSecondary=false,
            ownerId = '005W4000001mIEzIAM'           
        
        );

           
         system.debug('WebCartcartItems update action'+ webca);
        try {
                  update webca;
            }
            catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }   
        
        List<reviewCartWrapper> itemsFromCart = new  List<reviewCartWrapper>();
                List<CartItem> cartItems = new  List<CartItem>();
         /* cartItems=[SELECT Id, SalesPrice,Quantity, TotalPrice, Product2.Id, Product2.Availability__c,Product2.Copyright_Year__c, Product2.Grade_Level__c, Product2.ISBN13__c,Product2.Product_Status__c, Product2.Description, Product2.ISBN10__c
						  FROM CartItem
                          WHERE CartId = :activeCartId];  */
        
        		 List<WebCart> WebCartcartItems = new  List<WebCart>();
       List<WebCart> WebCartcartItemsupdate = new  List<WebCart>();
        		WebCartcartItems =[select AccountId,CreatedById,CreatedDate,Id,IsSecondary,LastModifiedById,LastModifiedDate,Name,OwnerId,Status,TotalAmount,TotalProductAmount,TotalProductCount,Type,WebStoreId FROM WebCart
                                  where AccountId='0015300000U1p4NAAR' AND WebStoreId='0ZEW40000002101OAA'];
        system.debug('WebCartcartItems'+ WebCartcartItems);
      /*  if(!WebCartcartItems.isEmpty()){
              for (WebCart acc : WebCartcartItems) {
                   system.debug('WebCartcartItems for loop');
                  acc.IsSecondary = true;
                  
                  WebCartcartItemsupdate.add(acc);
            
        } 
          
              try {
                  update WebCartcartItemsupdate;
            }
            catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            } 
        } */
            
         /*      public void updatewebcarts( List<WebCart> WebCartcartItemsupdate){
                update WebCartcartItemsupdate;
            }
          /*   try {
                  update WebCartcartItemsupdate;
            }
            catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }  
         
        		
      
         
           cartItems=[SELECT Id, SalesPrice,Quantity, TotalPrice, Product2.Id, Product2.Availability__c,Product2.Copyright_Year__c, Product2.Grade_Level__c, Product2.ISBN13__c,Product2.Product_Status__c, Product2.Description, Product2.ISBN10__c
						  FROM CartItem
                          WHERE CartId ='0a6W40000000wYfIAI']; */
        
       

    }
}