import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getCategoryProductsByCategory from '@salesforce/apex/CpqProductSelectionCtrl.getCategoryProductsByCategory';
import getCategoryProductsBySearchTerm from "@salesforce/apex/CpqProductSelectionCtrl.getCategoryProductsBySearchTerm";
import insertSelectedProducts from '@salesforce/apex/CpqProductSelectionCtrl.insertSelectedProducts';
import { refreshApex } from '@salesforce/apex';

export default class CpqProductList extends NavigationMixin(LightningElement) {
    
    @track error;
    // Controls spinner visibility
    @track isLoaded = false;
    intervalId;
    
    // Variables inherited from parent components
    @api recordId;
    @api categoryIds;
    @api termSearch;
    
    // Using ProductCategoryProduct object since it is the junction object between ProductCategory and Product2
    @track categoryProducts;
    @track showCategoryProducts = true;

    // Used for Apex method
    // @track selectedCatProducts = [];
    // updated to empty object
    @track selectedCatProducts = {};
    @api showProductCart;

    @track filters = {
        Audience: '',
        Product_Sub_Type: '',
        Program_Series: '',
        // W-016058 replace Grade_Band with Grade_Level
        Grade_Level: '',
        Solution_Type: '',
        Duration: '',
        Copyright_Year: '',
        // Default Net_Price before Products get loaded in
        Net_Price: 0,
    }
    // Ticket W-014516: Holds our filtered array of returned products
    @track categoryProductsFiltered = [];

    // pagination variables
    @track paginatedProducts;
    @track currentPage = 1;
    @track pageSize;
    @track totalPages = 0;
    pageSizeOptions = [10, 25, 50, 75, 100];
    @track totalProducts = 0;

    // Ticket W-014516: Holds our picklist field options for comboboxes
    @track audienceOptions = [];
    @track productSubTypeOptions = [];
    @track programSeriesOptions = [];
    // W-016058 replace gradeBandOptions with gradeLevelOptions
    @track gradeLevelOptions = [];
    @track solutionTypeOptions = [];
    @track durationOptions = [];

    // class variable for currencyIsoCode
    @track quoteCurrencyIsoCode;

    // FB-134: getter for isAllSelected to conditionally check the Select All checkbox based on the current page
    get isAllSelected() {
        // Uses optional chaining (?.) to check whether this current array exists. If it doesn't exist then expression returns undefined w/o throwing error
        return (this.selectedCatProducts[this.currentPage]?.length === this.paginatedProducts.length);
    }

        // grabs the maximum Net Price for the Price slider
    get maxNetPriceValue() {
        // changed to catProduct.netPrice
        let maxPrice = Math.max(...this.categoryProducts.map(catProduct => parseFloat(catProduct.netPrice)));

        // sets Max Price so it rounds up the next increment of 10
        maxPrice = Math.ceil(maxPrice / 10) * 10;

        return maxPrice;
    }

    // modifies look of net price for label
    get maxNetPriceLabel() {
        let maxPrice = Math.max(...this.categoryProducts.map(catProduct => parseFloat(catProduct.netPrice)));

        // sets Max Price so it rounds up the next increment of 10
        maxPrice = Math.ceil(maxPrice / 10) * 10;

        let formattedMaxPrice = this.formatNetPriceCurrency(maxPrice, this.quoteCurrencyIsoCode);
        return formattedMaxPrice;
    }

    // keep formatting consistent with minimum net price
    get minNetPrice() {
        return this.formatNetPriceCurrency(0, this.quoteCurrencyIsoCode);
    }

    // keep formatting consistent with selected filtered price
    get filteredNetPrice() {
        return this.formatNetPriceCurrency(this.filters.Net_Price, this.quoteCurrencyIsoCode);
    }

    // if Max Net Price is 0 or not a number hide it
    get hideSlider() {
        if (!this.maxNetPriceValue || this.maxNetPriceValue === 0) {
            return true;
        } else {
            return false;
        }
    }

