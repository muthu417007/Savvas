/*********************************************************
  Component Name       : scc_View_Run_Report_LWC
  Created Date         : 07/21/2024  
  Author               : Sudha Rani pathivada- Cognizant
  Description          : Nested component for scc_customreport LWC  
  
  Modifications Log 
  <Date>       <Author>            <Modification>
  
*********************************************************/

import { LightningElement, track, api } from 'lwc';
import getDetailReport from '@salesforce/apex/scc_Custom_ReportsController.detailReport';
import sendReportEmail from '@salesforce/apex/scc_reportEmailService.sendReportEmail';
import saveOrUpdateReportFilters from '@salesforce/apex/scc_ReportFilterController.saveOrUpdateReportFilters';
import fetchCustomReportData from '@salesforce/apex/scc_editReportController.fetchCustomReportData';
import fetchReportDetails from '@salesforce/apex/scc_editReportController.fetchReportDetails';
import { RefreshEvent } from 'lightning/refresh';
import scc_OrderStatusReportTracking from "@salesforce/label/c.scc_OrderStatusReportTracking";// added by sudha W-014819
import scc_OrderStatusReportSummary from "@salesforce/label/c.scc_OrderStatusReportSummary";// added by sudha W-014819
import scc_OrderStatusReportDetail from "@salesforce/label/c.scc_OrderStatusReportDetail";// added by sudha W-014819
import sheetJS from '@salesforce/resourceUrl/sheetJS';
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import { loadScript } from 'lightning/platformResourceLoader';

export default class scc_View_Run_Report_LWC extends LightningElement {
    excelIcon = imageIcons + '/Images/excel.png';
    emailIcon = imageIcons + '/Images/EmailIconWithoutColor.png';
    @track showEmailReportPopup = false;
    @track emailAddresses =[]; ;
    @track emailInput = '';
    @track isDisabled = true;
    @track isLoading = false;
    labels = {
        scc_OrderStatusReportTracking,
        scc_OrderStatusReportSummary,
        scc_OrderStatusReportDetail
    }
    @track Description = '';
    @track recordsToDisplay = [];
    @api selectedreport;
    @api showdetailpage;
    @track isoverrideDisabled = true;//save report
    @api shipnum;
    @api billnum;
    @track closingchild = false;
    closeDisabled = true
    @track OrderStatusReport = false;
    @track showSummaryReport = false;
    @track showDetailReport = false;
    @track showTrackingReport = false;
    @track EditedReportName;
    runreportDisabled = true
    emailDisabled = true
    saveDisabled = true
    @track records = [];
    First = '<< First'
    Previous = '< Previous'
    next = 'Next >'
    Last = 'Last >>'
    pageSizeOptions = [15, 30, 45, 60]; //Page size options
    totalRecords = 0; //Total no.of records
    pageSize; //No.of records to be displayed per page
    @track totalPages = 1; //Total no.of pages
    pageNumber = 1; //Page number    
    closeDisabled = true;
    editcriteriaDisabled = true;
    // runreportDisabled  =true ;
    @track displayedRecords = 0;
    // c comp values 
    @track showPopup = false;
    @track gotformC = false
    isdetailedopen = false;
    @api childrecords;
    @api customdescription;
    @api cmsg
    @api editedreport;
    @api originalreporttype;
    @track Detailopenafteredits = false;
    @track emailRecords;
    @track errorMessage = 'Please enter a valid email address (e.g., example@example.com)';
    @track displayedReportName = '';
    @track oldoriginalReportName = '';
    @track selectedReportName = '';

