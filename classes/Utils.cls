public class Utils{
    
    public static Map<Id,Boolean> doApprovals(List<Id> obj_ids){
        Map<Id,Boolean> approval_results = new Map<Id,Boolean>(); 
        for(Id rec_id : obj_ids){
            // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(rec_id);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
            approval_results.put(rec_id,result.isSuccess());
            // display if the reqeust was successful
            System.debug('Submitted for approval successfully: '+result.isSuccess());
        }
        
        return approval_results; 
    }
}