/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Apex class for Sampling
*
* The Class handles redirecting user to SOS with all the variables
*
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Romer Pasag   	
* @modifiedBy     Romer Pasag   	<Romer.Pasag@pearson.com>
* @maintainedBy   Romer Pasag   	<Romer.Pasag@pearson.com>
* @version        1.1
* @created        2013-08-09
* @modified       2017-09-12
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.1        	  Romer.Pasag@pearson.com
* 2017-08-29	  Updated to include alternative managers
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public class SingleMassSampleController {
  
  private ApexPages.StandardController controller {get; set;}
  public SampleRequest__c sr; 
  
  public SingleMassSampleController(ApexPages.StandardController controller) {
        this.controller = controller;
        this.sr = (SampleRequest__c)controller.getRecord();
    }
    
  public String getURL(){
      
      List<SampleRequestContact__c> mscs = [select Account__r.Id_18_character__c, Account__r.MDR_PID__c,Contact__r.FirstName,Contact__r.LastName,Contact__r.Email from SampleRequestContact__c where SampleRequest__c=:sr.id];
      List<Mass_Sample_Generic_Contacts__c> msgcs= [select Account__r.Id_18_character__c, Account__r.MDR_PID__c,Generic_Contact__c from Mass_Sample_Generic_Contacts__c where Mass_Sample_Generic__c=:sr.id];
      string SamplingSiteID;
      string UserCountry;
      string mgrEmail;
      string altMgr;
      User usrInfo=[SELECT Country,Manager_Email__c,Manager_Alternate_Approver__c FROM User WHERE UserName = :UserInfo.getUserName()];
      if(usrInfo.Country!=null)
      	userCountry = String.valueOf(usrInfo.Country);
      if(usrInfo.Manager_Email__c!=null)
      	mgrEmail=String.valueOf(usrInfo.Manager_Email__c);
      if(usrInfo.Manager_Alternate_Approver__c!=null)
      	altMgr=String.valueof(usrInfo.Manager_Alternate_Approver__c);
      string URL = 'https://opsweb1.lsk12.com/SOSv2/setParam.cfm?siteID=';
      if(UserCountry!=null && UserCountry.contains('Canada'))
           SamplingSiteID= '2';
      Else
          SamplingSiteID= '1';
      URL=URL+SamplingSiteID+'&user=';
      URL=URL+UserInfo.getUserEmail();
      URL=URL+'&self=N';
      URL=URL+'&mgr=';
      if(String.isBlank(altMgr)){
          URL=URL+mgrEmail;
      }Else{
          URL=URL+altMgr;
      }
      integer n = 1;
      if(mscs.size()>0){
        for(SampleRequestContact__c msrc:mscs){
          URL=URL+'&pid';
          URL=URL+string.valueof(n);
          URL=URL+'=';
          String PID = msrc.Account__r.MDR_PID__c;
          if(String.isEmpty(PID)){
              URL=URL+msrc.Account__r.Id_18_character__c;
          }else{
              URL=URL+PID;
          }
          	URL=URL+'&fn';
          	URL=URL+string.valueof(n);
          	URL=URL+'=';
          	URL=URL+msrc.Contact__r.FirstName;
          	URL=URL+'&ln';
          	URL=URL+string.valueof(n);
          	URL=URL+'=';
          	URL=URL+msrc.Contact__r.LastName;
          	URL=URL+'&e';
          	URL=URL+string.valueof(n);
          	URL=URL+'=';
          	URL=URL+msrc.Contact__r.Email;
            n++;
     	}
      }
      if(msgcs.size()>0){
          for(Mass_Sample_Generic_Contacts__c msgrc:msgcs){
          	URL=URL+'&pid';
          	URL=URL+string.valueof(n);
          	URL=URL+'=';
          	String PID = msgrc.Account__r.MDR_PID__c;
          	if(String.isEmpty(PID)){
              URL=URL+msgrc.Account__r.Id_18_character__c;
          	}else{
              URL=URL+PID;
          	}
          	URL=URL+'&fn';
          	URL=URL+string.valueof(n);
          	URL=URL+'=';
          	URL=URL+msgrc.Generic_Contact__c ;
          	URL=URL+'&ln';
          	URL=URL+string.valueof(n);
          	URL=URL+'=';
          	URL=URL+'&e';
          	URL=URL+string.valueof(n);
          	URL=URL+'=';
            n++;
          }
      }

      //string srcscount = string.valueof(srcs.size());
      return URL;
  }
    public PageReference redirect() {
        PageReference sosPage = new PageReference(getURL());
        sosPage.setRedirect(true);
        return sosPage;
    }  
}