    get bDisableFirst() {
        return this.pageNumber == 1;
    }

    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }


    get SearchByOptions() {
        return this.SearchByOptions1;
    }

    get noRecordsToDisplay() {
        return this.recordsToDisplay.length == 0;
    }
    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
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


    // JS function to handel pagination logic 
    paginationHelper() {
        this.recordsToDisplay = [];

        // calculate total pages
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);

        // set page number 
        if (this.totalPages <= 1) {
            this.totalPages = 1;
        }

        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }

        // set records to display on current page 
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.records[i]);
            this.displayedRecords = this.recordsToDisplay.length;
        }

        this.isLoading = false;
    }
    
    // connectedCallback

    connectedCallback() {
        this.customReportDescription = this.customdescription;
        this.oldoriginalReportName = this.originalreporttype;
        this.selectedReportName = this.editedreport;        
        this.maintainsourceoforiginalreport = this.originalreporttype;
        this.selectedValue = 'SaveAS';
        this.handleDefaultSelection();
        this.records = this.childrecords;
        this.EditedReportName = this.editedreport;
        this.msg = this.cmsg;

        if (this.editedreport.endsWith('[custom]')) {
            this.displayedReportName = this.editedreport.replace(' [custom]', '');
            this.Description = this.customReportDescription;
        } else {
            // For standard reports, use the name as is
            this.displayedReportName = this.editedreport;
        }


        if (this.msg === true) {
            this.seteditvalues();
            this.isdetailedopen == true
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.emailDisabled = false;
            this.saveDisabled = true            
            this.handledata();// handle data call  when  edit criteria component render from  Parent Component directly 
            this.setDescription();
        }
        if (this.msg === false) { // this is intial loading  and after closing the report detail and ediit report page 
            this.setDescription();
            this.EditedReportName = this.selectedreport
            this.setvalues();
        }

        //to catch escape keypress for accessibility

        this.template.addEventListener('keydown', this.handleKeydown.bind(this));
    }

    disconnectedCallback() {

        // Remove the keydown event listener when the component is removed from the DOM
        this.template.removeEventListener('keydown', this.handleKeydown);
    }

    //close popup when user press escape key -accessibility
    handleKeydown(event) {
        // Handle the keydown event
        if (event.key === 'Escape') {

            if (this.showEmailReportPopup) {
                this.closeEmailReportModal();
            }
            else if (this.savereport) {
                this.closesaveModal();
            }
            else if (this.showPopup) {
                this.closeDetailModal();
            }
        }
    }


    setvalues() {

        if (this.selectedreport && this.selectedreport.endsWith('[custom]')) {

            this.loadCustomReportData();

        }
        if (this.selectedreport === 'Order Status Report – Summary') {
            this.OrderStatusReport = true;
            this.showSummaryReport = true;
            this.showDetailReport = false;
            this.showTrackingReport = false;
            this.isdetailedopen = this.showdetailpage;
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = true
            this.fetchDetailReport();
        }
        if (this.selectedreport === 'Order Status Report – Detail') {
            this.OrderStatusReport = true;
            this.showDetailReport = true;
            this.showSummaryReport = false;
            this.showTrackingReport = false;
            this.isdetailedopen = this.showdetailpage;

            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = true

            this.fetchDetailReport();

        }
        if (this.selectedreport === 'Order Status Report – Tracking') {
            this.OrderStatusReport = true;
            this.showDetailReport = false;
            this.showSummaryReport = false;
            this.showTrackingReport = true;
            this.isdetailedopen = this.showdetailpage;

            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = true
            this.fetchDetailReport();
        }
    }
    // set edit valued for only when  edit criteria component reder from parent component
    seteditvalues() {

        this.selectedReportName = this.selectedreport
        this.customReportType = this.selectedreport
        this.maintainsourceoforiginalreport = this.selectedreport

        if (this.selectedreport && this.selectedreport.endsWith('[custom]')) {

            switch (this.originalreporttype) {
                case 'Order Status Report – Summary':
                    this.OrderStatusReport = true;
                    this.OrderStatusReport = true;
                    this.showSummaryReport = true;
                    this.showDetailReport = false;
                    this.showTrackingReport = false;
                    this.isdetailedopen = this.showdetailpage;
                    this.closeDisabled = false;
                    this.editcriteriaDisabled = false;
                    this.runreportDisabled = false;
                    this.emailDisabled = false
                    this.saveDisabled = false


                    break;
                case 'Order Status Report – Detail':
                    this.OrderStatusReport = true;
                    this.showDetailReport = true;
                    this.showSummaryReport = false;
                    this.showTrackingReport = false;
                    this.isdetailedopen = this.showdetailpage;
                    this.closeDisabled = false;
                    this.editcriteriaDisabled = false;
                    this.runreportDisabled = false;
                    this.emailDisabled = false
                    this.saveDisabled = false

                    break;
                case 'Order Status Report – Tracking':
                    this.isdetailedopen = this.showdetailpage;
                    this.closeDisabled = false;
                    this.editcriteriaDisabled = false;
                    this.runreportDisabled = false;
                    this.emailDisabled = false
                    this.saveDisabled = false

                    this.OrderStatusReport = true;
                    this.showDetailReport = false;
                    this.showSummaryReport = false;
                    this.showTrackingReport = true;
                    break;
                default:

                    break;
            }
        }

        if (this.selectedreport === 'Order Status Report – Summary') {

            this.OrderStatusReport = true;
            this.showSummaryReport = true;
            this.showDetailReport = false;
            this.showTrackingReport = false;
            this.isdetailedopen = this.showdetailpage;
            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = false

        }
        if (this.selectedreport === 'Order Status Report – Detail') {

            this.OrderStatusReport = true;
            this.showDetailReport = true;
            this.showSummaryReport = false;
            this.showTrackingReport = false;
            this.isdetailedopen = this.showdetailpage;

            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = false


        }
        if (this.selectedreport === 'Order Status Report – Tracking') {

            this.OrderStatusReport = true;
            this.showDetailReport = false;
            this.showSummaryReport = false;
            this.showTrackingReport = true;
            this.isdetailedopen = this.showdetailpage;

            this.closeDisabled = false;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false;
            this.emailDisabled = false
            this.saveDisabled = false


        }
    }

    setDescription() {
        const standardDescriptions = {
            'Order Status Report – Summary': scc_OrderStatusReportSummary,
            'Order Status Report – Detail': scc_OrderStatusReportDetail,
            'Order Status Report – Tracking': scc_OrderStatusReportTracking
        };

        if (this.editedreport && standardDescriptions[this.editedreport]) {

            this.Description = standardDescriptions[this.editedreport];

        } else if (this.editedreport && this.editedreport.endsWith('[custom]')) {

            this.Description = this.customReportDescription;

        } else {


        }
    }

    // track variables for updating dates 
    @track minDateElement;
    @track maxDateElement;
    @track minOrderDateFirst15;
    @track maxOrderDateFirst15;

    // calculate the dates 
    calculateDateRange() {

        if (Array.isArray(this.records) && this.records.length > 0) {
            const orderDates = this.records.map(record => new Date(record.orderDate));
            //  const orderDates = this.records.map(record => new Date(record.orderDate));
            const first15Records = this.records.slice(0, 15);
            const orderDatesFirst15 = first15Records.map(record => new Date(record.orderDate));

            // Find minimum and maximum dates for the first 15 records
            this.minOrderDateFirst15 = this.formatDate(new Date(Math.min(...orderDatesFirst15)));
            this.maxOrderDateFirst15 = this.formatDate(new Date(Math.max(...orderDatesFirst15)));


            // Find minimum and maximum dates
            this.minOrderDate = this.formatDate(new Date(Math.min(...orderDates)));
            this.maxOrderDate = this.formatDate(new Date(Math.max(...orderDates)));
            //   
        } else {

        }
    }

    fetchDetailReport() {
        this.isLoading = true;
        console.log(this.billnum);
         console.log(this.shipnum);
        getDetailReport({ BillTo: this.billnum, ShipTo: this.shipnum })
            .then(data => {
              
                this.records = data;
                this.emailRecords = data;
                this.pageSize = this.pageSizeOptions[0];
                this.totalRecords = this.records.length;
                this.paginationHelper();
                this.calculateDateRange();
                //this.orderDate = this.formatDate(this.records.orderDate);            

            })
            .catch(error => {
                this.error = error;

            });

    }

    formatDate(date) {
        const month = (date.getMonth() + 1).toString().padStart(2, '0');
        const day = date.getDate().toString().padStart(2, '0');
        const year = date.getFullYear();
        return `${month}/${day}/${year}`;
    }


    runreporthander(event) {
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {

            this.isdetailedopen = true;
            this.OrderStatusReport = true;
        }
    }

    //  download report
    loadCustomReportData() {
        this.isLoading = true;

        fetchCustomReportData({ reportNameWithCustom: this.selectedreport })
            .then(result => {

                this.records = result;
                this.emailRecords = result;

                // Set flags based on originalReport
                if (this.records.length > 0) {
                    let originalReportName = this.records[0].originalReport;
                    // this.Description = this.records[0].description;


                    switch (originalReportName) {
                        case 'Order Status Report – Summary':
                            this.OrderStatusReport = true;
                            this.OrderStatusReport = true;
                            this.showSummaryReport = true;
                            this.showDetailReport = false;
                            this.showTrackingReport = false;
                            this.isdetailedopen = this.showdetailpage;
                            this.closeDisabled = false;
                            this.editcriteriaDisabled = false;
                            this.runreportDisabled = false;
                            this.emailDisabled = false;
                            this.saveDisabled = true;


                            break;
                        case 'Order Status Report – Detail':
                            this.OrderStatusReport = true;
                            this.showDetailReport = true;
                            this.showSummaryReport = false;
                            this.showTrackingReport = false;
                            this.isdetailedopen = this.showdetailpage;
                            this.closeDisabled = false;
                            this.editcriteriaDisabled = false;
                            this.runreportDisabled = false;
                            this.emailDisabled = false
                            this.saveDisabled = true;

                            break;
                        case 'Order Status Report – Tracking':
                            this.isdetailedopen = this.showdetailpage;
                            this.closeDisabled = false;
                            this.editcriteriaDisabled = false;
                            this.runreportDisabled = false;
                            this.emailDisabled = false
                            this.saveDisabled = true

                            this.OrderStatusReport = true;
                            this.showDetailReport = false;
                            this.showSummaryReport = false;
                            this.showTrackingReport = true;
                            break;
                        default:

                            break;
                    }
                }
                this.pageSize = this.pageSizeOptions[0];
                this.totalRecords = this.records.length;

                this.calculateDateRange();
                this.paginationHelper();
            })

            .catch(error => {

            });
    }

    handleExport() {

        let csvContent = '';
        let relatedColumns = [];
        let fileName = '';

        if (this.showSummaryReport || this.originalreporttype == 'Order Status Report – Summary') {
            relatedColumns = [
                { label: 'PO #', fieldName: 'PO' },
                { label: 'ISBN', fieldName: 'isbn13' },
                { label: 'Title Description', fieldName: 'productDescription' },
                { label: 'Order Date', fieldName: 'orderDate' },
                { label: 'Order #', fieldName: 'orderNumber' },
                { label: 'Ordered Qty', fieldName: 'orderedQuantity' },
                { label: 'Shipped Qty', fieldName: 'shippedQuantity' },
                { label: 'Backorder Qty', fieldName: 'backorderQuantity' },
                { label: 'Due Date', fieldName: 'dueDate' },
                { label: 'On Hold Qty', fieldName: 'holdQuantity' },
                { label: 'Shippable Quantity', fieldName: 'shippedQuantity' },
                { label: 'Cancelled Quantity', fieldName: 'cancelledQuantity' },
                { label: 'Ship-to Account #', fieldName: 'shipAccount' },
                { label: 'Ship-to Account Name', fieldName: 'shipAccountName' },
                { label: 'City', fieldName: 'city' },
                { label: 'State', fieldName: 'state' }

            ];

            fileName = this.displayedReportName + '.xlsx';

        }
        else if (this.showDetailReport || this.originalreporttype == 'Order Status Report – Detail') {
            relatedColumns = [
                { label: 'PO #', fieldName: 'PO' },
                { label: 'ISBN', fieldName: 'isbn13' },
                { label: 'Title Description', fieldName: 'productDescription' },
                { label: 'Order Date', fieldName: 'orderDate' },
                { label: 'Order #', fieldName: 'orderNumber' },
                { label: 'Ordered Qty', fieldName: 'orderedQuantity' },
                { label: 'Invoice #', fieldName: 'invoiceNumber' },
                { label: 'Status', fieldName: 'status' },
                { label: 'Quantity', fieldName: 'quantity' },
                { label: 'Reason', fieldName: 'reason' },
                { label: 'Ship Date', fieldName: 'shipDate' },
                { label: 'Due Date', fieldName: 'dueDate' },
                { label: 'Backorder Cancel Date', fieldName: 'backorderCancelDate' },
                { label: 'Future Ship Date', fieldName: 'futureShipDate' },
                { label: 'Ship-to Account #', fieldName: 'shipAccount' },
                { label: 'Ship-to Account Name', fieldName: 'shipAccountName' },
                { label: 'City', fieldName: 'city' },
                { label: 'State', fieldName: 'state' }
            ];

            fileName = this.displayedReportName + '.xlsx';

        }
        else if (this.showTrackingReport || this.originalreporttype == 'Order Status Report – Tracking') {
            relatedColumns = [
                { label: 'PO #', fieldName: 'PO' },
                { label: 'ISBN', fieldName: 'isbn13' },
                { label: 'Title Description', fieldName: 'productDescription' },
                { label: 'Order Date', fieldName: 'orderDate' },
                { label: 'Order #', fieldName: 'orderNumber' },
                { label: 'Ordered Qty', fieldName: 'orderedQuantity' },
                { label: 'Invoice #', fieldName: 'invoiceNumber' },
                { label: 'Ship Date', fieldName: 'shipDate' },
                { label: 'Shipping Method', fieldName: 'carrierName' },
                { label: 'Parcel ID', fieldName: 'parcelID' },
                { label: 'Tracking #', fieldName: 'trackingNumber' },
                { label: 'Signature', fieldName: 'signature' },
                { label: 'Ship-to Account #', fieldName: 'shipAccount' },
                { label: 'Ship-to Account Name', fieldName: 'shipAccountName' },
                { label: 'City', fieldName: 'city' },
                { label: 'State', fieldName: 'state' }

            ];
            fileName = this.displayedReportName + '.xlsx';

        }

        const headers = relatedColumns.map(col => col.label);


        let data = [];
        this.emailRecords.forEach((record) => {
            const row = relatedColumns.map(col => {
                let value = record[col.fieldName];
                return value != null ? value : '';  // Handle null or undefined values
            });
            data.push(row);  // Push each row into the data array
        });
        // Create a worksheet and add headers
        const worksheet = XLSX.utils.aoa_to_sheet([headers, ...data]);
        const workbook = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(workbook, worksheet, this.displayedReportName);
        // Export to Excel
        //const fileName = this.selectedReportName + '.xlsx';
        XLSX.writeFile(workbook, fileName);
    }


    @track breadcrumbDisplaymsg = true;

    editCriteriaHander(event) {
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
            this.editCriteria = true
            this.OrderStatusReport = false;
            this.breadcrumbDisplaymsg = true;
            this.reporttypename = this.originalreporttype;

        }
    }

    //  handeld event from edit editCriteria comp 
    handleDataRetrieved(event) {

        this.isLoading = true;

        // Handle data received from child component
        const fetchedRecords = event.detail.results;
        this.records = fetchedRecords;
        this.emailRecords = fetchedRecords;
        this.gotformC = event.detail.valuefromC;

        // const editmsg = event.detail.enableSaveButton;

        this.saveDisabled = false; // here enabling save button after came from edits



        this.seteditvalues();
        this.pageNumber = 1;
        this.pageSize = this.pageSizeOptions[0];
        this.totalRecords = this.records.length;

        this.paginationHelper();

        this.editCriteria = false; // Close the edit criteria modal
        this.isdetailedopen = true;
        this.OrderStatusReport = true;

        this.editCriteriaMsg = true;

    }
    // this event  will notify when   edit called directly from parent , A to C to B 
    handledata() {
        this.isLoading = true;
        this.records = this.childrecords;
        this.emailRecords = this.childrecords;

        this.calculateDateRange();


        this.pageNumber = 1;
        this.pageSize = this.pageSizeOptions[0];
        this.totalRecords = this.records.length;

        this.paginationHelper();
        this.editCriteria = false; // Close the edit criteria modal
        this.isdetailedopen = true;
        this.OrderStatusReport = true;
        this.editCriteriaMsg = true;
        this.saveDisabled = false;

    }
    // this is main close button 
    detailhandleClose(event) {
        this.decodedValues = '';
        // if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {

        if (this.isSaveReportDone) {
            // If the report is saved, close directly without showing the popup
            this.isdetailedopen = false;
            this.OrderStatusReport = false;
            this.dispatchEvent(new CustomEvent('detailclose', {
                detail: {
                    cmsg: this.cmsg
                }
            }));
            this.dispatchEvent(new RefreshEvent());
        }
        else if (this.gotformC == true || this.cmsg == true) {
            this.showPopup = true;
            setTimeout(() => {
                this.template.querySelector('.pendingchngCloseBtn').focus();
            }, 100);
        } else {

            // Dispatch an event to notify the parent component to close this view without sending any value
            // this.dispatchEvent(new CustomEvent('detailclose'));
            this.dispatchEvent(new CustomEvent('detailclose', {
                detail: {
                    cmsg: this.cmsg
                }
            }));
            this.isdetailedopen = false;
            this.OrderStatusReport = false;

            this.dispatchEvent(new RefreshEvent());
        }
        //}  
    }
    // intial stage close button
    handleClose() {

        this.decodedValues = '';
        //if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {  

        // Dispatch an event to notify the parent component to close this view and send the selected value
        this.dispatchEvent(new CustomEvent('close', {
            detail: { value: this.selectedreport }
        }));
        //  }

    }

    handleOpen(event) {


        this.records = event.detail.recordsData;
        //  this.gotformC=event.detail.valuefromC;
        this.EditedReportName = event.detail.editedreport;

        this.editCriteria = false;

        this.OrderStatusReport = true;
        this.calculateDateRange();

    }
    // close showpopup
    CancelDetailHandler() {
        this.showPopup = false;
    }
    // popup close report detail  button 
    CloseDeailhander() {

        this.cmsg = false;



        this.dispatchEvent(new CustomEvent('detailclose', {
            detail: {
                cmsg: this.cmsg
            }
        }));

        this.isdetailedopen = false;
        this.OrderStatusReport = false;
        currentPageReference = '';

        this.dispatchEvent(new RefreshEvent());
    }

    msgfromc() {
        this.gotformC = event.detail.valuefromC;

    }

    closeEmailReportModal() {
        this.showEmailReportPopup = false;
        this.emailInput = '';
        const button = this.template.querySelector(".email-report");
        if (button) {
            setTimeout(() => {
                button.focus();
            }, 100);
        }
    }
    handleOpenEmailReportModal(event) {
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
            this.showEmailReportPopup = true;
            setTimeout(() => {
                this.template.querySelector('.emailRprtCloseBtn').focus();
            }, 100);

            this.focusCloseButton();
        }

    }


    @track showError = false;
    handleEmailInput(event) {
        this.emailInput = event.target.value;
        const emailArray = this.emailInput.split(',').map(email => email.trim());
        // const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; 
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        // Check if any email is invalid
        this.showError = !emailArray.every(email => emailRegex.test(email) || email === '')

        if (event.type == 'keypress') {
            if (!this.showError) {                
                this.emailIcon = imageIcons + '/Images/EmailIconWithColor.png';
                this.isDisabled = false;
            }
            if (event.keyCode === 8 || event.keyCode === 46) {

                this.emailIcon = imageIcons + '/Images/EmailIconWithColor.png';
                this.isDisabled = false;
            }
            if (event.keyCode === 13 && !this.isDisabled) {

                event.preventDefault();
                this.emailIcon = imageIcons + '/Images/EmailIconWithoutColor.png';
                this.isDisabled = true;
                this.emailHandler();
            }
        } else {
            if (this.emailInput != '' && this.emailInput != undefined && !this.showError) {

                this.emailIcon = imageIcons + '/Images/EmailIconWithColor.png';
                this.isDisabled = false;
            }
            else {
                this.emailIcon = imageIcons + '/Images/EmailIconWithoutColor.png';
                this.isDisabled = true;
            }
        }


    }


