public class SearchActivityAssignmentEventController {
    public KimbleOne__ActivityAssignment__c actAssignment {get;set;}
    public String eventId {get;set;}
    public Boolean showEventInfo{get;set;}
    public Boolean showInput{get;set;}
    public string resource{get;set;}
    public string workshopName{get;set;}
    public string accName{get;set;}
    public string accCity{get;set;}
    public string accState{get;set;}
    public string svcType{get;set;}
    public Date eventDate{get;set;}
    
    public Organization runningOrg {
    	get {
       		return [SELECT Id, IsSandbox FROM Organization LIMIT 1];
    	}
    	set;
	}
    
    public SearchActivityAssignmentEventController( ) {
        this.showInput=true;
        this.showEventInfo=false;
        actAssignment=new KimbleOne__ActivityAssignment__c();
    }
    
    
    public PageReference getActAssignment(){
        try{
            actAssignment=[select ID,Resource_Name__c,KimbleOne__ResourceUser__c,Delivery_Date__c,Workshop_Name__r.Name,Service_Type__c,Opportunity__r.AccountId,Opportunity__r.Account.billingcity,Opportunity__r.Account.Name,Opportunity__r.Account.billingState from KimbleOne__ActivityAssignment__c where event_id__c =:eventid];
            resource=actAssignment.Resource_Name__c;
            showEventInfo=!showEventInfo;
            showInput=!showInput;
            eventDate=actAssignment.Delivery_Date__c;
            accName=actAssignment.Opportunity__r.Account.Name;
            accCity=actAssignment.Opportunity__r.Account.billingcity;
            accState=actAssignment.Opportunity__r.Account.billingState;
            svcType=actAssignment.Service_Type__c;
            workshopName=actAssignment.Workshop_Name__c;
        }catch(QueryException ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Event Id'));
            
        }
        return null;
    }
    
    public PageReference clear(){
        showEventInfo=!showEventInfo;
        showInput=!showInput;
        eventId=null;
        return null;
    }
    
    public PageReference redirect(){
        
        String surveyKey = [SELECT Survey_Destination_Key__c FROM Get_Survey_Setting__mdt WHERE Organization_Id__c = :runningOrg.Id].Survey_Destination_Key__c;    
        
		String URL='https://www.getfeedback.com/r/' + surveyKey + '?accId='+actAssignment.Opportunity__r.AccountId+'&actAssign='+actAssignment.Id+'&svcType='+actAssignment.Service_Type__c+'&rsrcId='+actAssignment.KimbleOne__ResourceUser__c;
        PageReference getFeedback=new PageReference(URL);
        getFeedback.setRedirect(true);
        return getFeedback;
    }
}