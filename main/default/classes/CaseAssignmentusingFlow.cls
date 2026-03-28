public class CaseAssignmentusingFlow {
    @Invocablemethod(label='Case Assignment Using Apex' description='Trigger the case assignment rule' category='case')
    public static void caseAssign(List<Id> CaseIds){
       Database.DMLOptions dmo=new Database.DMLOptions();
       dmo.assignmentRuleHeader.useDefaultRule = true;
       Case caseRecord= [select Id FROM Case where case.id in:caseIds];
       caseRecord.setOptions(dmo);
       update caseRecord;
    }                        
                     
}