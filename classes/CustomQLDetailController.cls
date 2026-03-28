/*
*********************************************************
Class Name       : CustomQLDetailController
Created Date     : 11/06/2024  
Author           : Frank Berni - Cognizant
Description      : Custom controller for Quote Line Detail section on Quote Document Gen. Conditionally displays specific fields

History:
<Date>          <Authors Name>              <Brief Description of Change>
11/06/2024       Frank Berni               W-016414 : Initial creation
11/07/2024       Frank Berni               W-016414 : Added additional logic to separate <p> tags from Related Product Boms, allows them to display in Desc Column
11/08/2024       Frank Berni               Added an orderedProgramList to preserve the order of the programs when displayed in VF page
12/12/2024       Frank Berni               Fixed ampersand error on Program Category grouping by escaping them with &amp;
12/17/2024       Frank Berni               Updated ampersand handling for Description and Related Product Boms 
12/20/2024       Frank Berni               Added new grouping layer logic, Program Name to Program Category to Line Items and Subtotals
01/02/2025       Frank Berni               Commented out removal of any ampersands from SBQQ__Description
01/08/2025       Frank Berni               Updated Order By from Sort_Order__c to Sort_Order_Formula__c
01/21/2025       Frank Berni               Updated Order By  to use CategorySort and Audience instead of Sort_Order_Formula__c
**********************************************************/
public with sharing class CustomQLDetailController {

    // Grab and populate our Quote Id and Template
    public string quoteId {get; set;}
    public string templateId {get; set;}
    public SBQQ__QuoteTemplate__c template {get;set;}

    // create ordered list of programs    
    // public List<String> orderedProgramList{get;set;}

    // create getter setter for List<Map<String, groupedLines>
    public Map<String, GroupedLines> programToLineItemsMap{get;set;}

    // create boolean getter setter to show Free Amount
    public boolean showFreeAmount {get;set;}

    // create boolean getter setter to show Free Qty
    public boolean showFreeQuantity {get;set;}

    // create width Strings for columns getters setters
    public string isbnWidth {get; set;}
    public string descWidth {get; set;}
    public string priceWidth {get; set;}
    public string freeQtyWidth {get; set;}
    public string chargedQtyWidth {get; set;}
    public string freeAmtWidth {get; set;}
    public string paidAmtWidth {get; set;}
    // store Quote Line Id with List of Related Product Boms w/o <p> and </p> tags (causing errors in output doc gen)
    public Map<Id, List<String>> relatedProductBomsMap {get; set;}

    // create a public class for groupedLines with following variables    
    // Public Class to store line items with their total free and paid amounts
    public class GroupedLines{
        public List<SBQQ__QuoteLine__c> lines {get; set;}
        public Double freeAmountSum {get; set;}
        public Double paidAmountSum {get; set;}
       
        public GroupedLines(List<SBQQ__QuoteLine__c> lineItems, Double freeSum, Double paidSum ) {
            this.lines = lineItems;
            this.freeAmountSum = freeSum;
            this.paidAmountSum = paidSum;
        }  
      }

    //  getters/setters for masterProgramList and ProgramNameToCategories
    public List<String> masterProgramList {get;set;} // Keeps original order of Progam Names
    public Map<String, List<String>> programNameToCategories {get;set;} // Stores original order of Program Categories to their master Program Names


    public CustomQLDetailController() {
        quoteId = ApexPages.currentPage().getParameters().get('qid');
        templateId = ApexPages.currentPage().getParameters().get('tid');
        // default booleans as false
        showFreeAmount = false;
        showFreeQuantity = false;

        // set new List Map to be populated
        // programSet = new Set<String>();
        programToLineItemsMap = new Map<String, GroupedLines>();
        // List for ordered program list
        // orderedProgramList = new List<String>();
        // set up new Map<Id, List<String>()
        relatedProductBomsMap = new Map<Id, List<String>>();

        //  initialize masterProgramList and programtoCategories Map
        masterProgramList = new List<String>();
        programNameToCategories = new Map<String, List<String>>();
        
        // Query our template fields for styling
        this.populateTemplate();

        // Query quote lines and populate collections and variables above
        this.populateQuoteLineData();

        // Set widths for columns based on conditional booleans
        this.setColumnWidths();

    }

    /*
    *********************************************************
    Method Name    : populateTemplate
    Author         : Frank Berni
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
    Method Name    : populateQuoteLineData
    Author         : Frank Berni
    Description    : Queries Quote Line fields to display in VF page
    Param          : 
    return         : template
    ********************************************************
  */
  public void populateQuoteLineData() {
    // query all pertinent fields for Quote Lines, ensure they are related to the Quote and QL_Optional is not true, OrderedBy SortOrderGrouping__c & SBQQ__ProductCode__c  
    List<SBQQ__QuoteLine__c> quoteLines = [
        SELECT Id, Contract_Price_Returned__c, SBQQ__Description__c,
            DescriptionLongText__c, FWO_Quantity__c, SBQQ__ProductCode__c,
            SBQQ__CustomerPrice__c, SBQQ__Quantity__c, Program_Category__c,
            Related_Product_Boms__c, SBQQ__Quote__r.Explode_Boms__c,
            SBQQ__Quote__r.Free_Amount__c, SBQQ__Quote__r.FreeQtyofQLI__c, 
            Free_Amt__c, Paid_Amt__c
            //  added Program_Name__c to query
            , Program_Name__c
        FROM SBQQ__QuoteLine__c
        WHERE SBQQ__Quote__c = :quoteId
        AND QL_Optional__c != true
        // NEW updated Order By to use CategorySort and Audience
        ORDER BY Program_Name__c ASC, CategorySort__c ASC, Audience__c ASC
    ];

    Map<String, GroupedLines> listLinesByProgramMap = new Map<String, GroupedLines>();
    Map<String, List<SBQQ__QuoteLine__c>> linesByProgramMap = new Map<String, List<SBQQ__QuoteLine__c>>();
    // temp list of specific order of Programs
    List<String> tempProgramList = new List<String>();
    // Create a temp Map<Id, List<String> for productBoms
    Map<Id, List<String>> tempProductBomsMap = new Map<Id, List<String>>();

    //  temp collections for Program Name 
    Map<String, List<String>> tempProgramNameToCategories = new Map<String, List<String>>();
    List<String> tempMasterProgramList = new List<String>();

    // loop through quote lines and populate a List<Map<String, groupedLines> grouping by Program_Category__c
    for (SBQQ__QuoteLine__c ql : quoteLines) {

        //  qlProgramName gets its ampersand cleaned 
        String qlProgramName = formatString(ql.Program_Name__c, false);
        
        // Assign Program Category value to String to allow modifications
        String qlProgramCategory = formatString(ql.Program_Category__c, false);
        

        String qlRichDescription = formatString(ql.SBQQ__Description__c, true);
        //  Assign Description fields to String for modifications - Staging ampersands for VF page
        String qlLongDescription = formatString(ql.DescriptionLongText__c, false);

        //  Update SBQQ__Description with escaped character version if there is a difference
        if (ql.SBQQ__Description__c != qlRichDescription || ql.DescriptionLongText__c != qlLongDescription) {
          //  commented out SBQQ__Description staging
          // ql.SBQQ__Description__c = qlRichDescription;
          ql.DescriptionLongText__c = qlLongDescription;
        }
        
        //  check if list doesn't contain the Program Name, then add it to the list if so
        if(!tempMasterProgramList.contains(qlProgramName)) {
          tempMasterProgramList.add(qlProgramName);
        }

        //  Populate tempProgramNameToCategories
        if(tempProgramNameToCategories.containsKey(qlProgramName)) {
          // If associated Category list to Program Name does not contain this category then
          if(!tempProgramNameToCategories.get(qlProgramName).contains(qlProgramCategory)) {
            // Adding unique Category to list
            tempProgramNameToCategories.get(qlProgramName).add(qlProgramCategory);
          }
          
        }
        else {
            // create a new List for the newly added Program Category
            tempProgramNameToCategories.put(qlProgramName, new List<String>());
            // If associated Category list to Program Name does not contain this category then
            if(!tempProgramNameToCategories.get(qlProgramName).contains(qlProgramCategory)) {
              // Adding unique Category to list
              tempProgramNameToCategories.get(qlProgramName).add(qlProgramCategory);
            }
        }
        
        // check if SBQQ__Quote__r.Free_Amount__c > 0, then set boolean to true
        if(ql.SBQQ__Quote__r.Free_Amount__c > 0 && showFreeAmount != true) {
            showFreeAmount = true;
        }

        // check if SBQQ__Quote__r.FreeQtyofQLI__c > 0, then set boolean to true
        if(ql.SBQQ__Quote__r.FreeQtyofQLI__c > 0 && showFreeQuantity != true) {
            showFreeQuantity = true;
        }

         // check if Contract_Price_Returned__c, then concatenate "**" to end of the Description field
        if(ql.Contract_Price_Returned__c) {
            ql.SBQQ__Description__c = ql.SBQQ__Description__c + '**';
            ql.DescriptionLongText__c = ql.DescriptionLongText__c + '**';
        }

        System.debug('ql.SBQQ__Description__c post Contract Pricing formatted: ' + ql.SBQQ__Description__c);

        List<String> productBoms = new List<String>();

        // checking if related product boms is not null 
        if(ql.Related_Product_Boms__c != null) {
          // Replacing the opening and closing p tags so output doc doesn't have any problems
          String processedText = ql.Related_Product_Boms__c.replaceAll('<p>', '').replaceAll('</p>', '\n');

          // Split into individual lines
          // productBoms = processedText.split('\n');
          List<String> splitLines = processedText.split('\n');

          // Add only non-empty entries to productBoms
          for (String line : splitLines) {
            if(!String.isBlank(line)) {
              //  removing possible ampersands
              line = formatString(line, true);
              productBoms.add(line);
            }
          }  
        }

        // Place into map
        tempProductBomsMap.put(ql.Id, productBoms);

        // build map of programs and their associated quote lines
        if(linesByProgramMap.containsKey(qlProgramCategory)) {
            // Adding ql to list
            linesByProgramMap.get(qlProgramCategory).add(ql);
        }
        else {
            // create a new List for the newly added Program Category
            linesByProgramMap.put(qlProgramCategory, new List<SBQQ__QuoteLine__c>());
            // Adding ql to list
            linesByProgramMap.get(qlProgramCategory).add(ql);
        }

    }

    // Loop through program map keySet
    for (String program : linesByProgramMap.keySet()) {
        //Map<String, GroupedLines> groupedLinesByProgramMap = new Map<String, GroupedLines>();
        Double programFreeAmountSum = 0;
        Double programPaidAmountSum = 0; 

        // Loop through the program's quote lines
        for(SBQQ__QuoteLine__c programQL : linesByProgramMap.get(program)) {
            // sum up each programs quote line Free_Amt__c & Paid_Amt__c
            programFreeAmountSum += programQL.Free_Amt__c != null ? programQL.Free_Amt__c : 0; 
            programPaidAmountSum += programQL.Paid_Amt__c != null ? programQL.Paid_Amt__c : 0; 
        }

        // Create a GroupedLines for this program
        GroupedLines gl = new GroupedLines(
            linesByProgramMap.get(program),
            programFreeAmountSum,
            programPaidAmountSum
        );

        // Put the program with its associated groupedLines in a map
        listLinesByProgramMap.put(
            program,
            gl 
        ); 
    }

    //  assigning temp collections to main collections
    masterProgramList = tempMasterProgramList;
    programNameToCategories = tempProgramNameToCategories;

    // Assign entire list to class list for VF page
    programToLineItemsMap = listLinesByProgramMap;

    // assign temp related product boms to class map
    relatedProductBomsMap = tempProductBomsMap;

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
    isbnWidth = '10%';
    descWidth = '50%';
    priceWidth = 'auto';
    chargedQtyWidth = 'auto';
    paidAmtWidth = 'auto';

    // Ternary to set column-width to 0% if the boolean is false
    freeQtyWidth = this.showFreeQuantity ? 'auto' : '0%';
    freeAmtWidth = this.showFreeAmount ? 'auto' : '0%';
  }

  /*
    *********************************************************
    Method Name    : formatString
    Author         : Frank Berni
    Description    : Escapes/Replaces any special characters that could be mistaken for HTML code
    ********************************************************
  */
  private static String formatString(String input, Boolean remove) {
    String result = input;

    // If not null, and remove is false
    if (input != null && !remove) {

      // Handle ampersands with &amp;
      result = input.contains('&') ? input.replace('&','&amp;') : result;
    } 
    // If not null, and remove is true
    else if (input != null && remove) {
      // Remove any instances of ampersands
      result = input.contains('&amp;') ? input.replace('&amp;','') : input;
      result = input.contains('&') ? input.replace('&','') : result;
    }
    
    return result;
  }

}