public with sharing class ResourceManagementUserSearchController {
    public Qualification_Workshop__c workshops{get;set;}
    public Qualification__c competencies{get;set;}
    public List<Qualification__c> exportAllConsultants{get;set;}
    public contact cont{get;set;}
    public attributes__c att{get;set;}
    public string workshopTitle{get;set;}
    public string filterWorkshopTitle{get;set;}
    private String basequery{get;set;}
    private Integer pageSize = 100;
   
    //Constructor
    public ResourceManagementUserSearchController(){
		//Initialize variables
        workshops = new Qualification_Workshop__c();
        competencies=new Qualification__c();
        cont=new contact(status__c='Active');
        att=new attributes__c();
    }
    public ResourceManagementUserSearchController(ApexPages.StandardSetController c){}
        
    //Method that filter the workshop title based on the Product or Skill
    //Returns the records as a picklist value
    public list<SelectOption> getWorkshopTitleList(){
        list<SelectOption> workshopOptionList = new list<SelectOption>();
        list<Qualification_Workshop__c> workshopTitleList;
       
        if(string.isBlank(filterWorkshopTitle))
                workshopTitleList=[Select Title__c from Qualification_Workshop__c where Product_Skill__c=:workshops.Product_Skill__c];
        else{
            string workshopVar ='%'+filterWorkshopTitle+'%';
            workshopTitleList=[Select Title__c from Qualification_Workshop__c where title__c like:workshopVar];
        }
       
        workshopOptionList.add(new SelectOption(' ','--None--'));
        for(Qualification_Workshop__c qw:workshopTitleList){
            if(qw.title__c!=null)
                workshopOptionList.add(new SelectOption(qw.title__c,qw.title__c)); 
        }
        return workshopOptionList;
    }
    
    //Standardsetcontroller that builds the query based on which field is populated on the Visualforce page
    //returns the records based on the query
    public ApexPages.StandardSetController ConsultantSetController {
        get{
            if(ConsultantSetController ==null){
            //Only return results that belong to Account with Type of internal and Name contains Resource
            baseQuery='select contact__c,contact__r.name,contact__r.email,contact__r.phone,contact__r.mobilephone,contact__r.MailingCity,contact__r.MailingState,contact__r.Resource_Type__c,contact__r.description,Qualifications__c,workshop__r.title__c,workshop__r.Product_skill__c,workshop__r.Discipline__c from Qualification__c where contact__r.account.type =\'Internal\' and contact__r.account.name Like \'%Resource%\'';
            if(workshops.Product_Skill__c!=null )
               	basequery+=' and workshop__r.Product_skill__c Like \''+String.escapeSingleQuotes(workshops.Product_Skill__c)+'%\'';
            if(string.isNotBlank(workshopTitle))
               	basequery+=' and workshop__r.title__c Like \''+ String.escapeSingleQuotes(workshopTitle)+'%\'';
            if(competencies.Qualifications__c!=null)
               	basequery+=' and Qualifications__c Like \''+ String.escapeSingleQuotes(competencies.Qualifications__c)+'%\'';
            if(cont.Resource_Type__c!=null)
               	basequery+=' and contact__r.Resource_Type__c Like \''+ String.escapeSingleQuotes(cont.Resource_Type__c)+'%\'';
            if(cont.status__c!=null)
               	basequery+=' and contact__r.status__c Like \''+ String.escapeSingleQuotes(cont.status__c)+'%\'';
            if(cont.Nearest_Major_City__c!=null)
               	basequery+=' and contact__r.Nearest_Major_City__c Like \''+ String.escapeSingleQuotes(cont.Nearest_Major_City__c)+'%\'';
            if(att.Type__c!=null && att.detail__c!=null){
               	basequery+=' and contact__c in (Select contact__c from attributes__c where type__c Like \''+ String.escapeSingleQuotes(att.Type__c)+'%\' and detail__c Like \''+ String.escapeSingleQuotes(att.detail__c)+'%\')';
            }else if(att.type__c!=null){
            		basequery+='and contact__c in (Select contact__c from attributes__c where type__c Like \''+ String.escapeSingleQuotes(att.Type__c)+'%\')';
            }else if(att.Detail__c!=null){
               		basequery+=' and contact__c in (Select contact__c from attributes__c where detail__c Like \''+ String.escapeSingleQuotes(att.detail__c)+'%\')';
           }

           basequery+=' order by contact__r.name limit 10000';        
		   ConsultantSetController=new ApexPages.StandardSetController(Database.getQueryLocator(baseQuery));          
           ConsultantSetController.setPageSize(pageSize);
          }

           return ConsultantSetController;
        }
        set;
    }
    
    //Returns list of Qualifications with corresponding contacts
    public List<Qualification__c> getConsultants(){
      	list<Qualification__c> qList=new List<Qualification__c>();
        for(Qualification__c q:(List<Qualification__c>)ConsultantSetController.getRecords()){
            qList.add(q);
        }
        
        return qList;      
    }
    
    //Method that calls another visualforce page to export the data to excel
    public PageReference exportToExcel(){
        // Resets the page size so that all records can be exported
        ConsultantSetController.setPageSize(ConsultantSetController.getResultSize());
        ExportAllConsultants=ConsultantSetController.getRecords();
        return Page.ResourceManagementUserExportPage;
    }

        
    //Navigate to first Page
    public void firstPage()
    {
      ConsultantSetController.first();
    }
    
	public Boolean hasNext {
        get {
            return ConsultantSetController.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return ConsultantSetController.getHasPrevious();
        }
        set;
    }
    //Navigate to last Page
    public void lastPage()
    {
      ConsultantSetController.last();
    }

    //Navigate to Next page
    public void next()
    {
        ConsultantSetController.next();
    }

    //Navigate to Prev Page
    public void prev()
    {
        ConsultantSetController.previous();
    }
    
   //Return Page Number
    public Integer PageNumber{ 
    	get{
      		return ConsultantSetController.getPageNumber();
    	}
        set;
    }
    
    //Return Result Size
    public Integer ResultSize{ 
    	get{
      		return ConsultantSetController.getResultSize();
    	}
        set;
    }
    
   //Return Page Size
    public Integer ResultPageSize{ 
    	get{
      		return ConsultantSetController.getPageSize();
    	}
        set;
    }
    
    /**
    * Reset List View
    */
    public PageReference resetFilter()
    {
      ConsultantSetController = null;
      ConsultantSetController.setPageNumber(1);
      return null;
    }

}