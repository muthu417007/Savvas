@isTest
public class SavvasProspectStagingControllerTest {
    @isTest
    public static void insertProspectStaging(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/createProspectStaging';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "Asset_Name__c": null, "Assigned_Rep__c": "Susan Klossing", "Collection_ID__c": null, "Contact_Validation_Flag__c": "", "MDR_ID__c": "00187969", "Collection_Name__c": null, "Description__c": "Message", "Entity_ID__c": null, "External_Campaign_ID__c": null, "Company_Name__c": "Chaminade Madonna College Prep", "Lead_Source_Link_H__c": null, "MQL_CMP_ID__c": null, "Owner_ID__c": "0050W000006fvUdQAI", "Rep_to_Contact__c": "true", "Phone__c": "0123456789", "School_District__c": "Broward", "Response_Purchase_Decision_Maker__c": "School", "Response_Purchase_Funding__c": "Yes", "Response_Purchase_Timeframe__c": "1-3 months", "Thumbnail_ID__c": null, "Webtracking_ID__c": null, "Product_of_Interest__c": null, "MQL_Source__c": null, "RUID__c": null, "School_Finder__c": "33021-5800", "Email__c": "mail@mail.com", "First_Name__c": "Christian", "Job_Title__c": "Curriculum Director", "Last_Name__c": "Reyes", "Website__c": "http://www.cmlions.org/s/315/home.aspx", "Address__Street__s": "500 E Chaminade Dr", "Address__City__s": "Hollywood", "Address__PostalCode__s": "33021-5800", "Address__StateCode__s": "FL", "Address__CountryCode__s": "US", "Terms_of_Use_Accepted__c": true, "Privacy_Policy_Accepted__c": true, "Response_Date__c": "2023-04-25" }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasProspectStagingController.insertProspectStaging(); 
        String responseBody = res.responseBody.toString();
    }
    @isTest
    public static void insertProspectStagingException(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/createProspectStaging';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('{ "Asset_Name__c": null, "Assigned_Rep__c": "Susan Klossing", "Collection_ID__c": null, "Contact_Validation_Flag__c": null, "MDR_ID__c": "00187969", "Collection_Name__c": null, "Description__c": "Message", "Entity_ID__c": null, "External_Campaign_ID__c": null, "Company_Name__c": "Chaminade Madonna College Prep", "Lead_Source_Link_H__c": null, "MQL_CMP_ID__c": null, "Owner_ID__c": "0050W000006fvUdQAI", "Rep_to_Contact__c": "true", "Phone__c": "0123456789", "School_District__c": "Broward", "Response_Purchase_Decision_Maker__c": "School", "Response_Purchase_Funding__c": "Yes", "Response_Purchase_Timeframe__c": "1-3 months", "Thumbnail_ID__c": null, "Webtracking_ID__c": null, "Product_of_Interest__c": null, "MQL_Source__c": null, "RUID__c": null, "School_Finder__c": "33021-5800", "Email__c": "mail@mail.com", "First_Name__c": "Christian", "Job_Title__c": "Curriculum Director", "Last_Name__c": "Reyes", "Website__c": "http://www.cmlions.org/s/315/home.aspx", "Address__Street__s": "500 E Chaminade Dr", "Address__City__s": "Hollywood", "Address__PostalCode__s": "33021-5800", "Address__StateCode__s": "FL", "Address__CountryCode__s": "US", "Terms_of_Use_Accepted__c": true, "Privacy_Policy_Accepted__c": true, "Response_Date__c": "2023-04-25" }');
        RestContext.request = req;
        RestContext.response= res;
        SavvasProspectStagingController.insertProspectStaging(); 
        String responseBody = res.responseBody.toString();
    }
    @isTest
    public static void insertProspectStagingNullRequest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/createProspectStaging';
        req.httpMethod = 'Post';
        req.requestBody=Blob.valueOf('');
        RestContext.request = req;
        RestContext.response= res;
        SavvasProspectStagingController.insertProspectStaging(); 
        String responseBody = res.responseBody.toString();
    }
    @isTest
    public static void insertProspectStagingInsertionError(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/createProspectStaging';
        req.httpMethod = 'Post';
        String value = '{ "Asset_Name__c": null, "Assigned_Rep__c": "Susan Klossing", "Collection_ID__c": null, "Contact_Validation_Flag__c": null, "MDR_ID__c": "00187969", "Collection_Name__c": null, "Description__c": "Message", "Entity_ID__c": null, "External_Campaign_ID__c": null, "Company_Name__c": "Chaminade Madonna College Prep", "Lead_Source_Link_H__c": null, "MQL_CMP_ID__c": null, "Owner_ID__c": "0050W000006fvUdQAI", "Rep_to_Contact__c": "true", "Phone__c": "0123456789", "School_District__c": "Broward", "Response_Purchase_Decision_Maker__c": "School", "Response_Purchase_Funding__c": "Yes", "Response_Purchase_Timeframe__c": "1-3 months", "Thumbnail_ID__c": null, "Webtracking_ID__c": null, "Product_of_Interest__c": null, "MQL_Source__c": null, "RUID__c": null, "School_Finder__c": "33021-5800", "Email__c": "mail@mail.com", "First_Name__c": "Christian", "Job_Title__c": "Curriculum Director", "Last_Name__c": "Reyes", "Website__c": "http://www.cmlions.org/s/315/home.aspx", "Address__Street__s": "500 E Chaminade Dr", "Address__City__s": "Hollywood", "Address__PostalCode__s": "33021-5800", "Address__StateCode__s": "FL", "Address__CountryCode__s": "US", "Terms_of_Use_Accepted__c": true, "Privacy_Policy_Accepted__c": true, "Response_Date__c": "2023-04-25" }';
        Prospect_Staging__c prospect = new Prospect_Staging__c(Asset_Name__c='TEST CLASS');
        insert prospect;
        String id = ',"id":"'+prospect.Id+'"}';
        value = value.replace('}', id);
        req.requestBody=Blob.valueOf(value);
        RestContext.request = req;
        RestContext.response= res;
        SavvasProspectStagingController.insertProspectStaging(); 
        String responseBody = res.responseBody.toString();
    }
}