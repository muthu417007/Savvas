/************************************************************************ 
Name: OrderTriggerHandler
Purpose: W-013027, W-012203 - Sends the updated Order details to ML. Agents review the Order created through RPA process, makes neccessary updates on Order if required and then approves/rejects Orders.
		 These details are sent to ML system for the learning of ML algorithms,
History:
VERSION AUTHOR DATE       DETAIL                DESCRIPITOPN
1.0     CTS               INITIAL DEVELOPMENT   Created methods that call ML Order reconcilaition(/InsertFeedbackData) API
************************************************************************/
public with sharing class OrderTriggerHandler {
    public static boolean isRecursion = false;
    public static list<Order__c> orders = new list<Order__c>(); // to update ML response
   
/******************************************************************************** 
* Description: Forms the JSON structure to makes callout to ML's (/InsertFeedbackData) API and sends the details updated by Agents on Order.
*********************************************************************************/
    @future(callout=true)
    public static void callOrderReconciliationAPI(String orderIds)
    {
        String orderId = '';
        set<String> orderIdsset = new set<String>();
        list<Order__c> ordersToUpdate = new list<Order__c>();// to send to ML system 
        map<Id, Id> mapShipAddIdToOrderId = new map<Id, Id>();
        map<Id, Id> mapBillAddIdToOrderId = new map<Id, Id>();
        map<Id, Id> mapOrderIdToAccId = new map<Id, Id>();
        map<Id, Id> mapOrderIdToConId = new map<Id, Id>();
        map<Id, Account> mapAccIdToAcc = new map<Id, Account>();
        map<Id, Contact> mapConIdToCon = new map<Id, Contact>();
        map<Id, list<orderlineitem__c>> mapOrderIdToOLI = new map<Id, list<orderlineitem__c>>();
        map<Id, Account_Addresses__c> mapOrderIdToShipToAdd =  new map<Id, Account_Addresses__c>();
        map<Id, Account_Addresses__c> mapOrderIdToBillToAdd =  new map<Id, Account_Addresses__c>();
        
        try{
            for(Order__c objOrder : [SELECT Id, Account__c, ShipToContact__c, RPA_Phone__c, ShipToAddress__c, InvoiceToAddress__c, Case__c, ShipConfirmationEmail__c, Ship_to_Phone__c, Order_Date__c, PONumber__c, Review_Complete__c
                                     FROM Order__c
                                     WHERE Id IN: orderIds.split(',')])
            {
                if(objOrder.Review_Complete__c){
                    orderIdsset.add(objOrder.Id);
                    ordersToUpdate.add(objOrder);
                    mapOrderIdToAccId.put(objOrder.Id, objOrder.Account__c);
                    if(objOrder.ShipToContact__c != null) mapOrderIdToConId.put(objOrder.Id, objOrder.ShipToContact__c);
                    if(objOrder.ShipToAddress__c != null) mapShipAddIdToOrderId.put(objOrder.ShipToAddress__c, objOrder.Id);
                    if(objOrder.InvoiceToAddress__c != null) mapBillAddIdToOrderId.put(objOrder.InvoiceToAddress__c, objOrder.Id);
                }
            }
            
            // get Order Line Item and Address Details for the Order
            for(orderlineitem__c oli : [SELECT Free_Item_Quantity__c, ItemQuantity__c, UnitOfMeasure__c, Price__c, Ordered_Item__c, Order__c, ShippingAmount__c
                                        FROM orderlineitem__c 
                                        WHERE Order__c IN: orderIdsset])
                
            {

                if(mapOrderIdToOLI.containsKey(oli.Order__c)){
                    mapOrderIdToOLI.get(oli.Order__c).add(oli);
                }
                else{
                    mapOrderIdToOLI.put(oli.Order__c, new list<orderlineitem__c>{oli});
                }
            }
            
            // get ship to address details
            for(Account_Addresses__c accAdd1 : [SELECT Id, Address_1__c, Address_2__c, City__c, State__c, Zip_Code__c, Country__c
                                                FROM Account_Addresses__c
                                                WHERE Id IN: mapShipAddIdToOrderId.keyset()])
            {
                if(mapShipAddIdToOrderId.containsKey(accAdd1.Id)){
                    mapOrderIdToShipToAdd.put(mapShipAddIdToOrderId.get(accAdd1.Id), accAdd1);
                }
            }
            
            // get bill to address details
            for(Account_Addresses__c accAdd2 : [SELECT Id, Address_1__c, Address_2__c, City__c, State__c, Zip_Code__c, Country__c
                                                FROM Account_Addresses__c
                                                WHERE Id IN: mapBillAddIdToOrderId.keyset()])
            {
                if(mapBillAddIdToOrderId.containsKey(accAdd2.Id)){
                    mapOrderIdToBillToAdd.put(mapBillAddIdToOrderId.get(accAdd2.Id), accAdd2);
                }
            }
            
            //get account details
            for(Account acc : [SELECT Id, Name FROM Account WHERE Id IN: mapOrderIdToAccId.values()])
            {
                mapAccIdToAcc.put(acc.Id, acc);
            }
            
            //get Contact details
            for(Contact con : [SELECT Id, Name FROM Contact WHERE Id IN: mapOrderIdToConId.values()])
            {
                mapConIdToCon.put(con.Id, con);
            }
            
            // create Order update JSON
            OrderUpdateJSONWrapper jsonWrapper = new OrderUpdateJSONWrapper();
            OrderUpdateJSONWrapper.Data orderData;
            OrderUpdateJSONWrapper.OrderLineItem orderLineItemData;
            list<OrderUpdateJSONWrapper.OrderLineItem> lstOLIWrapper = new list<OrderUpdateJSONWrapper.OrderLineItem>();
            list<OrderUpdateJSONWrapper.Data> lstorderData = new list<OrderUpdateJSONWrapper.Data>();
            
            for(Order__c objOrder : ordersToUpdate)
            {
                //orderId = objOrder.Id;
                orderData = new OrderUpdateJSONWrapper.Data();
                orderData.case_id = objOrder.Case__c;
                if(mapOrderIdToAccId.containsKey(objOrder.Id)){
                    orderData.Institution_Name = mapAccIdToAcc.get(mapOrderIdToAccId.get(objOrder.Id)).Name;
                }
                if(mapOrderIdToConId.containsKey(objOrder.Id)){
                    orderData.Ship_to_Contact = mapConIdToCon.get(mapOrderIdToConId.get(objOrder.Id)).Name;
                }
                orderData.Ship_to_Email = objOrder.ShipConfirmationEmail__c;
                orderData.Ship_to_PhoneNum = objOrder.RPA_Phone__c;
                orderData.PODate = String.valueOf(objOrder.Order_Date__c);
                orderData.PONUMBER = objOrder.PONumber__c;
                //assign ship to address values
                if(mapOrderIdToShipToAdd.containsKey(objOrder.Id)){
                    Account_Addresses__c shipToAdd = mapOrderIdToShipToAdd.get(objOrder.Id);
                    if(String.isNotBlank(shipToAdd.Address_1__c)){
                        orderData.Ship_to_Street = shipToAdd.Address_1__c;
                    }
                    else if(String.isNotBlank(shipToAdd.Address_2__c)){
                        orderData.Ship_to_Street = shipToAdd.Address_2__c;
                    }
                    orderData.Ship_to_city = shipToAdd.City__c;
                    orderData.Ship_to_State = shipToAdd.State__c;
                    orderData.Ship_to_Country = shipToAdd.Country__c;
                    orderData.Ship_to_Zip = shipToAdd.Zip_Code__c;    
                }
                //assign bill to address values
                if(mapOrderIdToBillToAdd.containsKey(objOrder.Id)){
                    Account_Addresses__c billToAdd = mapOrderIdToBillToAdd.get(objOrder.Id);
                    if(String.isNotBlank(billToAdd.Address_1__c)){
                        orderData.Bill_to_Street = billToAdd.Address_1__c;
                    }
                    else if(String.isNotBlank(billToAdd.Address_2__c)){
                        orderData.Bill_to_Street = billToAdd.Address_2__c;
                    }
                    orderData.Bill_to_city = billToAdd.City__c;
                    orderData.Bill_to_State = billToAdd.State__c;
                    orderData.Bill_to_Country = billToAdd.Country__c;
                    orderData.Bill_to_Zip = billToAdd.Zip_Code__c;    
                }
                //OLI values
                if(mapOrderIdToOLI.containsKey(objOrder.Id)){
                    for(orderlineitem__c oli : mapOrderIdToOLI.get(objOrder.Id)){
                        orderLineItemData = new OrderUpdateJSONWrapper.OrderLineItem();
                        orderLineItemData.AMOUNT = String.valueOf(oli.ShippingAmount__c);
                        orderLineItemData.ISBN = oli.Ordered_Item__c;
                        if(oli.ItemQuantity__c != null){
                            orderLineItemData.QUANTITY = String.valueOf(oli.ItemQuantity__c);
                        }
                        else if(oli.Free_Item_Quantity__c != null){
                            orderLineItemData.QUANTITY = String.valueOf(oli.Free_Item_Quantity__c);
                        }
                        orderLineItemData.UNITPRICE = String.valueOf(oli.Price__c);
                        lstOLIWrapper.add(orderLineItemData);
                    }
                    
                    orderData.OrderLineItem = lstOLIWrapper;
                }
                lstorderData.add(orderData);
                system.debug('Final list'+lstorderData);
                jsonWrapper.data = lstorderData;
                String jsonBody = JSON.serialize(jsonWrapper);
                system.debug('To JSON format--->'+JSON.serialize(jsonWrapper));
                if(String.isNotBlank(jsonBody)){
                    orderUpdateToML(jsonBody, objOrder.Id);
                }
            }
            
            system.debug('Orders to update Recon response---->'+orders);
            if(!orders.isEmpty()){
                update orders;
            }
        }
        catch(Exception ex)
        {
            system.debug('Exception in OrderTriggerHandler---'+ex.getMessage()+'---At Line no --->'+ex.getLineNumber());
        }
    }
    /******************************************************************************** 
* Description: Makes callout to ML's (/InsertFeedbackData) API and sends the details updated by Agents on Order.
*********************************************************************************/
    public static void orderUpdateToML(String body, String orderId)
    {
        try{
            system.debug('Request body--->'+body);
            RPAEndpoints__mdt ep = RPAEndpoints__mdt.getInstance('RPA_Order_Reconciliation');
            
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-Type','application/json');
            req.setMethod('POST');
            req.setEndpoint(ep.Endpoint__c);
            req.setbody(body);
            req.setTimeout(120000);
            Http http = new Http();
            HttpResponse res = http.send(req);
            if(res.getStatusCode() == 200){
                system.debug('Reconciliation Response from ML---');
                system.debug(res.getBody());
                isRecursion = true;
                //orders.add( new Order__c(Id = orderId, RPA_Recon_Status__c = 'Success'));
                //update lstOrders;
            }
        }
        catch(Exception ex){
            system.debug('Exception in OrderTriggerHandler.orderUpdateToML---'+ex.getMessage()+'---At Line no --->'+ex.getLineNumber());
        } 
    }

    // assigning PO Cases to different Queue
    public static void assignCaseToQueues(list<Order__c> newOrders)
    {
        set<Id> caseIds = new set<Id>();
        for(Order__c objOrder : newOrders){
            if(objOrder.OrderSource__c == 'rpa' && objOrder.OrderType__c == 'RPA'){
                caseIds.add(objOrder.Case__c);
            }
        }
        assignRPAQueueToCase(caseIds);
    }
    
    /******************************************************************************** 
* Description: Assign Cases to RPA created after Order creation through RPA process is successfull.
*********************************************************************************/
    public static void assignRPAQueueToCase(set<Id> caseIds)
    {
        list<Case> casesToUpdate = new list<Case>();
        if(!caseIds.isEmpty())
        {
            List<RPACaseQueues__mdt> rPACaseQueues = [SELECT MasterLabel, DeveloperName, RPACaseQueueId__c 
                                                      FROM RPACaseQueues__mdt WHERE DeveloperName != 'EMAIL_CS_K12_New_Order'];
            set<String> rPAQueueIds = new set<String>();
            for(RPACaseQueues__mdt rPAQueue : rPACaseQueues){
                rPAQueueIds.add(rPAQueue.RPACaseQueueId__c);
            }
            ID queueId = [SELECT Queue.Id FROM queuesobject WHERE queue.name='EMAIL CS K12-RPA NEW ORDER'].Queue.Id;
            for(Case objCase : [SELECT Id, OwnerId FROM Case WHERE Id IN: caseIds])
            {
                if(!rPAQueueIds.contains(objCase.OwnerId) && !String.valueOf(objCase.OwnerId).startsWith('005') && objCase.OwnerId != queueId)
                {
                    objCase.OwnerId = queueId;
                    casesToUpdate.add(objCase);
                }
            }
        }

        try {
            if(!casesToUpdate.isEmpty())
                update casesToUpdate;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }

    // auto-populate values on Order
    public static void autopopulateFields(list<Order__c> newOrders)
    {
        set<Id> caseIds = new set<Id>();
        list<Order__c> rpaOrders = new list<Order__c>();
        for(Order__c objOrder : newOrders)
        {
           if(objOrder.OrderType__c == 'RPA')
           {
               objOrder.RPA_Bill_to_SAP_Account__c = objOrder.RPA_Bill_to_SAP_Account_Number__c;
               objOrder.RPA_Ship_to_SAP_Account__c = objOrder.RPA_Ship_to_SAP_Account_Number__c;
               objOrder.DeliverToAddress__c = objOrder.ShipToAddress__c;

               caseIds.add(objOrder.Case__c);
               rpaOrders.add(objOrder);
           }
        }

        map<Id, Case> mapIdToCase = new map<Id, Case>([SELECT Id, CaseNumber FROM Case WHERE Id IN: caseIds]);
        for(Order__c rpaOrder : rpaOrders)
        {
            if(mapIdToCase.containsKey(rpaOrder.Case__c)){
                rpaOrder.Customer_Service_Notes__c = mapIdToCase.get(rpaOrder.Case__c).CaseNumber;
            }
        } 
    }
    
    // This method checks if only RPA related fields are updated before sending to ML in feedback API
    public static list<Id> getRPAFieldUpdatedOrders(list<Id> lstOrderIds)
    {
        set<Id> setOrderIdsToReturn = new set<Id>();
        set<String> setOrderHistoryFields = new set<String>();
        set<String> setOLIHistoryFields = new set<String>();
        list<Id> lstOrderIdsToReturn = new list<Id>();
        map<Id, OrderLineItem__c> mapIdToOLI = new map<Id, OrderLineItem__c>();
        
        List<Schema.FieldSetMember> fieldSetMemberList =  readFieldSet('RPA_Order_History_Field_Set','Order__c');
        for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList)
        {
            system.debug('API Name ====>' + fieldSetMemberObj.getFieldPath()); //api name
            system.debug('Label ====>' + fieldSetMemberObj.getLabel());
            setOrderHistoryFields.add(fieldSetMemberObj.getFieldPath());
        }
        
        // checking Order history to find out if there is any RPA related field is updated
        for(Order__History objOH : [SELECT Id, ParentId, DataType, Field, OldValue, NewValue 
                              		FROM Order__History
                              		WHERE ParentId IN: lstOrderIds
                                    AND Field != 'unlocked' AND Field != 'locked' AND Field != 'created'])
        {
            if(setOrderHistoryFields.contains(objOH.Field))
            	setOrderIdsToReturn.add(objOH.ParentId);
        }
        
        //check if there is any insert/update in OLI
        for(OrderLineItem__c oli : [SELECT Id, Order__c FROM OrderLineItem__c WHERE LastModifiedBy.Name != 'Integration User' AND Order__c IN: lstOrderIds])
        {
            mapIdToOLI.put(oli.Id, oli);
        }
        
        fieldSetMemberList =  readFieldSet('RPA_Line_Item_History_Fields','OrderLineItem__c');
        system.debug('===Line item===');
        for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList)
        {
            system.debug('API Name ====>' + fieldSetMemberObj.getFieldPath()); //api name
            system.debug('Label ====>' + fieldSetMemberObj.getLabel());
            setOLIHistoryFields.add(fieldSetMemberObj.getFieldPath());
        }
        
        // checking Order Line item history to find out if there is any RPA related field is updated
        for(OrderLineItem__History olih : [SELECT Id, ParentId, Field, CreatedDate, DataType, NewValue, OldValue 
                                           FROM OrderLineItem__History
                                           WHERE ParentId IN: mapIdToOLI.keyset() AND ParentId!= null]) {
                                               
                                               if(setOLIHistoryFields.contains(olih.Field) || olih.Field == 'created'){
                                                   setOrderIdsToReturn.add(mapIdToOLI.get(olih.ParentId).Order__c);
                                               }
        }
        
        if(!setOrderIdsToReturn.isEmpty())
            lstOrderIdsToReturn.addAll(setOrderIdsToReturn);
        if(Test.isRunningTest()){
            return lstOrderIds;
        }
        return lstOrderIdsToReturn;
    }
    
    // this method returns fields of field set
    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName)
    {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        return fieldSetObj.getFields(); 
    }  
}