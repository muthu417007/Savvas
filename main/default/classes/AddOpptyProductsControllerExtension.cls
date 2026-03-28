/*
*********************************************************
Class Name       : AddOpptyProductsControllerExtension
Created Date     : 7/05/2024  
Author           : Brent Mac/Frank Berni - Cognizant
Description      : Controller extension for Add Products button for Opportunity Products related list

History:
<Date>          <Authors Name>              <Brief Description of Change>
7/05/2024       Brent Mac                   Initial creation
7/08/2024       Frank Berni                 Ticket W-015412: Refactoring to pull in PricebookEntry records related to Quote Pricebook
7/09/2024       Frank Berni                 Ticket W-015412: Introduced search bar and quick filters logic and Back and Cancel methods
7/10/2024       Frank Berni                 Ticket W-015412: Deprecating unused code and finalizing build for Sprint 6.5
8/15/2024       Frank Berni                 Ticket W-015766: Adjusted queries to filter for Opportunity currencyIsoCode to ensure CAD currencies are captured
**********************************************************/
public class AddOpptyProductsControllerExtension {
    // Opportunity specific fields
    public Opportunity opp {get; set;}
    public String oppPricebookName {get; set;}
    public Id oppPricebookId {get; set;}
    // NEW oppCurrency to match
    public String oppCurrency {get; set;}

    // controls visibility of each table
    public Boolean isReviewStep {get; set;}

    // pricebook entry and opp line item collections
    public List<SelectablePriceBookEntry> pbEntrylist {get; set;}
    public List<SelectablePriceBookEntry> searchedPbEntrylist {get; set;}
    public List<OpportunityLineItemWrapper> oppLineItems {get; set;}

    // Search bar
    public String searchTerm {get; set;}

    // Quick filters
    public List<SelectOption> productFamilyOptions {get; set;}
    public List<SelectOption> lineOfBusinessOptions {get; set;}
    public Set<String> selectedProductFamily {get; set;}
    public Set<String> selectedLineOfBusiness {get; set;}
    public String activeFilter {get; set;}
    

    // Queries the Opportunity Pricebook to then use to query related PricebookEntries that have ProductFamily_Entry__c = true
    public AddOpptyProductsControllerExtension(ApexPages.StandardController stdController) {
        this.opp = (Opportunity)stdController.getRecord();
        System.debug('opp - ' + this.opp);

        // soql to query Opp's Pricebook which should be 'Quote Pricebook'
        // NEW Added CurrencyIsoCode to query
        Opportunity opportunityRecord = [SELECT Id, Pricebook2Id, Pricebook2.Name, CurrencyIsoCode FROM Opportunity WHERE Id =: opp.Id LIMIT 1];
        System.debug('opportunityRecord - ' + opportunityRecord);

        // Saving pricebook Name and Id for user later on
        oppPricebookName = opportunityRecord.Pricebook2.Name;
        // System.debug('oppPricebookName - ' + oppPricebookName);

        oppPricebookId = opportunityRecord.Pricebook2Id;
        // System.debug('oppPricebookId - ' + oppPricebookId);

        // NEW assignment for oppCurrency
        oppCurrency = opportunityRecord.CurrencyIsoCode;
        System.debug('oppCurrency - ' + oppCurrency);

        // fetch our pricebook entries for the pageblockTable
        pbEntrylist = getFilteredPbEntries();
        System.debug('pbEntryList - ' + pbEntryList);

        searchedPbEntrylist = pbEntryList;

        // instantiate our oppLineItems wrapper collection
        oppLineItems = new List<OpportunityLineItemWrapper>();

        isReviewStep = false;
        System.debug('isReviewStep - ' + isReviewStep);

        searchTerm = '';

    }

    /*
    *********************************************************
    Class Name     : SelectablePriceBookEntry
    Author         : Frank Berni
    Description    : wrapper class to include selected boolean for price book entries
    ********************************************************
    */
    public class SelectablePriceBookEntry {
        public PricebookEntry pbe {get; set;}
        public Boolean selected {get; set;}