    // dynamic No Product Results based on type of search
    get noProductsReturnedMsg() {
        let message = 'No Available Products for this Category';
        if (this.termSearch) {
            message = 'No Available Products matching "' + this.termSearch + '"'; 
        }
        return message;
    }

    // controls disable of previous button, turns true if user's currentPage is 1
    get disablePrevious() {
        let status = false;
        if (this.currentPage === 1) {
            status = true;
        }
        return status;
    }

    // controls disable of next button, turns true if user's currentPage is the last page
    get disableNext() {
        let status = false;
        if (this.currentPage === this.totalPages) {
            status = true;
        }
        return status;
    }


    // on Load - renders the ProductList depending on what variables are available
    connectedCallback() {
        // console.log('renderedCallback ProductList');
        // console.log('this.categoryIds', this.categoryIds);
        // console.log('this.termSearch', this.termSearch);

        // Setting priority for which function is used based on data existing
        if (this.termSearch) {
            // console.log('Search Term detected fetching Products');
            this.fetchProductsbySearchTerm();
        }
        // updated condition to check that length of categoryIds is more than 0
        else if (this.termSearch && this.categoryIds.length > 0) {
            // console.log('Category Id and Search Term prioritizing fetching Products by Search Term');
            this.fetchProductsbySearchTerm();
        } 
        // updated condition to check that length of categoryIds is more than 0
        else if (this.categoryIds.length > 0) {
            // console.log('Category Id detected fetching Products');
            this.fetchProductsbyCategory();
        }

        // Keep spinner running until categoryProducts are loaded 
        this.intervalId = setInterval(this.checkCondition.bind(this), 100);
        
    }

    /*
    *********************************************************
    Function Name  : updateProductSelectionStatus
    Author         : Frank Berni
    Description    : FB-134: Keeps track of what products have been selected across each page and keeps their checkbox checked or not
    Param          : getCategoryProductsByCategory(categoryId, recordId)
    return         : categoryProducts and showCategoryProducts
    ********************************************************
    */
     updateProductSelectionStatus() {
        const selectedProductsOnPage = this.selectedCatProducts[this.currentPage] || [];
        this.paginatedProducts = this.paginatedProducts.map(catProduct => {
            return { 
                ...catProduct,
                selected: selectedProductsOnPage.includes(catProduct.id)
            };
        });
    }

