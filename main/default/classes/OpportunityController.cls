public class OpportunityController {

    @AuraEnabled
    public static String getRecentOppId(String accId){
        String oppId;
        List<Opportunity> oppList = new List<Opportunity>([SELECT Id FROM Opportunity WHERE AccountId=: accId
                                                           ORDER BY LastModifiedDate DESC LIMIT 1]);
        if(!oppList.isEmpty()){
            oppId = oppList[0].Id;
        }
        return oppId;
    }
}