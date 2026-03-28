import { LightningElement, api, wire, track } from 'lwc';
import getQuoteLines from "@salesforce/apex/CpqProductSelectionCtrl.getQuoteLines";
// notifyRecordUpdateAvailale and refreshApex to handle any stale quote line data
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

export default class CpqProductCart extends LightningElement {

    @track error;
    // handles spinner visibility 
    @track isLoaded = false;
    // controls spinner logic
    intervalId;

    // data inherited from parent
    @api recordId;
    @api showProductCart;

    // data from Apex for table
    @track quoteLines; 
    @track quoteLinesReady = false;
    
    // pagination variables
    @track paginatedLineItems;
    @track currentPage = 1;
    // defaulting pageSize to 50
    @track pageSize = 50;
    @track totalPages = 0;
    // updated to an object to work with lightning combobox
    @track pageSizeOptions = [
        { label: '10', value: '10'}, 
        { label: '25', value: '25'}, 
        { label: '50', value: '50'}, 
        { label: '75', value: '75'}, 
        { label: '100', value: '100'}
    ];
    @track totalLineItems = 0;
    
    // controls cart refresh
    wiredQuoteLinesResult;

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

    // on Load - handles spinner logic
    connectedCallback() {
        console.log('connectedCallback ProductCart');

        // keep spinner running until quoteLines are loaded
        this.intervalId = setInterval(this.checkCondition.bind(this), 100);
        
    }

    // on Render - calls refreshCart
    renderedCallback() {
        console.log('renderedCallback Product Cart');
        this.refreshCart();
    }

    /*
    *********************************************************
    Function Name  : wireQuoteLines
    Author         : Frank Berni
    Description    : calls Apex to query quote lines and load them into quoteLines table
    Param          : recordId
    return         : quoteLines
    ********************************************************
    */
    // call apex to return quote lines and assign to this.quoteLines
    @wire(getQuoteLines, {recordId: '$recordId'})
    wireQuoteLines(result) {
        console.log('wiredQuoteLines');
        console.log('recordId', this.recordId);
        
        // Stores the result, in case cart needs to be refreshed
        this.wiredQuoteLinesResult = result;

        // updated data to result.data
        if (result.data) {

            // NEW using spread operator instead and fixing special character issue in description
            //  format result.data rows for table
            this.quoteLines = result.data.map((row) => ({
                ...row,
                // formatting List Price to proper currency format
                listPrice: this.formatNetPriceCurrency(row.SBQQ__ListPrice__c, row.CurrencyIsoCode)
            }));
            console.log('this.quoteLines', JSON.stringify(this.quoteLines));

            // Check that there is data in the Cart and activate it
            if(this.quoteLines.length > 0) {
                console.log('Activating Quote Line Cart');
                this.quoteLinesReady = true;
                // setting up total line items and pages then calling updatePaginatedLineItems
                this.totalLineItems = this.quoteLines.length;
                this.totalPages = Math.ceil(this.quoteLines.length / this.pageSize);
                this.currentPage = 1;
                this.updatePaginatedLineItems();
            }

            this.error = undefined;
        // updated error to result.error
        } else if (result.error) {
            console.log('error: ' + JSON.stringify(result.error));
    
            if (Array.isArray(result.error.body)) {
                this.error = result.error.body.map(e => e.message).join(', ');
            } else if (result.error.body && typeof result.error.body.message === 'string') {
                this.error = result.error.body.message;
            } else if(typeof error === 'string'){
                this.error = result.error;
            }
            this.quoteLines = undefined;
            this.quoteLinesReady = false;
            this.template.querySelector('c-cpq-toast').showToast('error', 'Error finding Quote Lines:', this.error);
            console.log('Error wireQuoteLines: ', JSON.stringify(this.error));
        }
    }

    /*
    *********************************************************
    Function Name  : refreshCart
    Author         : Frank Berni
    Description    : Uses notifyRecordUpdateAvailable and refreshApex to refresh stale cache, called in renderedCallback
    Param          : 
    return         : clears this.intervalId
    ********************************************************
    */
    refreshCart() {
        console.log('refreshCart');
        // Using notifyRecordUpdateAvailable to invalidate the cache
        notifyRecordUpdateAvailable([{recordId: this.recordId}]); 
        return refreshApex(this.wiredQuoteLinesResult);
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
        if(this.quoteLines) {
            this.isLoaded = true;
            clearInterval(this.intervalId);
        }
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
    Function Name  : updatePaginatedLineItems
    Author         : Frank Berni
    Description    : This takes the filtered category products array and slices them into pages based on pageSize and then populates them into paginatedLineItems
    Param          : 
    return         : paginatedLineItems
    ********************************************************
    */
    updatePaginatedLineItems() {
        const start = (this.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;
        this.paginatedLineItems = this.quoteLines.slice(start, end);
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
            this.updatePaginatedLineItems();
        }
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
            this.updatePaginatedLineItems();
        }
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
        this.pageSize = parseInt(event.target.value, 10);
        this.totalPages = Math.ceil(this.quoteLines.length / this.pageSize);
        this.currentPage = 1;
        this.updatePaginatedLineItems();
    }


}