    /*
    *********************************************************
    Function Name  : fetchProductsbyCategory
    Author         : Frank Berni
    Description    : Uses category Id chosen by user to return a list of products that match it
    Param          : getCategoryProductsByCategory(categoryId, recordId)
    return         : categoryProducts and showCategoryProducts
    ********************************************************
    */
    fetchProductsbyCategory() {
        // updated variable name to match apex parameter
        getCategoryProductsByCategory({
            categoryIds: this.categoryIds,
            recordId: this.recordId
        })
        .then((data) => {
            if (data) {
                // isbn property to holds ProductCode as a string and adds leading zeroes to any code less than 13 digits
                this.categoryProducts = data.map(catProduct => ({ 
                    ...catProduct, 
                    selected: false, 
                    isbn: this.padProductCode(catProduct.productCode),
                    // formatted netPrice based on currency
                    netPriceFormatted: this.formatNetPriceCurrency(catProduct.netPrice, catProduct.currencyCode) 
                }));
                
                // Making sure Filtered array has initial products
                this.categoryProductsFiltered = [...this.categoryProducts];
                // console.log('Returned Products');
                console.log(this.categoryProducts);
                console.log(JSON.stringify(this.categoryProducts));
                // console.log('showProductCart categorySearch', this.showProductCart);

                // Controls rendering of Category Product List
                if(this.categoryProducts.length > 0) {
                    this.showCategoryProducts = true;
                    // assigning currencyCode from Products to it is accessible for other functions
                    this.quoteCurrencyIsoCode = this.categoryProducts[0].currencyCode;
                    // changed variable refs based on ProductTableData values
                    // Ticket W-014516: accounts for any unique picklist values that don't exist as default pl options
                    this.addUniqueFieldValuesToOptions('audience', 'audienceOptions');
                    this.addUniqueFieldValuesToOptions('productSubType', 'productSubTypeOptions');
                    this.addUniqueFieldValuesToOptions('programSeries', 'programSeriesOptions');
                    // W-016058 replace gradeBandOptions with gradeLevelOptions
                    this.addUniqueFieldValuesToOptions('gradeLevel', 'gradeLevelOptions');
                    this.addUniqueFieldValuesToOptions('solutionType', 'solutionTypeOptions');
                    this.addUniqueFieldValuesToOptions('duration', 'durationOptions', true);
                    // variable change
                    // setting Max Net Price for slider
                    this.filters.Net_Price = this.maxNetPriceValue;
                    this.pageSize = this.pageSizeOptions[0];
                    this.totalProducts = this.categoryProducts.length;

                    // activates filters as soon as products are available
                    this.applyFilters();
                } else {
                    this.showCategoryProducts = false;
                }
            }
        })
        .catch((error) => {
            if(error) {
                console.log('error: ' + error);
                if (Array.isArray(error.body)) {
                    this.error = error.body.map(e => e.message).join(', ');
                } else if (error.body && typeof error.body.message === 'string') {
                    this.error = error.body.message;
                } else if(typeof error === 'string'){
                    this.error = error;
                }
                this.template.querySelector('c-cpq-toast').showToast('error', 'Error finding Products:', this.error);
                console.log('Error getCategoryProductsByCategory: ', JSON.stringify(this.error));
            }
        }) 
    }

    /*
    *********************************************************
    Function Name  : fetchProductsbySearchTerm
    Author         : Frank Berni
    Description    : Uses Product.ProductCode (ISBN) or Product.Description search term to return a list of products that match it
    Param          : getCategoryProductsBySearchTerm(searchString, recordId)
    return         : categoryProducts and showCategoryProducts
    ********************************************************
    */
    fetchProductsbySearchTerm() {
        getCategoryProductsBySearchTerm({
            searchString: this.termSearch,
            recordId: this.recordId
        })
        .then((data) => {
            if (data) {
                console.log('data:', JSON.stringify(data));

                // isbn property to holds ProductCode as a string and adds leading zeroes to any code less than 13 digits
                this.categoryProducts = data.map(catProduct => ({ 
                    ...catProduct, 
                    selected: false, 
                    isbn: this.padProductCode(catProduct.productCode),
                    // formatted netPrice based on currency
                    netPriceFormatted: this.formatNetPriceCurrency(catProduct.netPrice, catProduct.currencyCode) 
                }));
                // making sure Filtered array has initial products
                this.categoryProductsFiltered = [...this.categoryProducts];
                
                
                // console.log('Returned Products');
                // console.log(JSON.stringify(this.categoryProducts));
                // console.log('showProductCart termSearch', this.showProductCart);

                // Controls rendering of Category Product List
                if(this.categoryProducts.length > 0) {
                    this.showCategoryProducts = true;
                    // assigning currencyCode from Products to it is accessible for other functions
                    this.quoteCurrencyIsoCode = this.categoryProducts[0].currencyCode;
                    // changed variable refs based on ProductTableData values
                    // accounting for any unique picklist values that don't exist as default options
                    this.addUniqueFieldValuesToOptions('audience', 'audienceOptions');
                    this.addUniqueFieldValuesToOptions('productSubType', 'productSubTypeOptions');
                    this.addUniqueFieldValuesToOptions('programSeries', 'programSeriesOptions');
                    // W-016058 replace gradeBandOptions with gradeLevelOptions
                    this.addUniqueFieldValuesToOptions('gradeLevel', 'gradeLevelOptions', true);
                    this.addUniqueFieldValuesToOptions('solutionType', 'solutionTypeOptions');
                    this.addUniqueFieldValuesToOptions('duration', 'durationOptions', true);
                    // variable change
                    // setting Max Net Price for slider
                    this.filters.Net_Price = this.maxNetPriceValue;
                    this.pageSize = this.pageSizeOptions[0];
                    this.totalProducts = this.categoryProducts.length;

                    // activates filters as soon as products are available
                    this.applyFilters();
                } else {
                    this.showCategoryProducts = false;
                }
            }
        })
        .catch((error) => {
            if(error) {
                console.log('error: ' + error);
                if (Array.isArray(error.body)) {
                    this.error = error.body.map(e => e.message).join(', ');
                } else if (error.body && typeof error.body.message === 'string') {
                    this.error = error.body.message;
                } else if(typeof error === 'string'){
                    this.error = error;
                }
                this.template.querySelector('c-cpq-toast').showToast('error', 'Error finding Products:', this.error);
                console.log('Error getCategoryProductsByCategory: ', JSON.stringify(this.error));
            }
        }) 
    }

