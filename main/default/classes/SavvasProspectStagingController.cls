/*
@Author : Cognizant Team
@name : SavvasProspectStagingController
@CreateDate : 25-Apr-2023
@Description This class get called when incrementalLog API is hit by pardot
*/
@RestResource(urlMapping='/createProspectStaging/*')
global class SavvasProspectStagingController {
    /*
@Author : Cognizant Team
@name : insertProspectStaging
@Description : Method to insert Prospect_Staging__c records
*/   
    @HttpPost
    global static void insertProspectStaging() {
        RestRequest req = RestContext.request;
        String requestBody = req.requestBody.toString();
        RestResponse response = RestContext.response;
        try{
            if(String.isNotBlank(requestBody)){
                Prospect_Staging__c prospect = (Prospect_Staging__c)JSON.deserialize(requestBody, Prospect_Staging__c.class);
                Database.SaveResult result = Database.insert(prospect);
                response.addHeader('Access-Control-Allow-Header', 'Origin,X-Requested-With,Content-Type,Accept');
                response.addHeader('Content-Type', 'application/json');
                if(result.isSuccess()){
                    Blob responseBody = Blob.valueOf(JSON.serialize('Record Inserted Successfully'));
                    response.responseBody = responseBody;
                    response.statusCode = 200;
                    if(Boolean.valueOf(Label.Savvas_Insert_Logs)){
                        Integration_Logs__c integrationLog = new Integration_Logs__c();
                        integrationLog.Type__c='Prospect Staging';
                        integrationLog.Request_Body__c =requestBody;
                        integrationLog.Response_Body__c = (response.responseBody).toString().length()>1000?((response.responseBody).toString()).subString(0,1000):(response.responseBody).toString();
                        integrationLog.Status__c = 'Success';
                        Insert integrationLog;
                    }
                }           
            }
            else{
                response.responseBody = Blob.valueOf(JSON.serialize('Request body is empty.'));
                response.statusCode = 400;
                if(Boolean.valueOf(Label.Savvas_Insert_Logs)){
                    Integration_Logs__c integrationLog = new Integration_Logs__c();
                    integrationLog.Type__c='Prospect Staging';
                    integrationLog.Request_Body__c =requestBody;
                    integrationLog.Response_Body__c = (response.responseBody).toString().length()>1000?((response.responseBody).toString()).subString(0,1000):(response.responseBody).toString();
                    integrationLog.Status__c = 'Error';
                    Insert integrationLog;
                }
            }
        }
        catch(Exception e){
            response.responseBody = Blob.valueOf(JSON.serialize('An error occured while processing your request. Please contact Salesforce Admin for error details'+e.getMessage()));
            response.statusCode = 400;
            if(Boolean.valueOf(Label.Savvas_Insert_Logs)){
                String errorMessage = 'Insert failed with error '+e.getMessage();
                Integration_Logs__c integrationLog = new Integration_Logs__c();
                integrationLog.Type__c='Prospect Staging';
                integrationLog.Request_Body__c =requestBody;
                integrationLog.Response_Body__c = errorMessage.length()>1000?errorMessage.subString(0,1000):errorMessage;
                integrationLog.Status__c = 'Error';
                Insert integrationLog;
            }
        }
    }
}