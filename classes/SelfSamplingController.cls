/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Queries the user manager and alternate manager for Sampling approval
* 
* Queries the user manager and alternate manager for Sampling approval
* Using a controller because cannot reference the formula fields from the visualforce page
*
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Romer Pasag   	<Romer.Pasag@pearson.com>
* @modifiedBy     Romer Pasag   	<Romer.Pasag@pearson.com>
* @maintainedBy   Romer Pasag   	<Romer.Pasag@pearson.com>
* @version        1.0
* @created        2017-06-13
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0        	  Romer.Pasag@pearson.com
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class SelfSamplingController {
    public String mgrEmail{get;set;}
    public string altMgrEmail{get;set;}
    public SelfSamplingController(){
      User usrInfo=[SELECT Country,Manager_Email__c,Manager_Alternate_Approver__c FROM User WHERE UserName = :UserInfo.getUserName()];
      mgrEmail=String.valueOf(usrInfo.Manager_Email__c);
      altMgrEmail=String.valueOf(usrInfo.Manager_Alternate_Approver__c);
    }
}