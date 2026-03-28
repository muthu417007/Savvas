/*
Apex Class: scc_csvDownloader
Author: CTS (Sanika)
Created Date: 2024-08-29
Reason:
Modified Date: 2024-10-18
*/
public class scc_csvDownloader {
    
    /**
* Description: Generates CSV content from the provided records and column definitions,
*              and returns it as a base64 encoded string.
* @param records: List of Map<String, Object> representing the data rows to be included in the CSV
* @param columns: List of Map<String, Object> representing the column definitions for the CSV
* @return: String - Base64 encoded CSV content
*/
    @AuraEnabled
    public static String generateCSVContent(List<Map<String, Object>> records, List<Map<String, Object>> columns) {
        String csvContent = '';
        try{
            for (Map<String, Object> column : columns) {
                csvContent += '"' + String.valueOf(column.get('label')) + '",';
            }
            csvContent = csvContent.removeEnd(',') + '\n';
            for (Map<String, Object> record : records) {
                for (Map<String, Object> column : columns) {
                    String fieldName = String.valueOf(column.get('fieldName'));
                    Object value = record.get(fieldName);
                    csvContent += '"' + (value != null ? String.valueOf(value).replace('"', '""') : '') + '",';
                }
                csvContent = csvContent.removeEnd(',') + '\n';
            }    
        }
        catch(Exception e){
            System.debug(scc_constantHelper.EXCEPTION_TYPE_CAUGHT+ e.getTypeName());    
            System.debug(scc_constantHelper.MESSAGE+ e.getMessage());    
            System.debug(scc_constantHelper.CAUSE+ e.getCause());    // returns null
            System.debug(scc_constantHelper.LINE_NUMBER + e.getLineNumber());    
            System.debug(scc_constantHelper.STACK_RACE+ e.getStackTraceString());
            throw new AuraHandledException('Failed to create CSV:'+e.getMessage()+e.getCause());
        }        
        return EncodingUtil.base64Encode(Blob.valueOf(csvContent));
    }
}