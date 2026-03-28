public class AccountTriggerHandler {
    /*Trigger handler for when the do not contact field has been updated.  
    public static void handlerDoNotContactBeforeUpdate(List<Account> newAcc,Map<ID,Account> OldAccMap){
        list<Account> accList=new list<Account>();
        List<Account> AccToUpdate=new List<account>();
        
        for(Account acc:newAcc){
            Account oldAcc=oldAccMap.get(acc.Id);
            
            Add accounts where the do not contact checkflag has changed and account is a public district type
            if(acc.Do_Not_Contact__c!=oldAcc.Do_Not_Contact__c && acc.type=='Public District' && (acc.Do_Not_Contact__c==TRUE || acc.Do_Not_Contact__c==FALSE && acc.Do_Not_Contact_End_Date__c!=date.today())){
                accList.add(acc);
            }
        }
       
        if(accList.size()>0){
            Query Child Account and up to 5 levels of parent Account
            list<Account> ChildAccList=[Select ID,Name,Do_Not_Contact__c,Do_Not_Contact_End_Date__c,Do_Not_Contact_Reason__c,ParentId,Parent.ParentId,Parent.Parent.ParentId,Parent.Parent.Parent.ParentId,Parent.Parent.Parent.Parent.ParentId from Account where ID NOT IN:newAcc and (parentid in:accList or parent.parentid in:accList or parent.parent.parentid IN:accList or parent.parent.parent.parentid IN:accList or parent.parent.parent.parent.parentid IN:accList)];
            Update child do not contact field values with values from Parent Account
            For(Account a:ChildAccList){
                for(Account parentAcc:accList){
                    if(a.Do_Not_Contact__c!=ParentAcc.Do_Not_Contact__c && (a.ParentId==parentAcc.Id ||a.parent.parentId==parentAcc.Id ||a.parent.parent.parentId==parentAcc.Id ||a.parent.parent.parent.parentId==parentAcc.Id||a.parent.parent.parent.parent.parentId==parentAcc.Id)){
                        a.Do_Not_Contact__c=parentAcc.Do_Not_Contact__c;
                        a.Do_Not_Contact_End_Date__c=parentAcc.Do_Not_Contact_End_Date__c;
                        a.Do_Not_Contact_Reason__c=parentAcc.Do_Not_Contact_Reason__c;
                        AccToUpdate.add(a);
                    }
                }
            }
        }

        if(AcctoUpdate.size()>0){
          update AccToUpdate;
            
        }
        
        if(!checkRecursive.inFutureContext){
            AccountTriggerHandler.updateDoNotContact();
        }
    }*/
    
    /**
     * Author: Taylor James
     * Moving the do not contact flag to a future method since this really needs to be a bulk operation. 
     * The issue with the old code is that it relies on a workflow action to update the do not contact flag before propagating it to it's child records
     * This won't work since workflows occur after trigger execution and most importantly only trigger explicit before and after update triggers one more time
     * in the save order of execution. 
     * It also will skip the method if someone happens to be updating the same account tree at the same time. To preven record locking we're moving 
     */
  /*  @future
    public static void updateDoNotContact () {
        checkRecursive.inFutureContext = true;
        List<Account> doNotContactAccounts = [Select 
                ID,
                Name,
                Do_Not_Contact__c,
                Do_Not_Contact_End_Date__c,
                Do_Not_Contact_Reason__c,
                ParentId
             FROM Account
             WHERE (Do_Not_Contact_End_Date__c > TODAY) AND Do_Not_Contact__c = false];
        
        List<Account> accountsThatCanBeContacted = 
            [Select 
                ID,
                Name,
                Do_Not_Contact__c,
                Do_Not_Contact_End_Date__c,
                Do_Not_Contact_Reason__c,
                ParentId
             FROM Account
             WHERE (Do_Not_Contact_End_Date__c <= TODAY) AND Do_Not_Contact__c = true];
        
        for(Account a: accountsThatCanBeContacted) {
            a.Do_Not_Contact__c=false;
        }
        
        
        for(Account a: doNotContactAccounts){
            a.Do_Not_Contact__c=true;
        }
        
        if(accountsThatCanBeContacted.size()>0 ) {
            try{
                update accountsThatCanBeContacted;
            } catch(DMLexception e) {
                System.debug('Account Update Do Not Contact Failed, this is most likely due to record locking.');
            }
        }
        
        if(doNotContactAccounts.size()>0 ) {
            try{
                update doNotContactAccounts;
            } catch(DMLexception e) {
                System.debug('Account Update Do Not Contact Failed, this is most likely due to record locking.');
            }
        }  */
    }