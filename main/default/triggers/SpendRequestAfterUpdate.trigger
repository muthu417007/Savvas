trigger SpendRequestAfterUpdate on Gifting_Request__c (AFTER Update) {
  
    List<ProcessInstance> pis= [Select TargetObjectId, (Select Id From Workitems) From ProcessInstance p WHERE p.TargetObjectId in :Trigger.newMap.KeySet()  AND p.Status = 'Pending'];
    //I create a Map with the recordId and the Process Instance so I can get it afterwards using the id
    Map<Id, ProcessInstance > piMap = new Map<Id, ProcessInstance >();
    for (ProcessInstance pi : pis){
     piMap.put(pi.TargetObjectId, pi);
    }
     
  for (Gifting_Request__c gr : Trigger.new) {
 
    boolean haveErrors = false;
    if (gr.request_Status__c == 'Submitted'){
        //confirm the trigger is due to update of flag for automatic approval
        if(gr.Participant_Count__c==0 && (gr.Type_of_Event__c=='Individual Meal' 
                                || gr.Type_of_Event__c=='Pearson-hosted Event (e.g., author reception)' 
                                || gr.Type_of_Event__c=='Conference Event (Pearson selects participants)')){
            //when submit for approval
            gr.adderror('Please add the Participants to the Event. Please click the browser "Back" button to get to the Spend Request.', false);                           
                          
            haveErrors=True;
        }   
          
        if (haveErrors==false && gr.Automatic_MGM_Approval__c && gr.MGM_Approval__c== 'Submitted'){  
         
             if (pis.size()>0){
                 //I use the Map to get the work Item Id's of the record I am processing
                 // we will get all the workitems for a process and approve them - we can clear the list after using it
                List<Id> newWorkItemIds = new List<Id>();
                ProcessInstance pi = piMap.get(gr.id);
                for (List<ProcessInstanceWorkitem> wis : pi.Workitems) {
                    for (ProcessInstanceWorkitem wi : wis ) {
                        newWorkItemIds.add(wi.id);
                    }
                } 
             
               //we will get the first workItem from a Process Instance and approve it         
               //System.debug('WorkItemId is: ' + newWorkItemIds.get(0));
               // Instantiate the new ProcessWorkitemRequest object and populate it
               Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
               req2.setComments('The MGM Approval is automatic, because no action was taken within the required time.');
               req2.setAction('Approve');
                // Use the ID from the newly created item to specify the item to be worked
               req2.setWorkitemId(newWorkItemIds.get(0));
               
                // Submit the request for approval
               Approval.ProcessResult result2 =  Approval.process(req2);
               
               // Verify the results
               System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
               
               //System.debug('The step has been '+result2.getInstanceStatus());
                
             }
        }
    }               
  }  
}