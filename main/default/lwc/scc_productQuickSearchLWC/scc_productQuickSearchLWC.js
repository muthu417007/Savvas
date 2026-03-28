import { LightningElement, track, wire, api } from 'lwc';
import searchRecords from '@salesforce/apex/scc_productQuickSearch_Controller.searchRecords';
import { RefreshEvent } from 'lightning/refresh';
import { CustomLabels } from 'c/scc_customlablesLWC';
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue' ;
export default class scc_productQuickSearchLWC extends LightningElement {

    @track selectedRecord;
    @track searchResults = [];
    @track recordIds = '';
    @track isSearchDisabled = true;
    @track filterCriteria;
    @track productData = [];
    @track showResults = false;
    @track message = 'Search by pasting one or more ISBNs';
    @track transformedDataLength = 0;
    @track totalCount = 0;
    showSearchResultErrorMessage=false;
    filterSearchValue = '';
    showSearchFilter = true;
    disableClearButton = true;
    searchButtonCSS = 'searchButtonDisabled';
    clearButtonCSS = 'clearButtonDisabled';
    infoIconUrl = imageIcons + '/Images/info.png';
    searchIconUrl = imageIcons + '/Images/search.png';
    crossIconUrl = imageIcons + '/Images/cross.png';
    noResult = imageIcons + '/Images/no_result.png';
    selectedProductRecord = {};
    @api multiisbntab;
    @track activeTab = 'ISBN'; 
    @track activeProducts = true; // Checked by default
    @track enableLogs = false;
    @track defaultNationalStateValue = false;
    columns = [
        {
            label: 'ISBN',
            fieldName: 'ISBN',
            type: 'button',
            sortable: true,
            typeAttributes: {
                label: {
                    fieldName: 'ISBN',
                    type: 'text'
                },
                name: 'viewRecords',
                target: '_blank',
                class: 'custom-button',
                variant: 'base'
            }
        },
        { label: 'Title Description', fieldName: 'Title_Description', type: 'text', sortable: true },
        { label: 'Type', fieldName: 'Type', type: 'text', sortable: true },
        { label: 'Grade', fieldName: 'Grade_Level', type: 'text', sortable: true },
        { label: 'Copyright', fieldName: 'Copyright', type: 'text', sortable: true },
        { label: 'Status', fieldName: 'Status', type: 'text', sortable: true },
        { label: 'Price', type: 'button-icon', initialWidth: 80, typeAttributes: { name: 'infoPrice', iconName: 'utility:hourglass', variant: 'border-filled', alternativeText: 'Info' }, sortable: true, hideDefaultActions: true }
    ];
     connectedCallback(){
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if(this.enableLogs){
                console.log('getEnableConsoleLogsTrue response is',response);
            }
        }).catch(error => {
            if(this.enableLogs){
                console.log('error is', error);
            }
        })

        if(this.multiisbntab)
        {
             const focusON = this.template.querySelector('[data-id="multiISBN"]');
            if (focusON) {
                focusON.focus();
            }
        }
        window.addEventListener('pNamultiISBNtextAreaFocus', this.focustextArea.bind(this));
    }

    focustextArea(){
        setTimeout(() => {
            if(this.template.querySelector(".pNamultiIsbntextarea") != undefined){
                this.template.querySelector(".pNamultiIsbntextarea").focus();
            }
        }, 100);
    }

    handleInputChange(event) {
        const rawInput = event.target.value;
        const lines = rawInput.split('\n');
        const cleanedLines = lines.map(line => line.trim().replace(/[^\dA-Za-z]/g, ''));
        const nonEmptyLines = cleanedLines.filter(line => line.length > 0);
        this.recordIds = nonEmptyLines;
        this.isSearchDisabled = this.recordIds.length === 0;
        this.disableClearButton = event.target.value == '';
        if (this.isSearchDisabled) {
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
     // Event handler for active products checkbox change
    handleActiveProductsChange(event) {
        this.activeProducts = event.target.checked;
    }

    handleSearch() {
        this.showSearchResultErrorMessage = false;
        if (this.recordIds.length > 0) {
            searchRecords({ 
                recordIds: this.recordIds,
                activeProducts: this.activeProducts
                })
                .then(result => {
                    this.records = result;
                    this.searchResults = result.map(record => {
                        return {
                            ...record.product,
                            price: record.price,
                            productid: record.productId,
                            productId: record.productId,
                            ISBN: record.ISBN,
                            Title_Description: record.Title_Description,
                            Grade_Level: record.Grade_Level,
                            Type: record.Type,
                            Status: record.Status,
                            Copyrightyear: record.Copyrightyear,
                            Copyright: record.Copyrightyear,
                            Price: record.Price,
                            programSeries: record.programSeries
                        };
                    });
                    this.productData = this.searchResults;
                    this.selectedProductRecord = this.productData[0];
                    this.showSearchFilter = false;
                    if(this.productData.length>0){
                        this.showResults = true;
                         
                    }
                    else{
                        this.showSearchResultErrorMessage = true;
                        this.showResults = false;
                        
                    }                    
                })
                .catch(error => {
                    console.error('Error occurred while fetching search results:', error);
                });
        } else {       
            if(this.enableLogs){     
            console.log('No record IDs provided.');
            }
        }
    }
    handleClear() {
        const textAreaInput = this.template.querySelector('.arvicon-input');
        if (textAreaInput) {
            textAreaInput.value = '';
        }        
        this.disableClearButton=true;
        this.recordIds = '';
        this.searchResults = '';
        this.isSearchDisabled = true;
        this.productData = '';
        this.transformedDataLength = 0;
        this.totalCount = 0;
        this.showSearchResultErrorMessage = false;
        this.showResults = false;
        this.showSearchFilter = true;
        this.searchButtonCSS = 'searchButtonDisabled';
        this.clearButtonCSS = 'clearButtonDisabled';
        this.dispatchEvent(new RefreshEvent());
        this.activeProducts = true;
    }
    //************* */ WorkItem:cleanUp Tkt Filter changes //************* */
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
    openChildTitlePage(event) {
        this.showProductTitlePage = true;
        this.showResults = false;
        const getdatafromchild = event.detail.parentSelectedProductRecord;
        const selectedProductRecord = {
            ISBN: getdatafromchild.ISBN,
            productId: getdatafromchild.productid,
            Title_Description: getdatafromchild.Title_Description,
            Grade_Level: getdatafromchild.Grade_Level,
            Copyright: getdatafromchild.Copyrightyear,
            Status: getdatafromchild.Status,
            Type: getdatafromchild.Type,
            Price: getdatafromchild.Price
        };
        const displayDEvent = new CustomEvent('showproducttitlepage', {
            detail: {
                parentSelectedProductRecord: selectedProductRecord,
            }
        });
        this.dispatchEvent(displayDEvent);

    }
    taskTypeHelpTextClass = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-left slds-fall-into-ground isbn-poppup slds-hide';
    togglePasswordHint() {
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
    clearFilterInput(event){
        this.filterSearchValue = ''; 
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
isRenderedCallbackCalled = false
 renderedCallback() {    
  if(this.isRenderedCallbackCalled==false){
      const closeBtn= this.template.querySelector(".multiISBN");
      setTimeout(() => {
                        if(closeBtn){
                          closeBtn.focus();
                        }
                        }, 2000);
      this.isRenderedCallbackCalled = true;
    }
    if(this.multiisbntab)
        {
             const focusON = this.template.querySelector('[data-id="multiISBN"]');
            if (focusON) {
                focusON.focus();
            }
        }
  }
@api activateTab() {
    const textArea = this.template.querySelector('[data-id="multiISBN"]');
    if (textArea) {
        setTimeout(() => {
            textArea.focus();
        }, 0);
    }
}
}