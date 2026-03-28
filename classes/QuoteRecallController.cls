public class QuoteRecallController {
    private Id quoteId;
    public String comments { get; set; } // Property to hold the comments
    public QuoteRecallController(ApexPages.StandardController stdController) {
        quoteId = stdController.getId();
        comments = ''; // Initialize comments to an empty string
    }
/* For Screen Flow + Invocable Action use case that allows user to add comments when recalling approvals */
    
@InvocableMethod(label='Recall Quote Approval' description = 'Captures comments entered in Screen Flow and Submits Quote for Approval' category='Quote')
 public static List<SBAA__Approval__c> submitForApproval(List<Id> quoteIds) {
   List<SBAA__Approval__c> approvals = new List<SBAA__Approval__c>();
   for(Id quoteId : quoteIds){
       SBAA.ApprovalAPI.recall(quoteId, SBAA__Approval__c.Quote__c);
   }
   return approvals;
 }
}