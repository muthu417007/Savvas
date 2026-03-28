/********************************************************************** 
Name: CheckInstallBaseAndServiceType
Purpose:
History: 
VERSION AUTHOR DATE       DETAIL   DESCRIPITOPN
1.0     CTS    29/06/2023 Update    W-012221, W-013027, W-012203, W-012606
									Logic to identify Orders that should be assigned to RPA queues.
									Logic to send Orders data updated by agents to ML.
									Logic to auto-populate Order fields
***********************************************************************/
trigger CheckInstallBaseAndServiceType on Order__c (before insert, after insert, before update, after update) {
    list <orderlineitem__c> olilist = new list <orderlineitem__c>();
    List<id> orderids = new List<id>();
    
    if(!OrderTriggerHandler.isRecursion){
        For (order__c o:Trigger.new){
            if(o.Status__c=='Approved'){
                orderids.add(o.id);
                
            }
        }
        map<id,string> orderIdsWithProblemsMap = new map<id,string>();
        olilist = [Select ID, Order__c, LineNumberText__c from orderlineitem__c where Order__c IN:orderids AND Install_Base_Required__c = 'Y' AND Service_Item_Type_Code__c = 'Service' AND ProductforService__c = null];
        
        for(orderlineitem__c oli:olilist){
            string existingErrorForThisOrder=orderIdsWithProblemsMap.get(oli.Order__c);
            string concatenatedErrorForThisOrder='';
            if(existingErrorForThisOrder==null){
                concatenatedErrorForThisOrder = 'The Product for Service reference for Line Item '+ oli.LineNumberText__c + ' needs to be populated.  ';        
            }else{
                concatenatedErrorForThisOrder = existingErrorForThisOrder+'The Product for Service reference for Line Item '+ oli.LineNumberText__c + ' needs to be populated.  ';
            }
            orderIdsWithProblemsMap.put(oli.Order__c,concatenatedErrorForThisOrder);
        }
        
        set<id> orderIdsWithProblemsSet = orderIdsWithProblemsMap.keyset();  
        For (Order__c o:Trigger.new){  
            if(orderIdsWithProblemsSet.contains(o.id)){                      
                o.addError(orderIdsWithProblemsMap.get(o.id));              
            }                                                               
        }
    }

    //RPA Phase#3 
   if(trigger.isAfter && trigger.isInsert)
    {
        OrderTriggerHandler.assignCaseToQueues(trigger.new);
    }

    //RPA Phase#3 Reconciliation
    if(trigger.isAfter && trigger.isUpdate)
    {
        list<Id> ordersToML = new list<Id>();
        list<Id> reviewCompletedOrders = new list<Id>();
        String orderIds = '';
        for(Order__c objOrder : Trigger.new)
        {
            if(!trigger.oldmap.get(objOrder.Id).Review_Complete__c && objOrder.Review_Complete__c)
            {
                reviewCompletedOrders.add(objOrder.Id);
            }
        }
        system.debug('reviewCompletedOrders--->'+reviewCompletedOrders);
        ordersToML = OrderTriggerHandler.getRPAFieldUpdatedOrders(reviewCompletedOrders);
        system.debug('ordersToML--->'+ordersToML);
        if(!ordersToML.isEmpty())
        	orderIds = String.join(ordersToML, ',');
        if(String.isNotBlank(orderIds))
            OrderTriggerHandler.callOrderReconciliationAPI(orderIds);
    }
    
    //RPA - W-012606
    if(trigger.isBefore && trigger.isInsert){
        OrderTriggerHandler.autopopulateFields(Trigger.new);
    }
}