/*********************************************************
  Component Name       : scc_searchAccessCodeLWC
  Created Date         : 2024-06-27
  Author               : CTS (Sanika)
  Description          : Search component for access codes that allows users to search,
                        view and export order details and related access code records.
  Modifications Log
  25/10/2024                Initial Version  
*********************************************************/
import { LightningElement, track } from 'lwc';
import searchOrders from '@salesforce/apex/scc_accessCodeController.searchOrders';
import getRelatedRecords from '@salesforce/apex/scc_accessCodeController.getRelatedRecords';
import getUserType from '@salesforce/apex/scc_accessCodeController.getUserType';
import errormessage from '@salesforce/label/c.scc_productcriteriaerrormessage';
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import { loadScript } from "lightning/platformResourceLoader";
import writeExcelFile from "@salesforce/resourceUrl/scc_write_excel_file";
import scc_code_redemption_hover_message from '@salesforce/label/c.scc_code_redemption_hover_message';
import sendResendAccess from '@salesforce/apex/scc_resend_AccessCode_Controller.sendResendAccess';
import { loadStyle } from 'lightning/platformResourceLoader';
import headmarkupstyle_static from '@salesforce/resourceUrl/headmarkupstyle_static';
import generateCSVContent from '@salesforce/apex/scc_csvDownloader.generateCSVContent';
import sheetJS from '@salesforce/resourceUrl/sheetJS';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
const columns = [
    { label: 'PO#', fieldName: 'PoNumber__c' },
    {
        label: 'Order#',
        fieldName: 'SAP_Document_Number__c',
        type: 'button',
        typeAttributes: {
            label: { fieldName: 'SAP_Document_Number__c' },
            name: 'view_order',
            variant: 'base'
        }
    },
    { label: 'Order Date', fieldName: 'EffectiveDate' },
    { label: 'Order Method', fieldName: 'SAP_Order_Method__c' },
    { label: 'Order Items', fieldName: 'Total_Items__c' },
    { label: 'Order Units', fieldName: 'Order_Total_Units__c' },
    { label: 'Ship To', fieldName: 'ShippingAddress' },
    { label: 'Bill To', fieldName: 'BillingAddress' },
];
const relatedColumns = [
    { label: 'PO#', fieldName: 'PoNumber__c' },
    { label: 'Order#', fieldName: 'SAP_Document_Number__c' },
    { label: 'Order Date', fieldName: 'EffectiveDate' },
    { label: 'ISBN', fieldName: 'ProductCode__c' },
    { label: 'Title Description', fieldName: 'Title_Description__c' },
    { label: 'E-Access Code', fieldName: 'EAccess_Code__c' },
    { label: 'Email Recipient', fieldName: 'Customer_Email__c' },
    { label: 'Code Redemption', fieldName: 'No_Of_Redemptions__c' },
];
const PAGE_SIZE_OPTIONS = [
    { label: '15', value: '15' },
    { label: '20', value: '20' },
    { label: '25', value: '25' },
];
const columnHeader = ['PO#', 'Order#', 'Order Date', 'ISBN', 'Title Description', 'EAccess Code', 'Email Recipient', 'Code Redemption'];
export default class Scc_searchAccessCodeLWC extends LightningElement {
    searchIconUrl = imageIcons + '/Images/search.png';
    infoIconUrl = imageIcons + '/Images/info.png';
    noResult = imageIcons + '/Images/no_result.png';
    excelIcon = imageIcons + '/Images/excel.png';
    @track orders = [];
    @track columns = columns;
    @track relatedColumns = relatedColumns;
    @track error;
    @track poNumber = '';
    @track orderNumber = '';
    @track sapDocumentNumber;
    @track isbn = '';
    isSearchDisabled = true;
    @track relatedRecords = [];
    @track pagedRelatedRecords = [];
    @track isRelatedView = false;
    @track currentPage = 1;
    @track pagedOrders = [];
    @track showResults = false;
    @track totalPages = 1;
    @track totalCount = 0;
    @track transformedDataLength = 0;
    @track pageSizeOptions = PAGE_SIZE_OPTIONS;
    @track pageSize = 15;
    @track bDisableFirst = true;
    @track bDisableLast = true;
    @track bDisableNext = true;
    @track displayPageSize = '15';
    @track bDisableFirstRelated = true;
    @track bDisableLastRelated = true;
    @track bDisableNextRelated = true;
    @track displayPageSizeRelated = '15';
    @track pageSizeRelated = 15;
    @track pageSizeOptionsRelated = PAGE_SIZE_OPTIONS;
    @track transformedDataLengthRelated = 0;
    @track totalCountRelated = 0;
    @track totalPagesRelated = 1;
    @track currentPageRelated = 1;
    @track columnHeader = columnHeader;
    @track isInternalUser = false;
    @track accountId = '';
    @track librariesLoaded = false;
    @track isOpen = false;
    @track hasSearched = false;
    @track isClearButtonDisabled = true;
    @track isAccessPopUpTrue = false;
    @track buttonDisabled = false;
    @track isLoading = false;
    @track enableLogs = false;
    searchResultErrorMessage = errormessage;
    showSearchResultErrorMessage = false;
    labels = {
        scc_code_redemption_hover_message
    }
    get searchButtonClass() {
        return this.isSearchDisabled ? 'searchButtonDisabled' : 'searchButton';
    }
    get clearButtonClass() {
        return this.isClearButtonDisabled ? 'clearButtonDisabled' : 'clearButton';
    }
    connectedCallback() {
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        });
        getUserType()
            .then(result => {
                let parsedResult = JSON.parse(result);
                this.isInternalUser = parsedResult.isInternal;
                this.accountId = parsedResult.accountId;
            })
            .catch(error => {
                if (this.enableLogs) console.error('Error fetching user type:', error);
            });
    }
    sheetJsInitialized = false;
    renderedCallback() {
        if (this.sheetJsInitialized) {
            return;
        }
        loadScript(this, sheetJS)
            .then(() => {
                this.sheetJsInitialized = true;
            })
            .catch(error => {
                if (this.enableLogs) console.error('Error loading SheetJS library', error);
            });
        loadStyle(this, headmarkupstyle_static).then(() => {
        }).catch(error => {
            if (this.enableLogs) console.error("Error in loading the colors")
        })
        if (this.librariesLoaded) return;
        this.librariesLoaded = true;
        loadScript(this, writeExcelFile)
            .then(async (data) => {
                if (this.enableLogs) console.log("success------>>>", data);
            })
            .catch(error => {
                if (this.enableLogs) console.log("failure------>>>>", error);
            });
    }
    handleInputChange(event) {
        const field = event.target.name;
        if (field === 'poNumber') {
            this.poNumber = event.target.value;
        } else if (field === 'orderNumber') {
            this.orderNumber = event.target.value;
        } else if (field === 'isbn') {
            this.isbn = event.target.value;
        }
        this.isSearchDisabled = !(this.poNumber.length >= 3 || this.orderNumber.length >= 3 || this.isbn.length >= 3);
        this.isClearButtonDisabled = !(this.poNumber || this.orderNumber || this.isbn);
    }
    handleSearch(event) {
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
            this.isLoading = true;
            this.isSearchDisabled = true;
            this.isClearButtonDisabled = false;
            this.showSearchResultErrorMessage = false;
            this.showResults = true;
            this.isRelatedView = false;
            this.hasSearched = false;
            searchOrders({ poNumber: this.poNumber, orderNumber: this.orderNumber, isbn: this.isbn })
                .then(result => {
                    this.error = undefined;
                    if (this.enableLogs) console.log('result ->' + JSON.stringify(result));
                    this.showSearchResultErrorMessage = (result.length === 0);
                    if (result && result.length === 1) {
                        this.isRelatedView = true;
                        this.hasSearched = false;
                        this.showResults = false;
                        const singleOrder = result[0];
                        this.sapDocumentNumber = singleOrder.SAP_Document_Number__c;
                        this.showRelatedRecords(singleOrder.Id);
                    } else {
                        this.isRelatedView = false;
                        this.hasSearched = true;
                        this.showResults = true;
                        this.orders = result.map(item => {
                            const formatAddress = (address) => {
                                if (!address) return '';
                                const parts = [
                                    address.street,
                                    address.city,
                                    address.state,
                                    address.postalCode,
                                    address.country
                                ].filter(part => part && part !== 'undefined');
                                return parts.join(', ');
                            };
                            const shippingAddress = formatAddress(item.ShippingAddress);
                            const billingAddress = formatAddress(item.BillingAddress);
                            const effectiveDate = this.formatDate(item.EffectiveDate);
                            return {
                                ...item,
                                ShippingAddress: shippingAddress,
                                BillingAddress: billingAddress,
                                EffectiveDate: effectiveDate
                            };
                        });
                        this.paginateData();
                    }
                })
                .catch(error => {
                    this.error = error;
                    this.orders = undefined;
                    if (this.enableLogs) console.error('Error searching orders:', error);
                })
                .finally(() => {
                    this.isLoading = false;
                });
        }
    }
    handleVerifyAccessCode() {
        this.isAccessPopUpTrue = true;
        if (this.enableLogs) console.log('this.isAccessPopUpTrue', this.isAccessPopUpTrue);
    }
    closeaccessmodalpopup() {
        this.isAccessPopUpTrue = false;
    }
    formatDate(dateString) {
        const date = new Date(dateString);
        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = date.getFullYear();
        return `${month}/${day}/${year}`;
    }
    handleOrderClick(event) {
        const orderId = event.target.dataset.id;
        this.orderId1 = event.target.dataset.id;
        const sapDocumentNumber = event.target.dataset.sapNumber;
        if (orderId && sapDocumentNumber) {
            if (this.enableLogs) console.log('Order Clicked:', orderId, sapDocumentNumber);
            this.showRelatedRecords(orderId, sapDocumentNumber);
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        } else {
            if (this.enableLogs) console.error('Order ID or SAP Document Number is missing.');
        }
    }
    showRelatedRecords(orderId) {
        this.isLoading = true;
        this.isRelatedView = true;
        if (this.enableLogs) console.log('Fetching related records for order:', orderId);
        getRelatedRecords({ orderId: orderId, poNumber: this.poNumber, orderNumber: this.orderNumber, isbn: this.isbn })
            .then(result => {
                if (this.enableLogs) console.log('Related records result:', result);
                this.relatedRecords = this.flattenRecords(result);
                this.error = undefined;
                this.showSearchResultErrorMessage = (this.relatedRecords.length === 0);
                if (result.length > 0 && !this.sapDocumentNumber) {
                    this.sapDocumentNumber = result[0].SAP_Document_Number__c;
                }
                if (result.length === 0) {
                    this.totalPagesRelated = 1;
                    this.updateRelatedButtons();
                }
                this.paginateRelatedData();
            })
            .catch(error => {
                this.error = error;
                this.relatedRecords = undefined;
                this.totalPagesRelated = 1;
                if (this.enableLogs) console.error('Error getting related records:', error);
            })
            .finally(() => {
                this.isLoading = false;
            });
        setTimeout(() => {
            this.template.querySelector('.closeButton lightning-button').focus();
        }, 100);
    }
    flattenRecords(records) {
        return records.map(record => {
            return {
                ...record,
                EffectiveDate: this.formatDate(record.EffectiveDate)
            };
        });
    }
    handleClear() {
        this.hasSearched = false;
        this.poNumber = '';
        this.orderNumber = '';
        this.isbn = '';
        this.isSearchDisabled = true;
        this.showResults = false;
        this.orders = [];
        this.relatedRecords = [];
        this.pagedRelatedRecords = [];
        this.pagedOrders = [];
        this.currentPage = 1;
        this.totalPages = 1;
        this.showSearchResultErrorMessage = false;
        this.isRelatedView = false;
        this.error = undefined;
        this.transformedDataLength = 0;
        this.transformedDataLengthRelated = 0;
        this.totalCount = 0;
        this.totalCountRelated = 0;
        this.bDisableFirst = true;
        this.bDisableLast = true;
        this.bDisableNext = true;
        this.bDisableFirstRelated = true;
        this.bDisableLastRelated = true;
        this.bDisableNextRelated = true;
        this.isClearButtonDisabled = true;
    }
    handleResend() {
        if (this.enableLogs) console.log('Resending the Access Codes...');
    }
    handleClose() {
        this.isRelatedView = false;
        this.relatedRecords = [];
        this.pagedRelatedRecords = [];
        this.disableRelatedPrevious = true;
        this.disableRelatedNext = true;
        this.showSearchResultErrorMessage = false;
    }
    handleResendForAccess() {
        this.isOpen = true;
    }
    sendResendAceessCode(event) {
        const eAddress = event.detail;        
        const eAccessCodes = this.relatedRecords.map(record => record.EAccess_Code__c);
        console.log('eAddress>>>',eAddress);
        console.log('eAccessCodes>>>',eAccessCodes);
        sendResendAccess({
            eAddrs: eAddress,
            orderNumber: this.sapDocumentNumber,
            eAccessCodes: eAccessCodes
        })
            .then(() => {
                this.isOpen = false;
            })
            .catch(error => {
                if (this.enableLogs) console.error('Error: ', error);
            });
    }
    cancelResend(event) {
        this.isOpen = event.detail;
    }
    firstPageRelated() {
        this.currentPageRelated = 1;
        this.paginateRelatedData();
    }
    previousPageRelated() {
        if (this.currentPageRelated > 1) {
            this.currentPageRelated -= 1;
            this.paginateRelatedData();
        }
    }
    nextPageRelated() {
        if (this.currentPageRelated < this.totalPagesRelated) {
            this.currentPageRelated += 1;
            this.paginateRelatedData();
        }
    }
    lastPageRelated() {
        this.currentPageRelated = this.totalPagesRelated;
        this.paginateRelatedData();
    }
    handlePageSizeChangeRelated(event) {
        this.pageSizeRelated = parseInt(event.target.value, 10);
        this.displayPageSizeRelated = event.target.value;
        this.currentPageRelated = 1;
        this.paginateRelatedData();
    }
    paginateRelatedData() {
        const start = (this.currentPageRelated - 1) * this.pageSizeRelated;
        const end = start + parseInt(this.pageSizeRelated, 10);
        this.pagedRelatedRecords = this.relatedRecords.slice(start, end);
        console.log('start>>>',start);
        console.log('end>>>>',end);
        console.log('this.pagedRelatedRecords>>>>',this.pagedRelatedRecords);
        console.log('this.relatedRecords>>>>',this.relatedRecords);
        this.totalPagesRelated = Math.ceil(this.relatedRecords.length / this.pageSizeRelated);
        this.updateRelatedButtons();
        this.transformedDataLengthRelated = this.pagedRelatedRecords.length;
        if (this.totalPagesRelated == 0) {
            this.totalPagesRelated = 1;
        }
        this.totalCountRelated = this.relatedRecords.length;
    }
    updateRelatedButtons() {
        this.bDisableFirstRelated = this.currentPageRelated === 1;
        this.bDisableLastRelated = this.currentPageRelated === this.totalPagesRelated || this.relatedRecords.length === 0;
        this.bDisableNextRelated = this.currentPageRelated >= this.totalPagesRelated;
    }
    get pageNumberRelated() {
        return this.currentPageRelated;
    }
    get totalPagesRelated() {
        if (this.totalPagesRelated !== 0) {
            return this.totalPagesRelated;
        } else {
            return 1;
        }
    }
    firstPage() {
        this.currentPage = 1;
        this.paginateData();
    }
    previousPage() {
        if (this.currentPage > 1) {
            this.currentPage -= 1;
            this.paginateData();
        }
    }
    nextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage += 1;
            this.paginateData();
        }
    }
    lastPage() {
        this.currentPage = this.totalPages;
        this.paginateData();
    }
    handlePageSizeChange(event) {
        this.pageSize = parseInt(event.target.value, 10);
        this.displayPageSize = event.target.value;
        this.currentPage = 1;
        this.paginateData();
    }
    paginateData() {
        const start = (this.currentPage - 1) * parseInt(this.pageSize, 10);
        const end = start + parseInt(this.pageSize, 10);
        this.pagedOrders = this.orders.slice(start, end);
        this.totalPages = Math.ceil(this.orders.length / this.pageSize);
        this.updateButtons();
        this.transformedDataLength = this.pagedOrders.length;
        if (this.totalPages == 0) {
            this.totalPages = 1;
        }
        this.totalCount = this.orders.length;
    }
    updateButtons() {
        this.bDisableFirst = this.currentPage === 1;
        this.bDisableLast = this.currentPage === this.totalPages || this.orders.length === 0;
        this.bDisableNext = this.currentPage >= this.totalPages;
    }
    get pageNumber() {
        return this.currentPage;
    }
    get totalPages() {
        if (this.totalPages !== 0) {
            return this.totalPages;
        } else {
            return 1;
        }
    }
    taskTypeHelpTextClassCount = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground countInfo-poppup slds-hide';
    togglePasswordHintCount() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground countInfo-poppup slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground countInfo-poppup';
        this.taskTypeHelpTextClassCount = this.taskTypeHelpTextClassCount == hideCss ? showCss : hideCss;
    }
    taskTypeHelpTextClassCode = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
    togglePasswordHintCode() {
        let hideCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-fall-into-ground slds-hide';
        let showCss = 'slds-popover slds-popover_tooltip slds-nubbin_bottom-right slds-rise-from-ground';
        this.taskTypeHelpTextClassCode = this.taskTypeHelpTextClassCode == hideCss ? showCss : hideCss;
    }
    columnSchema = [
        {
            column: 'PO#',
            type: String,
            wrap: 'true',
            value: data => data.PoNumber__c
        },
        {
            column: 'Order#',
            type: String,
            value: data => data.SAP_Document_Number__c
        },
        {
            column: 'Order Date',
            type: String,
            value: data => data.EffectiveDate
        },
        {
            column: 'ISBN',
            type: String,
            value: data => data.ProductCode__c
        },
        {
            column: 'Title Description',
            type: String,
            wrap: 'true',
            value: data => data.Title_Description__c
        },
        {
            column: 'E-Access Code',
            type: String,
            value: data => data.EAccess_Code__c
        },
        {
            column: 'Email Recipient',
            type: String,
            value: data => data.Customer_Email__c
        },
        {
            column: 'Code Redemption',
            type: String,
            value: data => data.No_Of_Redemptions__c
        }
    ];
    // modifed by sudha added this.relatedRecords instead of this.pagedRelatedRecords 
    handleExport() {
        const orderNumber = this.relatedRecords.length > 0 ? this.relatedRecords[0].SAP_Document_Number__c : 'AccessCodeOrder';
        let relatedColumns = [
            { header: 'PO#', key: 'PoNumber__c', width: 15 },
            { header: 'Order#', key: 'SAP_Document_Number__c', width: 20 },
            { header: 'Order Date', key: 'EffectiveDate', width: 20 },
            { header: 'ISBN', key: 'ProductCode__c', width: 15 },
            { header: 'Title Description', key: 'Title_Description__c', width: 30 },
            { header: 'E-Access Code', key: 'EAccess_Code__c', width: 20 },
            { header: 'Email Recipient', key: 'Customer_Email__c', width: 25 },
            { header: 'Code Redemption', key: 'No_Of_Redemptions__c', width: 15 }
        ];
        const records = this.relatedRecords.map(record => ({
            PoNumber__c: record.PoNumber__c || '',
            SAP_Document_Number__c: record.SAP_Document_Number__c || '',
            EffectiveDate: record.EffectiveDate || '',
            ProductCode__c: record.ProductCode__c || '',
            Title_Description__c: record.Title_Description__c || '',
            EAccess_Code__c: record.EAccess_Code__c || '',
            Customer_Email__c: record.Customer_Email__c || '',
            No_Of_Redemptions__c: record.No_Of_Redemptions__c || ''
        }));
        const workbook = XLSX.utils.book_new();
        const worksheet = XLSX.utils.json_to_sheet(records, { header: relatedColumns.map(col => col.key) });
        XLSX.utils.sheet_add_aoa(worksheet, [relatedColumns.map(col => col.header)], { origin: 'A1' });
        XLSX.utils.book_append_sheet(workbook, worksheet, 'Order Data');
        XLSX.writeFile(workbook, `${orderNumber}.xlsx`);
    }
}