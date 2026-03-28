/**
 * Class Name: CaseTriggerCalloutQueueable
 * Description: This Queueable class constructor will take caseIds as input parameters specific to fileuploads, rpaamountupdate, rpaclassificationchanges, rpaclassificationnulls for processing
 * Created By: Praveen Tharala
*/
public class CaseTriggerCalloutQueueable implements Queueable, Database.AllowsCallouts{
    List<Id> uploadFileCaseIds = null;
    List<Id> rPAAmountUpdateCaseIds = null;
    List<Id> rPAClassificationCaseIds = null;
    List<Id> rPAClassificationNullCaseIds = null;
    
    public CaseTriggerCalloutQueueable(List<Id> uploadFileCaseIds, List<Id> rPAAmountUpdateCaseIds, List<Id> rPAClassificationCaseIds, List<Id> rPAClassificationNullCaseIds){
        this.uploadFileCaseIds = uploadFileCaseIds;
        this.rPAAmountUpdateCaseIds = rPAAmountUpdateCaseIds;
        this.rPAClassificationCaseIds = rPAClassificationCaseIds;
        this.rPAClassificationNullCaseIds = rPAClassificationNullCaseIds;
    }

	/*
	 * This execute method will process all the constructor input case Ids list separately to update respective fields on case record
	 * */    
    public void execute(QueueableContext qContext){
        Map<Id, Case> casesToUpdateMap = new Map<Id, Case>();
        system.debug('queable execute method');
        
        if(!rPAClassificationNullCaseIds.isEmpty()){
            EmailToCaseHandler.onCaseInsertorUpdate(String.join(rPAClassificationNullCaseIds, ','));
        }
        
        if(!uploadFileCaseIds.isEmpty()){
            EmailToCaseHandler.uploadFile(String.join(uploadFileCaseIds, ','));
        }
        
        if(!rPAAmountUpdateCaseIds.isEmpty()){
            for(Id caseId : rPAAmountUpdateCaseIds)
                EmailToCaseHandler.onRPAAmountUpdate(caseId);
        }
        
        if(!rPAClassificationCaseIds.isEmpty()){
            for(Id caseId : rPAClassificationCaseIds)
                EmailToCaseHandler.onCaseUpdate(caseId);
        }
    }
}