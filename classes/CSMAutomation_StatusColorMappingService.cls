public class CSMAutomation_StatusColorMappingService {
    
    public class StatusColorMapping {
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public String color { get; set; }
        
        public StatusColorMapping(String status, String color) {
            this.status = status;
            this.color = color;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<StatusColorMapping> getStatusColorMappings() {
        List<StatusColorMapping> mappings = new List<StatusColorMapping>();
        
        for (StatusColorMapping__mdt record : [SELECT MasterLabel, Color__c FROM StatusColorMapping__mdt]) {
            mappings.add(new StatusColorMapping(record.MasterLabel, record.Color__c));
        }
        system.debug('mappings=>'+mappings);
        return mappings;
    }
    


}