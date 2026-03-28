/*********************************************************
  Component Name       : scc_productCriteriaSearchLWC
  Created Date         : 06/10/2024  
  Author               : Cognizant 
  Description          : This component used in price and availability page the OOB features have been 
                         implemented to existing component to enhance page functionality.
  
  Modifications Log
  06/10/2024      Jaba           Initial Version
*********************************************************/ 


import { LightningElement, wire, track, api } from 'lwc';
import searchProducts from '@salesforce/apex/scc_productCriteriaSearch.searchProducts';
import errormessage from '@salesforce/label/c.scc_productcriteriaerrormessage';
import LightningAlert from 'lightning/alert';
import { RefreshEvent } from 'lightning/refresh';
import productSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.productSimulation';
import cartSimulation from '@salesforce/apex/ensxtx_CTRL_Cart.cartSimulation';
import { getSessionContext } from 'commerce/contextApi';
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';

export default class Scc_productCriteriaSearchLWC extends LightningElement {
    @track selectedDiscipline = '';
    @track titlekeyword = '';
    @track isbnValue = '';
    @track activeProducts = true; // Checked by default
    @track searchDisabled = true; // Initially disabled
    @track showResults = false; // Initially hidden
    @track productData = []; // Data to display in the table
    @track disableNext = true; // Initially disabled
    @track disciplineOptions = [];
    @api filterCriteria = '';
    @track currentTab='tab-default-1__item';
    @api viewForCatalogSection = false;
    @track message='Search by ISBN, Keyword';
    @track enableLogs = false;
    sfObjectIdMap = {};
    activeTabValue;
    records = []; //All records available in the data table
    columns = []; //columns information available in the data table
    recordsToDisplay = []; //Records to be displayed on the page
    searchResultErrorMessage = errormessage;
    manualSearchBtnDisabled = true;
    showProductTitlePage = false;
    showTabset = true;
    selectedProductRecord = {};
    showSearchResultErrorMessage = false;
    @track pageRecordCount=0
    @track totalCount=0
    pdpAppSettingsName = 'ensxtx_SR_enosixCartPDPAppSettings';
    appSettingsName = 'ensxtx_SR_enosixProductB2BAppSettings';
    ensxtx_DS_Document_Detail;
    @track transformedDataLength = 0;
    @track totalCount = 0;
    disableClearButton = true;
    searchButtonCSS = 'searchButtonDisabled';
    clearButtonCSS = 'clearButtonDisabled';
    infoIconUrl = imageIcons + '/Images/info.png';
    searchIconUrl = imageIcons + '/Images/search.png';
    crossIconUrl = imageIcons + '/Images/cross.png';
    noResult = imageIcons + '/Images/no_result.png';
    showSearchFilter = true;
    filterSearchValue = '';
    // Pagination Variables
    @track currentPagetableData = [];
    selectedIdList = [];
    hideCheckbox = false;
    @track multiisbntab = false;
    @track catalogtab = false;


    
    // Define columns for the lightning-datatable
    columns = [
        {
            label: 'ISBN',
            fieldName: 'ISBN',
            type: 'button',
            typeAttributes: { label: { fieldName: 'ISBN', type: 'text' }, name: 'viewRecords', target: '_blank', class: 'custom-button', variant: 'base' },
            sortable: true
        },
        { label: 'Title Description', fieldName: 'Title_Description', sortable: true, type: 'text' },
        { label: 'Type', fieldName: 'Type', type: 'text', sortable: true, wrapText: true },
        { label: 'Grade Level', fieldName: 'Grade_Level', type: 'text', sortable: true },
        { label: 'Copyright', fieldName: 'Copyright', type: 'text', sortable: true },
        { label: 'Status', fieldName: 'Status', type: 'text', sortable: true },
        {
            label: 'Price',
            type: 'button-icon',
            initialWidth: 80,
            typeAttributes: {
                name: 'infoPrice',
                iconName: 'utility:hourglass',
                variant: 'border-filled',
                alternativeText: 'Info'
            }, sortable: true,
            hideDefaultActions: true
        }
    ];

