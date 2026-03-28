/*
Apex Class:scc_relatedProductsLWC_Controller
Author: CTS (MuthuKumar)
Created Date: 03/04/2024
Reason: Backend logic Scc_relatedProductsLWC.
Modified Date: 15/04/2024
*/
public without sharing class scc_relatedProductsLWC_Controller {
    /**
*  Description: This method queries relatedproducts from Product2     
*  @name: getAllRelatedproducts
*  @param:productId
*  @return: List values of related products
*/
    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> getAllRelatedproducts(String productId) {        
        String prodId=productid;
        List<Product2> productDetails= new list<product2>();
        List<ProductWrapper> productData = new List<ProductWrapper>();
        try{
            productDetails=[select id,Program_Series__c, Item_Category_Group__c,Grade_Level__c,Copyright_Year__c,PRODUCT_GROUP_CODE__c from product2 where id=:prodId Limit 1];
            String programSeries = productDetails[0].Program_Series__c;
            String productGroup =productDetails[0].PRODUCT_GROUP_CODE__c;
            String gradeLevel= productDetails[0].Grade_Level__c;
            String copyRight=productDetails[0].Copyright_Year__c;
            productDetails =[SELECT Id,ISBN10__c,ISBN13__c,Description,SAP_C__c,Product_Sub_Type__c,Net_Price__c, Sales_Restriction_Code__c,Rights_Restriction_Code__c, Grade_Level__c,Copyright_Year__c,Product_Status__c,Item_Category_Group__c,Program_Series__c,IsActive,Product_Status_ID__c FROM Product2 
                                 WHERE Program_Series__c =:programSeries 
                                 AND PRODUCT_GROUP_CODE__c =:productGroup
                                 AND Copyright_Year__c =:copyRight
                                 AND Grade_Level__c =:gradeLevel];
            
            
            for(Product2 prod:productDetails){
                if(String.isBlank(prod.ISBN13__c)){
                    prod.ISBN13__c=prod.ISBN10__c;
                }
                
                ProductWrapper wrapper = new ProductWrapper();
                wrapper.Id=prod.Id;
                wrapper.ISBN10=prod.ISBN10__c;
                wrapper.ISBN13=prod.ISBN13__c;
                wrapper.Description=prod.Description;
                wrapper.SalesRestriction = prod.Sales_Restriction_Code__c;
                wrapper.RightsRestriction = prod.Rights_Restriction_Code__c;
                wrapper.Product_Sub_Type=prod.Product_Sub_Type__c;
                wrapper.Net_Price='NA';   
                wrapper.Grade_Level=prod.Grade_Level__c;
                wrapper.Copyright_Year=prod.Copyright_Year__c;
                wrapper.Product_Status=prod.Product_Status__c;
                wrapper.Item_Category_Group=prod.Item_Category_Group__c;
                wrapper.IsActive=prod.SAP_C__c;
                wrapper.Program_Series=prod.Program_Series__c;
                wrapper.Product_Status_ID =prod.Product_Status_ID__c;
                if(prodId != prod.Id)
                    productData.add(wrapper);
            }                        
        }catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString()); 
        }
        return productData;
    }
    /**
*  Description: This method queries relatedproductsdetails from Product2     
*  @name: getRelatedproductsDetail
*  @param:productId and ISBN
*  @return: List values of related product Detail
*/
    @AuraEnabled(cacheable=true) 
    public static List<product2> getRelatedproductsDetail(String proddetailid, String ISBN) {
        String proddetail=proddetailid;
        String DisplayISBN=ISBN;
        List<Product2> productDetail= new list<product2>();
        try{        
            productDetail =[SELECT ISBN10__c,ISBN13__c,Product_Sub_Type__c, Availability__c, Product_Status__c, Sales_Restriction_Code__c,Net_Price__c,SBQQ__BatchQuantity__c,Copyright_Year__c,Grade_Level__c, Grade_Range__c, Description FROM Product2 where id=:proddetail Limit 1];
            String Restriction=productDetail[0].Sales_Restriction_Code__c;       
            scc_sales_restriction__mdt Restrict = [SELECT Sales_Restriction_Description__c FROM scc_sales_restriction__mdt WHERE Code__c = :Restriction];
            String Resttrictiondesc=Restrict.Sales_Restriction_Description__c;
            if (DisplayISBN != null && String.isNotBlank(DisplayISBN)) {
                for(Product2 prod:productDetail){               
                    prod.ISBN13__c=DisplayISBN;
                    prod.Sales_Restriction_Code__c= Resttrictiondesc;
                }
            }            
        }catch(Exception e){
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
        return productDetail;
    }
    
    public class ProductWrapper {
        @AuraEnabled public String Id;
        @AuraEnabled public String ISBN10;
        @AuraEnabled public String ISBN13;
        @AuraEnabled public String Description;
        @AuraEnabled public String Product_Sub_Type;
        @AuraEnabled public String Net_Price;
        @AuraEnabled public String Grade_Level;
        @AuraEnabled public String Copyright_Year;
        @AuraEnabled public Id accountId;
        @AuraEnabled public String Product_Status;
        @AuraEnabled public String Item_Category_Group;
        @AuraEnabled public Boolean IsActive;
        @AuraEnabled public String Program_Series;
        @AuraEnabled public String SalesRestriction;
        @AuraEnabled public String RightsRestriction;
        @AuraEnabled public String Product_Status_ID;
    }    
}