async emailHandler(event) {
    if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
        const standardReports = [
            'Order Status Report – Summary',
            'Order Status Report – Detail',
            'Order Status Report – Tracking'
        ];

        let matchedReportName = standardReports.find(report =>
            report === this.maintainsourceoforiginalreport ||
            report === this.originalreporttype ||
            report === this.EditedReportName
        );

        if (!this.showError) {
            this.isLoading = true;
            this.emailIcon = imageIcons + '/Images/EmailIconWithoutColor.png';
            this.isDisabled = true;
        }

        try {
            this.emailAddresses = this.emailInput.split(",").map(email => email.trim());

            // Filter report data based on the matched report name
            const filteredReportData = this.emailRecords.map(record => {
                let isbn = record.isbn13 ? record.isbn13.toString() : '';
                isbn = "\t" + isbn;
                let Order = record.orderNumber ? record.orderNumber.toString() : '';
                Order = "\t" + Order;
                let invoiceNumber = record.invoiceNumber ? record.invoiceNumber.toString() : '';
                invoiceNumber = "\t" + invoiceNumber;
                const commonData = {
                    'PO #': record.PO || '',
                    'ISBN': isbn || '',
                    'Title Description': record.productDescription || '',
                    'Order Date': record.orderDate || '',
                    'Order #': Order || '',
                    'Ordered Qty': record.orderedQuantity != null ? record.orderedQuantity : 0,
                    'Ship-to Account #': record.shipAccount || '',
                    'Ship-to Account Name': record.shipAccountName || '',
                    'City': record.city || '',
                    'State': record.state || ''
                };

                if (matchedReportName === 'Order Status Report – Summary') {
                    return {
                        ...commonData,
                        'Shipped Qty': record.shippedQuantity != null ? record.shippedQuantity : 0,
                        'Backorder Qty': record.backorderQuantity != null ? record.backorderQuantity : 0,
                        'Due Date': record.dueDate || '',
                        'On Hold Qty': record.holdQuantity != null ? record.holdQuantity : 0,
                        'Cancelled Quantity': record.cancelledQuantity != null ? record.cancelledQuantity : 0,
                    };
                } else if (matchedReportName === 'Order Status Report – Detail') {
                    return {
                        ...commonData,
                        'Invoice #': invoiceNumber || '',
                        'Status': record.status || '',
                        'Quantity': record.quantity != null ? record.quantity : 0,
                        'Reason': record.reason || '',
                        'Ship Date': record.shipDate || '',
                        'Due Date': record.dueDate || '',
                        'Backorder Cancel Date': record.backorderCancelDate || '',
                        'Future Ship Date': record.futureShipDate || '',
                    };
                } else if (matchedReportName === 'Order Status Report – Tracking') {
                    return {
                        ...commonData,
                        'Invoice #': invoiceNumber || '',
                        'Ship Date': record.shipDate || '',
                        'Shipping Method': record.carrierName || '',
                        'Parcel ID': record.parcelID || '',
                        'Tracking #': record.trackingNumber || '',
                        'Signature': record.signature || '',
                    };
                }
                return {}; // Return an empty object if no matching report type
            });

            // Convert filtered report data to CSV format
            const csvString = this.convertToCSV(filteredReportData, matchedReportName);            

            // Call Apex method
            await sendReportEmail({
                emailAddresses: this.emailAddresses,
                reportType: matchedReportName,
                reportData: csvString,
                reportName: this.displayedReportName
            });

            // Success handler
            this.dispatchEvent(new CustomEvent('emailsent'));
            this.isLoading = false;
        } catch (error) {
            // Error handler
            this.isLoading = false;
            console.error('Error processing email:', error);
        }
    }
}

