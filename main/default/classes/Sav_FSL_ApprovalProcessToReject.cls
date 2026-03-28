/**
 * ClassName: Sav_FSL_ApprovalProcessToReject
 * Description: W-013923, Reject the Approval process(After 24 hrs) 
 * Author: Prerna
 * Created Date: 14 FEB 2024
 * Version: v1.0
 * Work no : W-013923
 */

public class Sav_FSL_ApprovalProcessToReject {
   @InvocableMethod(label='Auto Reject an Approval Process')
    public static list<ARResult> rejection(List<ARListAndResponse> aRAndResponseList){
    Boolean approvalFailed;
    system.debug('Assigned Resource and response: '+ aRAndResponseList);
    List<ARResult> results = new List<ARResult>();
    List<ProcessInstanceWorkitem> workItems = new List<ProcessInstanceWorkitem>();
    if(aRAndResponseList[0].userId != null && !String.isBlank(aRAndResponseList[0].userId[0])){
    workItems = [
    SELECT Id, ProcessInstanceId 
    FROM ProcessInstanceWorkitem 
    WHERE ProcessInstance.TargetObjectId = : aRAndResponseList[0].aRList[0] AND OriginalActorId =:aRAndResponseList[0].userId[0] ];
    }else {
	workItems = [
    SELECT Id, ProcessInstanceId 
    FROM ProcessInstanceWorkitem 
    WHERE ProcessInstance.TargetObjectId = : aRAndResponseList[0].aRList[0] ];
    }
    //AND OriginalActorId =: UserInfo.getUserId()

    if(workItems.size() > 0){    
    system.debug('AR :'+ aRAndResponseList[0].aRList[0]);        
    System.debug('Approval Process id : '+ workItems[0].id);
	List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
    String res =  aRAndResponseList[0].responseList[0];
    system.debug('Resp :'+ aRAndResponseList[0].responseList[0]);        
        
	for(ProcessInstanceWorkitem workItem : workItems){
  		  Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
          req.setWorkitemId(workItem.Id);
          System.debug('In the list: '+ workItem.Id);
          req.setAction(res);
     
          requests.add(req);
	}
	Approval.ProcessResult[] processResults = Approval.process(requests);
        for(Approval.ProcessResult pr : processResults){
            if(pr.isSuccess()){
                results.add(new ARResult(true));
            }
        }
    }

    for(ARResult ar : results){
        if(ar.isSuccess == false){
            approvalFailed = true;
        }
    }
    return (approvalFailed == true) ? new list<ARResult>{new ARResult(false)} : new list<ARResult>{new ARResult(true)};
 }
    
    public class ARListAndResponse{
        @InvocableVariable(required=true)
        public list<String> aRList;
        
        @InvocableVariable(required=true)
        public list<String> responseList;

        @InvocableVariable(required = false)
        public list<String> userId;

    }

    public class ARResult{
        @InvocableVariable(required=true)
        public Boolean isSuccess;

        public ARResult(Boolean val ){
            this.isSuccess = val;
        }
    }

}