    /*
    *********************************************************
    Function Name  : selectAllCategoryProducts
    Author         : Frank Berni
    Description    : tied to the checkbox header column. Selects all category product Ids in the table and adds them to selectedCatProducts
    Param          : event
    return         : selectedCatProducts
    ********************************************************
    */
    selectAllCategoryProducts(event){
        // console.log('selectAllCategoryProducts');
        // console.log('event: ' + JSON.stringify(event));

        const selected = event.target.checked;
        // console.log('selected: ' + selected);

        // FB-134 : if the selectedCatProducts Current Page is undefined, set up an empty array 
        if (!this.selectedCatProducts[this.currentPage]) {
            this.selectedCatProducts[this.currentPage] = [];
        }

        // Update selectedCatProducts based on state of its checkbox
        if(selected) {
            // FB-134 : if selected then select all cat products on current page will be selected
            this.selectedCatProducts[this.currentPage] = this.paginatedProducts.map((catProduct) => catProduct.id);
        } else {
            // FB-134 : Deselect all products on current page if unselected
            this.selectedCatProducts[this.currentPage] = [];
        }

        // call update product selection status to keep checkboxes checked
        this.updateProductSelectionStatus();
        console.log('this.selectedCatProducts: ' + JSON.stringify(this.selectedCatProducts));
    }

    /*
    *********************************************************
    Function Name  : handleCatProductSelection
    Author         : Frank Berni
    Description    : tied to each row's checkbox. Selects the row's category product Id and adds it to selectedCatProducts
    Param          : event
    return         : selectedCatProducts
    ********************************************************
    */
    handleCatProductSelection(event) {
        // console.log('handleCatProductSelection');
        const catProductId = event.target.dataset.id;
        // console.log('catProductId: ' + JSON.stringify(catProductId));
        const isChecked = event.target.checked;

        // FB-134 : if the selectedCatProducts Current Page is undefined, set up an empty array 
        if (!this.selectedCatProducts[this.currentPage]) {
            this.selectedCatProducts[this.currentPage] = [];
        }

        if(isChecked) {
            // console.log('Id has been checked adding to selectedCatProducts');
            // Add to selectedCatProducts if checked
            // FB-134 : Add single product to selected list via current page
            this.selectedCatProducts[this.currentPage].push(catProductId);
        } else {
            // console.log('Id has been unchecked deleting from selectedCatProducts');
            // FB-134 : Remove product from select list
            this.selectedCatProducts[this.currentPage] = this.selectedCatProducts[this.currentPage].filter((id) => id !== catProductId);
        }
        // call update product selection status to keep checkboxes checked
        this.updateProductSelectionStatus();
        console.log('this.selectedCatProducts: ' + JSON.stringify(this.selectedCatProducts));
    }

