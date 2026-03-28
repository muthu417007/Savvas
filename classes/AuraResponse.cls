public class AuraResponse {
	@AuraEnabled
    public Boolean isSuccess{get; set;}
    @AuraEnabled
    public String message{get; set;}
    @AuraEnabled 
    public List<WorkOrder> response{get; set;}
    
    public AuraResponse(Boolean isSuccess, String message, List<WorkOrder> response) {
        this.isSuccess = isSuccess;
        this.message   = message;
        this.response  = response;
    }
}