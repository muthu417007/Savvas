public class CSMAutomation_StackedBarGraph {
    
    @AuraEnabled(cacheable=true)
    public static List<ServiceAppointmentGroupedData> getServiceAppointmentData(String accountId) {
        List<ServiceAppointmentGroupedData> appointmentData = new List<ServiceAppointmentGroupedData>();
        //accountId ='0015300000U1r13AAB';
     
        List<AggregateResult> results = [
            SELECT Sav_FSL_ISBN_Product_Text__c, Status, COUNT(Id)
            FROM ServiceAppointment
            WHERE AccountId = :accountId
            AND Sav_FSL_ISBN_Product_Text__c != NULL
            GROUP BY Sav_FSL_ISBN_Product_Text__c, Status
        ];
        system.debug('results=>'+results);
        
        // Process results
        for (AggregateResult ar : results) {
            appointmentData.add(new ServiceAppointmentGroupedData(
                (String)ar.get('Sav_FSL_ISBN_Product_Text__c'),
                (String)ar.get('Status'),
                (Integer)ar.get('expr0')
            ));
        }
        system.debug('appointmentData=>'+appointmentData);
        return appointmentData;
    }

    public class ServiceAppointmentGroupedData {
        @AuraEnabled
        public String isbnProduct { get; set; }
        @AuraEnabled
        public String status { get; set; }
        @AuraEnabled
        public Integer count { get; set; }
        
        public ServiceAppointmentGroupedData(String isbnProduct, String status, Integer count) {
            this.isbnProduct = isbnProduct;
            this.status = status;
            this.count = count;
        }
    }


}