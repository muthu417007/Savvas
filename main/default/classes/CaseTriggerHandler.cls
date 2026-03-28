public class CaseTriggerHandler {
    
    // Validation is no longer requred by the business.  
    // Commenting out all the code so it can be cleaned up at a later time
    /* 
    private static void checkForAttachedArticles(List < Case > cases) {
        // Get the Article Count by CaseID..
        Map < Id, AggregateResult > groupedCaseArticles = new Map < id, AggregateResult > ([Select CaseId Id, Count(KnowledgeArticleId) total FROM CaseArticle
            Where CaseId IN: cases GROUP BY CaseId
        ]);
        
        // For each case..
        for (Case currentCase: cases) {
            // If Status is closed and no articles attached and no value selected in Reason_Article_Not_Attached__c field, Throw an error.
            if (currentCase.status == 'Closed' && String.isBlank(currentCase.Reason_Article_Not_Attached__c )) {
                if (groupedCaseArticles.containsKey(currentCase.Id)) {
                    AggregateResult ar = groupedCaseArticles.get(currentCase.Id);
                    if (Integer.valueOf(ar.get('total')) <= 0) {
                        currentCase.addError(Label.No_Article_Attach_Error_for_Closed_Case);
                    }
                } else {
                    currentCase.addError(Label.No_Article_Attach_Error_for_Closed_Case);
                }

            } else {
                // If Status is closed and article attached and Reason_Article_Not_Attached__c not blank, throw an error
                if (currentCase.status == 'Closed' && (String.isnotBlank(currentCase.Reason_Article_Not_Attached__c ))) {
                    if (groupedCaseArticles.containsKey(currentCase.Id)) {
                        AggregateResult ar = groupedCaseArticles.get(currentCase.Id);
                        if (Integer.valueOf(ar.get('total')) > 0) {
                            currentCase.addError(Label.Both_Article_Attached_and_Reason_Provided_Error_for_Closed_Case);
                        }
                    }
    
                }
            }
        
    }

    public static void handleBeforeInsert(List < Case > cases) {
        checkForAttachedArticles(cases);
        // Void
    }
    public static void handleBeforeUpdate(List < Case > prevCases, List < Case > newCases) {
        checkForAttachedArticles(newCases);
    }
*/
}