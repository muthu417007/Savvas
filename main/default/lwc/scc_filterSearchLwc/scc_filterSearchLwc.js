export function filterDatarelatedProducts(data, searchTerm) {

    console.log('Search Term:', searchTerm); 

    const searchTerms = searchTerm.toLowerCase().trim().split(/\s+/).map(term => term.replace(/[-\s]/g, '')); // Clean search terms

    console.log('Search Terms Array:', searchTerms); // Log the array of cleaned search terms

    const filteredData = data.filter(item => {
       const itemName = item.Title_Description ? item.Title_Description.toLowerCase().trim() : '';
        const itemISBN = item.ISBN ? item.ISBN.toLowerCase().trim().replace(/[-\s]/g, '') : ''; // Clean ISBN
        const itemGradeLevel = item.Grade_Level ? item.Grade_Level.toLowerCase().trim() : '';
        const itemStatus = item.Status ? item.Status.toLowerCase().trim() : '';
        const itemType = item.Type ? item.Type.toLowerCase().trim() : '';
        const itemYear = item.Copyright ? item.Copyright.toLowerCase().trim() : '';

        // Log the item properties for debugging

        console.log('Current Item Details:', {

            'Title_Description': itemName,

            'ISBN': itemISBN,

            'Grade_Level': itemGradeLevel,

            'Status': itemStatus,

            'Type': itemType,

            'Year': itemYear

        });

        // Define matching logic based on search terms

        const matches = searchTerms.every(term => {

            if (/^\d{4}$/.test(term)) { 

                // If term is a 4-digit number, treat it as a year and search in the Year field

                console.log(`Checking for Year: ${term}`);

                return itemYear.includes(term);

            } else if (/^\d{5,}$/.test(term)) {

                // If the term is more than 5 digits, treat it as an ISBN

                console.log(`Checking for ISBN: ${term}`);

                return itemISBN.includes(term);

            } else {

                // Otherwise, check in Description, Status, and Type fields

                console.log(`Checking for Text/Number Combo in Description, Status, Type: ${term}`);

                return (

                    itemName.includes(term) ||

                    itemStatus.includes(term) ||

                    itemType.includes(term)

                );

            }

        });

        console.log('Match Found:', matches); // Log if a match was found

        return matches;

    });

    // Log the number of filtered records and the filtered data

    console.log('Number of filtered records:', filteredData.length);

    console.log('Filtered Data:', filteredData);

    return filteredData; // Return the filtered data

}