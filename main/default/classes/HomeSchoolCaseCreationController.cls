/* -----------------------------------------------------------------------------------------------------------------------
Name:        HomeSchoolCaseCreationController
Description: This class is called from 'HomeSchool Online Access - CS Subflow' Flow. This will create cases and populate case fields based on user input


Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
02/22/2022     1.0     Soundhariya       April FirstBiweekly release(W-011941)

-------------------------------------------------------------------------------------------------------------------------- */
public class HomeSchoolCaseCreationController {
    @InvocableMethod (label='HomeSchool Case Creation')
    public static List<CaseOutputResponse> getCaseDetails(List<GetCaseInputs> inputFromFlow){
        system.debug('inputFromFlow--->'+inputFromFlow);
		List<CaseOutputResponse> outputList = new List<CaseOutputResponse>();
        List<RecordType> caseRecType = new List<RecordType>();
		CaseOutputResponse flowOutput = new CaseOutputResponse();
        Case updateCase = new Case();
		GetCaseInputs flowInput = inputFromFlow[0];
		String newCaseNumber = '';
		Case newCase = new Case();
		newCase = flowInput.caseRec;
        if(flowInput.caseType == 'Customer Service'){            
            newCase.Subject = 'Homeschool Digital Access';
            caseRecType = [Select Id from RecordType where name = 'Customer Service' and SobjectType = 'Case' limit 1];
        }
        else if(flowInput.caseType == 'Technical Support'){
            caseRecType = [Select Id from RecordType where name = 'Technical Support' and SobjectType = 'Case' limit 1];
        }
		if(caseRecType.size()>0){
			newCase.recordtypeId = caseRecType[0].Id;  
		}
		if(flowInput.caseType == 'Customer Service'){
            List<Sobject> caseQueue = new List<Sobject>();
            if(flowInput.oldAccount){				
               caseQueue = [select Id,name from group where DeveloperName = 'Acct_Maint_Digital_Customer' limit 1];
            }
            else{
               caseQueue = [select Id,name from group where DeveloperName = 'CS_K12_ACCT_MAINTENANCE' limit 1]; 
            }
            if(caseQueue.size()>0){
                newCase.ownerid = caseQueue[0].Id;
            } 
		}
        else if(flowInput.caseType == 'Technical Support'){
            List<Group> techQueue = [select Id,name from group where DeveloperName = 'TS_LS_Licensing' limit 1];
			if(techQueue.size()>0){
				newCase.ownerid = techQueue[0].Id;
			}
        }
		if(flowInput.parentCase != '' && flowInput.parentCase != null){
			List<Case> parentCase = [Select Id from Case where CaseNumber = :flowInput.parentCase];
			if(parentCase.size() > 0){
				newCase.ParentId = parentCase[0].Id;
			}
		}
        if(flowInput.caseType == 'Customer Service'){    
            if(flowInput.contactExists){
                Contact selContact = [Select id,Primary_Role__c from Contact where id =:flowInput.selectedConID];
                if(selContact.Primary_Role__c != 'Home-School Teacher'){
                    selContact.Primary_Role__c = 'Home-School Teacher';
                    update selContact;
                }
            }            
            updateContactDetails(newCase,flowInput.contactFirstname,flowInput.contactLastname,flowInput.contactEmail,flowInput.contactPhone,flowInput.contactExists,flowInput.selectedConID,'Savvas Homeschool Customers');
        }
        else if(flowInput.caseType == 'Technical Support'){
            updateContactDetails(newCase,flowInput.contactFirstname,flowInput.contactLastname,flowInput.contactEmail,flowInput.contactPhone,flowInput.contactExists,flowInput.selectedConID,'Savvas Community Account');
        	newCase.Auto_Email_Override__c = true;
        }
		
		//try{			
			Database.insert(newCase,true);
			if(!String.isEmpty(newCase.Id)){
				updateCase = [Select Id,CaseNumber,Subject,Status,Account_Name__c from Case where Id =:newCase.Id];
                if(flowInput.caseType == 'Customer Service'){                 
					if(flowInput.oldAccount){                        
                    	updateCase.Status = 'In Process';
						if(updateCase.Account_Name__c != null){							
							updateCase.Subject = 'Existing Customer - Homeschool Digital Access Request - '+updateCase.Account_Name__c;
						}
						else{
							updateCase.Subject = 'Existing Customer - Homeschool Digital Access Request';	
						}
                    }
					else{
						updateCase.Subject = 'New Customer - Homeschool Digital Access Request';
					}
                }
                else if(flowInput.caseType == 'Technical Support'){
                    updateCase.Subject = updateCase.Subject.replace('{caseNum}',updateCase.CaseNumber);
                    updateCase.Auto_Email_Override__c = false;
                }
				newCaseNumber = updateCase.CaseNumber;				
				Database.update(updateCase,false);
			}
		//}
		/*catch(Exception e){
			system.debug('Exception: '+e);
		}*/
		flowOutput.caseNumber = newCaseNumber;
        flowOutput.newCaseRec = updateCase;
		outputList.add(flowOutput);
		return outputList;
    } 
/*
Method Name : updateContactDetails
Description : This method will add Query the contact with the entered email address and map to the new case if it is existing or if there is no contact for the provided email address then it will create contact and map to the new case
*/
	public static void updateContactDetails(Case cseRec, String conFistName, String conLastName, String conEmail, String conPhone, Boolean isContactExists,String selectedContact,String accName){
		if(!isContactExists){
			List<Contact> newContactList = new List<Contact>();
			List<Account> accList = [Select Id from Account where Name = :accName];
			Contact newContact = new Contact();
			newContact.Firstname = conFistName;
			newContact.Lastname = conLastName;
			newContact.Email = conEmail;
			newContact.Phone = conPhone;
			newContact.Primary_Role__c = 'Home-School Teacher';
			if(accList.size()>0){
				newContact.AccountId = accList[0].Id;
				cseRec.AccountID = accList[0].Id;
			}			
			Database.insert(newContact,false);
			cseRec.ContactID = newContact.Id;
		}
		else{
			cseRec.ContactID = selectedContact;
		}
	}
	
	
    public class GetCaseInputs{
		@InvocableVariable(required=true) public Case caseRec;	
		@InvocableVariable public String contactFirstname;
		@InvocableVariable public String contactLastname;
		@InvocableVariable public String contactEmail;
		@InvocableVariable public String selectedConID;
		@InvocableVariable public String contactPhone;
		@InvocableVariable(required=true) public Boolean contactExists;
		@InvocableVariable public Boolean oldAccount;
        @InvocableVariable public String parentCase;
        @InvocableVariable public String caseType;
		
    }	
	public class CaseOutputResponse {
      @InvocableVariable
       public String caseNumber;
      @InvocableVariable
       public Case newCaseRec;
   }
   
   
   
    
}