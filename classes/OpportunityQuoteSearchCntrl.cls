/* -----------------------------------------------------------------------------------------------------------------------
Name:        OpportunityQuoteSearchCntrl
Description: This class is called from Quote Search LWC. This will extract Account Name, Opportunity Name, Quote Name & Quote Number
to display active quotes related to the account on the case.

Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
06/02/2022     1.0     Smitha Prabhu      Initial Release
-------------------------------------------------------------------------------------------------------------------------- */
public with sharing class OpportunityQuoteSearchCntrl {
    
    
    /* Method: getOrders
     * Arguments: accountId - accountID will get passed from lwc 
     * Description: getOrders method querying Quote, QuoteRelease, Order and returning Account Name,Opportunity Name,
    Quote Name & Quote Number*/
    @AuraEnabled
    public static list<QuoteSearchWrapper> getOrders(String accountId){
        set<Id> quoteIds = new set<Id>();
        list<QuoteSearchWrapper> quoteSearchList = new list<QuoteSearchWrapper>();
        Integer year = system.today().year();
        Date d1 = Date.valueOf(year+'-09-30');
        year+=1;
        Date d2 = Date.valueOf(year+'-09-30');
        Date expiryDate;
        if(system.today() <= d1){
            expiryDate = d1;
        }
        else if(system.today() > d1){
            expiryDate = d2;
        }
        
        for(CameleonCPQ__Quote__c objQuote :[SELECT Id, CPQOpportunityId__r.Account.Name, CPQOpportunityId__r.Name, CPQ_Quote_Number__c, Name
                                             FROM CameleonCPQ__Quote__c 
                                             WHERE CameleonCPQ__AccountId__c =: accountId
                                             AND CPQ_Quote_Expiry_Date__c =: expiryDate])
        {
            quoteIds.add(objQuote.Id); 
            
        }
        
        QuoteSearchWrapper qsw;
        for(Order__c objOrder :[SELECT Id, Cameleon_Quote__c, Quote_Release_Number__c, Cameleon_Quote__r.CameleonCPQ__AccountId__r.Name, Cameleon_Quote__r.CPQOpportunityId__r.Name, Cameleon_Quote__r.CPQ_Quote_Number__c, Cameleon_Quote__r.Name 
                                FROM Order__c WHERE Cameleon_Quote__c IN : quoteIds])
        {
            qsw = new QuoteSearchWrapper();
            qsw.accountName = objOrder.Cameleon_Quote__r.CameleonCPQ__AccountId__r.Name;
            qsw.oppName = objOrder.Cameleon_Quote__r.CPQOpportunityId__r.Name;
            qsw.quoteName = objOrder.Cameleon_Quote__r.Name;
            qsw.quoteNumber = objOrder.Cameleon_Quote__r.CPQ_Quote_Number__c+'-'+objOrder.Quote_Release_Number__c;
            qsw.quoteLink = '/'+ objOrder.Cameleon_Quote__c;
            quoteSearchList.add(qsw);
        }
        return quoteSearchList;
    }
    
    /*
     * ClassName : QuoteSearchWrapper
     * Description : wrapper class to show values on LWC*/
    public class QuoteSearchWrapper
    {
        @AuraEnabled
        public String accountName;
        @AuraEnabled
        public String oppName;
        @AuraEnabled
        public String quoteName;
        @AuraEnabled
        public String quoteNumber;
        @AuraEnabled
        public String quoteLink;
        @AuraEnabled
        public String baseAmountSubTot;
        @AuraEnabled
        public String freeAmountSubTot;
        @AuraEnabled
        public String snh;
        @AuraEnabled
        public String total; 
    }
}