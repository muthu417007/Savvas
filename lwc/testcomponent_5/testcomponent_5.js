import { LightningElement,track,wire,api } from 'lwc';
        import populateSearchResults from '@salesforce/apex/scc_PlaceOrderMultiISBN_SearchController.populateSearchResults';
        export default class Testcomponent_5 extends LightningElement {

            @track isSearchDisabled = true;
                @track recordIds = [];
                @track quantities = [];
                  @track searchResults = [];
                  @track numberOfRecordsToShow = 15;
                  @track moreRecordsAvailable=false;
                  @track pageNumber=1;
                  @track pageSize=15;
                  @track searchResultsToShow=[];
               
                    @track selectedItemCount = '';
              @track iscartDisabled= true;
                  @track isReviewCart= true;
                  @track productQuantityMap;
                  @track newQuantity;
                    @track originalIndex
                  @track isSelecthDisabled=false;
                    @track showProductTitlePage=false;
                    @track showsearchresult=false;
                    @track displayText = false;
                    infoText = 'Search by pasting one or more ISBNs';
                        @track selectedProductRecord
                        @ track selectedItems=[];
                  constructor() {
    super();
    this.productQuantityMap = {};
}
get AddtoCart() {
        return `Add to Selected  (${this.selectedItemCount}) to Cart`;
    }
    handleInputChange(event) {
        
            const input = String(event.target.value).trim();
            console.log('Input:', input);

            const lines = input.split('\n'); // Split the input into lines
            console.log('Lines:', lines);

            // Initialize arrays to store record IDs and quantities
            this.recordIds = [];
            this.quantities = [];

            // Process each line of input
            lines.forEach(line => {
                const parts = line.trim().split(/\s+/); // Split each line based on any whitespace characters
                if (parts.length === 2) {
                    // If there are exactly two parts (record ID and quantity), add them to the arrays
                    this.recordIds.push(parts[0]);
                    this.quantities.push(parseInt(parts[1], 10));
                }
            });

            console.log('Record IDs:', this.recordIds);
            console.log('Quantities:', this.quantities);

            // Enable the search button if there's at least one valid record ID and quantity pair
            this.isSearchDisabled = !(this.recordIds.length > 0 && this.recordIds.length === this.quantities.length);
            console.log('Search button disabled:', this.isSearchDisabled);
        }

     
//  get isAnyDisabled() {
   
//    return this.searchResultsToShow.some(item => item.isDisabled);
// }
    handleClear() {
        this.recordIds = '';
        this.searchResults = [];
        this.isSearchDisabled = true;
        this.searchResultsToShow='';
        this.moreRecordsAvailable=false;
        this.showsearchresult= false;
            this.numberOfRecordsToShow = 15; 
        const textAreaInput = this.template.querySelector('.text-area-inputchange textarea');
        if (textAreaInput) {
            textAreaInput.value = '';
        }
    }
    
handleLoadMore() {
         this.displayNextBatch();
    }
    displayNextBatch() {
        console.log('ntered');
        const endIndex = Math.min(this.searchResults.length, this.numberOfRecordsToShow);
 console.log('endIndex',endIndex);
        this.numberOfRecordsToShow += 15;
         console.log('  this.numberOfRecordsToShow',  this.numberOfRecordsToShow);
        this.searchResultsToShow = this.searchResults.slice(0, endIndex);
          console.log('   this.searchResultsToShow',  this.numberOfRecordsToShow);
        this.moreRecordsAvailable = endIndex < this.searchResults.length;
          console.log('     this.moreRecordsAvailable',  this.numberOfRecordsToShow);
    }
    handleSearch() {
    console.log('Searching...');
    console.log('Record IDs:', this.recordIds); // Log the recordIds being used for the search

    if (this.recordIds.length > 0) {
        populateSearchResults({ recordIds: this.recordIds })
            .then(result => {
                console.log('Processed Search Results:', result); // Log the processed search results
                
                // Set searchResults to the fetched records
                this.searchResults = result.map((record, index) => {
                    console.log('Record:', record); // Log the current record being processed
                    return {
                        ...record.product,
                        quantity: this.quantities[index],
                        productid: record.productId,
                        isbnToDisplay: record.isbnToDisplay ? record.isbnToDisplay : this.getIsbnToDisplay(record.product),
                        disableCheckbox: record.disableCheckbox,
                        description: record.description,
                        gradeLevel: record.gradeLevel,
                        ProductSubType: record.ProductSubType,
                        ProductStatus: record.ProductStatus,
                        Copyrightyear: record.Copyrightyear,
                        Price:record.price

                    };
                });
                
                console.log('Number of search results:', this.searchResults.length);
                if (this.recordIds.length === 1) {
                  
                    const selectedISBN = this.searchResults[0].isbnToDisplay;
                    console.log('Selected ISBN:', selectedISBN); // Log the selected ISBN
                    this.dispatchShowProductTitlePageEvent(selectedISBN);
                    this.showProductTitlePage = true;
                } else {
                    // If more than one record ID provided, set a flag to indicate showing search results
                    this.showsearchresult = true;
                    console.log('Number of search results:', this.searchResults);
                    console.log('Number of records to show:', this.numberOfRecordsToShow);
                    this.searchResultsToShow = this.searchResults.slice(0, 15);
                    
                    // Determine if more records are available for pagination
                    if (this.searchResults.length > this.numberOfRecordsToShow) {
                        this.moreRecordsAvailable = true;
                    } else {
                        this.moreRecordsAvailable = false;
                    }

                    console.log('More records available:', this.moreRecordsAvailable);

                    // Display the first 15 records
                    this.displayNextBatch();
                }
            })
            .catch(error => {
                console.error('Error occurred while fetching search results:', error); // Log any errors that occur during the search          
            });
    } else {
        console.log('No record IDs provided.'); // Log if no record IDs are provided
    }
}

   /* handleChange(event) {
    const index = event.target.dataset.index;
    console.log(index);
    const newQuantity = parseInt(event.target.value, 10);
 console.log(newQuantity);
    // Update the quantity in the searchResultsToShow array
    this.searchResultsToShow[index].quantity = newQuantity;

 console.log( 'unatiti',this.searchResultsToShow[index].quantity);
    // Optional: You can also update the corresponding record in the searchResults array if needed
  const originalIndex = this.searchResultsToShow[index].originalIndex;
     console.log(originalIndex);
   this.searchResults[originalIndex].quantity = newQuantity;
      console.log(newQuantity);
     //console.log(this.quantities);
}*/
//@track index;

/*handleChange(event) {
    const index = event.target.dataset.index;
    this.newQuantity = parseInt(event.target.value, 10);

   
    console.log('Updating quantity for index:', index);
    console.log('New quantity:', this.newQuantity);


    if (this.searchResultsToShow[index]) {
        this.searchResultsToShow[index].quantity = this.newQuantity;

     
        console.log('Updated quantity in searchResultsToShow:', this.searchResultsToShow[index].quantity);
        console.log('Original index:', this.newQuantity);
       
       
      
        
    }
}*/

/*//update code
handleChange(event) {
    const index = event.target.dataset.index;
    const productId = this.searchResultsToShow[index].productid; // Get the product ID
    this.newQuantity = parseInt(event.target.value, 10);

    if (this.searchResultsToShow[index]) {
        this.searchResultsToShow[index].quantity = this.newQuantity;
         this.productQuantityMap[productId] = this.newQuantity;
        console.log('Product ID quantity:', this.newQuantity);
        // Now you have the product ID and the new quantity associated with it
        console.log('Product ID:', productId);
        console.log('New quantity:', this.newQuantity);
    }
}*/
      handleChange(event) {
    const index = event.target.dataset.index;
    const productId = this.searchResultsToShow[index].productid; // Get the product ID
    const newQuantity = parseInt(event.target.value, 10);

    if (this.searchResultsToShow[index]) {
        // Update the quantity in the displayed table data
        this.searchResultsToShow[index].quantity = newQuantity;

        // Update the quantity in the productQuantityMap
        this.productQuantityMap[productId] = newQuantity;

        // Check if the item is selected
        const selectedItem = this.selectedItems.find(item => item.productid === productId);
        if (selectedItem) {
            // Update the quantity of the selected item
            selectedItem.quantity = newQuantity;
        }

        // Log the updated quantity and the selected items array
        console.log('Product ID:', productId);
        console.log('New Quantity:', newQuantity);
        console.log('Selected Items after updating quantity:', this.selectedItems);
        console.log('Quantity updated for product:', productId);
    }
}


handleIconClick(){
    
}
   
handleISBNClick(event) {
   event.preventDefault(); 
    const selectedISBN = event.target.dataset.isbn;
    console.log('Selected ISBN:', selectedISBN); 
    this.dispatchShowProductTitlePageEvent(selectedISBN);
    this.showProductTitlePage = true;
}
dispatchShowProductTitlePageEvent(selectedISBN) {
    const selectedItem = this.searchResults.find(item => item.isbnToDisplay === selectedISBN);
    console.log('Selected Item:', selectedItem); 
    if (selectedItem) {
        this.selectedProductRecord = {
            productId: selectedItem.Id,
            Title_Description: selectedItem.description,
            Grade_Level: selectedItem.gradeLevel,
            Copyright: selectedItem.Copyrightyear,
            Status: selectedItem.ProductStatus,
            Type: selectedItem.ProductSubType,
            Price:selectedItem.Price,
            ISBN:selectedItem.isbnToDisplay
            
        };  
        console.log('selectedProductRecord:', this.selectedProductRecord);

        // Dispatch the event with the selected product record
        const selectEvent = new CustomEvent('showproducttitlepage', {
            detail: {
                parentSelectedProductRecord: this.selectedProductRecord
            }
        });
        this.dispatchEvent(selectEvent);
        console.log('Current Selected Product selectEvent:', selectEvent);
    }
}




//     handleCheckboxChange(event) {
//     const index = event.target.dataset.index;
//     const isChecked = event.target.checked;

//     // Get the item corresponding to the checkbox
//     const selectedItem =this.searchResults[index];
// console.log(selectedItem,'selected');
//     // Update selectedItemCount based on the checkbox state
//     if (isChecked) {
//         this.selectedItemCount++;
//         this.iscartDisabled = false;
//  console.log( this.selectedItems,' bforepush');
//         // Push the selected item into the selectedItems array
//         this.selectedItems.push(selectedItem);
//         console.log( this.selectedItems,' Aftrpush');
//     } else {
//         this.selectedItemCount--;

//         // Remove the unselected item from the selectedItems array
//         const itemIndex = this.selectedItems.findIndex(item => item.id === selectedItem.id);
//         if (itemIndex !== -1) {
//             this.selectedItems.splice(itemIndex, 1);
//             console.log(this.selectedItems,'After remove');
//         }
//     }

//     // Update the add to cart button state
//     this.updateAddToCartButtonState();
// }

handleCheckboxChange(event) {
    const index = event.target.dataset.index;
    const isChecked = event.target.checked;

    // Get the item corresponding to the checkbox
    const selectedItem = { ...this.searchResults[index] }; // Copy the selected item
    console.log(selectedItem, 'selected');

    // Update selectedItemCount based on the checkbox state
    if (isChecked) {
        this.selectedItemCount++;
        this.iscartDisabled = false;
        console.log(this.selectedItems, 'before push');

        // Push the selected item into the selectedItems array
        this.selectedItems.push(selectedItem);
        console.log(this.selectedItems, 'After push');
    } else {
        this.selectedItemCount--;

        // Remove the unselected item from the selectedItems array
        const itemIndex = this.selectedItems.findIndex(item => item.id === selectedItem.id);
        if (itemIndex !== -1) {
            this.selectedItems.splice(itemIndex, 1);
            console.log(this.selectedItems, 'After remove');
        }
    }
}



updateAddToCartButtonState() {
    // Disable the button when no items are selected
    this.iscartDisabled = this.selectedItemCount === 0;
}
handleMouseOver(){
  this.displayText = true;
}
handleMouseLeave(){
    this.displayText = false;
}
        }