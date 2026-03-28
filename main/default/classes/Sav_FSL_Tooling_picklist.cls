/**
 * ClassName: Sav_FSL_Tooling_picklist
 *
 * Description: Class to add extra picklist value to the Manager picklist when a new manager is found
 *
 * Methods:
 * createPicklist() : Returns void datatype taking String as input value and pushing it to the Sav_FSL_Manager__c custom picklist on ServiceResource object
 * Uses Tooling API with Sav_FSL named credential endpoints to get response and update picklist values
 * 
 * Author: CTS team
 * Created Date: 2 FEB 2024
 * Version: v1.0
 * Version: v2.0 (11 MAR 2024)
 * Work no : W-013853
 */

public class Sav_FSL_Tooling_picklist {
    
    @future(callout=TRUE)
    public static void createPicklist(){
        try{
    String customFieldId = '';

    HTTPRequest req = new HTTPRequest();
    req.setEndpoint('callout:Sav_FSL/services/data/v28.0/tooling/query/?q=select+Id+FROM+CustomField+WHERE+DeveloperName+=+\'Sav_FSL_Manager\'+AND+TableEnumOrId=\'serviceresource\'');
    req.setMethod('GET');
    req.setHeader('Content-Type', 'application/json');

    //To handle test class scenarios
    if(Test.isRunningTest()){
    Test.setMock(HttpCalloutMock.class, new Sav_FSL_Tooling_picklist_Test.MockHttpResponseGenerator());
    }

    Http h = new Http();
    HttpResponse res = h.send(req);
    JSONParser parser = JSON.createParser(res.getBody());

    while (parser.nextToken() != null) {
        if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
            //system.debug('>>>'+parser.getText());
            switch on parser.getText() {
               when 'Id' {
                // Advance to the label value.
                parser.nextToken();
                    customFieldId = parser.getText();
                }
            }
        }
    }

    if(!String.isBlank(customFieldId)){
        
        Map<String, String> validIds = new Map<String, String>{customFieldId => customFieldId};

        HTTPRequest req1 = new HTTPRequest();
        req1.setEndpoint('callout:Sav_FSL/services/data/v28.0/tooling/sobjects/CustomField/'+validIds.get(customFieldId));
        req1.setMethod('GET');
        // OAuth header
        req1.setHeader('Content-Type', 'application/json');

        Http h1 = new Http();
        HttpResponse res1 = h1.send(req1);
        Sav_FSL_JSON2APex wrapperObj = Sav_FSL_JSON2APex.parse(res1.getBody());

        set<String> managersList = new set<String>();
        for(ServiceResource sr  : [SELECT RelatedRecordId,Sav_FSL_Manager__c,Id,RelatedRecord.Manager.Name FROM ServiceResource WHERE IsActive = true AND RelatedRecord.ManagerId != NULL]){
            managersList.add(sr.RelatedRecord.Manager.Name);
        }

        wrapperObj.Metadata.picklist.picklistValues.clear();
        for(String singleValue : managersList){
        wrapperObj.Metadata.picklist.picklistValues.add(new Sav_FSL_JSON2APex.PicklistValues(singleValue));
        }

        if(wrapperObj.Metadata.picklist.picklistValues.size()>0){
            HTTPRequest req2 = new HTTPRequest();
            req2.setEndpoint('callout:Sav_FSL/services/data/v28.0/tooling/sobjects/CustomField/'+validIds.get(customFieldId));
            req2.setMethod('PATCH');
            // OAuth header
            req2.setHeader('Content-Type', 'application/json;charset=UTF-8');
            String metadata = JSON.serialize(wrapperObj.Metadata);
            String fullName = JSON.serialize(wrapperObj.FullName);

            String body = '{"Metadata":'+ metadata+',"FullName":'+fullName+'}';
            req2.setbody(body);

            Http h2 = new Http();
            HttpResponse res2 = h2.send(req2);
            }
        }
    }catch(exception ee){

    }
    }
}