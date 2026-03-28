public with sharing class LeadAccountSearchController{  
   public list <account> acc {get;set;} 
   public List<UserTerritory2Association> usersInTerr{get;set;}
   public list<Opportunity> opportunityList{get;set;}
   public list<Territory2> Territories{get;set;}
   public Id accId{get;set;}
   public String tabOpt{get;set;}
   private lead ld;
   private set<ID>pIdSet;
   private String searchType;
   private string previousTab;
   private integer offsetSize=0;
   private integer limitSize=10;
   private integer totalRecs=0; 
   private integer accOffsetSize=0;
   private integer accTotalRecs=0;
    
   public LeadAccountSearchController(ApexPages.StandardController controller) {  
       ld = (lead)controller.getRecord();
       usersInTerr=new list<UserTerritory2Association>();
       opportunityList=new list<Opportunity>();
       pIdSet=new set<ID>();
   }  

   public void searchAccNameSt(){ 
       string companyName;
       string companyState;
       tabOpt='Accounts';  
        if(previousTab!='Accounts'||searchType=='Zip'){
        	accoffsetSize=0;
            previousTab='Accounts';
        }
     
      if(ld.company!=null && ld.state!=null){
       //Statement that checks single quote and strips it
       if(ld.company.contains('\'')){
           companyName=ld.company.replaceAll('\'','');
       }else{
           companyName=ld.company;
       }
       
        if(ld.state.contains('\'')){
           companyState=ld.state.replaceAll('\'','');
        }else{
            companyState=ld.state;
        }
       
       
       string searchquery='select name,id,billingstate,BillingPostalCode,Do_Not_Contact__c,Do_Not_Contact_End_Date__c,Do_Not_Contact_Reason__c from account where name like \'%'+companyName+'%\' and billingstate like \'%' + companyState + '%\' order by name Limit '+limitSize+' OffSet '+accOffsetSize;  
       acc= Database.query(searchquery);                                                                                     
       string countQuery='select count() from account where name like \'%'+companyName+'%\' and billingstate like \'%'+ companyState + '%\'';
       accTotalRecs=database.countQuery(countQuery);
       }else
           ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please enter an Account name and State'));
       
   } 
    
    public void searchZip(){  
        if(previousTab!='Accounts'||searchType!='Zip'){
        	accoffsetSize=0;
            previousTab='Accounts';
        }
        tabOpt='Accounts';
        searchType='Zip';

        if(ld.PostalCode!=null){
     		string searchquery='select name,id,billingstate,BillingPostalCode,Do_Not_Contact__c,Do_Not_Contact_End_Date__c,Do_Not_Contact_Reason__c from account where BillingPostalCode like \'%'+ ld.PostalCode + '%\' order by name Limit '+limitSize+' OffSet '+accOffsetSize;  
     		acc= Database.query(searchquery); 
            string countQuery='select count() from account where BillingPostalCode like \'%'+ ld.PostalCode + '%\'';
			accTotalRecs=database.countQuery(countQuery);
        }else
             ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please enter an Zip Code'));
   }  
   
    public void searchRecords(){
        tabOpt='AGM';
        List <Id> tId = new List<ID>();

        List <ObjectTerritory2Association> otList=[Select Territory2Id FROM ObjectTerritory2Association where objectID =:accId];
        for(ObjectTerritory2Association ot:OtList)
        {
            tId.add(ot.Territory2Id);
        }
        territories=[select name,ParentTerritory2.name,territory2type.MasterLabel from territory2 where id=:tId And ParentTerritory2.name not in ('Clinical','Measurement','Virtual')];
        usersInTerr = [Select Id, UserId,user.name,user.phone,RoleInTerritory2 FROM UserTerritory2Association where Territory2Id =: tId and (RoleInTerritory2 = 'Account General Manager' or RoleInTerritory2 like '%AGM%')];     
   		pIdSet.clear();
        searchOpps();
    }
    public void searchOpps(){
        
		if(previousTab!='Opportunity'){
        	offsetSize=0;
            previousTab='Opportunity';
            totalRecs=0;
        }
        //Go through Account Hierarchy up to 5 levels.
        // --------------------------------------------------------------
        if(pIdSet.size()==0){
			Account accUltP = [select id, Name,ParentId,Parent.ParentId,Parent.Parent.ParentId,Parent.Parent.Parent.ParentId,Parent.Parent.Parent.Parent.ParentId from Account where id =: accId];
        	if(accUltP!=null){
           		if(accUltP.Parent.Parent.Parent.Parent.ParentId!=null)
           			pIdSet.add(accUltP.Parent.Parent.Parent.Parent.ParentId);
            	if(accUltP.Parent.Parent.Parent.ParentId!=null)
                	pIdSet.add(accUltP.Parent.Parent.Parent.ParentId);
            	if(accUltP.Parent.Parent.ParentId!=null)
                	pIdSet.add(accUltP.Parent.Parent.ParentId);
            	if(accUltP.Parent.ParentId!=null)
                	pIdSet.add(accUltP.Parent.ParentId);
            	if(accUltP.ParentId!=null)
                	pIdSet.add(accUltP.ParentId);     
            }
        }
        pIdSet.add(accId);
       // --------------------------------------------------------------
       opportunityList=[Select ID, Name, AccountId, amount,stagename,CloseDate from opportunity where AccountId=:pIdSet and isClosed=false and CloseDate >=THIS_YEAR order by CloseDate Limit:limitSize Offset:offsetSize];
       if(totalRecs==0)
        totalRecs=[Select count() from opportunity where AccountId=:pIdSet and isClosed=false and CloseDate >=THIS_YEAR];
       
    }
    //For Pagination, Returns to the first page
    public void firstPage(){
        if(tabOpt=='Opportunity'){
            OffsetSize = 0;
        	searchOpps();
        }else{
            accOffsetSize=0;
        	if(searchType=='Zip')
                searchZip();
            else
                searchAccNameSt();
        }
	}
    
    //For Pagination,  goes back to the previous page
	public void previous(){
		
        if(tabOpt=='Opportunity'){
            OffsetSize = OffsetSize - LimitSize;
            if(OffsetSize<0)
                OffsetSize=0;
        	searchOpps();
        }else{
            accOffsetSize=accOffsetSize-LimitSize;
            if(accOffsetSize<0)
                accOffsetSize=0;
        	if(searchType=='Zip')
                searchZip();
            else
                searchAccNameSt();
        }
	}
    
    //For Pagination,  goes to the next list of records
    public void next(){
        if(tabOpt=='Opportunity'){
            OffsetSize = OffsetSize + LimitSize;
            searchOpps();
        }else{
            accOffsetSize=accOffsetSize+LimitSize;
        	if(searchType=='Zip')
                searchZip();
            else
                searchAccNameSt();
        }
	}
    
    //For Pagination, goes to the last page of list of records
    public void lastPage(){
        if(tabOpt=='Opportunity'){
            system.debug(math.mod(totalRecs,LimitSize)+'Total Recs '+totalRecs);
            if(math.mod(totalRecs,LimitSize)!=0)
            	OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
            else
                OffsetSize=totalrecs-Limitsize;
            searchOpps();
        }else{
             if(math.mod(acctotalRecs,LimitSize)!=0)
            	accOffsetSize=accTotalRecs-math.mod(accTotalRecs,LimitSize);
            else
                accOffsetSize=acctotalrecs-Limitsize;
        	if(searchType=='Zip')
                searchZip();
            else
                searchAccNameSt();
        }
	}
	
    //Enable or Disable the previous buttons
    public boolean getprev(){

        
        //Disable the buttons on when on the Search Tab
        if(tabOpt=='Opportunity'){
			if(OffsetSize == 0)
				return true;
        	else
				return false;
        }else
            if(accOffsetSize==0)
            	return true;
        	else
                return false;
    
	}

    //Enable or Disable the next button
    public boolean getnxt()
	{
		
         //Disable the buttons on when on the Search Tab
         if(tabOpt=='Opportunity'){
			if((OffsetSize + LimitSize) >= totalRecs)
				return true;
			else
				return false;
         }else
             if((accOffsetSize + LimitSize) >= accTotalRecs)
				return true;
			else
				return false;
	}
    public void accTab(){
        tabOpt='Accounts';
        
    }
    public void oppTab(){
        tabOpt='Opportunity';
    }

 }