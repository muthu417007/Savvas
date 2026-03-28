/*Quote Report Export Controller
Implementation Notes:
- This is used alongside the QuoteReportExport VisualForce Page
- The related  VF page is intended to be added as a 'Tab' on Account Lightning Record Pages
- Addtional Custom or Standard Fields/Filters can be added to the SOQL queries below and added to the Visualforce tables as needed
*/

public class quoteRelatedVF {

    private final SBQQ__Quote__c quote;
    
    public quoteRelatedVF(ApexPages.StandardController stdController){
        this.quote = (SBQQ__Quote__c)stdController.getRecord();
    }

    
    public List<SBQQ__QuoteLine__c> getQuoteLines () {
          List<SBQQ__QuoteLine__c> quoteLines = [SELECT
            Id,
            Name,
            QL_Optional__c, 
            Program_Name__c, 
            SBQQ__Product__c, 
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
          WHERE SBQQ__Quote__c =: quote.Id];
          return quoteLines;
    }
}