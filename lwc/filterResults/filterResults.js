/********** PlaceorderfilterData this for place order component********** sprint 4 cleanup*****/
/*********** helper Js  for P&A , Place order and related details pages */
import { LightningElement, wire, track, api } from 'lwc';
export function placeorderFilterData(data, searchTerm) {
    console.log(data,'data from placeorderFilterData>>>');
    const searchTerms = searchTerm.toLowerCase().trim().split(/\s+/); // Split search term by spaces
    const filteredData = data.filter(item => {
        // Check if item has productDetails
        if (!item.productDetails) {
            return false; // Skip this item if productDetails is undefined
        }
        // Extract productDetails
        const details = item.productDetails;

        // Access properties of productDetails using optional chaining and nullish coalescing
        const itemName = (details.Title_Description ?? '').toLowerCase().trim();
        const itemISBN = (details.ISBN ?? '').toLowerCase().trim();
        const itemGradeLevel = (details.Grade_Level ?? '').toLowerCase().trim();
        const itemStatus = (details.Status ?? '').toLowerCase().trim();
        const itemType = (details.Type ?? '').toLowerCase().trim();
         const itemYear = (details.Copyright ?? '').toLowerCase().trim();
        // Convert searchTerm to lowercase for case-insensitive matching
        const searchTermLower = searchTerm.toLowerCase().trim();
     return searchTerms.some(term =>
            itemName.includes(term) ||
            itemISBN.includes(term) ||
            itemGradeLevel.includes(term) ||
            itemStatus.includes(term) ||
            itemYear.includes(term) ||
            itemType.includes(term)
        );
    });
    console.log('filteredData from placeorderFilterData>>>',filteredData);
   // console.log('Number of filtered records:', filteredData.length);
    //console.log('filteredData:', filteredData);
    return filteredData; // Return the filtered data
}

/********** filterData this for product order component********** sprint 4 cleanup *****/

export function filterData(data, searchTerm) {
    console.log(data,'data from filterData>>>');
    const searchTerms = searchTerm.toLowerCase().trim().split(/\s+/); // Split search term by spaces
    const filteredData = data.filter(item => {              
        const itemName = item.Description ? item.Description.toLowerCase().trim() : '';
        const itemISBN = item.ISBN10__c ? item.ISBN10__c.toLowerCase().trim() : '';
        const itemGradeLevel = item.Grade_Level__c ? item.Grade_Level__c.toLowerCase().trim() : '';
        const itemStatus = item.Product_Status__c? item.Product_Status__c.toLowerCase().trim() : '';
        const itemType = item.Product_Sub_Type__c ? item.Product_Sub_Type__c.toLowerCase().trim() : '';
         const itemISBN13 = item.ISBN13__c ? item.ISBN13__c.toLowerCase().trim() : '';

        // Check if any of the properties match any search term
        return searchTerms.some(term =>
            itemName.includes(term) ||
            itemISBN.includes(term) ||
            itemGradeLevel.includes(term) ||
            itemStatus.includes(term) ||
            itemISBN13.includes(term) ||
            itemType.includes(term)
        );
    });
   
    return filteredData; // Return the filtered data
}
/********** filterData this for product order component**********  futuer sprint  cleanup *****/
export function filterDatarealtedProducts(data, searchTerm) {
    console.log(data,'data from filterDatarealtedProducts>>>');
    const searchTerms = searchTerm.toLowerCase().trim().split(/\s+/); // Split search term by spaces
    const filteredData = data.filter(item => {
        // Convert each property value to lowercase and trim leading/trailing spaces
        const itemName = item.Title_Description ? item.Title_Description.toLowerCase().trim() : '';
        const itemISBN = item.ISBN ? item.ISBN.toLowerCase().trim() : '';
        const itemGradeLevel = item.Grade_Level ? item.Grade_Level.toLowerCase().trim() : '';
        const itemStatus = item.Status ? item.Status.toLowerCase().trim() : '';
        const itemType = item.Type ? item.Type.toLowerCase().trim() : '';

        // Check if any of the properties match any search term
        return searchTerms.some(term =>
            itemName.includes(term) ||
            itemISBN.includes(term) ||
            itemGradeLevel.includes(term) ||
            itemStatus.includes(term) ||
            itemType.includes(term)
        );
    });

    return filteredData; // Return the filtered data
}