        public SelectablePriceBookEntry(PricebookEntry pbEntry) {
            this.pbe = pbEntry;
            this.selected = false;
        }
    }

    /*
    *********************************************************
    Class Name     : OpportunityLineItemWrapper
    Author         : Frank Berni
    Description    : wrapper class to include selected for opportunity line items
    ********************************************************
    */
    public class OpportunityLineItemWrapper {
        public OpportunityLineItem opportunityLineItem {get; set;}
        public String productName {get; set;}
        public String uniqueId {get; set;}

        public OpportunityLineItemWrapper(OpportunityLineItem oli, String name, String unique) {
            this.opportunityLineItem = oli;
            this.productName = name;
            this.uniqueId = unique;
        }
    }

    /*
    *********************************************************
    Method Name    : getFilteredPbEntries
    Author         : Frank Berni
    Description    : uses Opportunity pricebook Id to find price book entries of ProductFamily_Entry__c = true. Pricebook Entries get set up as SelectablePriceBookEntry.
    Param          : 
    return         : List<SelectablePriceBookEntry> selectablePbes
    ********************************************************
    */
    public List<SelectablePriceBookEntry> getFilteredPbEntries() {
        
        // then another query for Product2 records that have PBEs matching Quote Pricebook and ProductFamily_Entry__c = true
        // NEW added filter to match oppCurrency
        List<PricebookEntry> pbeList = [
            SELECT Id, Product2Id, Name, IsActive, Business_Line__c, UnitPrice, ProductDescription__c, Product2.Description, ProductFamily__c
            FROM PricebookEntry
            WHERE Pricebook2Id =: oppPricebookId AND ProductFamily_Entry__c = true AND CurrencyIsoCode =: oppCurrency
            ORDER BY Name ASC
        ];
        System.debug('pbeList - ' + pbeList);
        System.debug('pbeList.size() - ' + pbeList.size());

        List<SelectablePriceBookEntry> selectablePbes = new List<SelectablePriceBookEntry>();
        for (PricebookEntry pbe : pbeList) {
            selectablePbes.add(new SelectablePriceBookEntry(pbe));
        }

        return selectablePbes;

    }

    /*
    *********************************************************
    Method Name    : searchPbEntries
    Author         : Frank Berni
    Description    : searches and filters down returned price book entries to a list of SelectablePriceBookEntry based on the search term from search bar. 
                     This list is used to create the table
    Param          : 
    return         : List<SelectablePriceBookEntry>() searchedPbEntryList
    ********************************************************
    */
    public PageReference searchPbEntries() {
        searchedPbEntrylist = new List<SelectablePriceBookEntry>();

        // Search bar logic
        if (searchTerm != null && !String.isBlank(searchTerm)) {
            for (SelectablePriceBookEntry spbe : pbEntryList) {
                if(spbe.pbe.Name.toLowerCase().contains(searchTerm.toLowerCase())) {
                    searchedPbEntrylist.add(spbe);
                }
            }
        } else {
            searchedPbEntrylist = pbEntryList;
        }

        return null;
    }

