/*
LWC Component:Scc_documentSearchLWC
Author: CTS (Vaibhav Saptal)
Created Date: 23/07/2024
Reason: JS logic Scc_documentSearchLWC component.
Modified Date: 29/07/2024
*/
import { LightningElement, track, wire, api } from 'lwc';
import getDocSearchByOptions from '@salesforce/apex/scc_documentSearchLWC_Controller.getDocSearchByOptions';
import getCriteriaDocdata from '@salesforce/apex/scc_documentSearchLWC_Controller.getCriteriaDocdata';
import getUserInformation from '@salesforce/apex/scc_headerLWC_Controller.getUserInformation';
import getBillingAddress from '@salesforce/apex/scc_confirmAddress.getUserBillingAddress';
import getRelatedShippingAddress from '@salesforce/apex/scc_confirmAddress.getUserShippingAddress';
import scc_home_Search from "@salesforce/label/c.scc_home_Search";
import scc_OrderStatus_Clear from "@salesforce/label/c.scc_OrderStatus_Clear";
import scc_home_From from "@salesforce/label/c.scc_home_From";
import scc_home_To from "@salesforce/label/c.scc_home_To";
import scc_home_Order_Date from "@salesforce/label/c.scc_home_Order_Date";
import scc_emailDocumentSuccess from "@salesforce/label/c.scc_emailDocumentSuccess";
import scc_document_not_found_errormsg from "@salesforce/label/c.scc_document_not_found_errormsg";
import scc_noResults from "@salesforce/resourceUrl/scc_noResults";
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import scc_email_icon_white from '@salesforce/resourceUrl/scc_email_icon_white';
import scc_email_icon_blue from '@salesforce/resourceUrl/scc_email_icon_blue';
import scc_calender_icon from "@salesforce/resourceUrl/scc_calender_icon";
import { loadStyle } from 'lightning/platformResourceLoader';
import headmarkupstyle_static from '@salesforce/resourceUrl/headmarkupstyle_static';
import generateRADARRequest from '@salesforce/apex/scc_documents_RADAR_Controller.generateRADARRequest';
import { viewAndDownloadPdf } from 'c/scc_exportRADAR_PdfLWC';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
export default class Scc_documentSearchLWC extends LightningElement {
    alertIcon = imageIcons + '/Images/alert.png';
    @track SearchByvalue = '';
    @track InvoiceSelect = false;
    @track SearchByOptions1 = [];
    @track isLoading1 = false;
    @track InvoNum = '';
    @track SearchDisabledReturn = true;
    @track orderDetailsSect = false;
    @track showSearchResults = false;
    @track sortDirection;
    @track sortedBy;
    @track selectedDocuments = '';
    @track allSelected = '';
    @track isAllChecked = false;
    @track isEachChecked = false;
    @track valEmail = '';
    @track disableDoc = true;
    @track requestData;
    @track emailUpdated = '';
    @track emailIcon = scc_email_icon_white;
    @track popupEmailIcon = scc_email_icon_white;
    First = '<< First'
    Previous = '< Previous'
    next = 'Next >'
    Last = 'Last >>'
    pageSizeOptions = [15, 30, 45, 60];
    records = [];
    totalRecords = 0;
    pageSize;
    @track totalPages = 1;
    pageNumber = 1;
    recordsToDisplay = [];
    @track data;
    @track totalRecords;
    @track isGuest = false;
    @track isInternal = false;
    @track CustomerName = false;
    @track isAdvanced = false;
    @track showInvoiceEmail = false;
    @track Email = '';
    @track showEmailMessage = false;
    isViewScChecked = true;
    isEmailChecked = false;
    sendEmail = true;
    showCheckBox = false;
    InvoiceStatusValue = 'All';
    PONum = '';
    startDate = null;
    endDate = null;
    minimumDate = null;
    accNumber = '';
    @track currentTab = 'tab-default-1__item';
    @track showStatementEmailMessage = false;
    @track isrequestComboboxExpanded = false;
    @track quickTabSelected = true;
    @track advancedTabSelected = false;
    @track docNotFound = false;
    @track showError = false;
    @track errorMessage = 'Please enter a valid email address (e.g., example@example.com)';
    @track enableLogs = false;
    @track monthOptions = [{ label: 'January', value: '01' }, { label: 'February', value: '02' },
    { label: 'March', value: '03' }, { label: 'April', value: '04' },
    { label: 'May', value: '05' }, { label: 'June', value: '06' },
    { label: 'July', value: '07' }, { label: 'August', value: '08' },
    { label: 'September', value: '09' }, { label: 'October', value: '10' },
    { label: 'November', value: '11' }, { label: 'December', value: '12' }
    ];
    @track InvoiceStatusOptions = [{ label: 'All', value: 'All' }, { label: 'Open', value: 'Open' }, { label: 'Closed', value: 'Closed' }];
    @track yearOptions = [{ label: 'Current Year', value: 'Current Year' }, { label: 'Last Year', value: 'Last Year' }, { label: 'Prior Year', value: 'Prior Year' }];
    labels = {
        scc_home_Search,
        scc_OrderStatus_Clear,
        scc_noResults,
        scc_email_icon_white,
        scc_email_icon_blue,
        scc_calender_icon,
        scc_home_From,
        scc_emailDocumentSuccess,
        scc_home_To, scc_home_Order_Date,
        scc_document_not_found_errormsg
    }
    @track confirmAddress = false;
    constructor() {
        super();
        getUserInformation().then(response => {
            if (this.enableLogs) console.log('response is', response);
            let paser = JSON.parse(response);
            let data = paser[0];
            if (this.enableLogs) console.log(data);
            this.userName = data.userName;
            this.accountName = data.accountName;
            this.isGuest = data.isGuest;
            this.isInternal = data.isInternal;
            this.accNumber = data.AccountNumber;
            if (!this.isInternal) {
                this.confirmAddress = true;
            } else {
                this.confirmAddress = false;
            }
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        });
    }
    connectedCallback() {
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        });
        this.callSearchOptions();
        this.handleDates();
        this.docNotFound = false;
        this.template.addEventListener('keydown', this.handleKeydown.bind(this));
    }
    disconnectedCallback() {
        this.template.removeEventListener('keydown', this.handleKeydown);
    }
    handleKeydown(event) {
        if (event.key === 'Escape') {
            if (this.showInvoiceEmail) {
                this.closeModal();
            }
        }
    }
    formatDate(date) {
        const [year, month, day] = date.split('-');
        return `${month}/${day}/${year}`;
    }
    handleDates() {
        const today = new Date();
        const threeMonthsAgo = new Date(today);
        const twentyFourMonthsAgo = new Date(today);
        twentyFourMonthsAgo.setMonth(today.getMonth() - 24);
        threeMonthsAgo.setMonth(today.getMonth() - 3);
        this.startDate = threeMonthsAgo.toISOString().split('T')[0];
        this.endDate = today.toISOString().split('T')[0];
        this.minimumDate = twentyFourMonthsAgo.toISOString().split('T')[0];
    }
    callSearchOptions() {
        this.isLoading1 = true;
        getDocSearchByOptions({
            HomePage: false,
            isAdvanced: this.isAdvanced,
            isInternal: this.isInternal
        }).then(response => {
            if (this.enableLogs) console.log('response is', response);
            let paser = JSON.parse(response);
            if (this.enableLogs) console.log('getDocSearchByOptions', paser);
            this.SearchByOptions1 = JSON.parse(response);
            this.isLoading1 = false;
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
            this.isLoading1 = false;
        })
    }
    handleInvoNumChange(event) {
        this.InvoNum = event.target.value
    }
    handleInvoiceStatusOptionChange(event) {
        this.InvoiceStatusValue = event.target.value;
    }
    handlePONumChange(event) {
        this.PONum = event.target.value;
    }
    handleStartDateChange(event) {
        this.startDate = event.target.value;
    }
    handleEndDateChange(event) {
        this.endDate = event.target.value;
    }
    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
    }
    @track base64String;
    @track iFrameUrl;
    handleInvoice(event) {
        this.docNotFound = false;
        const requestData = {
            documentNumber: event.target.dataset.invoiceNumber,
            opeartion: this.SearchByvalue,
            emailId: '',
            Combined: 'N',
            IncludePOD: 'N',
            accountNumber: this.accNumber,
            month: this.monthValue,
            year: this.yearValue
        };
        if (this.isViewScChecked) {
            generateRADARRequest({
                requestData: requestData
            }).then(data => {
                if (this.enableLogs) console.log('data', data);
                this.base64String = JSON.parse(data);
            })
                .catch(error => {
                    if (this.enableLogs) console.log('error', error);
                }).finally(() => {
                    if (this.base64String != null && this.base64String != '') {
                        let valRetn = viewAndDownloadPdf(this.base64String);
                    } else {
                        this.docNotFound = true;
                    }
                });
        } else if (this.isEmailChecked) {
            this.showEmailDoc();
        }
    }
    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }
    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.paginationHelper();
    }
    firstPage() {
        this.pageNumber = 1;
        this.paginationHelper();
    }
    lastPage() {
        this.pageNumber = this.totalPages;
        this.paginationHelper();
    }
    paginationHelper() {
        this.recordsToDisplay = [];
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        if (this.totalPages <= 1) {
            this.totalPages = 1;
        }
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.records[i]);
        }
    }
    onHandleSort(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortedBy, this.sortDirection);
    }
    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.recordsToDisplay));
        let keyValue = (element) => {
            return element[fieldname];
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((xElement, yElement) => {
            xElement = keyValue(xElement) ? keyValue(xElement) : '';
            yElement = keyValue(yElement) ? keyValue(yElement) : '';
            return isReverse * ((xElement > yElement) - (yElement > xElement));
        });
        this.recordsToDisplay = parseData;
    }
    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }
    get startDate() {
        return this.startDate;
    }
    get endDate() {
        return this.endDate;
    }
    get SearchByOptions() {
        return this.SearchByOptions1;
    }
    get noRecordsToDisplay() {
        return this.recordsToDisplay.length == 0;
    }
    get InvoiceStatusOptions() {
        return InvoiceStatusOptions;
    }
    get isAdvanced() {
        return this.isAdvanced;
    }
    handleDocPrefChange(event) {
        if (event.target.dataset.id == 'View on Screen') {
            this.isViewScChecked = true;
            this.isEmailChecked = false;
            this.showCheckBox = false;
            this.showEmailMessage = false;
            this.showStatementEmailMessage = false;
        }
        if (event.target.dataset.id == 'Email') {
            this.isViewScChecked = false;
            this.isEmailChecked = true;
            this.showCheckBox = true;
        }
    }
    handlecheck(event) {
        this.allSelected = event.target.checked;
        let selectedInvoiceArray = [];
        const checkboxes = this.template.querySelectorAll('input.invoicecheckbox');
        this.selectedDocuments = '';
        checkboxes.forEach(checkbox => {
            checkbox.checked = this.allSelected;
            if (this.allSelected) {
                selectedInvoiceArray.push(checkbox.value);
            }
            else {
                this.selectedDocuments = '';
            }
        });
        this.selectedDocuments = selectedInvoiceArray.join(';');
        if (this.enableLogs) console.log('selectedDocuments', this.selectedDocuments);
        const selectedCount = this.selectedDocuments ? this.selectedDocuments.split(';').length : 0;
        if (selectedCount > 0 && selectedCount <= 5) {
            this.sendEmail = false;
            this.emailIcon = scc_email_icon_blue;
        }
        else {
            this.sendEmail = true;
            this.emailIcon = scc_email_icon_white;
        }
    }
    handleDocEmailChange(event) {
        const value = event.target.name;
        if (event.target.name == 'all') {
            this.isAllChecked = true;
            this.isEachChecked = false;
        }
        if (event.target.name == 'each') {
            this.isEachChecked = true;
            this.isAllChecked = false;
        }
        if (event.target.name == 'email') {
            this.valEmail = event.target.value;
            if (this.enableLogs) console.log('email', this.valEmail);
            const emailArray = this.valEmail.split(',').map(email => email.trim());
            const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
            this.showError = !emailArray.every(email => emailRegex.test(email) || email === '');
            if (!this.showError) {
                let semiColonSeperated = this.valEmail.replace(/,/g, ';');
                this.emailUpdated = semiColonSeperated.replace(/\s*;\s*/g, ';').trim();
            }
        }
    }
    get disableDocEmail() {
        if (this.valEmail != '' && !this.showError && (this.isAllChecked == true || this.isEachChecked == true)) {
            this.disableDoc = false;
        } else {
            this.disableDoc = true;
        }
        return this.disableDoc;
    }
    showSendDoc(event) {
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
            if (this.enableLogs) console.log('selectedDocuments', this.selectedDocuments);
            this.showInvoiceEmail = false;
            this.handleSubmit();
        }
    }
    handleSubmit() {
        if (this.isAllChecked) {
            this.requestData = {
                documentNumber: this.selectedDocuments,
                opeartion: this.SearchByvalue,
                emailId: this.emailUpdated,
                Combined: 'Y',
                IncludePOD: 'N',
                accountNumber: this.accNumber,
                month: this.monthValue,
                year: this.yearValue
            }
        }
        else if (this.isEachChecked) {
            this.requestData = {
                documentNumber: this.selectedDocuments,
                opeartion: this.SearchByvalue,
                emailId: this.emailUpdated,
                Combined: 'N',
                IncludePOD: 'N',
                accountNumber: this.accNumber,
                month: this.monthValue,
                year: this.yearValue
            }
        }
        if (this.enableLogs) console.log('this.requestData', this.requestData);
        generateRADARRequest({
            requestData: this.requestData
        }).then(data => {
            if (this.enableLogs) console.log('data', data);
            this.base64String = JSON.parse(data);
            if (this.SearchByvalue == 'Statement') {
                this.showStatementEmailMessage = true;
                this.showEmailMessage = false;
            } else {
                this.showEmailMessage = true;
                this.showStatementEmailMessage = false;
            }
        })
            .catch(error => {
                if (this.enableLogs) console.log('error', error);
            });
    }
    handleRefresh() {
        this.valEmail = '';
        const checkboxes = this.template.querySelectorAll('input.invoicecheckbox');
        this.selectedDocuments = '';
        this.sendEmail = true;
        checkboxes.forEach(checkbox => {
            checkbox.checked = false;
        })
        this.isEachChecked = false;
        this.isAllChecked = false;
    }
    handlecheckbox(event) {
        const invoiceid = event.target.value;
        const isChecked = event.target.checked;
        let selectedInvoiceArray = this.selectedDocuments ? this.selectedDocuments.split(';') : [];
        if (isChecked) {
            if (!selectedInvoiceArray.includes(invoiceid)) {
                selectedInvoiceArray.push(invoiceid);
            }
        }
        else {
            selectedInvoiceArray = selectedInvoiceArray.filter(docId => docId !== invoiceid);
        }
        this.selectedDocuments = selectedInvoiceArray.join(';');
        const selectedCount = this.selectedDocuments ? this.selectedDocuments.split(';').length : 0;
        if (selectedCount > 0 && selectedCount <= 5) {
            this.sendEmail = false;
            this.emailIcon = scc_email_icon_blue;
        }
        else {
            this.sendEmail = true;
            this.emailIcon = scc_email_icon_white;
        }
    }
    @track StatementSelect;
    @track DebitMemoSelect;
    @track CreditMemoSelect;
    @track yearValue = '';
    @track monthValue = '';
    @track isStatementSelected = false;
    @track billingAccountNumber = '';
    handleSearchOptionChange(event) {
        this.handleClearClick();
        this.SearchByvalue = event.target.value;
        this.InvoiceSelect = false;
        this.DebitMemoSelect = false;
        this.StatementSelect = false;
        this.CreditMemoSelect = false;
        this.isStatementSelected = this.SearchByvalue === 'Statement';
        if (this.SearchByvalue == 'Invoice' || this.SearchByvalue == 'Invoice & Proof of Delivery (if available)' || this.SearchByvalue == 'Proof of Delivery (if available)') {
            this.InvoiceSelect = true;
        }
        if (this.SearchByvalue == 'Statement') {
            this.StatementSelect = true;
        }
        if (this.SearchByvalue == 'Debit Memo') {
            this.DebitMemoSelect = true;
        }
        if (this.SearchByvalue == 'Credit Memo') {
            this.CreditMemoSelect = true;
        }
    }
    handleAriaExpanded() {
        this.isrequestComboboxExpanded = !this.isrequestComboboxExpanded;
    }
    handleMonthOptionChange(event) {
        this.monthValue = event.target.value;
    }
    handleYearOptionChange(event) {
        this.yearValue = event.target.value;
    }
    handleBillingAccountChange(event) {
        this.billingAccountNumber = event.target.value;
        this.accNumber = event.target.value;
    }
    handleClearClick(event) {
        if (!JSON.parse(this.template.querySelector('.clear-button').getAttribute('aria-disabled'))) {
            this.recordsToDisplay = [];
            this.showSearchResults = false;
            this.InvoNum = '';
            this.monthValue = '';
            this.yearValue = '';
            this.PONum = '';
            this.InvoiceStatusValue = 'All';
            this.billingAccountNumber = '';
            this.handleDates();
            this.showEmailMessage = false;
            this.showStatementEmailMessage = false;
            this.sendEmail = true;
            this.docNotFound = false;
            this.showError = false;
            this.isEmailChecked = false;
            this.isViewScChecked = true;
            this.handleRefresh();
        }
    }
    get SearchDisabled() {
        if (this.isAdvanced == false) {
            if ((this.InvoNum != '')) {
                this.SearchDisabledReturn = false;
            } else {
                if ((this.monthValue != '' && this.yearValue != '')) {
                    this.SearchDisabledReturn = false;
                } else {
                    this.SearchDisabledReturn = true;
                }
            }
        }
        if (this.isAdvanced == true) {
            if ((this.InvoNum != '' || this.PONum != '' || (this.startDate != null && this.endDate != null))) {
                this.SearchDisabledReturn = false;
            } else {
                this.SearchDisabledReturn = true;
            }
        }
        return this.SearchDisabledReturn;
    }
    formatDate(date) {
        const [year, month, day] = date.split('-');
        return `${month}/${day}/${year}`;
    }
    handleBackClick() {
        this.records = this.data;
        this.pageSize = this.pageSizeOptions[0];
        this.totalRecords = this.data.length;
        this.paginationHelper();
        this.orderDetailsSect = false;
    }
    get recordsToDisplay() {
        return this.recordsToDisplay;
    }
    @track sapShipTo = '';
    @track sapBillTo = '';
    handleSearch(event) {
        if (!JSON.parse(this.template.querySelector('.search-button').getAttribute('aria-disabled'))) {
            this.isLoading1 = true;
            this.showEmailMessage = false;
            this.showStatementEmailMessage = false;
            this.docNotFound = false;
            this.handleRefresh();
            if (!!this.selectedShipping) {
                this.sapShipTo = this.selectedShipping.ShipToNumber;
            }
            if (!!this.selectedBilling) {
                this.sapBillTo = this.selectedBilling.BillToNumber;
            }
            const docRequestData = {
                SearchByvalue: this.SearchByvalue,
                InvoNum: this.InvoNum,
                PONum: this.PONum,
                InvoiceStatus: this.InvoiceStatusValue,
                startDate: this.startDate,
                endDate: this.endDate,
                monthValue: this.monthValue,
                yearValue: this.yearValue,
                isAdvanced: this.isAdvanced,
                billingAccountNumber: this.isInternal ? this.billingAccountNumber : null,
                SAP_ShipTo: this.sapShipTo,
                SAP_BillTo: this.sapBillTo
            };
            if (this.SearchByvalue == 'Statement') {
                if (this.isViewScChecked) {
                    let ev = { target: { dataset: { invoiceNumber: '' } } };
                    this.handleInvoice(ev);
                } else if (this.isEmailChecked) {
                    this.showEmailDoc(event);
                }
                this.isLoading1 = false;
            } else {
                this.recordsToDisplay = [];
                this.totalRecords = 0;
                this.showSearchResults = true;
                if (this.enableLogs) console.log('docRequestData', docRequestData);
                getCriteriaDocdata({
                    docRequestData: docRequestData
                }).then(response => {
                    if (this.enableLogs) console.log('response is', response);
                    let paser = JSON.parse(response);
                    if (this.enableLogs) console.log('getCriteriaOrderdata', paser);
                    this.data = JSON.parse(response);
                    if (this.enableLogs) console.log('this.data ', this.data);
                    this.records = this.data;
                    this.pageSize = this.pageSizeOptions[0];
                    this.totalRecords = this.data.length;
                    this.paginationHelper();
                    if (this.totalRecords == 1) {
                        let ev = { target: { dataset: { invoiceNumber: data[0].invoice } } };
                        this.handleInvoice(ev);
                    }
                    this.isLoading1 = false;
                }).catch(error => {
                    if (this.enableLogs) console.log('error is', error);
                    this.isLoading1 = false;
                })
            }
        }
    }
    handleActive(event) {
        const tab = event.target.dataset.id;
        if (this.currentTab != tab) {
            this.currentTab = tab;
            if (tab == 'tab-default-2__item') {
                this.handleClearClick();
                this.isAdvanced = true;
                this.SearchByvalue = '';
                this.InvoiceSelect = false;
                this.CreditMemoSelect = false;
                this.DebitMemoSelect = false;
                this.StatementSelect = false;
                this.isViewScChecked = true;
                this.isEmailChecked = false;
                this.advancedTabSelected = true;
                this.quickTabSelected = false;
                this.callSearchOptions();
            }
            if (tab == 'tab-default-1__item') {
                this.handleClearClick();
                this.isAdvanced = false;
                this.SearchByvalue = '';
                this.InvoiceSelect = false;
                this.CreditMemoSelect = false;
                this.DebitMemoSelect = false;
                this.StatementSelect = false;
                this.isViewScChecked = true;
                this.isEmailChecked = false;
                this.advancedTabSelected = false;
                this.quickTabSelected = true;
                this.callSearchOptions();
            }
            setTimeout(() => {
                this.template.querySelector(".requestCombobox").focus();
            }, 100);
        }
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
            if (ele.classList.contains("slds-show")) {
                ele.classList.remove("slds-show");
                ele.classList.add("slds-hide");
            }
        })
    }
    toggleSearchFields(event) {
        this.template.querySelector('.search-fields-group').classList.toggle("slds-hide");
        event.target.classList.toggle("chevron-up");
    }
    billaddress;
    selectedAccountId;
    billingaddreses;
    Shipaddress;
    searchTerm = '';
    searchTermShip = '';
    totalRecordsInShip;
    filteredresult = [];
    filteredresultt = [];
    totalRecords = '';
    selectedAcc = [];
    selectedBilling;
    selectedShipping;
    lengthBillAddress;
    totalBillToRecords;
    totalShipToRecords
    selectedAccount;
    selectedShipAccount;
    previouslySelected;
    showMultiAddressPage = false;
    showSingleAddressPage = false;
    showShipAddressPage = false;
    showShipAddressEmptyPage = false;
    isChecked = false;
    @wire(getBillingAddress)
    wiredBillAddresss({ error, data }) {
        if (data) {
            this.billaddress = data;
            this.selectedBilling = this.billaddress.find(billing => billing.AccId === this.billaddress[0].AccId);
            if (this.enableLogs) console.log('this.selectedBilling', this.selectedBilling);
            this.totalRecords = data.length;
            this.billingaddreses = data;
            this.applyFilters();
            this.selectedAccount = data[0];
        } else if (error) {
            this.error = error;
            if (this.enableLogs) console.log('errorbillingaddressloadfirst', error);
        }
    }
    @wire(getRelatedShippingAddress)
    wiredShipAddress({ error, data }) {
        if (data) {
            this.Shipaddress = data;
            this.totalRecordsInShip = data.length;
            if (this.totalRecords > 1 || this.totalRecordsInShip > 1) {
                this.showMultiAddressPage = true;
                this.showShipAddressEmptyPage = true;
                this.isChecked = true;
            } else {
                this.showMultiAddressPage = false;
                this.selectedShipping = this.Shipaddress.find(shipping => shipping.AccShipId === this.Shipaddress[0].AccShipId);
                this.showShipAddressEmptyPage = false;
            }
            this.showSingleAddressPage = true;
            this.applyFilterss();
        }
        else if (error) {
            this.error = error;
        }
    }
    renderedCallback() {
        loadStyle(this, headmarkupstyle_static)
            .then(() => {
            })
            .catch(error => {
                if (this.enableLogs) console.error("Error in loading the colors", error)
            });
        if (this.selectedAccountId) {
            const billingInputs = this.template.querySelectorAll('input[name="BillingAddresss"]');
            billingInputs.forEach(input => {
                if (this.enableLogs) console.log('insideBillingAddress', this.selectedAccountId, 'inputs', input);
                if (input.value === this.selectedAccountId) {
                    input.checked = true;
                }
            });
        }
        if (this.showInvoiceEmail) {
            this.focusCloseButton();
        }
    }
    focusCloseButton() {
        const closeButton = this.template.querySelector('[data-id="closeButton"]');
        if (closeButton) {
            closeButton.focus();
        } else {
            if (this.enableLogs) console.error('Close button not found');
        }
    }
    handleRowClick(event) {
        this.selectedAccountId = event.currentTarget.dataset.recordId;
        this.selectedBilling = this.billaddress.find(billing => billing.AccId === this.selectedAccountId);
        if (this.enableLogs) console.log('this.selectedBilling', this.selectedBilling);
    }
    handleShipRowClick(event) {
        this.selectedShipAccountId = event.currentTarget.dataset.recordId;
        this.selectedShipping = this.Shipaddress.find(shipping => shipping.AccShipId === this.selectedShipAccountId);
        this.showShipAddressEmptyPage = false;
        if (this.enableLogs) console.log('this.selectedShipping', this.selectedShipping);
        this.isChecked = false;
        const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
        shippingInputs.forEach(input => {
            if (this.enableLogs) console.log('insideshippingAddress', this.selectedShipAccountId, 'inputs', input);
            if (input.value === this.selectedShipAccountId) {
                input.checked = true;
            }
        });
    }
    handlecheckboxChange(event) {
        this.isChecked = event.target.checked;
        if (this.isChecked == true) {
            this.selectedShipping = [];
            this.showShipAddressEmptyPage = true;
            const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
            shippingInputs.forEach(input => {
                if (this.enableLogs) console.log('insideshippingAddress', this.selectedShipAccountId, 'inputs', input);
                if (input.value === this.selectedShipAccountId) {
                    if (this.enableLogs) console.log('this.selectedShipAccountId', this.selectedShipAccountId);
                    input.checked = false;
                    this.handlechangemethod();
                }
            });
        }
        else {
            this.selectedShipAccountId = this.Shipaddress[0].AccShipId;
            this.selectedShipping = this.Shipaddress.find(shipping => shipping.AccShipId === this.selectedShipAccountId);
            this.showShipAddressEmptyPage = false;
            this.showShipAddressPage = true;
            const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
            shippingInputs.forEach(input => {
                if (this.enableLogs) console.log('insideshippingAddress', this.selectedShipAccountId, 'inputs', input);
                if (input.value === this.selectedShipAccountId) {
                    input.checked = true;
                }
            });
        }
    }
    handlechangemethod() {
        if (this.selectedShipAccountId) {
            const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
            shippingInputs.forEach(input => {
                if (this.enableLogs) console.log('insideshippingAddress', this.selectedShipAccountId, 'inputs', input);
                if (input.value === this.selectedShipAccountId) {
                    input.checked = false;
                }
            });
        }
    }
    handleUserInputs(event) {
        this.searchTerm = event.target.value.toLowerCase();
        if (this.searchTerm.length >= 3 || this.searchTerm == '') {
            this.applyFilters();
        }
    }
    clearFilterInputBill() {
        this.searchTerm = '';
        this.applyFilters();
    }
    handleUserInputsShip(event) {
        this.searchTermShip = event.target.value.toLowerCase();
        if (this.searchTermShip.length >= 3 || this.searchTermShip == '') {
            this.applyFilterss();
        }
    }
    clearFilterInputShip() {
        this.searchTermShip = '';
        this.applyFilterss();
    }
    applyFilters() {
        if (!this.billingaddreses) {
            this.filteredresult = this.billingaddreses;
            return;
        }
        const searchte = this.searchTerm;
        this.filteredresult = this.billingaddreses.filter(billingadd => {
            if (this.enableLogs) console.log('name and zip value is', billingadd.AccountName, billingadd.ZipCode);
            const zipfromacc = billingadd.ZipCode;
            const accountName = billingadd.AccountName;
            if ((zipfromacc == undefined || zipfromacc == '') && (accountName != undefined && accountName != '')) {
                return (
                    (billingadd.AccountName.toLowerCase().includes(searchte))
                );
            }
            if (zipfromacc == undefined && zipfromacc == '' && accountName == undefined && accountName == '') {
                return;
            }
            if (zipfromacc !== undefined && zipfromacc !== '' && accountName !== undefined && accountName !== '') {
                return (
                    (billingadd.AccountName.toLowerCase().includes(searchte))
                    || (billingadd.ZipCode.toLowerCase().includes(searchte))
                );
            }
            if ((accountName == undefined || accountName == '') && (zipfromacc != undefined && zipfromacc != '')) {
                return (
                    (billingadd.ZipCode.toLowerCase().includes(searchte))
                );
            }
        });
        this.showAvailableShipping = true;
        this.lengthBillAddress = this.filteredresult.length;
        this.totalBillToRecords = this.lengthBillAddress;
    }
    applyFilterss() {
        if (!this.Shipaddress) {
            this.filteredresultt = this.Shipaddress;
            return;
        }
        const searchter = this.searchTermShip;
        this.filteredresultt = this.Shipaddress.filter(Shipaddresss => {
            const shipAccName = Shipaddresss.SAccountName;
            const shipPostalCode = Shipaddresss.PostalCode;
            if (shipAccName == undefined && shipAccName == '' && shipPostalCode == undefined && shipPostalCode == '') {
                return;
            }
            if (shipAccName !== undefined && shipAccName !== '' && shipPostalCode !== undefined && shipPostalCode !== '') {
                return (
                    (Shipaddresss.SAccountName.toLowerCase().includes(searchter)) ||
                    (Shipaddresss.PostalCode.toLowerCase().includes(searchter))
                );
            }
            if ((shipAccName != undefined && shipAccName != '') && (shipPostalCode == undefined || shipPostalCode == '')) {
                return (
                    (Shipaddresss.SAccountName.toLowerCase().includes(searchter))
                );
            }
            if ((shipAccName == undefined || shipAccName == '') && (shipPostalCode != undefined && shipPostalCode != '')) {
                return (
                    (Shipaddresss.PostalCode.toLowerCase().includes(searchter))
                );
            }
        });
        this.lengthShipAddress = this.filteredresultt.length;
        this.totalShipToRecords = this.lengthShipAddress;
        if (this.totalShipToRecords > 0) {
            this.selectedShipAccount = this.filteredresultt[0].AccShipId;
        }
    }
    returnProductDetailpageOnclick() {
        this.confirmAddress = false;
        const firstele = this.template.querySelector(".first-breadcrumb");
        setTimeout(() => {
            firstele.focus();
        }, 100);
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
    showEmailDoc(event) {
        if (event && !JSON.parse(event.target.getAttribute('aria-disabled'))) {
            this.showInvoiceEmail = true;
            if (this.SearchByvalue == 'Statement') {
                this.sendEmail = false;
                this.emailIcon = scc_email_icon_blue;
            } else {
                if (this.selectedDocuments.length === 0 || this.selectedDocuments.length > 5) {
                    this.sendEmail = false;
                    this.emailIcon = scc_email_icon_blue;
                }
            }
        }
    }
    closeModal() {
        this.showInvoiceEmail = false;
        this.clearEmailFields();
        const button = this.template.querySelector(".email-button");
        if (button) {
            setTimeout(() => {
                button.focus();
            }, 100);
        }
    }
    focusOutClose(event) {
        var related = event.relatedTarget;
        if (related != undefined) {
            if (related.getAttribute('data-index') != 0) {
                this.template.querySelector('.cancel-modal-button').focus();
            }
        }
    }
    focusOutButton(event) {
        var related = event.relatedTarget;
        if (related != undefined) {
            if (related.getAttribute('data-index') != 0) {
                this.template.querySelector('.guestOrderStatusClose').focus();
            }
        }
    }
}