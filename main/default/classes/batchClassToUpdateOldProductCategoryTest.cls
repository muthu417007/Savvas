/********************************************************************
* 
* Author: batchClassToUpdateOldProductCategoryTest
* Made Method: This class is for batchClassToUpdateOldProductCategory for Work Item W-013306
* Date Creaated : 10/10/2023 
* Created By :  Suraj
* Version: 1.0
*********************************************************************/
@isTest
public class batchClassToUpdateOldProductCategoryTest {
    //test data 
    @IsTest
	static void testBatch() {
        /*PROS_Version_Setting__c pas = new PROS_Version_Setting__c();
        pas.Name = 'Version';
        insert pas;*/
		List<ProductCategory> rootCatToInsert = new List<ProductCategory>();
        List<Product2> product = new List<Product2>();
        List<ProductCategoryProduct> pdtcatPdt = new List<ProductCategoryProduct>();
        //List<ProductCategory> productCategories = new List<ProductCategory>();
        ProductCatalog pcatalog = new ProductCatalog();
        pcatalog.Name = 'HomeSchool Microcatalog';
        insert pcatalog;
       // Insert test data
       	Product2 pdt = new Product2();
        pdt.IS_VISIBLE__c = true;
        pdt.SAP_A_Check__c = true;
        pdt.Name = 'pdtTest';
        product.add(pdt);
        insert product;
        
		ProductCategory root1 = new ProductCategory(Name='catEducationServices', Description = 'Educational Services', CollectionID__c = 'catEducationServices', PROS_Catalog_ID__c = 'catEducationServices',CatalogId = pcatalog.Id, ISFEATURED__c = true);
        
        
        ProductCategory root2 = new ProductCategory(Name='catEducationServices', Description = 'Educational Services', CollectionID__c = 'catEducationServices', PROS_Catalog_ID__c = 'catEducationServices',CatalogId = pcatalog.Id, ISFEATURED__c = false ,Catalogs__c = 'Main');
        ProductCategory root3 = new ProductCategory(Name='catEducationServices', Description = 'Educational Services', CollectionID__c = 'catEducationServices', PROS_Catalog_ID__c = 'catEducationServices',CatalogId = pcatalog.Id, Catalogs__c = 'Quoting');
        ProductCategory root4 = new ProductCategory(Name='catEducationServices', Description = 'Educational Services', CollectionID__c = 'catEducationServices', PROS_Catalog_ID__c = 'catEducationServices',CatalogId = pcatalog.Id, ISFEATURED__c = false);
        rootCatToInsert.add(root1);
        rootCatToInsert.add(root2);
        rootCatToInsert.add(root3);
        rootCatToInsert.add(root4);
        insert rootCatToInsert;
        
        ProductCategory rootC = new ProductCategory(Name='catEducationServices', Description = 'Educational Services', CollectionID__c = 'catEducationServices', PROS_Catalog_ID__c = 'catEducationServices',CatalogId = pcatalog.Id);
        insert rootC;
        ProductCategory rootCC = new ProductCategory(ParentCategoryId = rootC.Id,Name='catEducationServices', Description = 'Educational Services', CollectionID__c = 'catEducationServices', PROS_Catalog_ID__c = 'catEducationServices',CatalogId = pcatalog.Id);
        insert rootCC;
        ProductCategory rootCCC = new ProductCategory(ParentCategoryId =rootCC.Id, Name='catEducationServices', Description = 'Educational Services', CollectionID__c = 'catEducationServices', PROS_Catalog_ID__c = 'catEducationServices',CatalogId = pcatalog.Id);
        insert rootCCC;
        ProductCategory rootCCCC = new ProductCategory(ParentCategoryId =rootCCC.Id, Name='catEducationServices', Description = 'Educational Services', CollectionID__c = 'catEducationServices', PROS_Catalog_ID__c = 'catEducationServices',CatalogId = pcatalog.Id);
        insert rootCCCC;
        ProductCategory rootCCCCC = new ProductCategory(ParentCategoryId =rootCCCC.Id, Name='catEducationServices', Description = 'Educational Services', CollectionID__c = 'catEducationServices', PROS_Catalog_ID__c = 'catEducationServices',CatalogId = pcatalog.Id);
        insert rootCCCCC;
        ProductCategory rootCCCCCC = new ProductCategory(ParentCategoryId =rootCCCCC.Id, Name='catEducationServices', Description = 'Educational Services', CollectionID__c = 'catEducationServices', PROS_Catalog_ID__c = 'catEducationServices',CatalogId = pcatalog.Id);
        insert rootCCCCCC;
        ProductCategory rootCCCCCCC = new ProductCategory(ParentCategoryId =rootCCCCCC.Id, Name='catEducationServices', Description = 'Educational Services', CollectionID__c = 'catEducationServices', PROS_Catalog_ID__c = 'catEducationServices',CatalogId = pcatalog.Id, ISFEATURED__c = true,Catalogs__c = 'Quoting');
        insert rootCCCCCCC;
        
        ProductCategoryProduct pdtCatPdt1 = new ProductCategoryProduct();
        pdtCatPdt1.ProductId = product[0].Id;
        pdtCatPdt1.ProductCategoryId = rootCatToInsert[0].Id;
        pdtcatPdt.add(pdtCatPdt1); 
        
        ProductCategoryProduct pdtCatPdt2 = new ProductCategoryProduct();
        pdtCatPdt2.ProductId = product[0].Id;
        pdtCatPdt2.ProductCategoryId = rootCatToInsert[2].Id;
        pdtcatPdt.add(pdtCatPdt2); 
        
        ProductCategoryProduct pdtCatPdt3 = new ProductCategoryProduct();
        pdtCatPdt3.ProductId = product[0].Id;
        pdtCatPdt3.ProductCategoryId = rootCatToInsert[1].Id;
        pdtcatPdt.add(pdtCatPdt3); 
		
        ProductCategoryProduct pdtCatPdt4 = new ProductCategoryProduct();
        pdtCatPdt4.ProductId = product[0].Id;
        pdtCatPdt4.ProductCategoryId = rootCatToInsert[3].Id;
        pdtcatPdt.add(pdtCatPdt4);
        
        ProductCategoryProduct pdtCatPdt5 = new ProductCategoryProduct();
        pdtCatPdt5.ProductId = product[0].Id;
        pdtCatPdt5.ProductCategoryId = rootCCCCCCC.Id;
        pdtcatPdt.add(pdtCatPdt5);
        
        //inserting ProductCategoryProduct
        insert pdtcatPdt;
        
        // Schedule the batch

        Test.startTest();
        batchClassToUpdateOldProductCategory batch = new batchClassToUpdateOldProductCategory();
        String jobId = System.schedule('TestBatch', '0 0 * * * ?', batch);
        Test.stopTest();
            
        // Query and assert on the updated records, or perform any other required assertions

        List<ProductCategory> updatedProductCategories = [SELECT Id, Is_Quotable__c,ISFEATURED__c, Catalogs__c,IS_VISIBLE__c FROM ProductCategory WHERE Id IN :rootCatToInsert];

        for (ProductCategory pc : updatedProductCategories) {
             System.assertEquals(4, updatedProductCategories.size());
        }

    }
}