    /*
    *********************************************************
    Method Name    : moveToReview
    Author         : Frank Berni
    Description    : tied to the Next button which will allow users to review all selected PBEs as Opp Line Items before saving them to Opportunity
    Param          : 
    return         : List<SelectablePriceBookEntry>() searchedPbEntryList
    ********************************************************
    */
    public PageReference moveToReview() {

        // Sets up a uniqueIdCounter to properly identify oppty line items in review
        Integer uniqueIdCounter = 0;
        Set<Id> selectedPbeIds = new Set<Id>();

        // Adding selected Ids to a set
        for (SelectablePriceBookEntry spbe : pbEntrylist) {
            if (spbe.selected) {
                System.debug('spbe.selected - ' + spbe.selected);
                // deselects the pricebook entry from the selection table to prevent users going back and accidentally adding duplicates
                spbe.selected = false;
                selectedPbeIds.add(spbe.pbe.Id);
            }
        }
        
        // querying all selectedPbes and their fields
        List<PricebookEntry> selectedPbeList = [
            SELECT Id, Product2Id, Name, IsActive, Business_Line__c, UnitPrice, ProductDescription__c, Product2.Description, ProductFamily__c
            FROM PricebookEntry
            WHERE Pricebook2Id =: oppPricebookId AND ProductFamily_Entry__c = true AND Id IN :selectedPbeIds
        ];

        System.debug('selectedPbeList - ' + selectedPbeList);
        System.debug('selectedPbeList.size() - ' + selectedPbeList.size());

        for (PricebookEntry pbe : selectedPbeList) {
            OpportunityLineItem oli = new OpportunityLineItem(
                OpportunityId = opp.Id,
                PricebookEntryId = pbe.Id,
                Quantity = 1,
                CPQ_Free_QTY__c = 0,
                Description = pbe.ProductDescription__c,
                UnitPrice = pbe.UnitPrice
            );

            // These oppty line items recieve the product name and uniqueIdCounter as separate class variables since the name and id won't be available during review
            oppLineItems.add(new OpportunityLineItemWrapper(oli, pbe.Name, 'item-' + uniqueIdCounter++));
        }

        System.debug('oppLineItems - ' + oppLineItems);
        System.debug('oppLineItems.size() - ' + oppLineItems.size());

        // Review step controls rendering of the product selection and line item review sections
        isReviewStep = true;
        System.debug('isReviewStep - ' + isReviewStep);

        return null;

    }

    /*
    *********************************************************
    Method Name    : moveToSelection
    Author         : Frank Berni
    Description    : Tied to back button - takes user back a step to the pricebook entry/ product selection
    Param          : 
    return         : List<SelectablePriceBookEntry>() searchedPbEntryList
    ********************************************************
    */
    public PageReference moveToSelection() {
        // rendering is set to false so it hides the line item review section and renders product selection table
        isReviewStep = false;
        return null;
    }

    /*
    *********************************************************
    Method Name    : cancel
    Author         : Frank Berni
    Description    : Tied to cancel button - takes user back to oppty record page
    Param          : 
    return         : PageReference oppPage
    ********************************************************
    */
    public PageReference cancel() { 
        PageReference oppPage = new PageReference('/' + opp.Id);
        oppPage.setRedirect(true);

        return oppPage;
    }

    /*
    *********************************************************
    Method Name    : saveOppLineItems
    Author         : Frank Berni
    Description    : Inserts the Pricebook Entries as Oppty Line Items and then brings the user back to Oppty's Products Page
    Param          : 
    return         : PageReference oppPage
    ********************************************************
    */
    public PageReference saveOppLineItems() {
        List<OpportunityLineItem> itemsToInsert = new List<OpportunityLineItem>();

        // loops through all wrapper line items and adds the opp line item to a list to be inserted
        for (OpportunityLineItemWrapper wrapper : oppLineItems) {
            itemsToInsert.add(wrapper.opportunityLineItem);
        }

        System.debug('itemsToInsert - ' + itemsToInsert);

        insert itemsToInsert;

        // build page ref to oppty's record page to direct user
        PageReference oppPage = new PageReference('/' + opp.Id);
        oppPage.setRedirect(true);

        return oppPage;
    }

    /*
    *********************************************************
    Method Name    : removeLineItem
    Author         : Frank Berni
    Description    : tied to each line item row's remove button - removes line item from table
    Param          : 
    return         : 
    ********************************************************
    */
    // 
    public void removeLineItem() {
        // The uniqueId built for each oli wrapper item gets called from that row
        String uniqueId = ApexPages.currentPage().getParameters().get('uniqueId');
        System.debug('uniqueId - ' + uniqueId);

        for(OpportunityLineItemWrapper wrapper : oppLineItems) {
            // Find matching Id in List
            if(wrapper.uniqueId == uniqueId) {
                // Find the lineItems index
                Integer lineIndex = oppLineItems.indexOf(wrapper);
                System.debug('lineIndex - ' + lineIndex);

                // Use its index to then remove it from the list
                oppLineItems.remove(lineIndex);
                System.debug('Item removed from list');

                break;
            }
        }
        
    }

}