getHeaders(reportType) {
    switch (reportType) {
        case 'Order Status Report – Summary':
            return [
                'PO #', 'ISBN', 'Title Description', 'Order Date', 'Order #', 
                'Ordered Qty', 'Shipped Qty', 'Backorder Qty', 'Due Date', 
                'On Hold Qty', 'Cancelled Quantity', 'Ship-to Account #', 
                'Ship-to Account Name', 'City', 'State'
            ];
        case 'Order Status Report – Detail':
            return [
                'PO #', 'ISBN', 'Title Description', 'Order Date', 'Order #', 
                'Ordered Qty', 'Invoice #', 'Status', 'Quantity', 'Reason', 
                'Ship Date', 'Due Date', 'Backorder Cancel Date', 
                'Future Ship Date', 'Ship-to Account #', 'Ship-to Account Name', 
                'City', 'State'
            ];
        case 'Order Status Report – Tracking':
            return [
                'PO #', 'ISBN', 'Title Description', 'Order Date', 'Order #', 
                'Ordered Qty', 'Invoice #', 'Ship Date', 'Shipping Method', 
                'Parcel ID', 'Tracking #', 'Signature', 
                'Ship-to Account #', 'Ship-to Account Name', 'City', 'State'
            ];
        default:
            return [];
    }
}


