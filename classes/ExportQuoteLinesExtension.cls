/*
*********************************************************
Class Name       : ExportQuoteLinesExtension
Created Date     : 08/21/2024  
Author           : Frank Berni - Cognizant
Description      : Controller extension for Export Quote Lines button for SBQQ Quote
README: - The related  VF page is intended to be added as a 'Tab' on Account Lightning Record Pages
        - Addtional Custom or Standard Fields/Filters can be added to the SOQL queries below and added to the Visualforce tables as needed

History:
<Date>          <Authors Name>              <Brief Description of Change>
08/21/2024      Frank Berni                  Ticket W-015737: Initial creation - error handle and bulkified quote lines
**********************************************************/
public class ExportQuoteLinesExtension {
  
  private final SBQQ__Quote__c quote;
  private List<SBQQ__QuoteLine__c> cachedQuoteLines;

  public ExportQuoteLinesExtension(ApexPages.StandardController stdController) {
      this.quote = (SBQQ__Quote__c)stdController.getRecord();
  }

/*
*********************************************************
Method Name    : getQuoteLines
Author         : Frank Berni
Description    : Method returns specified quote line fields related to the Quote to be displayed in excel doc
Param          : 
return         : List<SBQQ__QuoteLine__c> cachedQuoteLines
********************************************************
*/
  public List<SBQQ__QuoteLine__c> getQuoteLines() {
      if (cachedQuoteLines == null) {
            cachedQuoteLines = [
                SELECT
                    Id, Name, SBQQ__AdditionalDiscount__c,
                    SBQQ__AdditionalDiscountAmount__c, SBQQ__ListTotal__c, Base_SH__c, Contract_Price_Checked__c,
                    SBQQ__Description__c, Free_Amt__c, FWO_Quantity__c, SBQQ__ListPrice__c,
                    SBQQ__NetTotal__c, SBQQ__NetPrice__c, QL_Optional__c, Paid_Amt__c,
                    SBQQ__Quantity__c, SBQQ__Product__c, SBQQ__ProductName__c, Program_Name__c,
                    Applied_Promotion_Name__c, SH_Amount__c, StandardCost__c, Total_Quantity__c
                FROM SBQQ__QuoteLine__c
                WHERE SBQQ__Quote__c = :quote.Id
            ];
      }
      return cachedQuoteLines;
  }
}