    connectedCallback() {
        this.template.addEventListener('keydown', this.handleKeydown.bind(this));
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        });
        if (this.enableLogs) console.log('the user selected input', this.userselection);
        this.userInputs = this.userselection;
        this.template.addEventListener('keydown', this.handleKeydown.bind(this));
        window.addEventListener('placeOrdercatalogFilterFocus', this.focusfilterinput.bind(this));
    }

    // Event handler for text input change
    handleTextInputChange(event) {
        if (event.target.dataset.id == 'ISBN') {
            this.isbnValue = event.target.value;
        }
        else {
            this.titlekeyword = event.target.value;
        }
        this.checkSearchButtonState();
    }
    // Event handler for active products checkbox change
    handleActiveProductsChange(event) {
        this.activeProducts = event.target.checked;
        this.checkSearchButtonState();        
    }
    // Check if search button should be enabled
    checkSearchButtonState() {        
         this.manualSearchBtnDisabled = !this.selectedDiscipline && !this.titlekeyword && !this.isbnValue;
         this.disableClearButton = !this.selectedDiscipline && !this.titlekeyword && !this.isbnValue;
         if(this.manualSearchBtnDisabled){
            this.searchButtonCSS = 'searchButtonDisabled';
         }
         else{
            this.searchButtonCSS = 'searchButton';
         }
         if(this.disableClearButton){
            this.clearButtonCSS = 'clearButtonDisabled';
         }
         else{
             this.clearButtonCSS = 'clearButton';
         }
    }
    
handleSearch(event) {
    if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
        const searchStartTime = performance.now();
        const searchStartDateTime = new Date();
        if (this.enableLogs){
        console.log(`Search initiated on: ${searchStartDateTime.toLocaleString()}`);        
        console.log('Search button Clicked');
        }
        this.manualSearchBtnDisabled = true; // Disable the search button after clicking it

        const queryStartTime = performance.now();
        searchProducts({ 
            isbnValue: this.isbnValue, 
            selectedDiscipline: this.selectedDiscipline, 
            titlekeyword: this.titlekeyword, 
            activeProducts: this.activeProducts 
        })
        .then(result => {
            const queryEndTime = performance.now();
            const queryDurationSeconds = (queryEndTime - queryStartTime) / 1000;
            if (this.enableLogs){
            console.log(`Salesforce query completed on: ${new Date().toLocaleString()}`);
            console.log(`Time taken for Salesforce query: ${queryDurationSeconds.toFixed(3)} seconds`);
            console.log('Search results:', result);
            }
            this.productData = result;
            this.records = result;

            if (this.productData != undefined) {
                this.showSearchResultErrorMessage = false;                

                if (this.productData.length < 1) {
                    this.showSearchResultErrorMessage = true;
                    this.showResults = true;
                } else if (this.productData.length >= 1) {
                    if (this.productData.length == 1) {
                        this.showTabset = false;
                        this.showResults = false;
                        this.showProductTitlePage = true;
                        this.selectedProductRecord = this.productData[0];
                    }
                }
            }

            this.showSearchFilter = false;
            this.showResults = (this.productData.length) ? true : false;
            this.manualSearchBtnDisabled = true;
            this.error = undefined; // Reset error if any

            const searchEndTime = performance.now();
            const searchDurationSeconds = (searchEndTime - searchStartTime) / 1000;
            if (this.enableLogs){
            console.log(`Search process completed on: ${new Date().toLocaleString()}`);
            console.log(`Total time for search process: ${searchDurationSeconds.toFixed(3)} seconds`);
            }
        })
        .catch(error => {
            const queryEndTime = performance.now();
            const queryDurationSeconds = (queryEndTime - queryStartTime) / 1000;
            if (this.enableLogs){
            console.log(`Error occurred on: ${new Date().toLocaleString()}`);
            console.log(`Time taken before error occurred: ${queryDurationSeconds.toFixed(3)} seconds`);            
            console.error('Error fetching results:', error);
            }
            this.error = error;
            this.productData = [];
            this.showResults = false;

            const searchEndTime = performance.now();
            const searchDurationSeconds = (searchEndTime - searchStartTime) / 1000;
            if (this.enableLogs){
            console.log(`Search process (with error) completed on: ${new Date().toLocaleString()}`);
            console.log(`Total time for search process (with error): ${searchDurationSeconds.toFixed(3)} seconds`);
            }
        });
    }
}

    // Event handler for closing product title page
    closeChildTitlePage(event) {
  
     setTimeout(()=>{
            let eve = {target:{dataset:{id:event.detail.currentTab}}};
         if (eve == 'tab-default-2__item' || eve == 'tab-default-3__item') {
             this.showProductTitlePage = false;
            this.showResults = false;
         }         
            this.handleActive(eve);
        }, 50);
    
    this.showProductTitlePage = false;
    this.showTabset = true;
    if (event.detail.currentTab == 'tab-default-1__item') {
             this.showProductTitlePage = false;
            this.showResults = true;
         }
    
    this.getactiveTabValue = event.detail.tabValue;
    
    this.activateTab(this.getactiveTabValue);
}

