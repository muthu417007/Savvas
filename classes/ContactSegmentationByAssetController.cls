public class ContactSegmentationByAssetController{
    public Account acc{get;set;}
    public Boolean hasCampaignId{get;set;}
    public Boolean noEmail{get;set;}
    public Boolean myTeamsAccounts{get;set;} 
    public Boolean resultPageBlock{get;set;}  
    public Date expireStartDate{get;set;}
    public Date expireEndDate{get;set;}
    public Date installStartDate{get;set;}
    public Date installEndDate{get;set;}
    Public Integer enrollStartRange{get;set;}
    Public Integer enrollEndRange{get;set;}
    Public Integer AIMStartRange{get;set;}
    Public Integer AIMEndRange{get;set;}
    Public Integer Title1StartRange{get;set;}
    Public Integer Title1EndRange{get;set;}
    Public Integer ELLStartRange{get;set;}
    Public Integer ELLEndRange{get;set;}
    Public Integer AfricanAmStartRange{get;set;}
    Public Integer AfricanAmEndRange{get;set;}
    Public Integer AsianStartRange{get;set;}
    Public Integer AsianEndRange{get;set;}
    Public Integer CaucasianStartRange{get;set;}
    Public Integer CaucasianEndRange{get;set;}
    Public Integer HispanicStartRange{get;set;}
    Public Integer HispanicEndRange{get;set;}
    Public Integer NativeAmStartRange{get;set;}
    Public Integer NativeAmEndRange{get;set;}
    Public Integer MathGrade4StartRange{get;set;}
    Public Integer MathGrade4EndRange{get;set;}
    Public Integer MathGrade8StartRange{get;set;}
    Public Integer MathGrade8EndRange{get;set;}
    Public Integer ReadingGrade4StartRange{get;set;}
    Public Integer ReadingGrade4EndRange{get;set;}
    Public Integer ReadingGrade8StartRange{get;set;}
    Public Integer ReadingGrade8EndRange{get;set;}
    public String ISBN13{get;set;}
    Public String Titles{get;set;}
    Public String SelectedContactTitle{get;set;}
    Public List<string> AccStateLeftSelected{get;set;}
    Public List<string> AccStateRightSelected{get;set;}
    Public List<string> ISBNrightselected{get;set;}
    Public List<string> Titlesrightselected{get;set;}
    Public List<string> MPleftselected{get;set;}
    Public List<string> MPrightselected{get;set;} 
    Set<string> AccStateLeftValues;
    Set<string> AccStateRightValues = new Set<string>();
    Set<string> ISBNvalues = new Set<string>();
    Set<string> TitleValues = new Set<string>();
    set<string> masterProgram=new set<string>();
    Set<string> MPleftvalues = new Set<string>();
    Set<string> MPrightvalues = new Set<string>();
    private List<User> myTeamIds=new List<User>();
    private String basequery{get;set;}
    private String resultQuery{get;set;}
    private Integer pageSize = 100;
    private string currentUser;
    private ID campId;
    	
    public ContactSegmentationByAssetController(){
		Map<String,MasterProgram__c> mcs=MasterProgram__c.getAll();
        campId=ApexPages.currentPage().getParameters().get('id');
        if(campId!=null){
            hasCampaignId=true;
        }else{
            hasCampaignId=false;
        }
        for(MasterProgram__c m:mcs.values()){
            masterProgram.add(string.valueof(m.Master_Program__c));
        }
        AccStateLeftValues=new Set<String>{'AK','AL','AR','AS','AZ','CA','CO','CT','DC','DE','FL','FM','GA','GU','HI','IA','ID','IL','IN','KS','KY','LA','MA','MD','ME','MH','MI','MN','MO','MP','MS','MT','NC','ND','NE','NH','NJ','NM','NV','NY','OH','OK','OR','PA','PR','PW','RI','SC','SD','TN','TX','UT','VA','VI','VT','WA','WI','WV','WY'};
        multiselect();
        if(acc==null)
        	acc=new Account();
        
    }
	public ContactSegmentationByAssetController(ApexPages.StandardSetController c){}
    
    public void multiselect(){
        MPleftselected = new List<String>();
        MPrightselected = new List<String>();
        AccStateLeftSelected= new List<String>();
        AccStateRightSelected= new List<String>();
        MPleftvalues.addAll(masterProgram);
    }
    
    public PageReference MPselectclick(){
        MPrightselected.clear();
        for(String s : MPleftselected){
            MPleftvalues.remove(s);
            MPrightvalues.add(s);
        }
        
        return null;
    }
     
    public PageReference MPunselectclick(){
        MPleftselected.clear();
        for(String s : MPrightselected){
            MPrightvalues.remove(s);
            MPleftvalues.add(s);
        }
        return null;
    }
 
    public List<SelectOption> getMPunSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(MPleftvalues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
       
        return options;
    }
 
    public List<SelectOption> getMPSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(MPrightvalues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
    
    public PageReference AccStateselectclick(){
        AccStateRightSelected.clear();
        for(String s : AccStateLeftSelected){
            AccStateLeftValues.remove(s);
            AccStateRightValues.add(s);
        }
        
        return null;
    }
     
    public PageReference AccStateunselectclick(){
        AccStateLeftSelected.clear();
        for(String s : AccStateRightSelected){
            AccStateRightValues.remove(s);
            AccStateLeftValues.add(s);
        }
        return null;
    }
    
   public List<SelectOption> getAccStateunSelectedValues(){
        List<SelectOption> AccStateOptions = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(AccStateLeftValues);
        tempList.sort();
        for(string s : tempList)
            AccStateOptions.add(new SelectOption(s,s));
       
        return AccStateOptions;
    }
    
    public List<SelectOption> getAccStateSelectedValues(){
        List<SelectOption> AccStateOptions1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(AccStateRightValues);
        tempList.sort();
        for(String s : tempList)
            AccStateOptions1.add(new SelectOption(s,s));
        return AccStateOptions1;
    }
    
    public PageReference ISBNselectclick(){ 
        if(ISBN13.contains(',')){
            For(String s:ISBN13.split(',')){
                ISBNValues.add(s);
            }
        }else
        	ISBNvalues.add(ISBN13);  
        return null;
    }
     
    public PageReference ISBNunselectclick(){
        ISBN13='';
        integer i=1;
        for(String s : ISBNrightselected){
            ISBNvalues.remove(s);
            if(i<ISBNrightselected.size())
            	ISBN13+=s+',';
            else
                ISBN13+=s;
            i++;
        }    
        return null;
    }
 
    public List<SelectOption> getISBNSelectedValues(){
        List<SelectOption> ISBNoptions = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(ISBNvalues);
        tempList.sort();
        for(String s : tempList)
            ISBNoptions.add(new SelectOption(s,s));
        return ISBNoptions;
    }
      
    public PageReference TitlesSelectclick(){ 
        if(Titles.contains(',')){
            For(String s:Titles.split(',')){
                TitleValues.add(s);
            }
        }else
        	TitleValues.add(Titles);  
        return null;
    }
     
    public PageReference TitlesUnselectclick(){
        Titles='';
        integer i=1;
        for(String s : Titlesrightselected){
            TitleValues.remove(s);
            if(i<Titlesrightselected.size())
            	Titles+=s+',';
            else
                Titles+=s;
            i++;
        }    
        return null;
    }
 
    public List<SelectOption> getTitlesSelectedValues(){
        List<SelectOption> TitleOptions = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(TitleValues);
        tempList.sort();
        for(String s : tempList)
            TitleOptions.add(new SelectOption(s,s));
        return TitleOptions;
    }
    
    public ApexPages.StandardSetController ContactsSetController{
        get{  
           //list<Contact> ContactList=new list<contact>();
           set<contact> filteredContact=new set<contact>();
        	//myTeamIds=roleUtils.getRoleSubordinateUsers(currentUser);
        	if(currentUser!=null) 
        		myTeamIds=[Select ID from user where isActive = true and (managerid=:currentUser or ID=:currentUser)];  
            
            if(ContactsSetcontroller==null){            
               	baseQuery='select account.name,account.billingstate,name, email, phone,MDR_Job_Code__c from contact where status__c=\'Active\' and Marketing_Email_Opt_Out__c=FALSE' ;
                resultQuery='select account.name,account.billingstate,name, email, phone from contact';
                if(acc.ownerId==null)
            		currentUser=UserInfo.getUserId();
        		else
            		currentUser=acc.OwnerId;
                if(myTeamsAccounts==TRUE){
                    myTeamIds=[Select ID from user where isActive = true and (managerid=:currentUser or ID=:currentUser)];
                    baseQuery+=' and account.ownerid IN:myTeamIds';
                }else{
                    baseQuery+=' and account.ownerid=:currentUser';
                }
                if(AccStateRightValues.size()!=0){
                    baseQuery+=' and account.billingstate IN:AccStateRightValues';
                }
                if(enrollStartRange>0){
                    baseQuery+=' and account.Enrollment__c >=:enrollStartRange';
                }
                if(enrollEndRange>0){
                    baseQuery+=' and account.Enrollment__c <=: enrollEndRange';
                }
                if(AIMStartRange>0){
                    baseQuery+=' and account.AIM_Per_Pupil__c >=:AIMStartRange';
                }
                if(AIMEndRange>0){
                    baseQuery+=' and account.AIM_Per_Pupil__c <=: AIMEndRange';
                }                
                if(Title1StartRange>0){
                    baseQuery+=' and account.Title_1__c>=:Title1StartRange';
                }
                if(Title1EndRange>0){
                    baseQuery+=' and account.Title_1__c<=:Title1EndRange';
                }
                if(ELLStartRange>0){
                    baseQuery+=' and account.District_ELL_Percentage__c>=:ELLStartRange';
                }
                if(ELLEndRange>0){
                    baseQuery+=' and account.District_ELL_Percentage__c<=:ELLEndRange';
                }
                if(AfricanAmStartRange>0){
                    baseQuery+=' and account.African_Am__c>=:AfricanAmStartRange';
                }
                if(AfricanAmEndRange>0){
                    baseQuery+=' and account.African_Am__c<=:AfricanAmEndRange';
                }
                if(AsianStartRange>0){
                    baseQuery+=' and account.Asian_Percent__c>=:AsianStartRange';
                }
                if(AsianEndRange>0){
                    baseQuery+=' and account.Asian_Percent__c<=:AsianEndRange';
                }
                if(CaucasianStartRange>0){
                    baseQuery+=' and account.Caucasian_Percent__c>=:CaucasianStartRange';
                }
                if(CaucasianEndRange>0){
                    baseQuery+=' and account.Caucasian_Percent__c<=:CaucasianEndRange';
                }
                if(HispanicStartRange>0){
                    baseQuery+=' and account.Hispanic_Percent__c>=:HispanicStartRange';
                }
                if(HispanicEndRange>0){
                    baseQuery+=' and account.Hispanic_Percent__c<=:HispanicEndRange';
                }
                if(NativeAmStartRange>0){
                    baseQuery+=' and account.Native_Am_Percent__c>=:NativeAmStartRange';
                }
                if(NativeAmEndRange>0){
                    baseQuery+=' and account.Native_Am_Percent__c<=:NativeAmEndRange';
                }
                if(MathGrade4StartRange>0){
                    baseQuery+=' and account.Test_Score_Math_Gr4__c>=:MathGrade4StartRange';
                }
                if(MathGrade4EndRange>0){
                    baseQuery+=' and account.Test_Score_Math_Gr4__c<=:MathGrade4EndRange';
                }
                if(MathGrade8StartRange>0){
                    baseQuery+=' and account.Test_Score_Math_Gr8__c>=:MathGrade8StartRange';
                }
                if(MathGrade8EndRange>0){
                    baseQuery+=' and account.Test_Score_Math_Gr8__c<=:MathGrade8EndRange';
                }
                if(ReadingGrade4StartRange>0){
                    baseQuery+=' and account.Test_Score_Reading_Gr4__c>=:ReadingGrade4StartRange';
                }
                if(ReadingGrade4EndRange>0){
                    baseQuery+=' and account.Test_Score_Reading_Gr4__c<=:ReadingGrade4EndRange';
                }
                if(ReadingGrade8StartRange>0){
                    baseQuery+=' and account.Test_Score_Reading_Gr8__c>=:ReadingGrade8StartRange';
                }
                if(ReadingGrade8EndRange>0){
                    baseQuery+=' and account.Test_Score_Reading_Gr8__c<=:ReadingGrade8EndRange';
                }
                if(noEmail!=TRUE){
                    baseQuery+=' and Email!=null';
                }
                baseQuery+=' and accountid IN (select accountid from asset where product2id!=null'; 
                if(ISBNvalues.size()!=0 && MPrightvalues.size()!=0){
                    baseQuery+=' and (product2.productcode IN:ISBNValues OR product2.masterProgram__c IN:MPrightvalues)'; 
                }else if(ISBNvalues.size()!=0){
                   	baseQuery+=' and product2.productcode IN:ISBNValues';        
                }else if(MPrightvalues.size()!=0){
                    baseQuery+=' and product2.masterProgram__c IN:MPrightvalues';
                }
                if(expireStartDate!=null){
                    baseQuery+=' and UsageEndDate >=:expireStartDate';
                }
                if(expireEndDate!=null){
                    baseQuery+=' and UsageEndDate <=:expireEndDate';
                }               
				if(installStartDate!=null){
   					baseQuery+=' and InstallDate >=:installStartDate';
				}
				if(installEndDate!=null){
   					baseQuery+=' and InstallDate <=:installEndDate';
				} 
                basequery+=')';
             
                if(TitleValues.size()!=0){
                    if(SelectedContactTitle=='MDR Job Codes'){
                    	baseQuery+=' and MDR_ID__c!=null and Inactive__c=FALSE Limit 49900';
                    	Integer counter=1;
                    
                		for(List<contact> contList:Database.query(baseQuery)){               
                        	for(Contact cont:contList){
                    			if(cont.MDR_Job_Code__c!=NULL){
                        			for(String jobCode:TitleValues){
                            			if(cont.MDR_Job_Code__c.containsIgnoreCase(jobCode))
                                			filteredContact.add(cont);
                        			}	    
                    			}
                            	counter++;
                        	}   
                		}
                    	resultQuery+=' where ID IN:filteredContact LIMIT 10000';
                    	if(counter>=49900){
                        	ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Maximum number of records has been reached.'));
                    	}
                    	if(filteredContact.size()>=10000){
                        	ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Error, 'Number of contacts with Job codes is over the Limit.'));
                    	}
                    }else{
                        baseQuery+=' and Inactive__c=FALSE AND Title Like :TitleValues Limit 10000';
                        resultQuery=baseQuery;
                    }
                }else{
                    resultQuery=baseQuery+' LIMIT 10000';
                }
       			
                ContactsSetcontroller=new ApexPages.StandardSetController(Database.getQueryLocator(resultQuery));  
                 if(filteredContact.size()==0 && ContactsSetcontroller.getResultSize()==10000){
                        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Error, 'Number of contacts is over the Limit.'));
                    }
           		ContactsSetcontroller.setPageSize(pageSize);
            }    
            return ContactsSetcontroller;
        }
        set;    
    }
    
    public List<Contact> getContactsQuery(){
        
      	List <contact> cont=new list<contact>();
        for(Contact c:(list<contact>)ContactsSetcontroller.getRecords()){
            Cont.add(c);
        }    
        return cont;
    }
    
    public PageReference queryContacts(){
      resultPageBlock=TRUE;
      ContactsSetcontroller = null;
      ContactsSetcontroller.setPageNumber(1);
      return null;
    }
    
    public void addtoCampaign(){
        List<campaignMember> CampaignMemberlist=new list<campaignMember>();
        Map <ID,ID> CampaignMemberMap= new Map <ID,ID>();
        list<contact> contlist=Database.query(resultQuery);
        
        if(contList.size()>0){
          	//Query existing campaign members
            for(campaignmember cm: [Select Id,ContactId from campaignmember where contactId!=null and CampaignId=:campId]){
                campaignMemberMap.put(cm.contactid,cm.id);
            }
            
            //Add new contacts to the campaign if they aren't part of the campaign
            for(contact cont:contList){
              if(campaignMemberMap.get(cont.Id)==null){
              	CampaignMemberlist.add(new CampaignMember(contactId=cont.Id,CampaignId=campId,status='Sent'));        
            	} 
            }
            insert CampaignMemberlist;
            if(CampaignMemberlist.size()>0)
       			ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Confirm, CampaignMemberList.size()+' Out of '+contList.size()+' contacts has been inserted into the campaign.'));
            if(contList.size()-CampaignMemberlist.size()>0){
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Warning,contList.size()-CampaignMemberlist.size()+' of the contacts already exist on the campaign'));               
            }
        }
    }
          
    /** PAGINATION */
    //Navigate to first Page
    public void firstPage()
    {
      ContactsSetcontroller.first();
      
    }
    
	public Boolean hasNext {
        get {
            return ContactsSetcontroller.getHasNext();           
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            
            return ContactsSetcontroller.getHasPrevious();
        }
        set;
    }
    //Navigate to last Page
    public void lastPage()
    {
      ContactsSetcontroller.last();
    }

    //Navigate to Next page
    public void next()
    {
        ContactsSetcontroller.next();
    }

    //Navigate to Prev Page
    public void prev()
    {
        ContactsSetcontroller.previous();
    }
    
   //Return Page Number
    public Integer PageNumber{ 
    	get{
      		return ContactsSetcontroller.getPageNumber();
    	}
        set;
    }
    
    //Return Result Size
    public Integer ResultSize{ 
    get{
      		return ContactsSetcontroller.getResultSize();
    	}
        set;
    }
    
   //Return Page Size
    public Integer ResultPageSize{ 
    	get{
      		return ContactsSetcontroller.getPageSize();
    	}
        set;
    }

}