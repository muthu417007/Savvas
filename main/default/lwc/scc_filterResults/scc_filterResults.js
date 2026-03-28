//this method used for Place order Tab  (single and multi and catalog )in  basis of js structure it will  be implemented 
import { LightningElement, wire, track, api } from 'lwc';
export function filterDatarealtedProducts(data, searchTerm) {
    const searchTerms = searchTerm
        .toLowerCase()
        .trim()
        .replace(/\s+/g, ' '); 

    const filteredData = data.filter(item => {
        // Normalize the data fields by removing extra spaces and converting to lowercase
        const itemName = item.Title_Description
            ? item.Title_Description.toLowerCase().replace(/\s+/g, ' ').trim()
            : '';
        const itemISBN = item.ISBN
            ? item.ISBN.toLowerCase().trim()
            : '';
        const itemGradeLevel = item.Grade_Level
            ? item.Grade_Level.toLowerCase().replace(/\s+/g, '').trim()
            : ''; // Remove spaces for Grade Level
        const itemStatus = item.Status
            ? item.Status.toLowerCase().trim()
            : '';
        const itemType = item.Type
            ? item.Type.toLowerCase().trim()
            : '';
        const itemCopyright = item.Copyright
            ? item.Copyright.toLowerCase().trim()
            : '';

        // Check if the search term matches exactly with grade-related fields
        const exactGradeMatch = itemGradeLevel === searchTerms;

        // Partial match: Check if the search term is present in any field
        const partialMatch = itemName.includes(searchTerms) ||
            itemISBN.includes(searchTerms) ||
            itemGradeLevel.includes(searchTerms) ||
            itemStatus.includes(searchTerms) ||
            itemType.includes(searchTerms) ||
            itemCopyright.includes(searchTerms);

        // Return true if either exact grade match or partial match
        return exactGradeMatch || partialMatch;
    });

    return filteredData;
}
//this method used for Place order related products // basis of  data strutre and variables it was implemented 
export function filterData(data, searchTerm) {
 
    const searchTerms = searchTerm
        .toLowerCase()
        .trim()
        .replace(/\s+/g, ' '); 
       const filteredData = data.filter(item => {
        // Normalize the data fields by removing extra spaces and converting to lowercase
        const itemName = item.Description
            ? item.Description.toLowerCase().replace(/\s+/g, ' ').trim()
            : '';
        const itemISBN = item.ISBN10
            ? item.ISBN10.toLowerCase().trim()
            : '';
        const itemGradeLevel = item.Grade_Level
            ? item.Grade_Level.toLowerCase().replace(/\s+/g, '').trim()
            : ''; // Remove spaces for Grade Level
        const itemStatus = item.Product_Status
            ? item.Product_Status.toLowerCase().trim()
            : '';
        const itemType = item.Product_Sub_Type
            ? item.Product_Sub_Type.toLowerCase().trim()
            : '';
             
        const itemCopyright = item.Copyright_Year
            ? item.Copyright_Year.toLowerCase().trim()
            : '';     
       const itemISBN13 = item.ISBN13
            ? item.ISBN13.toLowerCase().trim()
            : '';
        // Check if any of the properties match any search term
      const exactGradeMatch = itemGradeLevel === searchTerms;

        // Partial match: Check if the search term is present in any field
        const partialMatch = itemName.includes(searchTerms) ||
            itemISBN.includes(searchTerms) ||
            itemGradeLevel.includes(searchTerms) ||
            itemStatus.includes(searchTerms) ||
            itemType.includes(searchTerms) ||
            itemISBN13.includes(searchTerms) ||
            itemCopyright.includes(searchTerms);

        // Return true if either exact grade match or partial match
        return exactGradeMatch || partialMatch;
    });

    return filteredData;

}
 
export function placeorderFilterData(data, searchTerm) {
  
    const searchTerms = searchTerm
        .toLowerCase()
        .trim()
        .replace(/\s+/g, ' '); 
        const filteredData = data.filter(item => {
        if (!item.productDetails) {
            return false; // Skip this item if productDetails is undefined
        }
        // Extract productDetails
        const details = item.productDetails;
        
        const itemName = details.Title_Description
            ? details.Title_Description.toLowerCase().replace(/\s+/g, ' ').trim()
            : '';
        const itemISBN = details.ISBN
            ? details.ISBN.toLowerCase().trim()
            : '';
        const itemGradeLevel = details.Grade_Level
            ? details.Grade_Level.toLowerCase().replace(/\s+/g, '').trim()
            : ''; // Remove spaces for Grade Level
        const itemStatus = details.Status
            ? details.Status.toLowerCase().trim()
            : '';
        const itemType = details.Type
            ? details.Type.toLowerCase().trim()
            : '';
             
        const itemCopyright = details.Copyright
            ? details.Copyright.toLowerCase().trim()
            : '';     
      
        // Check if any of the properties match any search term
      const exactGradeMatch = itemGradeLevel === searchTerms;

        // Partial match: Check if the search term is present in any field
        const partialMatch = itemName.includes(searchTerms) ||
            itemISBN.includes(searchTerms) ||
            itemGradeLevel.includes(searchTerms) ||
            itemStatus.includes(searchTerms) ||
            itemType.includes(searchTerms) ||
            
            itemCopyright.includes(searchTerms);

        // Return true if either exact grade match or partial match
        return exactGradeMatch || partialMatch;
    });

    return filteredData;
}