global with sharing class PROSReleaseController {

    private CameleonCPQ__Quote__c quo {get; set;}
    @AuraEnabled(cacheable=true)
    public static List<CameleonCPQ__QuoteRelease__c> getReleasesList(String quoteId) {
        return [SELECT Id, Name, Active__c, CameleonCPQ__Status__c, CameleonCPQ__ReleaseNumber__c
            FROM CameleonCPQ__QuoteRelease__c  
            WHERE CameleonCPQ__QuoteId__c=:quoteId
            LIMIT 99];
    }

    @AuraEnabled
    public static CPQInfo setActiveReleaseAndGetStatus(String releaseId) {
        
        CPQInfo cpqInfo = new CPQInfo();
        CameleonCPQ__QuoteRelease__c qr = [SELECT CameleonCPQ__ReleaseNumber__c, CameleonCPQ__QuoteId__c FROM CameleonCPQ__QuoteRelease__c WHERE Id =: releaseId];
        cpqInfo.objectId = qr.CameleonCPQ__QuoteId__c;
        try {
             boolean dmlOK = updateQuoteContent(qr.CameleonCPQ__QuoteId__c, qr.CameleonCPQ__ReleaseNumber__c);
           if(!dmlOK) {
              cpqInfo.cpqErr = 'System.Label.InsufficientAccessRights';
           }
        }
        catch (DmlException e) {
           cpqInfo.cpqErr = 'System.Label.InsufficientAccessRights';
           System.debug(Logginglevel.ERROR, 'System.Label.InsufficientAccessRights'+'  ->'+e.getMessage());
        }

        return cpqInfo;
    }

        private static String getCPQQuoteContent(String quoId, Decimal release) {
            final PROSCAMCPQWS.cartSOAP cart = new PROSCAMCPQWS.cartSOAP();
            final PROSCAMCPQWS.QuoteKeyType qk = new PROSCAMCPQWS.QuoteKeyType();
            qk.domain = UserInfo.getOrganizationId();
            qk.quoteId = quoId;
            qk.release = Integer.valueOf(release);
            final PROSCAMCPQWS.getQuoteResponse_element getQuoteResponse = cart.getQuote(qk, new String[] {'EXCLUDE_EVENT_HISTORY','EXCLUDE_CONF_DATA'}, null);
            if (getQuoteResponse.statusAction != null && !'OK'.equals(getQuoteResponse.statusAction))
               throw new CameleonCPQ.CPQRequestFormatter.CPQRequestException(getQuoteResponse.messageAction);
            return getQuoteResponse.xmlCart;
        }
    

    private static boolean updateQuoteContent(String quoId, Decimal release) {
        boolean dmlOK = false;
        final Blob bqc = EncodingUtil.base64Decode(getCPQQuoteContent(quoId, release));
        String quoteXML = '';
        if (bqc != null) {
           quoteXML = bqc.toString();
           if (quoteXML.startsWith('<?xml'))
              quoteXML = quoteXML.substring(quoteXML.indexOf('?>') + 2);
           quoteXML = '<cartSessionResults>' + quoteXML + '</cartSessionResults>';
        }
        CameleonCPQ__QuoteContent__c[] qc = [SELECT Id FROM CameleonCPQ__QuoteContent__c WHERE CameleonCPQ__QuoteId__c =: quoId];
        if (qc != null && qc.size() > 0) {
           if(CameleonCPQ__QuoteContent__c.sObjectType.getDescribe().isDeletable()) {
              delete qc;
              if(Schema.sObjectType.CameleonCPQ__QuoteContent__c.fields.CameleonCPQ__QuoteId__c.isCreateable() &&
                 Schema.sObjectType.CameleonCPQ__QuoteContent__c.fields.Name.isUpdateable()       &&
                 Schema.sObjectType.Attachment.fields.Name.isCreateable()            &&
                 Schema.sObjectType.Attachment.fields.ParentId.isCreateable()        &&
                 Schema.sObjectType.Attachment.fields.Body.isCreateable())
              {
                 qc = new CameleonCPQ__QuoteContent__c[]{new CameleonCPQ__QuoteContent__c(CameleonCPQ__QuoteId__c = quoId)};
                 insert qc;
                 Attachment att = new Attachment(ParentId = qc[0].Id, Name = quoId + '_content');
                 att.Body = Blob.valueOf(quoteXML);
                 insert att;
                 // Fire the update trigger
                 qc[0].Name = 'content_' + System.Now();
                 update qc;
                 dmlOK = true;
              }
           }
        }
        return dmlOK;
    }

    global class CPQInfo
    {
        global String cpqErr {get; set;}
        global String objectId {get; set;}

        global CPQInfo()
        {
        }
    }
}