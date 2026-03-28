/*
*********************************************************
Class Name       : CustomTemplateController
Created Date     : 10/01/2024  
Author           : Brent Mac - Cognizant
                   Frank Berni - Cognizant
Description      : Custom controller for Template Content on Quote Document Gen

History:
<Date>          <Authors Name>              <Brief Description of Change>
10/01/2024       Brent Mac                 Initial creation
10/02/2024       Brent Mac                 Fixed rendering issue with template
10/29/2024       Frank Berni               W-016384: Dynamic columns for Price Quote Summary section
10/30/2024       Frank Berni               Moved divide Discount % logic to VF page 
11/05/2024       Frank Berni               W-016384: Added SUM variables to store total of Base, Free and Total Amount fields 
11/12/2024       Frank Berni               Updated SUM variables from Total to Paid Amount instead 
11/25/2024       Frank Berni               Added PromoBaseAmount__c to be used instead of BaseAmount__c
12/17/2024       Frank Berni               Escaping ampersands in Program Name
**********************************************************/
public class CustomTemplateController{

  public string quoteId {get; set;}
  public string templateId {get; set;}
  public List<SBQQ__QuoteLine__c> lines {get; set;}
  public List<QuoteLineProgram__c> qlPrograms {get; set;}
  public List <Id> lineIDs {get; set;}
  public SBQQ__QuoteTemplate__c template {get;set;}
  public boolean showPriceQuoteSummary {get;set;}
  // W-016384: new booleans to control visibility for Free Amount and Discount columns
  public boolean showFreeAmount {get;set;}
  public boolean showDiscount {get;set;}
  // column widths variables to set to table-column tags
  public string solutionWidth {get; set;}
  public string baseWidth {get; set;}
  public string freeWidth {get; set;}
  public string discountAmtWidth {get; set;}
  public string discountPercWidth {get; set;}
  public string totalWidth {get; set;}
  // 3 Double class variables for total Base, Free and Total with getters setters, numbers could potentially be large
  public Double baseSum {get; set;}
  public Double freeSum {get; set;}
  public Double paidSum {get; set;}

  /*
    *********************************************************
    Method Name    : CustomTemplateController
    Author         : Brent Mac/ Frank Berni
    Description    : Controller constructor, assigns quoteId and templateId from getters and populates Template, LineData and ProgramData
    Param          : 
    return         : 
    ********************************************************
  */
  public CustomTemplateController() {
    quoteId = ApexPages.currentPage().getParameters().get('qid');
    templateId = ApexPages.currentPage().getParameters().get('tid');
    lineIDs = new List <Id>{};
    qlPrograms = new List <QuoteLineProgram__c>{};
    // setting controlling variables to false
    showPriceQuoteSummary = false;
    showFreeAmount = false;
    showDiscount = false;
    // setting sum variables to 0
    this.baseSum = 0;
    this.freeSum = 0;
    this.paidSum = 0;
    this.populateTemplate();
    this.populateLineData();
    this.populateProgramData();
    // calls method to set our column widths based on columns present
    this.setColumnWidths();
  }

  /*
    *********************************************************
    Method Name    : populateTemplate
    Author         : Brent Mac
    Description    : Queries SBQQ__QuoteTemplate__c from getter and populates template class variable
    Param          : 
    return         : template
    ********************************************************
  */
  public void populateTemplate() {
    template = [
      SELECT Id, SBQQ__FontFamily__c, SBQQ__FontSize__c, SBQQ__ShadingColor__c 
      FROM SBQQ__QuoteTemplate__c 
      WHERE Id = :templateId
    ];
  }

  /*
    *********************************************************
    Method Name    : populateLineData
    Author         : Brent Mac
    Description    : Queries SBQQ__QuoteLine__c from getter quoteId and populates lines class collection
    Param          : 
    return         : template
    ********************************************************
  */
  public void populateLineData() {
    lines = [
      SELECT Id, ProductCategory_MasterProgramFamily__c, Program_Category__c, SBQQ__Quote__c, 
             CategoryType_SortOrder__c, GradeLevel_SortOrder__c  
      FROM SBQQ__QuoteLine__c 
      WHERE SBQQ__Quote__c = :quoteId 
      ORDER BY CategoryType_SortOrder__c, GradeLevel_SortOrder__c ASC
    ];

    /*for(SBQQ__QuoteLine__c line : lines){
    lineIDs.add(line.Id);
    } */

  }

  /*
    *********************************************************
    Method Name    : populateProgramData
    Author         : Brent Mac/ Frank Berni
    Description    : Queries QuoteLineProgram__c from getter quoteId and populates qlPrograms class collection
    Param          : 
    return         : template
    ********************************************************
  */
  public void populateProgramData() {
    // Added following API fields:  Quote__r.Free_Amount__c, Quote__r.FreeQtyofQLI__c AND Quote__r.AdditionalDiscountApplied__c
    qlPrograms = [
      SELECT  id, Name, Quote__c, BaseAmount__c, PromoBaseAmount__c, Paid_Amt__c, FreeAmount__c, Total__c,  Free_Qty__c, Paid_Qty__c, 
              Total_Discount__c, Total_Discount_Amount__c, Additional_Discount_Amount__c, Additional_Discount_Percent__c, CurrencyIsoCode,
              Quote__r.Free_Amount__c, Quote__r.FreeQtyofQLI__c, Quote__r.AdditionalDiscountApplied__c
      FROM QuoteLineProgram__c  
      WHERE Quote__c = :quoteId 
      // filtering out Optional Products records
      AND Name != 'Optional Products'
      ORDER BY Name
    ];

    // W-016384: loop through qlPrograms to check valid values for Quote__r.Free_Amount__c and Quote__r.AdditionalDiscountApplied__c
    for (QuoteLineProgram__c qlp : qlPrograms) {

      // NEW
      qlp.Name = qlp.Name.contains('&') ? qlp.Name.replace('&','&amp;') : qlp.Name;
 
      // if Quote__r.Free_Amount__c is greater than 0 OR Quote__r.FreeQtyofQLI__c is greater than 0, set showFreeAmount to true
      if (qlp.Quote__r.Free_Amount__c > 0 || qlp.Quote__r.FreeQtyofQLI__c > 0) {
        showFreeAmount = true;
      }

       // if Quote__r.AdditionalDiscountApplied__c is true then set showDiscount to true
      if (qlp.Quote__r.AdditionalDiscountApplied__c == true) {
        showDiscount = true;
      }

      // sum up PromoBaseAmount__c, FreeAmount__c, Paid_Amt__c to class variables
      this.baseSum += qlp.PromoBaseAmount__c != null ? qlp.PromoBaseAmount__c : 0; 
      this.freeSum += qlp.FreeAmount__c != null ? qlp.FreeAmount__c : 0;
      this.paidSum += qlp.Paid_Amt__c != null ? qlp.Paid_Amt__c : 0; 

    }
    
  } 

  /*
    *********************************************************
    Method Name    : setColumnWidths
    Author         : Frank Berni
    Description    : dynamically sets column widths on table-column tags based on how many columns are rendering on the output doc
    ********************************************************
  */
  public void setColumnWidths() { 
    // Set as default when all columns are shown
    solutionWidth = '50%';
    baseWidth = 'auto';
    // Ternary to set column-width to 0% if the boolean is false
    freeWidth = this.showFreeAmount ? 'auto' : '0%';
    discountAmtWidth = this.showDiscount ? 'auto' : '0%';
    discountPercWidth = this.showDiscount ? 'auto' : '0%';
    totalWidth = 'auto';

  }
}