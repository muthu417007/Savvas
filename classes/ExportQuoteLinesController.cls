public with sharing class ExportQuoteLinesController {
    
    private final SBQQ__Quote__c quote;
  private List<SBQQ__QuoteLine__c> cachedQuoteLines;

  public ExportQuoteLinesController(ApexPages.StandardController stdController) {
      this.quote = (SBQQ__Quote__c)stdController.getRecord();
  }

  public List<SBQQ__QuoteLine__c> getQuoteLines() {
      if (cachedQuoteLines == null) {
          try {
              cachedQuoteLines = [
                  SELECT
                      Id,
                      Name,
                      QL_Optional__c, 
                      Program_Name__c, 
                      SBQQ__Product__c, 
                      SBQQ__ProductCode__c,
                      SBQQ__ProductName__c,
                      SBQQ__Description__c, 
                      SBQQ__Quantity__c, 
                      FWO_Quantity__c, 
                      Total_Quantity__c, 
                      SBQQ__ListPrice__c, 
                      SBQQ__ListTotal__c, 
                      SBQQ__AdditionalDiscount__c, 
                      SBQQ__AdditionalDiscountAmount__c, 
                      SBQQ__NetPrice__c, 
                      StandardCost__c, 
                      Paid_Amt__c, 
                      Free_Amt__c, 
                      Contract_Price_Checked__c, 
                      Applied_Promotion_Name__c, 
                      Base_SH__c, 
                      SH_Amount__c, 
                      SBQQ__NetTotal__c
                  FROM SBQQ__QuoteLine__c
                  WHERE SBQQ__Quote__c = :quote.Id
              ];
          } catch (Exception e) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error retrieving quote lines: ' + e.getMessage()));
              return new List<SBQQ__QuoteLine__c>();
          }
      }
      return cachedQuoteLines;
  }

  public PageReference redirectToQuote() {
      return new PageReference('/' + quote.Id);
  }
}