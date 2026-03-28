/********************************************************************
* 
* Author: batchClassToUpdateOldProductCategory
* Made Method: Updating the isQuotable,isVisible on the basis ProductCategory fields for Work Item W-013306
* Date Creaated : 10/10/2023 
* Created By :  Suraj
* Version: 1.0
*********************************************************************/
global class batchClassToUpdateOldProductCategory implements Schedulable, Database.Batchable<sobject>,Database.Stateful{
    global Set<Id> prdctCatIdIsVisibleProcessed = new Set<Id>();
    global void execute(SchedulableContext sc)
    {
        batchClassToUpdateOldProductCategory bc = new batchClassToUpdateOldProductCategory();
        Database.executeBatch(bc, 200);
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = System.Label.fetchProductCategoryQuery;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<ProductCategory> prductCategory){
        Map<Id, Boolean> productCategoryMapIsVisible = new Map<Id, Boolean>();
        Map<Id, Boolean> productCategoryMapIsQuotable = new Map<Id, Boolean>();
        Map<Id, Boolean> productCategoryMapIsVisibleParentHeirarchy = new Map<Id, Boolean>();
        Map<Id, Boolean> productCategoryMapIsQuotableParentHeirarchy = new Map<Id, Boolean>();
        Set<Id> prdctCatId = new Set<Id>();
        
        for(ProductCategory prdctCat :prductCategory){
            prdctCatId.add(prdctCat.Id);
        }
        
        map<id,ProductCategoryProduct> productctgMap = new map<id,ProductCategoryProduct>();
        
        for( ProductCategoryProduct prodctglst : [Select Id, productId,ProductCategoryId from ProductCategoryProduct where Product.Is_Visible__c = true AND ProductCategoryId IN:prdctCatId])
        {
            productctgMap.put(prodctglst.ProductCategoryId,prodctglst);
        }
        
        for (ProductCategory pdtCat : prductCategory) {
            Boolean isVisible = false;
            Boolean isQuotable = false;
            
            if (pdtCat.ISFEATURED__c) {
                isVisible = true;
            }
            
            else if (pdtCat.Catalogs__c != null && pdtCat.Catalogs__c != 'Quoting' && productctgMap.containsKey(pdtCat.Id) && productctgMap.get(pdtCat.Id)!= null) {
                isVisible = true;
            }
            
            else if (!pdtCat.ISFEATURED__c && productctgMap.containsKey(pdtCat.Id) && productctgMap.get(pdtCat.Id)== null) {
                isVisible = false;
            }
            
            else if (pdtCat.Catalogs__c == null || pdtCat.Catalogs__c == 'Quoting') {
                isVisible = false;
            }
            
            if (pdtCat.Catalogs__c != null && pdtCat.Catalogs__c.contains('Quoting') && productctgMap.containsKey(pdtCat.Id) && productctgMap.get(pdtCat.Id)!= null) {
                isQuotable = true;
            }
            //Start : Added for updating the Parent hierarchy
            if(isVisible){
                //productCategoryMapIsVisibleParentHeirarchy.put(pdtCat.Id, isVisible);
                prdctCatIdIsVisibleProcessed.add(pdtCat.Id);
            }
            //Not Completed the Logic for isQuotable as logic to update Catelogs as Quoating is not in place in Production as on 10/13/2023
            /*if(isQuotable){
                productCategoryMapIsQuotableParentHeirarchy.put(pdtCat.Id, isQuotable);
            }*/
            //End : Added for updating the Parent hierarchy
            
            productCategoryMapIsVisible.put(pdtCat.Id, isVisible);
            productCategoryMapIsQuotable.put(pdtCat.Id, isQuotable);
        }
        List<ProductCategory> updatePrdCtr = new List<ProductCategory>();
        
        for (Id categoryId : productCategoryMapIsVisible.keySet()) {
            
            ProductCategory p = new ProductCategory();
            p.Id = categoryId;
            p.Is_Quotable__c = productCategoryMapIsQuotable.get(categoryId);
            p.IS_VISIBLE__c = productCategoryMapIsVisible.get(categoryId);
            
            updatePrdCtr.add(p);
        }
        
        if(!updatePrdCtr.isEmpty()){
            Database.SaveResult[] updateResults = Database.update(updatePrdCtr, false);
            
            for (Database.SaveResult sr : updateResults){
                
                if (sr.isSuccess()) {
                    System.debug('Successfully inserted ' + sr.getId());
                }else{
                    for(Database.Error err : sr.getErrors()) {
                        //store this info in new collection 
                        System.debug(err.getStatusCode() + ': ' + err.getMessage() +' for the recordId '+sr.getId());
                        System.debug('field Error ' + err.getFields());
                    }
                }
            }
        }
        //Start : Added for updating the Parent hierarchy
        /*if(productCategoryMapIsVisibleParentHeirarchy != null && productCategoryMapIsVisibleParentHeirarchy.size()>0){
            updateParentHierarchy(productCategoryMapIsVisibleParentHeirarchy.keySet());
        }*/
        //End : Added for updating the Parent hierarchy
    }
    global void finish(Database.BatchableContext BC){
        updateParentHierarchy(prdctCatIdIsVisibleProcessed);
        system.debug('finish--');
    }
    //Start : Added for updating the Parent hierarchy
    global void updateParentHierarchy(Set<Id> setPCIds){
        List<ProductCategory> lstProductCategories = new List<ProductCategory>();
        lstProductCategories = [Select Id,IS_VISIBLE__c,Is_Quotable__c,
                                ParentCategoryId,
                                ParentCategory.ParentCategoryId,
                                ParentCategory.ParentCategory.ParentCategoryId,
                                ParentCategory.ParentCategory.ParentCategory.ParentCategoryId,
                                ParentCategory.ParentCategory.ParentCategory.ParentCategory.ParentCategoryId,
                                ParentCategory.ParentCategory.ParentCategory.ParentCategory.ParentCategory.ParentCategoryId,
                                Name from ProductCategory where Id IN:setPCIds];
        Set<Id> setProdCatIds = new Set<Id>();
        Set<ProductCategory> setUpdateProductCategories = new Set<ProductCategory>();
        for(ProductCategory pc : lstProductCategories){
            //Grand Child
            if (pc.IS_VISIBLE__c && pc.ParentCategoryId != null && !setProdCatIds.contains(pc.ParentCategoryId)){
                ProductCategory ppcu = new ProductCategory();
                ppcu.Id = pc.ParentCategoryId;
                ppcu.IS_VISIBLE__c = pc.IS_VISIBLE__c;
                setUpdateProductCategories.add(ppcu);
                setProdCatIds.add(pc.ParentCategoryId);
            }
            //Child
            if (pc.IS_VISIBLE__c && pc.ParentCategory.ParentCategoryId != null && !setProdCatIds.contains(pc.ParentCategory.ParentCategoryId)){
                ProductCategory ppcu = new ProductCategory();
                ppcu.Id = pc.ParentCategory.ParentCategoryId;
                ppcu.IS_VISIBLE__c = pc.IS_VISIBLE__c;
                setUpdateProductCategories.add(ppcu);
                setProdCatIds.add(pc.ParentCategory.ParentCategoryId);
            }
            //Parent
            if (pc.IS_VISIBLE__c && pc.ParentCategory.ParentCategory.ParentCategoryId != null && !setProdCatIds.contains(pc.ParentCategory.ParentCategory.ParentCategoryId)){
                //Parent
                ProductCategory ppcu = new ProductCategory();
                ppcu.Id = pc.ParentCategory.ParentCategory.ParentCategoryId;
                ppcu.IS_VISIBLE__c = pc.IS_VISIBLE__c;
                setUpdateProductCategories.add(ppcu);
                setProdCatIds.add(pc.ParentCategory.ParentCategory.ParentCategoryId);
            }
            //Grand Parent
            if (pc.IS_VISIBLE__c && pc.ParentCategory.ParentCategory.ParentCategory.ParentCategoryId != null && !setProdCatIds.contains(pc.ParentCategory.ParentCategory.ParentCategory.ParentCategoryId)){
                //Parent
                ProductCategory ppcu = new ProductCategory();
                ppcu.Id = pc.ParentCategory.ParentCategory.ParentCategory.ParentCategoryId;
                ppcu.IS_VISIBLE__c = pc.IS_VISIBLE__c;
                setUpdateProductCategories.add(ppcu);
                setProdCatIds.add(pc.ParentCategory.ParentCategory.ParentCategory.ParentCategoryId);
            }
            //Great Grand Parent
            if (pc.IS_VISIBLE__c && pc.ParentCategory.ParentCategory.ParentCategory.ParentCategory.ParentCategoryId != null && !setProdCatIds.contains(pc.ParentCategory.ParentCategory.ParentCategory.ParentCategory.ParentCategoryId)){
                //Parent
                ProductCategory ppcu = new ProductCategory();
                ppcu.Id = pc.ParentCategory.ParentCategory.ParentCategory.ParentCategory.ParentCategoryId;
                ppcu.IS_VISIBLE__c = pc.IS_VISIBLE__c;
                setUpdateProductCategories.add(ppcu);
                setProdCatIds.add(pc.ParentCategory.ParentCategory.ParentCategory.ParentCategory.ParentCategoryId);
            }
            //Great Great Grand Parent
            if (pc.IS_VISIBLE__c && pc.ParentCategory.ParentCategory.ParentCategory.ParentCategory.ParentCategory.ParentCategoryId != null && !setProdCatIds.contains(pc.ParentCategory.ParentCategory.ParentCategory.ParentCategory.ParentCategory.ParentCategoryId)){
                //Parent
                ProductCategory ppcu = new ProductCategory();
                ppcu.Id = pc.ParentCategory.ParentCategory.ParentCategory.ParentCategory.ParentCategory.ParentCategoryId;
                ppcu.IS_VISIBLE__c = pc.IS_VISIBLE__c;
                setUpdateProductCategories.add(ppcu);
                setProdCatIds.add(pc.ParentCategory.ParentCategory.ParentCategory.ParentCategory.ParentCategory.ParentCategoryId);
            }
        }
        if(setUpdateProductCategories.size() > 0){
            List<ProductCategory> lstUpdateProductCategories = new List<ProductCategory>();
            lstUpdateProductCategories.addAll(setUpdateProductCategories);
            if(lstUpdateProductCategories.size() > 0){
                Database.SaveResult[] updateResults = Database.update(lstUpdateProductCategories, false);
                system.debug('updateResults>>'+updateResults);
                for (Database.SaveResult sr : updateResults){
                    system.debug('sr>>>>>'+sr);
                    if (sr.isSuccess()) {
                        System.debug('Successfully inserted ' + sr.getId());
                    }else{
                        for(Database.Error err : sr.getErrors()) {
                            //store this info in new collection 
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('feild Error ' + err.getFields());
                        }
                    }
                }
            }
        }
    }
    //End : Added for updating the Parent hierarchy
}