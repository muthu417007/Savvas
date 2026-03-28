/*
*********************************************************
Class Name       : QuoteLineExportController
Created Date     : 08/22/2024  
Author           : Frank Berni - Cognizant
Description      : Controller for quoteLineExport LWC, queries related quote lines, formats them as a CSV in base64Encode, and sends it to the LWC


History:
<Date>          <Authors Name>              <Brief Description of Change>
08/22/2024      Frank Berni                  Ticket W-015737: Initial creation - LWC version of Exporting Quote Lines
09/03/2024      Frank Berni                  Ticket W-015941: Adding ProductCode to Columns and fixing Addtl Discount columns
09/04/2024      Frank Berni                  Ticket W-015941: ISBN moved next to Description and left only one apostrophe in front of ISBNs
09/16/2024      Frank Berni                  Ticket W-015941: Reformatting ProductCode/ISBN so no apostrophes appear 
**********************************************************/
public with sharing class QuoteLineExportController {
    
    /*
    *********************************************************
    Method Name    : generateQuoteLineCsv
    Author         : Frank Berni
    Description    : Method returns a map of String, String to store the Quote's Name and formatted quote lines in CSV content
    Param          : Id quoteId
    return         : Map<String, String> result
    ********************************************************
    */
    @AuraEnabled
    public static Map<String, String> generateQuoteLineCsv(Id quoteId) {

        // Query the Name from Quote to be used in File Name and Header Row
        SBQQ__Quote__c quote = [SELECT Id, Name, Quote_Name__c FROM SBQQ__Quote__c WHERE Id = :quoteId LIMIT 1];

        // Query all Quote Lines related to Quote
        List<SBQQ__QuoteLine__c> quoteLines = [
            SELECT Id, Name, SBQQ__AdditionalDiscount__c, SBQQ__Product__r.Description,
            SBQQ__AdditionalDiscountAmount__c, SBQQ__ListTotal__c, Base_SH__c, Contract_Price_Checked__c,
            SBQQ__Description__c, Free_Amt__c, FWO_Quantity__c, SBQQ__ListPrice__c,
            SBQQ__NetTotal__c, SBQQ__NetPrice__c, QL_Optional__c, Paid_Amt__c,
            SBQQ__Quantity__c, SBQQ__Product__c, SBQQ__ProductName__c, Program_Name__c,
            Applied_Promotion_Name__c, SH_Amount__c, StandardCost__c, Total_Quantity__c, 
            // Added ProductCode to queried fields, and Discount since that should be assigned to Additional Discount column
            SBQQ__Product__r.ProductCode, SBQQ__Discount__c
            FROM SBQQ__QuoteLine__c
            WHERE SBQQ__Quote__c = :quoteId
        ];
        
        // Byte Order Mark (BOM) for UTF-9 to help it recognize special characters
        String bom = '\uFEFF';

        // This build the first row to have the Quote's Name. Each \n is a new row break
        String csvContent = bom + 'Quote Name: ' + quote.Quote_Name__c + '\n\n';

        // Build the csvContent uses comma separations for the columns
        // Modified Additional Discount and Additional Discount Amount to better reflect the column's name
        csvContent += 'Name,Optional,Program Name,ISBN,Description,Paid Quantity,FWO Quantity,Total Quantity,List Price,List Total,Additional Discount (%),Additional Discount (Amt),Net Price,Standard Cost,Paid Amt,Free Amt,Contract Price Checked,Promo Code,Base S&H,S&H Amount,Net Total\n';
        
        // Loop through the quote lines to build onto the csvContent
        for (SBQQ__QuoteLine__c qli : quoteLines) {
            
            // escape fields that potentially have commas to prevent unintentional offset columns
            String programName = escapeForCsv(qli.Program_Name__c);
            String description = escapeForCsv(qli.SBQQ__Product__r.Description);
            String promoCode = escapeForCsv(qli.Applied_Promotion_Name__c);

            // checkbox fields will use ternary conditions to assign true or false
            String qlOptional = qli.QL_Optional__c ? 'True' : 'False';
            String cpChecked = qli.Contract_Price_Checked__c ? 'True' : 'False';

            // NEW handling product code to prevent scientific notation
            String productCode = formatAsExcelFormula(qli.SBQQ__Product__r.ProductCode);

            // handling additional discount percentage
            String addtlDiscPercentage = qli.SBQQ__Discount__c != null ? String.valueOf(qli.SBQQ__Discount__c.setScale(2)) + '%' : '';

            // currency fields will have dollar signs associated as well as setScale(2) for proper currency format, if null then leave them as empty strings
            String listPrice = qli.SBQQ__ListPrice__c != null ? '$' + String.valueOf(qli.SBQQ__ListPrice__c.setScale(2)) : '';
            String listTotal = qli.SBQQ__ListTotal__c != null ? '$' + String.valueOf(qli.SBQQ__ListTotal__c.setScale(2)) : '';
            String addtlDiscAmt = qli.SBQQ__AdditionalDiscountAmount__c != null ? '$' + String.valueOf(qli.SBQQ__AdditionalDiscountAmount__c.setScale(2)) : '';
            String netPrice = qli.SBQQ__NetPrice__c != null ? '$' + String.valueOf(qli.SBQQ__NetPrice__c.setScale(2)) : '';
            String standardCost = qli.StandardCost__c != null ? '$' + String.valueOf(qli.StandardCost__c.setScale(2)) : '';
            String paidAmount = qli.Paid_Amt__c != null ? '$' + String.valueOf(qli.Paid_Amt__c.setScale(2)) : '';
            String freeAmount = qli.Free_Amt__c != null ? '$' + String.valueOf(qli.Free_Amt__c.setScale(2)) : '';
            String baseSh = qli.Base_SH__c != null ? '$' + String.valueOf(qli.Base_SH__c.setScale(2)) : '';
            String shAmount = qli.SH_Amount__c != null ? '$' + String.valueOf(qli.SH_Amount__c.setScale(2)) : '';
            String netTotal = qli.SBQQ__NetTotal__c != null ? '$' + String.valueOf(qli.SBQQ__NetTotal__c.setScale(2)) : '';
            
            // combine the csvContent with each quote line field separated by commas, also using reformatted strings above
            // added ProductCode/ISBN column next to the description
            csvContent += qli.Name + ',' + qlOptional + ',' + programName + ',' + productCode + ',' + description + ',' + qli.SBQQ__Quantity__c + ',' + qli.FWO_Quantity__c + ',';
            // set SBQQ__Discount__c to Additional Discount column
            csvContent += qli.Total_Quantity__c + ',' + listPrice + ',' + listTotal + ',' + addtlDiscPercentage + ',' + addtlDiscAmt + ',' + netPrice + ',';
            csvContent += standardCost + ',' + paidAmount + ',' + freeAmount + ',' + cpChecked + ',' + promoCode + ',' + baseSh + ',';
            csvContent += shAmount + ',' + netTotal;

            // bookend this loop with a row break
            csvContent += '\n';
        }
        
        // Create a new map of String String
        Map<String, String> result = new Map<String, String>();
        // The first key/value pair will be the EncodingUtil.base64Encode format of the csvContent
        result.put('csvContent', 'data:text/csv;charset=utf-8;base64,' + EncodingUtil.base64Encode(Blob.valueOf(csvContent)));
        // The second key/value pair will be the quote's name to be referenced in JS and Excel Doc
        result.put('quoteName', quote.Quote_Name__c);
        return result;
    }

    /*
    *********************************************************
    Method Name    : escapeForCsv
    Author         : Frank Berni
    Description    : Takes a string and returns it enclosed with double quotes to handle cases where field values have commas in them
    Param          : String value
    return         : reformatted String of value
    ********************************************************
    */
    private static String escapeForCsv(String value) {
        if (value == null) {
            return '';
        }

        return '"' + value.replace('"', '""') + '"';
    }

    /*

    *********************************************************
    Method Name    : formatAsExcelFormula
    Author         : Frank Berni
    Description    : Takes a string and formats it so it appears as text instead of a number to the CSV and does not apply scientific notation
    Param          : String value
    return         : reformatted result string
    ********************************************************
    */
    private static String formatAsExcelFormula(String value) {
        if (value == null) {
            return '';
        }
        
        // NEW Formula to force Excel to treat it as text i.e. ="0123456789123"
        String result = '="' + value + '"';

        // We saved the value with double quotes and start it with a single (') to tell CSV to treat this as text and not a number
        return result;
    }
}