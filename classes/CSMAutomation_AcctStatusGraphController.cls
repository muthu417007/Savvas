public with sharing class CSMAutomation_AcctStatusGraphController {
     
    @AuraEnabled(cacheable=true)
    public static List<Id> getOpportunityIdsByUser(String userId) {
        List<Id> opportunityIds = new List<Id>();

        List<OpportunityTeamMember> teamMembers = [
            SELECT OpportunityId
            FROM OpportunityTeamMember
            WHERE TeamMemberRole = 'Customer Success Manager' AND UserId = :userId
        ];

        for (OpportunityTeamMember tm : teamMembers) {
            opportunityIds.add(tm.OpportunityId);
        }

        return opportunityIds;
    }
 
    @AuraEnabled(cacheable=true)
    public static Map<Id, String> getAccountIdsAndNamesFromOpportunities(List<Id> opportunityIds) {
        Map<Id, String> accountMap = new Map<Id, String>();

        if (opportunityIds.isEmpty()) {
            return accountMap;
        }

        List<Opportunity> opportunities = [
            SELECT AccountId, Account.Name
            FROM Opportunity
            WHERE Id IN :opportunityIds
        ];

        for (Opportunity opp : opportunities) {
            accountMap.put(opp.AccountId, opp.Account.Name);
        }

        return accountMap;
    }

    @AuraEnabled(cacheable=true)
    public static List<ServiceAppointmentGroupedData> getServiceAppointmentDataByAccounts(List<Id> accountIds) {
        List<ServiceAppointmentGroupedData> appointmentData = new List<ServiceAppointmentGroupedData>();

        if (accountIds.isEmpty()) {
            return appointmentData;
        }

        List<AggregateResult> results = [
            SELECT AccountId, Status, COUNT(Id)
            FROM ServiceAppointment
            WHERE AccountId IN :accountIds
            GROUP BY AccountId, Status
        ];

        for (AggregateResult ar : results) {
            appointmentData.add(new ServiceAppointmentGroupedData(
                (Id)ar.get('AccountId'),
                (String)ar.get('Status'),
                (Integer)ar.get('expr0')
            ));
        }

        return appointmentData;
    }

    @AuraEnabled(cacheable=true)
    public static List<CSM_Automation_Metadata__mdt> getColorAndStatus() {
        return [SELECT Status__c, Color__c
                FROM CSM_Automation_Metadata__mdt
                WHERE BarGraphFlag__c = true WITH SECURITY_ENFORCED];
    }

    public class ServiceAppointmentGroupedData {
        @AuraEnabled
        public Id accountId { get; set; }

        @AuraEnabled
        public String status { get; set; }

        @AuraEnabled
        public Integer count { get; set; }

        public ServiceAppointmentGroupedData(Id accountId, String status, Integer count) {
            this.accountId = accountId;
            this.status = status;
            this.count = count;
        }
    }

}