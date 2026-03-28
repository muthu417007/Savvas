/*
Apex Test Class:scc_relatedProductsLWC_Controller_Test
Author: CTS (MuthuKumar)
Created Date: 03/04/2024
Modified Date: 15/04/2024
*/

@isTest 
public class scc_relatedProductsLWC_Controller_Test {
    
    List<product2> prod= new List<product2>();
    @isTest
    static void relatedproducttest(){
        List<product2> prod= new List<product2>();
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
        prod.add(produc);
        
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
        prod.add(Produc2);
        
        Product2 Produc1 = new product2();
        Produc1.Name = 'Better Business';
        Produc1.Discipline__c = 'SPECIAL MARKETS';
        Produc1.ISBN10__c = '0134522745';
        Produc1.ISBN13__c = '9780134522746';
        Produc1.Description = 'BETTER BUSINESS';
        Produc1.Product_Sub_Type__c = 'Pupil Text Hardcover';
        Produc1.Grade_Level__c = 'CU';
        Produc1.Copyright_Year__c = '2023';
        Produc1.Product_Status__c = 'IN PRINT';
        Produc1.Net_Price__c = 124.99;
        Produc1.IsActive = true;
        Produc1.Material_Type_ID__c = 'ZSBN';
        prod.add(Produc1);
        
        Product2 produc3 = new Product2();
        produc3.Name = 'Better Business';
        produc3.Discipline__c = 'SPECIAL MARKETS';
        produc3.ISBN10__c = '0134522745';
        produc3.Description = 'BETTER BUSINESS';
        produc3.Product_Sub_Type__c = 'Pupil Text Hardcover';
        produc3.Grade_Level__c = 'CU';
        produc3.Copyright_Year__c = '2023';
        produc3.Product_Status__c = 'IN PRINT';
        produc3.Net_Price__c = 124.99;
        produc3.IsActive = true;
        produc3.Material_Type_ID__c = 'ZSBN';
        prod.add(produc3);
        
        insert prod;
        
        String prodid=Prod[0].Id;
        String prodid1=Prod[1].Id;
        String prodid2=Prod[2].Id;
        String prodid3=Prod[3].Id;
        string ISBNVAl='9780133131482';
        
        TEST.StartTest();
        scc_relatedProductsLWC_Controller.getAllRelatedproducts(prodid);
        scc_relatedProductsLWC_Controller.getAllRelatedproducts(prodid1);
        scc_relatedProductsLWC_Controller.getAllRelatedproducts(prodid3);
        scc_relatedProductsLWC_Controller.getRelatedproductsDetail(prodid2,ISBNVAl);
        System.assertNotEquals(null,scc_relatedProductsLWC_Controller.getAllRelatedproducts(prodid));
        Test.stopTest();   
    }
}