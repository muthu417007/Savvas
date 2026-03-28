/*********************************************************
  Component Name       : scc_internalProductSearch
  Created Date         : 05/21/2024  
  Author               : Sudha Rani pathivada- Cognizant
  Description          : this component used for internal user purpose 
  Modifications Log
  <Date>       <Author>            <Modification>
*********************************************************/
import { LightningElement, wire, track, api } from 'lwc';
import searchProducts from '@salesforce/apex/scc_InternalUser_SingleISBN.searchProducts';
import errormessage from '@salesforce/label/c.scc_productcriteriaerrormessage';
import { loadStyle } from 'lightning/platformResourceLoader';
import headmarkupstyle_static from '@salesforce/resourceUrl/headmarkupstyle_static';
import scc_accountHoverMessage from "@salesforce/label/c.scc_accountHoverMessage";
import imageIcons from '@salesforce/resourceUrl/scc_Images';
export default class scc_internalProductSearch extends LightningElement {
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
    @api viewForCatalogSection = false;
    @track message = 'Search by ISBN, Keyword';
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
    @track usertypecheck = false
    showSearchResultErrorMessage = false;
    @track pageRecordCount = 0
    @track totalCount = 0
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
    @track country = 'Only US Sales Org';
    @track accountId = '';
    @track accSAPId = '';
    @track accIn = false;
    labels = {
        scc_accountHoverMessage
    }
    handleRadioChange(event) {
        this.country = event.target.value;
        // Check if there's any search criteria entered before triggering the search
        if (this.isbnValue || this.titlekeyword || this.selectedDiscipline || this.accountId) {
            this.handleSearch();
        }
    }
    get isUSSelected() {
        return this.country === 'Only US Sales Org';
    }
    get isCanadaSelected() {
        return this.country === 'Only Canadian Sales Org';
    }
    get isBothSelected() {
        return this.country === 'Both';
    }
    renderedCallback() {
        loadStyle(this, headmarkupstyle_static).then(() => {
        }).catch(error => {
        })
    }
    handleAccountInputChange(event) {
        this.accountId = event.target.value || '';  // Ensure it's never undefined
        this.accIn = !!this.accountId; 
      
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
    //Event handler for active products checkbox change
    handleActiveProductsChange(event) {
        this.activeProducts = event.target.checked;
        this.checkSearchButtonState();
        // this.manualSearchBtnDisabled = false; // Enable the search button when the checkbox changes
    }
    //Check if search button should be enabled
    checkSearchButtonState() {
        // this.searchDisabled = !this.selectedDiscipline && !this.titlekeyword;
        this.manualSearchBtnDisabled = !this.selectedDiscipline && !this.titlekeyword && !this.isbnValue;
        this.disableClearButton = !this.selectedDiscipline && !this.titlekeyword && !this.isbnValue;
        if (this.manualSearchBtnDisabled) {
            this.searchButtonCSS = 'searchButtonDisabled';
        }
        else {
            this.searchButtonCSS = 'searchButton';
        }
        if (this.disableClearButton) {
            this.clearButtonCSS = 'clearButtonDisabled';
        }
        else {
            this.clearButtonCSS = 'clearButton';
        }
    }
    handleEnter(event) {
        if (event.keyCode === 13 && (!this.manualSearchBtnDisabled || !this.disableClearButton)) {
            this.handleSearch();
        }
    }
    // Handle search button click event
    handleSearch() {
       
       this.productData=[];
       this.countrycode='';
        // this.searchDisabled = true;
       // this.manualSearchBtnDisabled = true; 
        const safeAccountId = this.accountId || '';
        this.countrycode=this.country
        searchProducts({
            isbnValue: this.isbnValue,
            selectedDiscipline: this.selectedDiscipline,
            titlekeyword: this.titlekeyword,
            activeProducts: this.activeProducts,
            accountId: safeAccountId,
            country: this.countrycode
        })
            .then(result => {
                this.productData = result;
                this.records = result;
                if (this.accIn) {
                    this.accSAPId = this.productData[0].accountId;
                }
                if (this.productData != undefined) {
                    this.showSearchResultErrorMessage = false;
                    if (this.productData.length < 1) {
                        this.showSearchResultErrorMessage = true;
                        this.showResults = true;
                    }
                    else if (this.productData.length >= 1) {
                        if (this.productData.length == 1) {
                            this.showTabset = false;
                            this.showResults = false;
                            this.showProductTitlePage = true;
                            this.selectedProductRecord = this.productData[0];
                            this.accSAPId = this.productData[0].accountId;
                            this.showProductTitlePage = this.productData[0];
                            const event = new CustomEvent('parentSelectedProductRecord', {
                                detail: {
                                    selectedProductRecord: this.selectedProductRecord
                                }
                            });
                            this.dispatchEvent(event);
                        }
                    }
                }
                this.showSearchFilter = false;
                this.showResults = (this.productData.length) ? true : false;
                //this.manualSearchBtnDisabled = true;
                this.error = undefined; // Reset error if any
                //this.getProductDetails();
            })
            .catch(error => {
                this.error = error;
                this.productData = [];
                this.showResults = false;
            });
    }
    // Event handler for closing product title page
    closeChildTitlePage(event) {
        this.showProductTitlePage = false;
        this.showTabset = true;
        this.showResults = false;
        this.titlekeyword = '';
        this.accountId = '';
        this.isbnValue = '';
        this.getactiveTabValue = event.detail.tabClose;
    }
    openChildTitlePage(event) {
        this.showProductTitlePage = true;
        this.showTabset = false;
        this.showResults = false;
        this.selectedProductRecord = event.detail.parentSelectedProductRecord;
        this.usertypecheck = event.detail.isInternalUser;
    }
    // Handle clear button click event
    handleClear() {
        this.isbnValue = '';
        this.selectedDiscipline = '';
        this.titlekeyword = '';
        this.accountId = '';
        this.country = 'Only US Sales Org';
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
        else if (this.selectedDiscipline == '' && this.isbnValue == '' && this.titlekeyword == '' && this.accountId =='') {
            boolVal = true;
        }
        return boolVal;
    }
    // Event handler for showing product title page
    handleShowProductTitlePage(event) {
        this.showTabset = false;
        this.showProductTitlePage = true;
        this.selectedProductRecord = event.detail.parentSelectedProductRecord;
        this.usertypecheck = event.detail.isInternalUser;
    }
    handleActive(event) {
        event.preventDefault();
        this.template.querySelectorAll('.slds-tabs_default__item').forEach((ele) => {
            if (ele.classList.contains('slds-is-active')) {
                ele.classList.remove('slds-is-active');
                ele.setAttribute('aria-selected', 'false');
                ele.tabindex = -1;
            }
            if (event.target.dataset.id == ele.dataset.id) {
                ele.classList.add('slds-is-active');
                ele.setAttribute('aria-selected', 'true');
                ele.tabindex = "0";
            }
        })
        this.template.querySelectorAll("[data-name=tabpanel]").forEach((ele) => {
            if (event.target.dataset.id == ele.dataset.id) {
                if (!ele.classList.contains("slds-show")) {
                    ele.classList.remove("slds-hide");
                    ele.classList.add("slds-show");
                }
            }
            else if (ele.classList.contains("slds-show")) {
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
    }
    onHandleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortDirection);
    }
    sortData(fieldname, direction) {
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
    taskTypeHelpTextClassAccount = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-fall-into-ground countInfo-poppup slds-hide';
    togglePasswordHintAccount() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-fall-into-ground countInfo-poppup slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-rise-from-ground countInfo-poppup';
        this.taskTypeHelpTextClassAccount = this.taskTypeHelpTextClassAccount == hideCss ? showCss : hideCss;
    }
    clearFilterInput(event) {
        this.filterSearchValue = '';
        this.filterCriteria = '';
    }
    handleTransformedDataLength(event) {
        this.transformedDataLength = event.detail.transformedDataLength;
        if (event.detail.totalFilteredRecords) {
            this.totalFilteredRecords = event.detail.totalFilteredRecords;
            this.totalCount = this.totalFilteredRecords; // Update totalCount with totalFilteredRecords
        } else {
            this.totalCount = event.detail.totalCount; // Update totalCount with original totalRecords
        }
        // Update parent component's data or UI based on the length of the transformed data received from the child component
    }
}