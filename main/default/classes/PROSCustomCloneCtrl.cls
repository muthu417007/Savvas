/* -----------------------------------------------------------------------------------------------------------------------
Name:        PROSCustomCloneCtrl
Description: This is controller class for the pros_custom_quo_clone LWC
Date         Version  Author             Summary of Changes
-----------  -------  -----------------  ------------------------------------------------------------------------------
09/12/2021     1.0     Initial Dev       This fuctionality is initiated from Clone Quote button on CameleonCPQ__Quote__c object
-------------------------------------------------------------------------------------------------------------------------- */
global with sharing class PROSCustomCloneCtrl {
   @AuraEnabled
   public static void validateOpp(string oppId){
      try {
         Opportunity opp = [SELECT id, ContactId FROM Opportunity where id =:oppId ];
         if (opp.ContactId == null) {
            AuraHandledException e = new AuraHandledException('The Opportunity must have primary contact');
            e.setMessage('The Opportunity must have primary contact');
            throw e;
         }
         if ([SELECT id FROM CameleonCPQ__Quote__c where CPQOpportunityId__c=:oppId].size()<>0) {
            
            AuraHandledException e = new AuraHandledException('The Opportunity has an associated quote already');
            e.setMessage('The Opportunity has an associated quote already');
            throw e;
            
         }
      } catch (Exception e) {
         throw e;
      }
   }
   @AuraEnabled
    global static void cloneQuoteContent(String srcQuoId, String targetQuoId, String activeRelease, Boolean refresh) {
        try {
            CameleonCPQ__Quote__c quo = [select Name, CameleonCPQ__ActiveRelease__c from CameleonCPQ__Quote__c where id=:targetQuoId];
            CameleonCPQ__Quote__c quoSource = [select Name, CameleonCPQ__ActiveRelease__c from CameleonCPQ__Quote__c where id=:srcQuoId];
            //W-011885 - created a method to clone the quote line items of active release
            copyQuoteRelease(srcQuoId, targetQuoId, String.valueOf(quoSource.CameleonCPQ__ActiveRelease__c), quo);
            //W-011885 - moved existing callout code to future method due to exception
            asyncCopyCartRelease(srcQuoId, targetQuoId, String.valueOf(quoSource.CameleonCPQ__ActiveRelease__c), refresh);
        }
        catch (Exception e) {
            System.debug(e);
        }
    }

    // This method clones a active release and its line items
    public static void copyQuoteRelease(String srcQuoId, String targetQuoId, String activeRelease, CameleonCPQ__Quote__c quo)
    {
          // Clone the Release
          String qry = 'SELECT Id, Name '+(UserInfo.isMultiCurrencyOrganization() ? ',CurrencyIsoCode' : '')+' FROM CameleonCPQ__QuoteRelease__c where CameleonCPQ__QuoteId__c=\''+srcQuoId+'\' and CameleonCPQ__ReleaseNumber__c='+activeRelease;  
          SObject[] oriQrList = (CameleonCPQ__QuoteRelease__c[])Database.query(qry); 
          if(oriQrList!=null&&oriQrList.size()>0) {
             CameleonCPQ__QuoteRelease__c[] newQrList = oriQrList.deepClone(false); 
             newQrList[0].put('Name', quo.Name);
             newQrList[0].put('CameleonCPQ__QuoteId__c',targetQuoId);  
             newQrList[0].put('CameleonCPQ__ReleaseNumber__c',1); 
             insert newQrList[0];
          }

          Map<String, Schema.SObjectField> flds = Schema.SObjectType.CameleonQuoteLineItem__c.fields.getMap(); 
          List<String> fieldList = new List<String>();
          fieldList.addAll(flds.keySet());
            String qliFlds = '';
            for(integer i=0; i<fieldList.size(); i++){
               if (flds.get(fieldList[i]).getDescribe().IsCreateable()){
                  qliFlds = qliFlds + (qliFlds.length()>0?', ':'') + fieldList[i];
               }
            }
               
          String qliQuery = 'SELECT '+qliFlds+' FROM CameleonQuoteLineItem__c where Cameleon_Quote__c=:srcQuoId';
          System.debug('qliQuery---->'+qliQuery);
          SObject[] qliQrList = (CameleonQuoteLineItem__c[])Database.query(qliQuery); 
          if(qliQrList!=null&&qliQrList.size()>0) {
            CameleonQuoteLineItem__c[] newQLIList = qliQrList.deepClone(false); 
            for(CameleonQuoteLineItem__c objQLI : newQLIList){
               objQLI.put('Cameleon_Quote__c',targetQuoId);  
            }
            system.debug('newQLIList----->'+newQLIList);  
            insert newQLIList;
         }
    }

    @future (callout=true)
    public static void asyncCopyCartRelease(String srcQuoId, String targetQuoId, String activeRelease, Boolean refresh)
    {
      final CPQInfo cpqInfo = new CPQInfo();
      final String[] CPQResult = CameleonCPQ.CPQRequestFormatter.sendCPQRequest(srcQuoId, targetQuoId, activeRelease,'copyCartRelease','');
      if(!'0'.equals(CPQResult[1])) {
         cpqInfo.cpqStatus = CPQResult[1];
         cpqInfo.cpqErr = CPQResult[2];
         cpqInfo.cpqUrl = (Site.getPathPrefix()!=null?Site.getPathPrefix():'')+(new PageReference(Page.CameleonCPQ__CPQErrorPage.getURL()+'?id='+srcQuoId+'&msgType=2&errMsg='+EncodingUtil.urlEncode(CPQResult[2],'UTF-8'))).getUrl();
         SObject[] q = Database.query('SELECT Id FROM CameleonCPQ__Quote__c where Id=\''+targetQuoId+'\'');
         if(q.size()>0) delete q;
         //return cpqInfo;
      }
    }

    global class CPQInfo
    {
        global String cpqUrl {get; set;}
        global String cpqStatus {get; set;}
        global String cpqErr {get; set;}
        global String objectId {get; set;}
        global CPQInfo()
        {
        } 
    }
}