    /*
    *********************************************************
    Function Name  : insertSelectedProducts
    Author         : Frank Berni
    Description    : calls Apex method insertSelectedProducts. Takes the list of all selected category product ids and inserts quote line for each on the parent quote
    Param          : insertSelectedProducts(selectedCatProductIds, recordId)
    return         : insert of SBQQ__QuoteLine__c records
    ********************************************************
    */
    insertSelectedProducts() {
        // console.log('insertSelectedProducts');
        if (this.selectedCatProducts.length === 0) {
            // Handle case when no products are selected
            this.template.querySelector('c-cpq-toast').showToast('error', 'No Product Selected:', 'Please Select a Product Before Adding to Quote');
            console.log('No Products Selected. Please select a Product before adding to Quote');
            return;
        }

        // FB-134 : combined all selected product Ids from across all pages - flat will flatten an array of arrays into a single array
        const allSelectedCatProductIds = Object.values(this.selectedCatProducts).flat();

        // Call Apex method to add selected products to the quote
        // FB-134 : use allSelectedCatProductIds for apex method
        insertSelectedProducts({ selectedCatProductIds: allSelectedCatProductIds, recordId: this.recordId })
            .then(result => {
                // console.log('result: ' + result);
                // console.log(JSON.stringify(result));
                this.template.querySelector('c-cpq-toast').showToast('success', 'Success:', 'Products successfully inserted as Quote Line Items');
                
                // Setting timeout for 1.5 second so toast message populates for user before moving to the next screen
                setTimeout(() => {
                    // Communicates to parent that the Product Cart can be show to user
                    const showCartEvent = new CustomEvent('showcart');
                    // console.log('showCartEvent: ' + JSON.stringify(showCartEvent));
                    this.dispatchEvent(showCartEvent);

                    // Communicates to parent to hide Category Tree
                    const hideCategoriesEvent = new CustomEvent('hidecategories');
                    // console.log('hideCategoriesEvent: ' + JSON.stringify(hideCategoriesEvent));
                    this.dispatchEvent(hideCategoriesEvent);

                    return refreshApex(this.categoryProducts);
                }, 1500);
            })
            .catch(error => {
                console.log('error: ' + error);
                if (Array.isArray(error.body)) {
                    this.error = error.body.map(e => e.message).join(', ');
                } else if (error.body && typeof error.body.message === 'string') {
                    this.error = error.body.message;
                } else if(typeof error === 'string'){
                    this.error = error;
                }
                this.template.querySelector('c-cpq-toast').showToast('error', this.error, this.error);
                console.log('Error insertSelectedProducts: ', JSON.stringify(this.error));
                
            });
    }

    /*
    *********************************************************
    Function Name  : checkCondition
    Author         : Frank Berni
    Description    : supports spinner logic for long data loads
    Param          : 
    return         : clears this.intervalId
    ********************************************************
    */
    checkCondition() {
        // Checks if categoryProducts is populated before switching isLoaded to true and clearing the interval
        if(this.categoryProducts) {
            this.isLoaded = true;
            clearInterval(this.intervalId);
        }
    }

    /*
    *********************************************************
    Function Name  : padProductCode
    Author         : Frank Berni
    Description    : function to add leading zeros to ISBN/ProductCodes with less than 13 digits
    Param          : 
    return         : productCode
    ********************************************************
    */
    padProductCode(productCode) {
        // uses padStart function to add leading zeros to any productcode fed through
        return productCode.toString().padStart(13, '0');
    }

