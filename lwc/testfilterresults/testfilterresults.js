export function filterData(data, searchTerm) {
    const searchTerms = searchTerm.toLowerCase().trim().split(/\s*,\s*/); // Split search term by commas and trim whitespace

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

        // Convert searchTerm to lowercase for case-insensitive matching
         const searchTermLower = searchTerm.toLowerCase().trim();
        // const searchTermLower = searchTerms.map(term => term.toLowerCase().trim());
        // Check if any of the properties match the search term
        //const matchesSearchTerm = itemName.includes(searchTermLower) || 
        const matchesSearchTerm = itemName.some(item => searchTermLower.includes(item)) ||
// added or condition includes
        itemISBN.includes(searchTermLower)||
        itemGradeLevel.includes(searchTermLower)||
        itemStatus.includes(searchTermLower)||
        itemType.includes(searchTermLower);

        return matchesSearchTerm;
    });

    console.log('Number of filtered records:', filteredData.length);
    console.log('filteredData:', filteredData);
    return filteredData; // Return the filtered data
}