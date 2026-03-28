public with sharing class QueryAssetsFromParentAccountController {
    private final contact cont;
    private set <Id> accIdSet;
    private Account currentAcc;
    public string filterProdSearch{get;set;}
        
	public QueryAssetsFromParentAccountController() {
        ID accId=ApexPages.currentPage().getParameters().get('id');
        accIdSet=new set<Id>();
       
        if(accId!=null){                 
            //Go through Account Hierarchy up to 5 levels.
            // --------------------------------------------------------------
			currentAcc = [select id, Name,ParentId,Parent.ParentId,Parent.Parent.ParentId,Parent.Parent.Parent.ParentId,Parent.Parent.Parent.Parent.ParentId from Account where id =: accId];
            if(currentAcc!=null){
                accIdSet.add(currentAcc.Id);
                if(currentAcc.Parent.Parent.Parent.Parent.ParentId!=null)
                    accIdSet.add(currentAcc.Parent.Parent.Parent.Parent.ParentId);
                if(currentAcc.Parent.Parent.Parent.ParentId!=null)
                    accIdSet.add(currentAcc.Parent.Parent.Parent.ParentId);
                if(currentAcc.Parent.Parent.ParentId!=null)
                    accIdSet.add(currentAcc.Parent.Parent.ParentId);
                if(currentAcc.Parent.ParentId!=null)
                    accIdSet.add(currentAcc.Parent.ParentId);
                if(currentAcc.ParentId!=null)
                    accIdSet.add(currentAcc.ParentId);
             }
            // --------------------------------------------------------------          
        }Else
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Fatal, 'There is no contact.'));
    }
    
    
    public ApexPages.StandardSetController assetRecords{
        get {
            if(assetRecords==null){
                if(string.isBlank(filterProdSearch)){
                	assetRecords=new ApexPages.StandardSetController(
                	Database.getQueryLocator([select ID, name,accountId,Product2id,product2.name,installDate,status,District_wide__c from asset where accountId IN:accIdSet and Id NOT IN(Select asset__c from Asset_Account_Exclusion__c where account__c =:accIdSet)]));
                }else{
                   string ProdVar ='%'+filterProdSearch+'%';
                   assetRecords=new ApexPages.StandardSetController(
                   Database.getQueryLocator([select ID, name,accountId,Product2id,product2.name,installDate,status,District_wide__c from asset where accountId IN:accIdSet and product2.name like:ProdVar and Id NOT IN(Select asset__c from Asset_Account_Exclusion__c where account__c =:accIdSet)]));
                 
                }     
                    assetRecords.setPageSize(20);
            }
            
        return assetRecords;
        }
        private set;
    }
    
    public List<Asset> getAccountAssets(){
        return(List<Asset>) assetRecords.getRecords();
    }
    /**
    * Reset List View
    */
    public PageReference resetFilter()
    {
      assetRecords = null;
      assetRecords.setPageNumber(1);
      return null;
    }

    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return assetRecords.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return assetRecords.getHasPrevious();
        }
        set;
    }

    // returns the first page of records
     public void first() {
         assetRecords.first();
     }

     // returns the last page of records
     public void last() {
         assetRecords.last();
     }

     // returns the previous page of records
     public void previous() {
         assetRecords.previous();
     }

     // returns the next page of records
     public void next() {
         assetRecords.next();
     }

     // returns the PageReference of the original page, if known, or the home page.
     public void cancel() {
         assetRecords.cancel();
     }
        
   //Return Page Number
    public Integer PageNumber{ 
    	get{
      		return assetRecords.getPageNumber();
    	}
        set;
    }
    
    //Return Result Size
    public Integer ResultSize{ 
    	get{
      		return assetRecords.getResultSize();
    	}
        set;
    }
    
   //Return Page Size
    public Integer ResultPageSize{ 
    	get{
      		return assetRecords.getPageSize();
    	}
        set;
    }
}