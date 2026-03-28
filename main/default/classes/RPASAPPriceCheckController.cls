/********************************************************************** 
Name: RPASAPPriceCheckController
Purpose: W-013141 - Makes callout to SAP system to get Pricing details of ISBNs. This is invoked from flow RPA SAP Price Check.
History: 
VERSION AUTHOR DATE       DETAIL   DESCRIPITOPN
1.0     CTS    29/06/2023 INITIAL  DEVELOPMENT
***********************************************************************/
public with sharing class RPASAPPriceCheckController {
    
    /********************************************************************** 
     * Description: Makes callout to SAP system and return the response to flow RPA SAP Price Check.
     **********************************************************************/
    @InvocableMethod(label='Get SAP Data' description='Get SAP Pricing Details')
    public static list<FlowOutput> getSAPPricingDetails(List<flowInputs> inputsFromFlow) 
    {
        list<OrderLineItem__c> olisToSendToSAP = new list<OrderLineItem__c>();
        list<Integration_Logs__c> lstIntegrationLogs = new list<Integration_Logs__c>();
        map<String, OrderLineItem__c> mapISBNToOLIs = new map<String, OrderLineItem__c>();
        
        for(flowInputs objFI : inputsFromFlow){
            olisToSendToSAP.addAll(objFI.selectedOLIs);
        }
        
        for(OrderLineItem__c oli : olisToSendToSAP){
            mapISBNToOLIs.put(oli.Ordered_Item__c, oli);
        }
        
        try{
            String strXML = RPASAPPriceCheckUtility.getRequestXML(olisToSendToSAP, inputsFromFlow[0].order);
            RPAEndpoints__mdt endpt = RPAEndpoints__mdt.getInstance('RPA_SAP_Price_Check');
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(endpt.Endpoint__c);
            req.setBody(strXML);
            req.setHeader('Content-Type','text/plain');
            req.setTimeout(120000);
            Http http =new Http();
            HTTPResponse res = http.send(req);
            System.debug('Callout Log code:' + res.getStatusCode());
            System.debug('Callout Log :body' + String.valueof(res.getbody()));
            try{
                if(res.getStatusCode() == 200)
                	lstIntegrationLogs.add( new Integration_Logs__c(Order__c = inputsFromFlow[0].order.Id, Request_Body__c = strXML, Response_Body__c = String.valueof(res.getbody()), Status__c = 'Success', Type__c = 'RPA SAP Price Check'));
                else
                    lstIntegrationLogs.add( new Integration_Logs__c(Order__c = inputsFromFlow[0].order.Id, Request_Body__c = strXML, Response_Body__c = String.valueof(res.getbody()), Status__c = 'Error', Type__c = 'RPA SAP Price Check'));
                insert lstIntegrationLogs;
            }
            catch(DmlException e){
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
            
            String responsemsg = RPASAPPriceCheckUtility.parseXMLResponse(String.valueof(res.getbody()), mapISBNToOLIs);
            FlowOutput output = new FlowOutput(responsemsg);
            return new list<FlowOutput>{output};
        }
        catch(system.CalloutException ex)
        {
            system.debug('Exception is---'+ex.getMessage());
            FlowOutput output = new FlowOutput(ex.getMessage());
            return new list<FlowOutput>{output};
        }
    }
    
    public class flowInputs {
        @InvocableVariable
        public List<String> selectedOLIIds;
        
        @InvocableVariable
        public Order__c order;
        
        @InvocableVariable
        public List<OrderLineItem__c> selectedOLIs;
    }
    
    public class FlowOutput{
        @InvocableVariable public String sapResponse;
        public FlowOutput(String sapResponse) {this.sapResponse = sapResponse;}
    }
}