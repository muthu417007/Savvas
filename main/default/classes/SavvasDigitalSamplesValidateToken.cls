@RestResource(urlMapping='/ValidateToken') 
global without sharing class SavvasDigitalSamplesValidateToken{
    @HTTPPost
    global static void validate(String sitecoreId){
        User userRecord = [SELECT Id,ContactId,contact.Name from User where Id=: UserInfo.getUserId() ];
        sitecoreId = sitecoreId.toLowerCase();
        List<Sitecore_Asset__c> sitecoreAsset = [SELECT ID,Is_SF_Launched__c from Sitecore_Asset__c where Sitecore_Id__c=:sitecoreId AND Contact__c =: userRecord.contactId];
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type', 'application/json');
        response.addHeader('Access-Control-Allow-Origin', Label.Sitecore_URL_to_whitelist);
        response.addHeader('Access-Control-Allow-Header', 'Origin,X-Requested-With,Content-Type,Accept');
        if(!sitecoreAsset.isEmpty()){
            Boolean isAvailable = sitecoreAsset[0].Is_SF_Launched__c;
            if(isAvailable){
                sitecoreAsset[0].Is_SF_Launched__c = false;
                update sitecoreAsset;
            }
            response.responseBody = Blob.valueOf(String.valueOf(isAvailable));
            response.statusCode = 200;
        }
        else{
            response.responseBody = Blob.valueOf('false');
            response.statusCode = 400;
        }
        if(Boolean.valueOf(Label.Savvas_Insert_Logs)){
            Integration_Logs__c integrationLog = new Integration_Logs__c(Type__c='Validation Token',Request_Body__c =sitecoreId,Response_Body__c =(response.responseBody).toString().length()>1000?((response.responseBody).toString()).subString(0,1000):(response.responseBody).toString(),Status__c = 'Success',
                                                                         contact__c=userRecord.ContactId);
            Insert integrationLog;
        }
    }
}