convertToCSV(data, reportType) {
    const headers = this.getHeaders(reportType); // Get headers based on report type

    const csvRows = [headers.join(',')]; // Add headers to the first row

    if (data && data.length) {
        for (const row of data) {
            const values = headers.map(header => {
                const value = row[header] !== undefined ? row[header] : ''; // Fallback to empty string if undefined
                const escaped = ('' + value)
                    .replace(/"/g, '""') // Escape double quotes
                    .replace(/(\r\n|\n|\r)/gm, " ") // Replace new lines
                    .replace(/,/g, ' '); // Replace commas

                return `"${escaped}"`; // Wrap values in quotes
            });
            csvRows.push(values.join(',')); // Add values as a row in CSV
        }
    }

    return csvRows.join('\n'); // Return as a single string with headers (and data if available)
}

    // save report variables save report functionality starts from here 
    @track message = '';
    @track reportName = '';
    @track NewDescription = '';
    @track ExistedReport = false;
    @track isSaveButtonDisabled = true;
    @track SaveAsDescription = '';
    @track savereport = false;
    @track isDisabled = true;
    @track Description = '';
    //@track issavedisabled=false;
    @track isInputsavedisabled = false;
    @track isRadioDisabled = false;
    @track selectedValue = 'SaveAS';
    @track isCustomReport = true;

    closeDetailModal() {
        this.showPopup = false;
        const button = this.template.querySelector(".close-detail");
        if (button) {
            setTimeout(() => {
                button.focus();
            }, 100);
        }
    }
    closesaveModal() {
        this.savereport = false;
        const button = this.template.querySelector(".save");
        if (button) {
            setTimeout(() => {
                button.focus();
            }, 100);
        }
    }
    saveahander(event) {
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
            // this.setDescription();
            this.savereport = true;
            setTimeout(() => {
                this.template.querySelector('.saveModalCloseBtn').focus();
            }, 100);
            this.message = this.Description;
            this.descriptionUpdated = false;


            const standardReports = [
                'Order Status Report – Summary',
                'Order Status Report – Detail',
                'Order Status Report – Tracking'
            ];

            // Check if the selected report name is one of the standard reports.
            this.isRadioDisabled = standardReports.includes(this.displayedReportName);


        }
    }
    @track maintainsourceoforiginalreport = '';

    @track appendcustom = '';
    @track isCustomReport = true
    @track editCriteriaResult = [];
    @track isSaveReportDone = false;
    @track isLoader = false;
    handleCustomSave(event) {
        this.isSaveButtonDisabled = true;
        this.isLoading = false
        this.isLoader = true;


        const standardReports = ['Order Status Report – Summary', 'Order Status Report – Detail', 'Order Status Report – Tracking'];


        let matchedReportName = standardReports.find(report =>
            report === this.maintainsourceoforiginalreport ||
            report === this.originalreporttype
        );
        let isStandardReport = !!matchedReportName;

        if (this.records && this.records.length > 0) {
          
            const firstItem = this.records[0];
            if (!this.selectedValue || this.selectedValue !== 'OverideExistedreport') {
                this.selectedValue === 'SaveAS'
            }
        
            if (this.selectedValue === 'OverideExistedreport') {
                this.NewDescription = this.message;
                this.reportName = this.displayedReportName;
                this.ExistedReport = false;
                 
            } if (this.selectedValue === 'SaveAS') {

                this.reportName = this.newReportName;
                this.NewDescription = this.SaveAsDescription;
                this.Description = this.SaveAsDescription;


                const textArea = this.template.querySelector('textarea[data-type="unique-textarea"]');

                if (textArea) {
                    textArea.value = this.SaveAsDescription;

                    this.descriptionUpdated = true;
                }
                this.ExistedReport = false;

            }



            const filterParams = {
                userId: firstItem.loggedInUserId,
                isbnList: firstItem.isbnList.join(','),
                poList: firstItem.poList.join(','),
                //isbnList: firstItem.isbnList,
                //poList: firstItem.poList,
                startDate: firstItem.startDate || '',
                endDate: firstItem.endDate || '',
                orderStatus: firstItem.orderStatus || '',
                sortOrder1: firstItem.sortOrder1 || '',
                sortOrder2: firstItem.sortOrder2 || '',
                sortOrder3: firstItem.sortOrder3 || '',
                orderEntryPeriod: firstItem.orderEntryPeriod || '',
                Name: this.reportName,
                Description: this.NewDescription,
                standardReport: this.ExistedReport,
                // orginalReport:isStandardReport ? this.maintainsourceoforiginalreport : 'Custom'
                orginalReport: isStandardReport ? matchedReportName : 'Custom'
            };





            // Call Apex method to save the filter
            saveOrUpdateReportFilters({ filterParamsList: [filterParams] })
                .then(result => {
            
                    const reportId = result[0];
                
                    return fetchReportDetails({ reportId: reportId });
                })
                .then(details => {
                    this.savereport = false;
                    this.isLoader = false
                    this.isSaveReportDone = true;

                    this.records = details;
                    this.prepareEditCriteria(details);
                    // this.editCriteriaResult=details;

                    if (details.length > 0) {
                     
                        this.displayedReportName = details[0].Name;

                        this.isCustomReport = details[0].StandardReport;
                        this.checkcustomreportname = details[0].Name;

                      
                        this.customReportType = `${this.checkcustomreportname} [custom]`;
                        this.EditedReportName = `${this.checkcustomreportname} [custom]`;


                        this.Description = details[0].Description;
                        this.customReportDescription = details[0].Description;

                        const textArea = this.template.querySelector('textarea[data-type="unique-textarea"]');

                        if (textArea) {
                            textArea.value = this.Description;

                            
                        }
                    }

                    switch (this.maintainsourceoforiginalreport) {

                        case 'Order Status Report – Summary':
                            this.OrderStatusReport = true;
                            this.OrderStatusReport = true;
                            this.showSummaryReport = true;
                            this.showDetailReport = false;
                            this.showTrackingReport = false;
                            this.isdetailedopen = true;
                            this.closeDisabled = false;
                            this.editcriteriaDisabled = false;
                            this.runreportDisabled = false;
                            this.emailDisabled = false
                            this.saveDisabled = false


                            break;
                        case 'Order Status Report – Detail':
                            this.OrderStatusReport = true;
                            this.showDetailReport = true;
                            this.showSummaryReport = false;
                            this.showTrackingReport = false;
                            this.isdetailedopen = true;
                            this.closeDisabled = false;
                            this.editcriteriaDisabled = false;
                            this.runreportDisabled = false;
                            this.emailDisabled = false
                            this.saveDisabled = false

                            break;
                        case 'Order Status Report – Tracking':
                            this.isdetailedopen = true;
                            this.closeDisabled = false;
                            this.editcriteriaDisabled = false;
                            this.runreportDisabled = false;
                            this.emailDisabled = false
                            this.saveDisabled = false

                            this.OrderStatusReport = true;
                            this.showDetailReport = false;
                            this.showSummaryReport = false;
                            this.showTrackingReport = true;
                            break;
                    }
                    this.pageSize = this.pageSizeOptions[0];
                    this.totalRecords = this.records.length;
                    this.paginationHelper();
                    this.calculateDateRange();
                    this.isInputsavedisabled = false;
                    this.isoverrideDisabled = true;
                    this.selectedValue = 'SaveAS';

                })
                .catch(error => {
                    console.error('Error in process:', error);
                });
        }
        //}
    }
    prepareEditCriteria(details) {
        if (details && details.length > 0) {
            const firstDetail = details[0];
            this.editCriteriaResult = {


                startDate: firstDetail.startDate,
                endDate: firstDetail.endDate,
                orderStatus: firstDetail.orderStatus,
                isbnList: firstDetail.isbnList,
                poList: firstDetail.poList,
                sortOrder1: firstDetail.sortOrder1,
                sortOrder2: firstDetail.sortOrder2,
                sortOrder3: firstDetail.sortOrder3,
                orderEntryPeriod: firstDetail.orderEntryPeriod,
                originalReport: firstDetail.originalReportType__c,
                description: firstDetail.Description__c,
                name: firstDetail.Name,
                standardReport: firstDetail.StandardReport__c
            };

        }
    }
    sheetJsInitialized = false;
    isRenderedCallbackCalled = false;

    renderedCallback() {

        if (this.sheetJsInitialized) {
            return;
        }
        loadScript(this, sheetJS)
            .then(() => {
                this.sheetJsInitialized = true;
            })
            .catch(error => {

            });


        this.updateDescriptionInView();
        if (this.isRenderedCallbackCalled == false) {
            const firstele = this.template.querySelector(".first-breadcrumb");
            setTimeout(() => {
                firstele.focus();
            }, 100);
            this.isRenderedCallbackCalled = true;
        }



    }

    focusCloseButton() {
        // Find the close button using data-id attribute
        const closeButton = this.template.querySelector('[data-id="closeButton"]');
        if (closeButton) {
            // Focus on the close button
            closeButton.focus();
        } else {

        }
    }


    updateDescriptionInView() {
        if (this.savereport && !this.descriptionUpdated) {
            const textArea = this.template.querySelector('textarea[data-type="unique-textarea"]');

            if (textArea) {
                textArea.value = this.Description;
                // Ensure this.Description is reactive and updates
                this.descriptionUpdated = true;  // Set flag to true after updating
            }
        }
    }

    handleOverideradioChange(event) {

        this.selectedValue = event.target.value;





        if (this.selectedValue === 'OverideExistedreport') {
            // Enable or disable the text area and override option based on the type of report

            this.isoverrideDisabled = false; //!isCustomReport
            this.isInputsavedisabled = true;

            //this.isDisabled = !isCustomReport;
            this.isSaveButtonDisabled = false;
            this.SaveAsDescription = '';
            this.newReportName = '';
        } else {
            this.isoverrideDisabled = true;
            this.isInputsavedisabled = false;
            // Optionally reset the selectedValue if you need to deselect the radio button
            this.selectedValue = null;
        }
    }
    handleDefaultSelection() {
        if (this.selectedValue === 'SaveAS') {
            this.isoverrideDisabled = true
            this.isInputsavedisabled = false;
            this.isSaveButtonDisabled = true;
        }
        else {
            this.isoverrideDisabled = false;
            this.isInputsavedisabled = false;

        }
    }
    handleSaveasRadioChange(event) {
        this.selectedValue = event.target.value;

        //this.handleDefaultSelection();
        if (this.selectedValue === 'SaveAS') {
            this.isoverrideDisabled = true
            this.isInputsavedisabled = false;
            this.isSaveButtonDisabled = true;
        }
        else {
            this.isoverrideDisabled = false;
            this.isInputsavedisabled = false;

        }
    }
    handledescription(event) {
        this.Description = event.target.value;
    }

    handleDescriptionChange(event) {

        this.message = event.target.value;
        this.isSaveButtonDisabled = false

    }
    handleReportNameChange(event) {
        this.newReportName = event.target.value;

        this.updateButtonState();
    }

    handleSaveAsDescription(event) {
        this.SaveAsDescription = event.target.value;
        this.updateButtonState();
    }
    updateButtonState() {

        const description = this.SaveAsDescription || '';
        const reportName = this.newReportName || '';


        if (description.trim() !== '' && reportName.trim() !== '') {
            this.isSaveButtonDisabled = false;
        } else {
            this.isSaveButtonDisabled = true; // Disable the button if either field is empty
        }
    }
    handleSaveCancel() {
        this.savereport = false;
    }

    //added by zubiya

    //Trap focus inside modal
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
                this.template.querySelector('.closebtnOnFocus').focus();
            }
        }
    }

}