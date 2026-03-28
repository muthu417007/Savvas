/*
*********************************************************
Class Name       : SbqqQuoteTriggerHandler
Created Date     : 6/10/2024  
Author           : Frank Berni - Cognizant
Description      : Handler class for the SBQQ__Quote__c Trigger

History:
<Date>          <Authors Name>              <Brief Description of Change>
6/10/2024       Frank Berni                 Initial creation: Ticket W-014653 
6/11/2024       Frank Berni                 Ticket W-014653 - created updateQLRelatedProductBoms solution to write related product records to Related_Product_Boms__c
7/10/2024       Frank Berni                 Ticket W-014654 - added ProductCode concatenation along with Product Name for related product boms
7/18/2024       Frank Berni                 Sprint 6 Demo feedback: added additional white space for isbnName for more spaced out presentation, Related Products are now Ordered By Sequence
**********************************************************/
public with sharing class SbqqQuoteTriggerHandler {
    
    /*****************************************************************************************************
    *********************************   Contextual Trigger Methods     ***********************************
    *****************************************************************************************************/

    /*
    *********************************************************
    Method Name    : afterUpdateMethod
    Author         : Frank Berni
    Description    : Handles any logic for Trigger in After Update context
    Param          : List<SBQQ__Quote__c> newList, Map<Id, SBQQ__Quote__c> oldMap
    ********************************************************
    */
    public static void afterUpdateMethod(List<SBQQ__Quote__c> newList, Map<Id, SBQQ__Quote__c> oldMap) {
        
        // Ticket W-014653 - Include/ Exclude Package Components for Output Doc - Explode Boms
        updateQLRelatedProductBoms(newList, oldMap);

    }


    /*****************************************************************************************************
    ***********************************   Helper Methods     *********************************************
    *****************************************************************************************************/


    /*
    *********************************************************
    Method Name    : updateQLRelatedProductBoms
    Author         : Frank Berni
    Description    : Ticket W-014653 - Include/ Exclude Package Components for Output Doc - Explode Boms
                     Searches for Related Product Product B records for the Quote's Quote Lines and stamps their names on them
    Param          : List<SBQQ__Quote__c> newQuoteList, Map<Id, SBQQ__Quote__c> oldQuoteMap
    return         : Quote Line's Related Product Boms become populated
    ********************************************************
    */
    public static void updateQLRelatedProductBoms(List<SBQQ__Quote__c> newQuoteList, Map<Id, SBQQ__Quote__c> oldQuoteMap) {

        // Populate set with any Quote Ids where Explode Boms was checked
        Set<Id> quoteIdSet = new Set<Id>();
        for (SBQQ__Quote__c quote : newQuoteList) {
            // User checks explode boms
            SBQQ__Quote__c oldQuote = oldQuoteMap.get(quote.Id);
            if (quote.Explode_Boms__c && !oldQuote.Explode_Boms__c) {
                quoteIdSet.add(quote.Id);
            } 
        }

        System.debug('quoteIdSet - ' + quoteIdSet);

        // Check that quoteIdSet above is populated first
        if (!quoteIdSet.isEmpty()) {

            // Query related quote line items
            List<SBQQ__QuoteLine__c> relatedQuoteLines = [
                SELECT Id, SBQQ__Product__c, Related_Product_Boms__c, SBQQ__Quote__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c IN :quoteIdSet LIMIT 50000
            ];

            // Populate map with quote line Id and its Product2 Id
            Map<Id, Id> quoteLineToProductMap = new Map<Id, Id>();
            for (SBQQ__QuoteLine__c ql : relatedQuoteLines) {
                quoteLineToProductMap.put(ql.Id, ql.SBQQ__Product__c);
            }

            System.debug('quoteLineToProductMap - ' + quoteLineToProductMap);

            try {

                // Query matching Related Products by their Product A field and quote line Product Ids
                // NEW added Order By Sequence to match desired order of boms
                List<Related_Product__c> relatedProducts = [
                    SELECT Id, ProductA__c, ProductB__c, ProductB__r.Name, ProductB__r.ProductCode FROM Related_Product__c 
                    WHERE ProductA__c IN :quoteLineToProductMap.values() 
                    ORDER BY Sequence__c ASC
                    LIMIT 50000
                ];

                System.debug('relatedProducts - ' + relatedProducts);

                // Populate Product Id with List of Related Product Product B Names
                Map<Id, List<String>> productIdtoRpIdListMap = new Map<Id, List<String>>();
                for (Related_Product__c rp : relatedProducts) {
                    //NEW updated String that concatenates ProductB__r.Name + '  -  ' + ProductB__r.ProductCode so it is more spaced out
                    String isbnName = rp.ProductB__r.ProductCode + '  -  ' + rp.ProductB__r.Name;
                    
                    if(productIdtoRpIdListMap.containsKey(rp.ProductA__c)) {
                        // Adding isbnName string to list
                        productIdtoRpIdListMap.get(rp.ProductA__c).add(isbnName);
                    }
                    else {
                        productIdtoRpIdListMap.put(rp.ProductA__c, new List<String>());
                        // Adding isbnName string to list
                        productIdtoRpIdListMap.get(rp.ProductA__c).add(isbnName);
                    }
                }

                System.debug('productIdToRpIdListMap - ' + productIdToRpIdListMap);

                // Assign each quote line their respective list of Product B record Names
                for (SBQQ__QuoteLine__c ql : relatedQuoteLines) {
                    Id productId = quoteLineToProductMap.get(ql.Id);
                    if(productIdToRpIdListMap.containsKey(productId)) {

                        // Find the matching Product B list for the quote line
                        List<String> productBList = productIdToRpIdListMap.get(productId);

                        // Looping through the Product B list and formatting it so we have line breaks delimitting each name
                        String formattedBomList = '';
                        for (String name : productBList) {
                            
                            // opening and closing p tags allow Rich Text fields to display line breaks
                            formattedBomList += '<p>' + name + '</p>';
                        }
                        
                        // Setting the quote line's Related Product Boms to the formattedBomList
                        ql.Related_Product_Boms__c = formattedBomList;
                    }
                }

                update relatedQuoteLines;

            }
            catch (Exception e) {
                System.debug('Exception occurred - ' + e);
                return;
            }
        }
    }
}