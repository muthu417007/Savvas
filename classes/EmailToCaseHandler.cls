/*
* class name: EmailToCaseHandler
* description: This class has methods to send the needed case's subject, description, pdf attachements to backend to get the classification and order amount.
* created by: Praveen Tharala
*/

Public class EmailToCaseHandler {
    public static Boolean isCaseTriggerRPAIntegrationExecuted = false;
    
    /**
* Check if the case belongs to any Email CS queue and update the RPA_classification__c
* @param insertedCaseIds
*/
    @future(callout=true)
    public static void onCaseInsertorUpdate(String insertedCaseIds){
        List<Case> insertedCases = [select id,OwnerId,RecordTypeId,Subject,Description, RPA_Classification__c from case where id in:insertedCaseIds.split(',')];
        List<Case> cases = new List<Case>();
        //JC
        system.debug('The Inserted Cases in onCaseInsertorUpdate is ' +insertedCases);
        for(Case caseObj:insertedCases){
            getCaseWithUpdatedRPAValues(caseObj, cases);
        }
        if(!cases.isEmpty())
            update cases;
    }
    
    /**
* Send case subject, description to the api to map the response with the RPA_classification__c field
* @param caseid
* @return Case
*/
    Public static Case getCaseWithUpdatedRPAValues(Case insertedCase, List<Case> cases) {
        try{
            String subject = insertedCase.Subject;
            String description = insertedCase.Description !=null?insertedCase.Description:'';
            //12/06/22 - Smitha - Removed Subject: and Description: string from body
            //String jsonBodyOne ='Subject: '+subject.escapeJava()+' Description: '+description.escapeJava();
            String jsonBodyOne = subject.escapeJava()+' '+description.escapeJava();
            string jsonBodyTwo = '{"text": "'+jsonBodyOne+'"}';
            String getData = EmailService.GetData(jsonBodyTwo);
            system.debug('GetData is ' + getData);
            if(getData!=''){
                RPA rpaResponse = (RPA)JSON.deserialize(getData, RPA.class);
                RPALabel rpaMetric=(rpaResponse.labels!=null && rpaResponse.labels.size()>0) ? rpaResponse.labels[0] : null;
                if(rpaMetric!=null)
                {
                    Case c = new Case(Id = insertedCase.Id);
                    c.RPA_Classification__c = rpaMetric.label;
                    cases.add(c);
                }
            }
        }catch (Exception e){
            system.debug('exception from onCaseInsert: '+e.getMessage());
        }
        return null;
    }
    
    /**
* send the case number, subject, description, RPA_Classification__c on update of RPA_Classification__c
* @param caseid 
*/
    Public static void onCaseUpdate(String caseid) {
        try{
            Case insertedCase= [Select id,caseNumber,Subject,Description, RPA_Classification__c,RecordTypeId from Case where id=:caseid];
            
            String caseNumber = insertedCase.caseNumber;
            String subject = insertedCase.Subject;
            String description = insertedCase.Description!=null  ?insertedCase.Description:'';
            String RPA_Classification = insertedCase.RPA_Classification__c;
            
            String payload ='{"Case_number": "'+caseNumber+'","Email_Body":"'+description.escapeJava()
                +'","Subject":"'+subject.escapeJava()+'","Classification": '+'"'+RPA_Classification+'"}';
            
            EmailService.UpdateData(payload);
            
        }catch (Exception e){
            system.debug('exception is: '+e.getMessage());
        }
    }
    
    
    /*
* Call the API to inform about the RPA_ORDER_AMOUNT__c field value change
*/
    
    @future(callout=true)
    Public static void onRPAAmountUpdate(String caseid) {
        try{
            Case insertedCase= [Select CaseNumber,RPA_ORDER_AMOUNT__c,RecordTypeId from Case where id=:caseid];
            
            String payload ='{"case_id": "'+insertedCase.id+'","corrected_amount":"'+insertedCase.RPA_ORDER_AMOUNT__c +'"}';
            
            RPAEndpoints__mdt ep = RPAEndpoints__mdt.getInstance('RPA_Amount_Reconciliation');
            
            HttpRequest request=new HttpRequest();
            request.setMethod('POST');
            request.setHeader('Content-Type','application/json');
            String endPoint = ep.Endpoint__c;
                //'http://8.20.68.20:8089/reconcile_pdf';
            request.setEndPoint(endPoint);
            request.setBody(payload);
            request.setTimeout(120000);
            Http httpProtocol  = new Http();
            HttpResponse respo=httpProtocol.send(request);
        }catch (Exception e){
            system.debug('exception is: '+e.getMessage());
        }
    }
    
    static string getCaseId(String parentId){
        String caseId='';
        List<emailmessage> emailMessages=[select parentid from emailmessage where id=:parentId limit 1];
        if(emailMessages.size()>0)
        {
            caseId=emailMessages.get(0).parentid;
        }
        return caseId;
    }
    
    /**
* Upload file to the backen
* @param contentDocumentId 
*/
    @future(callout=true)
    public static void uploadFile(String allInsertedCaseIds){
        try{
            system.debug(' RPA File upload called--->');
            Map<Id, Case> caseIdMap=new Map<Id, Case>([Select id,casenumber,OwnerId from case where id in:allInsertedCaseIds.split(',')]);
            List<Id> caseIdsforQueue = new List<Id>(caseIdMap.keySet());
            
            List<attachment> caseAttachments=[select id, Name, Body, ParentId from attachment where (ContentType='application/pdf' or ContentType='application/octet-stream') 
                                              and parentid in(select id from emailmessage where parentid in:caseIdsforQueue) limit 1];
            
            List<Case> cases = new List<Case>();
            //Phase#3
            List<RPACaseQueues__mdt> rPACaseQueues = [select MasterLabel, DeveloperName, RPACaseQueueId__c from RPACaseQueues__mdt WHERE DeveloperName != 'EMAIL_CS_K12_New_Order'];
            set<String> rPAQueueIds = new set<String>();
            for(RPACaseQueues__mdt rPAQueue : rPACaseQueues){
                rPAQueueIds.add(rPAQueue.RPACaseQueueId__c);
            }
            //Phase#3
            for(Attachment attachment:caseAttachments)
            {
                String caseId= getCaseId(attachment.ParentId);
                RPAEndpoints__mdt ep = RPAEndpoints__mdt.getInstance('RPA_Upload_API');
                HttpRequest request=new HttpRequest();
                request.setMethod('POST');
                request.setHeader('Content-Type','application/json');
                request.setTimeout(120000);
                request.setEndPoint(ep.Endpoint__c);
                //request.setEndpoint('callout:RPA_File_Upload');
                //request.setClientCertificateName('savvas_com');
                String attachmentName=attachment.Name.replace(':','').replace('/','').replace('\\','').replace(':','')
                    .replace('?','').replace('*','').replace('"','').replace('<','').replace('>','').replace('|','');
                string payload = '{"case_id":"'+caseId+'","file_name": "'+attachmentName+'","base64":"'+EncodingUtil.base64Encode(attachment.Body)+'"}';
                
                request.setBody(payload);
                Http httpProtocol  = new Http();
                HttpResponse respo=httpProtocol.send(request);
                system.debug(' RPA response--->'+respo.getBody());
                if(respo.getStatusCode()==200)
                {
                    Integer apiStatusCode=updateRPAAmount(attachmentName,caseId,cases);
                    if(apiStatusCode!=200) {
                        updateRPAAmount(attachmentName,attachment.ParentId,cases);                    
                    }
                    // call create Order API only if Case is under queue listed in WI#W-012650 
                   if(caseIdMap.containsKey(caseId) && !rPAQueueIds.contains(caseIdMap.get(caseId).OwnerId))
                    {
                        getOrderDetailsFromRPA(attachmentName, caseId);
                    }
                }
            }
            if(!cases.isEmpty())
                update cases;
        }
        catch(Exception ex){
            system.debug('exception is: '+ex.getMessage()+'---l.no.--'+ex.getLineNumber());
        }
    }
    
    static integer updateRPAAmount(String fileName, String caseId, List<Case> cases) {
        HttpRequest request1=new HttpRequest();
        request1.setMethod('GET');
        request1.setHeader('Content-Type','application/json');
        RPAEndpoints__mdt ep = RPAEndpoints__mdt.getInstance('RPA_Amount_API');
        String endPoint = ep.Endpoint__c;
        //'http://8.20.68.20:8088/RA/api/JSON/v1.0/file_path_request?xmlpath={0}.OCR.xml';
        fileName=fileName.trim();
        fileName=fileName.substring(0,fileName.length()-4);
        endPoint=endPoint.replace('{0}',EncodingUtil.urlEncode(fileName,'UTF-8').replace('+','%20'));
        request1.setEndPoint(endPoint);
        request1.setTimeout(120000);
        
        Http httpProtocol1  = new Http();
        HttpResponse respo1=httpProtocol1.send(request1);
        
        if(respo1.getStatusCode()==200)
        {
            system.debug('RPA Amount response---->'+respo1.getBody());
            RPAGetAmountAPI apiResponse = (RPAGetAmountAPI)JSON.deserialize(respo1.getBody(), RPAGetAmountAPI.class);
            if(apiResponse.data[0].size()>2){
                String rpaAmount=apiResponse.data[0][2];
                system.debug('RPA Amount rpaAmount---->'+rpaAmount);
                if(String.isNotBlank(rpaAmount))
                {
                    Case c = new Case(Id = caseId);
                    c.RPA_ORDER_AMOUNT__c = Decimal.valueOf(rpaAmount.replace('$','').replace(',',''));
                    cases.add(c);
                }
            }                   
        }
        
        return respo1.getStatusCode();
    }
    
    // method to call Order API from ML
    static void getOrderDetailsFromRPA(String filename, String caseId){
        RPAOrderRequest roreq = new RPAOrderRequest();
        String str = '';
        str = filename.removeEndIgnoreCase('PDF');
        str = str+'OCR.xml';
        system.debug('File name -->'+str);
        /*if(filename.indexOf('PDF') > 1){
            str = filename.replace('PDF','OCR.xml');
        }
        else if(filename.indexOf('pdf') > 1){
            str = filename.replace('pdf','OCR.xml');
        }*/
        roreq.xmlpath = str;
        roreq.caseID = caseId;
        //+'.OCR.xml';
        String body = JSON.serialize(roreq);
        system.debug('Request body--->'+body);
        RPAEndpoints__mdt ep = RPAEndpoints__mdt.getInstance('RPA_Order_Creation_API');
        
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type','application/json');
        req.setMethod('POST');
        req.setEndpoint(ep.Endpoint__c);
        req.setbody(body);
        req.setTimeout(120000);
        Http http = new Http();
        HttpResponse res = http.send(req);
        if(res.getStatusCode() == 200){
            system.debug('PO Response from ML---');
            system.debug(res.getBody());
            //return res.getBody();
            RPAJSONParser.parseOrderJSON(res.getBody(), caseId);
        }
    }
    
    //Inner Model class to map the ML response
    class RPA
    {
        public string text{set;get;}
        public RPALabel[] labels{set;get;}
    }
    class RPALabel
    {
        public string label{set;get;}
        public decimal confidence{set;get;}
    }
    
    class RPAGetAmountAPI
    {
        public List<List<string>> data{set;get;}      
    } 
    
   public class RPAOrderRequest {
        public String xmlpath {get;set;}
        public String caseID {get;set;}
    }
}