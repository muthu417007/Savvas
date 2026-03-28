/*
Apex Class:scc_checkSIOPRegistration
Author: CTS (MuthuKumar)
Created Date: 03/04/2024
Reason: Backend Scc_siopRegistrationLWC
Modified Date: 16/04/2024
*/
public without sharing class scc_checkSIOPRegistration {
/**
*  Description: This method check SIOP record from Order for guest users     
*  @name: checkSIOPRegistration
*  @param: zipcode and ordernum
*  @return: SIOP redirect url
*/
    @auraenabled
    public static String checkSIOPRegistration(String zipcode, String ordernum){
        try{
            String zip=zipcode +'%';    // added by sudha W-016431 
            String ordernumber=ordernum;
            String siopURL=System.Label.scc_SIOP_No_Access_User; 
            String redirecturl;
            List<Order> ord = new List<order>();
          
            // ord = [select Id, Name from Order where BillingPostalCode=:zip AND SAP_Document_Number__c =:ordernum ];
            // added by sudha W-016431 
            ord = [SELECT Id, Name 
                   FROM Order 
                   WHERE BillingPostalCode LIKE :zip 
                   AND SAP_Document_Number__c = :ordernum];
                   //ended by sudha 
            if(!ord.isEmpty()){
                redirecturl=siopURL+ordernumber;                
            }
            System.debug('value in ord is'+redirecturl);
            return redirecturl; 
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get SIOP url:'+e.getMessage()+e.getCause());
        }
    }
/**
*  Description: This method check SIOP record from Order for registered users     
*  @name: getSIOPurl
*  @param: ordernum
*  @return: SIOP redirect url
*/
    @AuraEnabled
    public static String getSIOPurl(String orderNum){
        try{
            String ordernumber=orderNum;
            String siopURL; 
            String redirecturl;
            List<User> usr = [select ID,Profile.Name,Email,Contact.AccountID,Contact.Account.SAP_Account_Id__c,contact.name,contact.Account.name from user where id =: userInfo.getUserID()];  
            String accountID = usr[0].Contact.AccountID; 
            List<PermissionSetAssignment> permissions = [SELECT Id,Assignee.Email,PermissionSetId,PermissionSet.Name, Assignee.Id,Assignee.Name FROM PermissionSetAssignment WHERE PermissionSet.Name='Savvas_SIOP_Permissions' and Assignee.Id=:userInfo.getUserID()];
            
            if(permissions.isEmpty() && usr[0].Profile.Name !=scc_constantHelper.MY_SAVVAS_ORDERS_PROFILE){
                siopURL=System.Label.scc_SIOP_No_Access_User; 
                redirecturl = siopURL+orderNum+'&email='+usr[0].Email+'&SFacct='+accountID;
            }else{
                if(usr[0].Profile.Name ==scc_constantHelper.MY_SAVVAS_ORDERS_PROFILE){
                    siopURL=System.Label.scc_SIOP_No_Access_User;               
                }else{
                    siopURL=System.Label.scc_SIOP_Access_User;               
                }
                redirecturl=siopURL+orderNum; 
            }
            
            System.debug('value of redirecturl is 2'+redirecturl);
            return redirecturl;
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get SIOP url:'+e.getMessage()+e.getCause());
        }
    }
/**
*  Description: This method gets SIOP record from Order for registered users     
*  @name: getSIOPOrderNumber
*  @param: orderID
*  @return:order
*/    
    @AuraEnabled
    public static List<Order> getSIOPOrderNumber(ID orderID){
        try{
            String SAPOrderNumber;
            List<Order> ordr = [Select id,SAP_Document_Number__c from Order Where Id=: orderID Limit 1];
            if(ordr.isEmpty()){
              throw new AuraHandledException('Order not found:');  
            }
            return ordr;
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get SIOP order number :'+e.getMessage()+e.getCause());
        }
    }
/**
*  Description: This method check SIOP and worktext permission for registered users     
*  @name: checkSIOPWorkTextUser
*  @param: NA
*  @return: List of permissions
*/    
    @AuraEnabled
    public static List<PermissionSetAssignment> checkSIOPWorkTextUser(){
        try{
            List<PermissionSetAssignment> permissions = [SELECT Id,Assignee.Email,PermissionSetId,PermissionSet.Name, Assignee.Id,Assignee.Name FROM PermissionSetAssignment WHERE PermissionSet.Name IN ('Savvas_SIOP_Permissions','Savvas_Worktext_Subscription_Permissions') and Assignee.Id=:userInfo.getUserID()];
            if(permissions.isEmpty()){
              throw new AuraHandledException('SIOP WorkText permissions not available for user :');  
            }
            return permissions;
        }catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to get SIOP WorkText permissions :'+e.getMessage()+e.getCause());
        }
    }        
}