/*
Purpose : This scheduler will extract the approval work item to get pending approvals and update Assigned_User__c field in Quote object with current approver.
          this will help the business to identify the pending quota approvals using reports.
Created on : 2/14/2020
*/
global class schApprovalProcess implements Schedulable {
    // Execute at regular intervals
    global void execute(SchedulableContext ctx){
      try{
           Map<id,id> QuoteIds=new Map<id,id>();
           list<ProcessInstanceWorkitem> scope=[select actor.name,actor.id,ProcessInstance.TargetObjectId from ProcessInstanceWorkitem where ProcessInstance.Status='Pending' ];
           for(ProcessInstanceWorkitem objP:scope){
                    //filter only the Quote records from approval pending items
                    if(objP.ProcessInstance.TargetObjectId!=null && objP.ProcessInstance.TargetObjectId.getSObjectType().getDescribe().getName()=='CameleonCPQ__Quote__c'){
                        QuoteIds.put(objP.ProcessInstance.TargetObjectId,objP.ActorId);
                    }
            }
            //Reterive Quote records
            List<CameleonCPQ__Quote__c> lQuote=new List<CameleonCPQ__Quote__c>([Select id,Assigned_User__c from CameleonCPQ__Quote__c where id in : QuoteIds.keySet()]);
            List<CameleonCPQ__Quote__c>updateList=new List<CameleonCPQ__Quote__c>();
            for(CameleonCPQ__Quote__c m:lQuote){
                if(QuoteIds.get(m.id)!=null && m.Assigned_User__c!=QuoteIds.get(m.id)){
                    m.Assigned_User__c=QuoteIds.get(m.id);
                    updateList.add(m);
                }
            }
            System.Debug('****Update Log*****'+updateList);
           // Update updateList;
         
         Database.SaveResult[] srList = Database.update(updateList, false);
         
         for (Database.SaveResult sr : srList) {
           if (sr.isSuccess()) {
               //Success full records
              System.debug('Quote ID : ' + sr.getId());
           } else {
                  // Failed Records
                  for(Database.Error objErr : sr.getErrors()) {
                     System.debug('Error Records'+objErr.getStatusCode() + ': ' + objErr.getMessage());
                  }
           }
        }
        
        
         //*********************Commented Custom object logic *****************************************   
            
             /*  System.debug('++++execute ' + scope.size());
               //******Delete old records from Approval pending custom object
                List<Approval_Pending__c> lstApprovalHistory = [Select id from Approval_Pending__c];
                if(lstApprovalHistory!=null && lstApprovalHistory.size()>0){
                    delete lstApprovalHistory;
                    Database.emptyRecycleBin(lstApprovalHistory);
                }
                lstApprovalHistory=new List<Approval_Pending__c>();
                for(ProcessInstanceWorkitem objP:scope){
                        //filter only the Quote records from approval pending items
                        if(String.ValueOf(objP.ProcessInstance.TargetObjectId).startsWith('a0a')){
                            Approval_Pending__c obj=new Approval_Pending__c(Assigned_User__c=objP.ActorId,PROS_Quote__c=objP.ProcessInstance.TargetObjectId);
                            lstApprovalHistory.add(obj);
                        }
                }
                 System.Debug(lstApprovalHistory.size());
                if(lstApprovalHistory!=null && lstApprovalHistory.size()>0){
                    insert lstApprovalHistory;
                }*/
        //*********************Commented Custom object logic******************************************    
        }catch(Exception e){
            system.debug('Exception occured+++'+e.getMessage());
        }
    }
}