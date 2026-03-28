/**
Devleloper Name: Soundhariya
Date Created: March 3, 2022
Ticket : W-010934
Description : Removed the logic of updating 'DonotContact' fields in child accounts from 'Update Do not contact end date and reason for Public District Accounts' to this apex class in order to reduce the CPU execution time. This class is called from the same flow to do the child account updates. 
**/
public class UpdateDoNotContactDetails{
    @InvocableMethod(label='Update Child Accounts' description='Update the list of child accounts.')
    /**
    This method will get Parent Account Id and Blackout details from the flow and perform below operation
    i) If 'Do not Contact', 'Do-Not-Contact Reason Why' and 'Do-Not-Contact End Date' are filled in Parent account, then the same fields will get updated in all related child accounts with the same respective values
    ii) If 'Do not Contact' is unchecked in Parent account, then the 'Do not Contact' get unchecked and 'Do-Not-Contact Reason Why', 'Do-Not-Contact End Date' fields will get updated with blank value in all related child accounts
    **/
    public static void updateChildAccounts(List<FlowInputs> parentAccountDetails){
        
        List<Account> childAccountUpdate = new List<Account>();
		Map<Id,Boolean> parentAccIdBlackout = new Map<Id,Boolean>();
        Boolean isChange = false;
        //String parentAccountID = parentAccountDetails[0].parentAccId;
       // Boolean isAccBlackout = parentAccountDetails[0].isBlackout;
		
		for(FlowInputs flowInput: parentAccountDetails){
			parentAccIdBlackout.put(flowInput.parentAccId,flowInput.isBlackout);
		}
		System.debug('parentAccIdBlackout: '+parentAccIdBlackout);
        //Get the list of Child accounts using the Parent account ID fetched from Flow
        List<Account> childAccountList =[SELECT Id,Do_Not_Contact_End_Date__c,Do_Not_Contact_Reason__c,Do_Not_Contact__c,
                                         parent.Do_Not_Contact_End_Date__c,parent.Do_Not_Contact_Reason__c,parentId
                                         FROM Account
                                         WHERE parentId in :parentAccIdBlackout.keyset()];
        if(childAccountList.size()>0){
            for(Account acc : childAccountList){
                isChange = false;
                //If 'Do not Contact' detail will be present in isAccBlackout flag. If 'Do not Contact' is unchecked, 'Do not Contact' get unchecked and 'Do-Not-Contact Reason Why', 'Do-Not-Contact End Date' fields will get updated with blank value in related child accounts
                //if(!isAccBlackout){
				if(parentAccIdBlackout.get(acc.parentID) != true){	
                    if(acc.Do_Not_Contact_End_Date__c != null){
                        isChange = true;
                        acc.Do_Not_Contact_End_Date__c = null;
                    }
                    if(!String.ISBLANK(acc.Do_Not_Contact_Reason__c)){
                        isChange = true;
                        acc.Do_Not_Contact_Reason__c =  null;   
                    }
                    if(acc.Do_Not_Contact__c){
                        isChange = true;
                        acc.Do_Not_Contact__c = false;
                    } 
                    if(isChange){   
                        childAccountUpdate.add(acc);
                    }
                }
                //If 'Do not Contact', 'Do-Not-Contact Reason Why' and 'Do-Not-Contact End Date' are filled in Parent account, then the same fields will get updated in all related child accounts with the same respective values
                else if(parentAccIdBlackout.get(acc.parentID) == true){
                    if(acc.Do_Not_Contact_End_Date__c != acc.parent.Do_Not_Contact_End_Date__c){
                        isChange = true;
                        acc.Do_Not_Contact_End_Date__c = acc.parent.Do_Not_Contact_End_Date__c;
                    }
                    if(acc.Do_Not_Contact_Reason__c != acc.parent.Do_Not_Contact_Reason__c){
                        isChange = true;
                        acc.Do_Not_Contact_Reason__c =  acc.parent.Do_Not_Contact_Reason__c;
                    }
                    if(!acc.Do_Not_Contact__c){     
                        isChange = true;                    
                        acc.Do_Not_Contact__c = true;
                    }
                    if(isChange){
                        childAccountUpdate.add(acc);
                    }
                }
            }
        }
		system.debug('childAccountUpdate: '+childAccountUpdate);
        if(childAccountUpdate.size()>0){
            database.update(childAccountUpdate,false); 
        }
    }
    /** Inputs feeded from Flow**/
    public class FlowInputs {
        @InvocableVariable public String parentAccId;
        @InvocableVariable public Boolean isBlackout;
    }
}