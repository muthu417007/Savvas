public class AccessCodeProcessingMonitor {
    public static void checkBatchStatus(Id orderId) {
        try {
            // 1. Check Order and OrderItems
            Order ord = [SELECT Id, Name, Access_Code_Was_Sent__c,
                        (SELECT Id, Product2.ProductCode, Quantity 
                         FROM OrderItems 
                         WHERE ISBN__c != null)
                        FROM Order 
                        WHERE Id = :orderId];
            
            System.debug('=== Order Details ===');
            System.debug('Order ID: ' + ord.Id);
            System.debug('Access Codes Sent Flag: ' + ord.Access_Code_Was_Sent__c);
            
            // 2. Check Access Codes Assignment
            for(OrderItem item : ord.OrderItems) {
                Integer assignedCodes = [SELECT COUNT() 
                                       FROM EAccess_List__c 
                                       WHERE Order__c = :orderId 
                                       AND ProductId__r.ProductCode = :item.Product2.ProductCode];
                
                System.debug('Product Code: ' + item.Product2.ProductCode);
                System.debug('Quantity Ordered: ' + item.Quantity);
                System.debug('Access Codes Assigned: ' + assignedCodes);
            }
            
            // 3. Check Batch Job Status
            AsyncApexJob[] batchJobs = [
                SELECT Id, Status, NumberOfErrors, JobItemsProcessed, 
                       TotalJobItems, CreatedDate, CompletedDate
                FROM AsyncApexJob 
                WHERE ApexClass.Name = 'scc_AccessCodeBatchProcessor'
                ORDER BY CreatedDate DESC 
                LIMIT 1
            ];
            
            if(!batchJobs.isEmpty()) {
                AsyncApexJob job = batchJobs[0];
                System.debug('=== Batch Job Status ===');
                System.debug('Status: ' + job.Status);
                System.debug('Records Processed: ' + job.JobItemsProcessed + '/' + job.TotalJobItems);
                System.debug('Errors: ' + job.NumberOfErrors);
                if(job.CompletedDate != null) {
                    Long processingTime = (job.CompletedDate.getTime() - job.CreatedDate.getTime())/1000;
                    System.debug('Processing Time: ' + processingTime + ' seconds');
                }
            } else {
                System.debug('No batch jobs found');
            }
            
        } catch(Exception e) {
            System.debug('Error in monitoring: ' + e.getMessage());
        }
    }
}