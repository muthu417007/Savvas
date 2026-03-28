/***************************************************************************************
* @Class Name: scc_ReportFilterController
* @Description: This apex class helps to  save  or update the  report
* @Created By: Sudha Rani Pathivada
* @Created On: 09/07/2024
* **************************************************************************************
* Modification Log:
* -------------------------------------------------------------------------------------
* Developer        Date            Description
* -------------------------------------------------------------------------------------
*/
public with sharing class scc_ReportFilterController {
    /********************************************************************** 
Method Name :  saveOrUpdateReportFilters
Description :  Method helps to  get  reports data fro custom reports 
Input       :  filterParamsList
Return type : List<Map<String, String>>
***********************************************************************/    
    @AuraEnabled
    public static List<Id> saveOrUpdateReportFilters(List<Map<String, String>> filterParamsList) {
        // Collect all user Ids and names for the reports from the parameters
        List<Custom_Report_Filter__c> filtersToUpsert = new List<Custom_Report_Filter__c>();
        
        for (Map<String, String> filterParams : filterParamsList) {
            Id userId = (Id) filterParams.get('userId');
            String reportName = filterParams.get('Name').trim();
            
            User userRecord = [SELECT Id,AccountId, ContactId FROM User where id =: userId LIMIT 1];	
            Id contactId = userRecord.ContactId;     
            Custom_Report_Filter__c filter = new Custom_Report_Filter__c();
            List<Custom_Report_Filter__c> existingFilters = [SELECT Id, Name, Contact__c FROM Custom_Report_Filter__c WHERE Name = :reportName AND Contact__c = :contactId LIMIT 1];
            
            if (!existingFilters.isEmpty()) {
                filter = existingFilters[0];  		
            } else {            
                filter = new Custom_Report_Filter__c(); 
                filter.Contact__c = contactId; 
            }
            
            filter.ISBN_To_Include__c = String.isNotBlank(filterParams.get('isbnList')) ? String.join(parseCSV(filterParams.get('isbnList')), ',') : null;
            filter.PO_To_Include__c = String.isNotBlank(filterParams.get('poList')) ? String.join(parseCSV(filterParams.get('poList')), ',') : null;
            
            String currentorderStatus= filterParams.get('orderStatus');
            if(currentorderStatus.equalsIgnoreCase('All')){
                filter.Order_Status__c='All';
            }
            else if(String.isNotBlank(currentorderStatus)){
                String clearorderstatus = currentorderStatus.replace('%','');
                filter.Order_Status__c=clearorderstatus +'%';
            }
            else{
                filter.Order_Status__c=currentorderStatus;
            }
            
            filter.Order_From_Date__c = parseDate(filterParams.get('startDate'));
            filter.Order_To_Date__c = parseDate(filterParams.get('endDate'));
            filter.OrderEntryPeriod__c = filterParams.get('orderEntryPeriod');
            filter.Sort_By__c = filterParams.get('sortOrder1');
            filter.Sort_By_2__c = filterParams.get('sortOrder2');
            filter.Sort_By_3__c = filterParams.get('sortOrder3');
            filter.Name = reportName;
            filter.Description__c = filterParams.get('Description');
            filter.originalReportType__c=filterParams.get('orginalReport');
            filter.StandardReport__c = Boolean.valueOf(filterParams.get('standardReport'));
            filtersToUpsert.add(filter);        
        }
        
        // Upsert all collected filters at once
        try {
            upsert filtersToUpsert;
        
            return new List<Id>(new Map<Id, Custom_Report_Filter__c>(filtersToUpsert).keySet());
        } catch (DmlException e) {            
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Error saving report filters: ' + e.getMessage());
        }
    }
    
    private static List<String> parseCSV(String csv) {
        if (String.isEmpty(csv)) return new List<String>();
        return csv.split(',');
    }
    private static Date parseDate(String dateStr) {
        if (String.isEmpty(dateStr)) return null;
        try {
            return Date.valueOf(dateStr);
        } catch (Exception e) {
            System.debug('Invalid date format: ' + dateStr);
            
            return null;
        }
    }
}