    /*
    *********************************************************
    Function Name  : addUniqueFieldValuesToOptions
    Author         : Frank Berni
    Description    : Ticket W-014516: helper function to add any unique field values for comboboxes. Sort is only used for Duration filters
    Param          : fieldName, stateField, sort
    return         : options for stateField
    ********************************************************
    */
    addUniqueFieldValuesToOptions(fieldName, stateField, sort = false) {
        // console.log('addUniqueFieldValuesToOptions');
        // clone the categoryProducts field values for the given picklist field
        const uniqueValues = [... new Set(this.categoryProducts.map(catProduct => catProduct[fieldName]))];
        // console.log('uniqueValues', JSON.stringify(uniqueValues));

        // Looping through the Set of field values, if there is a field value that doesn't exist in the picklist field, add it to the respective options array
        uniqueValues.forEach(value => {
            if(!this[stateField].some(option => option.value === value)) {
                this[stateField].push({
                     label: value, value: value
                });
            }
        });
        // Sorting logic for Duration options
        if (sort) {

            if (stateField === 'durationOptions') {
                // Sorting Duration field to appear in shortest to longest order 1YR, 2YR, 3YR. etc.
                this[stateField].sort((a, b) => {
                    // handles undefined values and replaces them as 0's
                    const numA = parseInt(a.value?.replace('YR', '')) || 0;
                    const numB = parseInt(b.value?.replace('YR', '')) || 0;
                    return numA - numB
                });
            // else block to handle sorting for Grade Level picklist options
            } else {
                // Default sorting for Grade Level
                this[stateField].sort((a, b) => {
                    // Preferred sorting order for Grade levels
                    const gradeOrder = [
                        'PK','K','00','01','02','03','04','05','06','07','08','09','10','11','12','9',
                        'AD','AP','CB','CU','GS','KN','P3','P4','XX'
                    ];
                    const indexA = gradeOrder.indexOf(a.value);
                    const indexB = gradeOrder.indexOf(b.value);
                    return indexA - indexB;
                    
                });
            }
            
        }
        // Adding blank option to clear filters
        this[stateField].unshift({ label: 'All', value: ''});
        this[stateField] = [...this[stateField]];
        // console.log(stateField + ' - ' + JSON.stringify(this[stateField]));
    }

    /*
    *********************************************************
    Function Name  : handleFilterChange
    Author         : Frank Berni
    Description    : Ticket W-014516: function to handle any change made to any filter input fields. Assigns the new value to specified filter
    Param          : event
    return         : value for filter
    ********************************************************
    */
    handleFilterChange(event) {
        // console.log('handleFilterChange');
        // console.log('event', event);
        // console.log('event.target', event.target);
        const { name, value } = event.target;
        this.filters[name] = value;
        console.log('Filters:', JSON.stringify(this.filters));
        this.applyFilters();
    }

    /*
    *********************************************************
    Function Name  : applyFilters
    Author         : Frank Berni
    Description    : Ticket W-014516: helper function for handleFilterChange - makes appropriate updates to categoryProductsFiltered based on the filters that are active
    Param          : 
    return         : categoryProductsFiltered
    ********************************************************
    */
    applyFilters() {
        // console.log('applyFilters');
        // Uses filter function for categoryProducts to adjust the categoryProductsFiltered items based on the active filter
        this.categoryProductsFiltered = this.categoryProducts.filter(catProduct => {
            return (!this.filters.Audience || catProduct.audience === this.filters.Audience) &&
            (!this.filters.Product_Sub_Type || catProduct.productSubType === this.filters.Product_Sub_Type) &&
            (!this.filters.Program_Series || catProduct.programSeries === this.filters.Program_Series) &&
            // W-016058 replace gradeBandOptions with gradeLevelOptions
            (!this.filters.Grade_Level || catProduct.gradeLevel === this.filters.Grade_Level) &&
            (!this.filters.Solution_Type || catProduct.solutionType === this.filters.Solution_Type) &&
            (!this.filters.Duration || catProduct.duration === this.filters.Duration) &&
            (!this.filters.Copyright_Year || catProduct.copyrightYear.includes(this.filters.Copyright_Year)) &&
            // changed Net Price to account for slider maximum
            (parseFloat(catProduct.netPrice) <= this.filters.Net_Price);
            // (!this.filters.Net_Price || catProduct.netPrice.toString().includes(this.filters.Net_Price));
        });
        console.log('this.categoryProductsFiltered', JSON.stringify(this.categoryProductsFiltered));
    
        // update total products and pagination array
        this.totalProducts = this.categoryProductsFiltered.length;
        this.totalPages = Math.ceil(this.categoryProductsFiltered.length / this.pageSize);
        this.currentPage = 1;
        this.updatePaginatedProducts();
    }
     