activateTab(tabValue) {
    const tabToActivate = this.template.querySelector(`[data-value="${tabValue}"]`);
    if (tabToActivate) {
        const event = new CustomEvent('click');
        tabToActivate.dispatchEvent(event);
        
        // If it's the Multi ISBN tab, call its activateTab method
        if (tabValue === 'multiISBN') {
            const multiIsbnComponent = this.template.querySelector('c-scc_product-quick-search-l-w-c');
            if (multiIsbnComponent) {
                multiIsbnComponent.activateTab();
            }
        }
    }
}
    openChildTitlePage(event) {
        this.showProductTitlePage = true;
        this.showTabset = false;
        this.showResults = false;
        this.selectedProductRecord = event.detail.parentSelectedProductRecord;
    }
    // Handle clear button click event
    handleClear() {        
        this.isbnValue = '';
        this.selectedDiscipline = '';
        this.titlekeyword = '';
        this.activeProducts = true;
        this.searchDisabled = true;
        this.showResults = false;
        this.disableNext = true;
        this.productData = [];
        this.transformedDataLength = 0;
        this.totalCount = 0;
        this.manualSearchBtnDisabled = true;
        this.showSearchResultErrorMessage = false;
        this.disableClearButton = true;
        this.showSearchFilter = true;
        this.searchButtonCSS = 'searchButtonDisabled';
        this.clearButtonCSS = 'clearButtonDisabled';        
        this.dispatchEvent(new RefreshEvent()); // Refresh the page        
    }
    get checkInputValues() {
        let boolVal = false;
        if (this.manualSearchBtnDisabled) {
            boolVal = true;
        }
        else if (this.selectedDiscipline == '' && this.isbnValue == '' && this.titlekeyword == '') {
            boolVal = true;
        }
        return boolVal;
    }
    // Event handler for showing product title page
    handleShowProductTitlePage(event) {
    this.showTabset = false;
    this.showProductTitlePage = true;
    this.selectedProductRecord = event.detail.parentSelectedProductRecord;
    this.selectedProductRecord.activeTab = this.activeTab;
}
    handleActive(event) {
         this.activeTab = event.target.dataset.value;
        this.currentTab=event.target.dataset.id;        
        this.template.querySelectorAll('.slds-tabs_default__item').forEach((ele)=>{
            const link =ele.querySelector('a');//updated changes for accessibility
            if(ele.classList.contains('slds-is-active')){
                ele.classList.remove('slds-is-active');
                ele.setAttribute('aria-selected','false');
                link.setAttribute('aria-selected','false');
                ele.tabindex=-1;
            }
            if(event.target.dataset.id == ele.dataset.id){
                ele.classList.add('slds-is-active');
                ele.setAttribute('aria-selected','true');
                link.setAttribute('aria-selected','true');
                ele.tabindex="0";
            }
            
        })
        this.template.querySelectorAll("[data-name=tabpanel]").forEach((ele)=>{
            if(event.target.dataset.id == ele.dataset.id){
                if(!ele.classList.contains("slds-show")){
                    ele.classList.remove("slds-hide");
                    ele.classList.add("slds-show");
                }
            }
            else if(ele.classList.contains("slds-show")){
                ele.classList.remove("slds-show");
                ele.classList.add("slds-hide");
            }
        })
        
        
        this.getactiveTabValue = event.target.dataset.value;
        if (this.getactiveTabValue === 'catalogSearch') {
            this.viewForCatalogSection = true;
        } else {
            this.viewForCatalogSection = false;
        }

        if(event.target.dataset.id == 'tab-default-1__item'){
            setTimeout(() => {
                this.template.querySelector('.priceAvaIsbnFirstField').focus();
            }, 100);
        }else if(event.target.dataset.id == 'tab-default-2__item'){
                window.dispatchEvent(new CustomEvent('pNamultiISBNtextAreaFocus'));
            
        }else if(event.target.dataset.id == 'tab-default-3__item'){
                window.dispatchEvent(new CustomEvent('pNacatalogFilterFocus'));
            
        }
        
    }


    onHandleSort(event) {        
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortDirection);
    }
    sortData(fieldname, direction) {
        if (this.enableLogs){
        console.log('sortData :: ', fieldname, direction);
        }
        let parseData = JSON.parse(JSON.stringify(this.currentPagetableData));
        let keyValue = (element) => {
            return element[fieldname];
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((xElement, yElement) => {
            xElement = keyValue(xElement) ? keyValue(xElement) : '';
            yElement = keyValue(yElement) ? keyValue(yElement) : '';
            return isReverse * ((xElement > yElement) - (yElement > xElement));
        });
        this.currentPagetableData = parseData;
    }
    // Event handler for changing records per page // sprit 4 tkt written by sudha 
    handleFilter(event) {
        this.filterSearchValue = event.target.value;
        const searchTerm = event.target.value.trim();    
        if (!searchTerm || searchTerm.length < 3 && !/^\d{3,}$/.test(searchTerm)) {           
            this.filterCriteria = '';
        } else {
            const searchTerms = searchTerm.split(/\s+/).filter(term => term);
            if (searchTerms.length > 1) {
                this.filterCriteria = searchTerm;                
            } else if (/^\d{10,13}$/.test(searchTerm)) {
                this.filterCriteria = searchTerm;             
            } else if (/^\d{1,5}$/.test(searchTerm)) {
                this.filterCriteria = searchTerm;            
            } else {
                this.filterCriteria = searchTerm;               
            }
        }
    }
  taskTypeHelpTextClass = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-fall-into-ground isbn-poppup slds-hide';//slds-popover slds-popover_tooltip slds-nubbin_bottom
    togglePasswordHint(event) {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-fall-into-ground isbn-poppup slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-rise-from-ground isbn-poppup';
        this.taskTypeHelpTextClass = this.taskTypeHelpTextClass == hideCss ? showCss : hideCss;

    }
    taskTypeHelpTextClassfilter = 'slds-popover slds-popover_tooltip slds-nubbin_bottom slds-fall-into-ground filterInfo-poppup slds-hide';
    togglePasswordHintfilter() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom slds-fall-into-ground filterInfo-poppup slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom slds-rise-from-ground filterInfo-poppup';
        this.taskTypeHelpTextClassfilter = this.taskTypeHelpTextClassfilter == hideCss ? showCss : hideCss;

    }
    taskTypeHelpTextClassCount = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground countInfo-poppup slds-hide';
    togglePasswordHintCount() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground countInfo-poppup slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground countInfo-poppup';
        this.taskTypeHelpTextClassCount = this.taskTypeHelpTextClassCount == hideCss ? showCss : hideCss;

    }
    clearFilterInput(){
        this.filterSearchValue = '';
        this.filterCriteria = '';
        
    }
    handleFilterKeydown(event) {
        if (event.key === 'Enter') {
        this.clearFilterInput();
        }
    }
    
    handleTransformedDataLength(event) {
        this.transformedDataLength = event.detail.transformedDataLength;
        if (event.detail.totalFilteredRecords) {
            this.totalFilteredRecords = event.detail.totalFilteredRecords;
            this.totalCount = this.totalFilteredRecords; // Update totalCount with totalFilteredRecords
        } else {
            this.totalCount = event.detail.totalCount; // Update totalCount with original totalRecords
        }        
    }


//added by zubiya
 handleKeyDownISBN(event) {
        if (event.key === 'Enter') {
            const focusON = this.template.querySelector('[data-id="ISBN"]');
            if (focusON) {
                focusON.focus();
            }
        }
       
    }

}