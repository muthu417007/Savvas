/**************************************************************************************** 
* @Class Name  - scc_fetchCustomAlertMessage
* @description - Class to fetch custom alert message from Custom_Alert_Message__c object
* @Created By  - CTS-Muthukumar
* @Created On - 2024-07-30 
* ***************************************************************************************/ 
public class scc_fetchCustomAlertMessage {
    /********************************************************************** 
    Method Name :  Custom_Alert_Message__c
    Description :  used to fetch alert message
    Input       :  NA
    Return type :  Custom_Alert_Message__c customAlert
    ***********************************************************************/ 
    @AuraEnabled(cacheable=true)
    public static Custom_Alert_Message__c fetchAlertMessage(){ 
        try{
            
                Custom_Alert_Message__c customAlert = [SELECT Id, Name, Alert_Content__c, Alert_Heading__c,  End_Date__c, Publish_Alert__c,  Start_Date__c
                                                       FROM Custom_Alert_Message__c WHERE Publish_Alert__c = true
                                                       ORDER BY LastModifiedDate DESC Limit 1];
                if(customAlert.Publish_Alert__c){
                    Date today = date.today();
                    if( customAlert.Start_Date__c <= today && customAlert.End_Date__c >= today ){                        
                        return customAlert;
                    }                    
                }            
            return null;
        }
        catch (Exception e) {
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            return null;
        }
        
    }
}