    /*
    *********************************************************
    Function Name  : handleSliderChange
    Author         : Frank Berni
    Description    : tied to the Net Price slider. Updates the filter.Net_Price to the selected Net Price and calls applyFilters
    Param          : 
    return         : this.filters.NetPrice
    ********************************************************
    */
    handleSliderChange(event) {
        // console.log('handleSliderChange');
        const value = event.target.value;
        // console.log('value', JSON.stringify(value));
        this.filters = {...this.filters, Net_Price: value};
        this.applyFilters();
    }
    
    /*
    *********************************************************
    Function Name  : formatNetPriceCurrency
    Author         : Frank Berni
    Description    : helper function to reformat prices to Intl.NumberFormat based on currencyIsoCode
    Param          : value, currencyCode
    return         : reformatted price
    ********************************************************
    */
    formatNetPriceCurrency(value, currencyCode) {
        // Using Intl.NumberFormat to present net prices in traditional currency format, adapts to USD and CAD 
        const formatter = new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: currencyCode,
            minimumFractionDigits: 2,
        });
        return formatter.format(value);
    }

    /*
    *********************************************************
    Function Name  : updatePaginatedProducts
    Author         : Frank Berni
    Description    : This takes the filtered category products array and slices them into pages based on pageSize and then populates them into paginatedProducts
    Param          : 
    return         : paginatedProducts
    ********************************************************
    */
    updatePaginatedProducts() {
        const start = (this.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;
        this.paginatedProducts = this.categoryProductsFiltered.slice(start, end);
    }

    /*
    *********************************************************
    Function Name  : handlePreviousPage
    Author         : Frank Berni
    Description    : This is tied to the Previous button. Takes the user back to their previous page in the table
    Param          : 
    return         : 
    ********************************************************
    */
    handlePreviousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.updatePaginatedProducts();
        }
        // call update product selection status on load
        this.updateProductSelectionStatus();
    }

    /*
    *********************************************************
    Function Name  : handleNextPage
    Author         : Frank Berni
    Description    : This is tied to the Next button. Takes the user back to the next page in the table
    Param          : 
    return         : 
    ********************************************************
    */
    handleNextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.updatePaginatedProducts();
        }
        // call update product selection status on load
        this.updateProductSelectionStatus();
    }

    /*
    *********************************************************
    Function Name  : handleRecordsPerPage
    Author         : Frank Berni
    Description    : This is tied to the select dropdown next to the Next and Previous buttons. Updates the pageSize based on selected option
    Param          : 
    return         : pageSize
    ********************************************************
    */
    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.totalPages = Math.ceil(this.categoryProductsFiltered.length / this.pageSize);
        this.currentPage = 1;
        this.updatePaginatedProducts();
    }

    /*
    *********************************************************
    Function Name  : handleResetFilters
    Author         : Frank Berni
    Description    : This is tied to the Reset Filters button. Clears all combobox values and the Copyright Year. Reverts price slider to Max Price value.
    Param          : 
    return         : filters{}
    ********************************************************
    */
    // NEW W-016199 - function for button to reset all filters
    handleResetFilters() {
        // Set all filter values to empty strings
        this.filters = {
            Audience: '',
            Product_Sub_Type: '',
            Program_Series: '',
            Grade_Level: '',
            Solution_Type: '',
            Duration: '',
            Copyright_Year: '',
        }

        // Net Price is set back to the maximum price value
        this.filters.Net_Price = this.maxNetPriceValue;

        // Reset combo box and input tags
        this.template.querySelectorAll('lightning-combobox').forEach(comboBox => {
            // comboBox.label = 'All';
            comboBox.value = '';
        });

        this.template.querySelectorAll('lightning-input').forEach(input => {
            input.value = '';
        });

        // Call our applyFilters function to re-render the table
        this.applyFilters();

    }

}