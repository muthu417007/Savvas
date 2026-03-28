/*********************************************************
  Component Name       : scc_editCriteriaLWC
  Created Date         : 07/21/2024  
  Author               : Sudha Rani pathivada- Cognizant
  Description          : nested component of scc_viewrunreport And this component will execute on click on Run report From Edit creitera page 
  
  Modifications Log
  <Date>       <Author>            <Modification>
  
*********************************************************/



import { LightningElement, track, api, wire } from 'lwc';
import scc_OrderStatusReportTracking from "@salesforce/label/c.scc_OrderStatusReportTracking";// added by sudha W-014819
import scc_OrderStatusReportSummary from "@salesforce/label/c.scc_OrderStatusReportSummary";// added by sudha W-014819
import scc_OrderStatusReportDetail from "@salesforce/label/c.scc_OrderStatusReportDetail";// added by sudha W-014819
import imageIcons from '@salesforce/resourceUrl/scc_Images';
import scc_calender_icon from "@salesforce/resourceUrl/scc_calender_icon";
import getOrderStatusOptions from '@salesforce/apex/scc_orderStatusLWC_Controller.getOrderStatusOptions';
import getOrderEntryOptions from '@salesforce/apex/scc_editReportController.getOrderEntryOptions';
import getOrderItemData from '@salesforce/apex/scc_editReportController.getOrderItemData';

export default class scc_editCriteriaLWC extends LightningElement {
    @api fromcomponent
    //track 
    @track editedreportName = '';
    @track Last_N_MONTH = '';
    @track includeAllISBNs = true;
    @track includeAllPOs = true;
    @track specificISBNs = '';
    @track specificPOs = '';
    @track closeDisabled = false;
    @track runreportDisabled = true;
    @track showclosewindow = false;
    @track startDate = '';
    @track endDate = '';
    @track OrderStatusValue = '';
    @track orderEntryPeriod;
    @track isbnValues = '';
    @track poValues = '';
    @track isbns = [];
    showEditPage = true;
    @api oldreporttype
    @api breadcrumbmsg;
    @api searchcriteria;

    @track ipos = [];
    @track SortOrderOptions1 = [{ label: 'ISBN', value: 'ISBN' }, { label: 'Order Entry Date', value: 'Order Entry Date' }, { label: 'PO #', value: 'PO #' }, { label: 'State', value: 'State' }, { label: 'Zip', value: 'Zip' }];
    @track SortOrderOptions2 = [{ label: 'ISBN', value: 'ISBN' }, { label: 'Order Entry Date', value: 'Order Entry Date' }, { label: 'PO #', value: 'PO #' }, { label: 'State', value: 'State' }, { label: 'Zip', value: 'Zip' }];
    @track SortOrderOptions3 = [{ label: 'ISBN', value: 'ISBN' }, { label: 'Order Entry Date', value: 'Order Entry Date' }, { label: 'PO #', value: 'PO #' }, { label: 'State', value: 'State' }, { label: 'Zip', value: 'Zip' }];
    @track OrderStatusOptions1 = [{ label: 'All', value: 'All' }, { label: 'Open', value: 'Open' }, { label: 'Cancelled', value: 'Cancelled' }, { label: 'FullFilled', value: 'FullFilled' }];
    @track OrderEntryOptions1 = [{ label: 'Last 12 months', value: 'Last_12_months' }, { label: 'Last 18 months', value: 'Last_18_months' }, { label: 'Last_24_months', value: 'Last_24_months' },

    { label: 'Last 3 months', value: 'Last_3_months' },
    { label: 'Last 36 months', value: 'Last_36_months' },
    { label: 'Last 6 months', value: 'Last_6_months' },
    { label: 'Last month', value: 'Last_month' }];
    //api
    @api editedreport;
    @track valuefromC = false;
    @api customdescription;
    @api sentDescription

    updateCheckboxes() {

        if (this.searchcriteria && Object.keys(this.searchcriteria).length > 0) {


            this.includeAllISBNs = !(this.searchcriteria.isbnList && this.searchcriteria.isbnList.length > 0);
            this.includeAllPOs = !(this.searchcriteria.poList && this.searchcriteria.poList.length > 0);

        }
    }
    updateFromSearchCriteria() {
        if (this.searchcriteria) {

            this.specificISBNs = (this.searchcriteria.isbnList || []).join('\n');
            this.isbns = this.specificISBNs.split('\n').filter(Boolean);  // Convert to array for handleRunReport

            this.specificPOs = (this.searchcriteria.poList || []).join('\n');


            this.updateCheckboxes();
        }
    }


    isRenderedCallbackCalled = false;
    renderedCallback() {
        if (this.searchcriteria && Object.keys(this.searchcriteria).length > 0) {
            const textArea = this.template.querySelector('textarea[data-type="unique-includeAllISBNs"]');

            if (textArea) {
                textArea.value = this.specificISBNs;


            }
        }

        //added by zubiya
        if (this.showclosewindow) {
            this.focusCloseButton();
        }


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
            console.error('Close button not found');
        }
    }




    updateOrderEntry() {
        if (this.searchcriteria && Object.keys(this.searchcriteria).length > 0) {
            if (this.searchcriteria.orderEntryPeriod == '1') {
                this.orderEntryPeriod = 'Last month';
            } else if (this.searchcriteria.orderEntryPeriod == '3') {
                this.orderEntryPeriod = 'Last 3 months';
            } else if (this.searchcriteria.orderEntryPeriod == '6') {
                this.orderEntryPeriod = 'Last 6 months';
            } else if (this.searchcriteria.orderEntryPeriod == '12') {
                this.orderEntryPeriod = 'Last 12 months';
            } else if (this.searchcriteria.orderEntryPeriod == '18') {
                this.orderEntryPeriod = 'Last 18 months';
            } else if (this.searchcriteria.orderEntryPeriod == '24') {
                this.orderEntryPeriod = 'Last 24 months';
            } else if (this.searchcriteria.orderEntryPeriod == '36') {
                this.orderEntryPeriod = 'Last 36 months';
            } else {
                this.orderEntryPeriod = '';
            }



        }
    }
    // save variables
    @track originalStartDate = '';
    @track originalEndDate = '';
    @track originalOrderStatus = '';
    @track originalISBNs = '';
    @track originalPOs = '';
    @track originalSortOrder1 = '';
    @track originalSortOrder2 = '';
    @track originalSortOrder3 = '';
    @track originalOrderEntryPeriod = '';
    connectedCallback() {




        if (this.searchcriteria && Object.keys(this.searchcriteria).length > 0) {
            // Initialize and format the dates
            this.formateoriginalStartDate = this.searchcriteria.startDate ? new Date(this.searchcriteria.startDate) : null;
            this.formateoriginalEndDate = this.searchcriteria.endDate ? new Date(this.searchcriteria.endDate) : null;

            // Ensure the correct date format is set for the report
            this.startDate = this.formateoriginalStartDate ? this.formateoriginalStartDate.toISOString().slice(0, 10) : '';
            this.endDate = this.formateoriginalEndDate ? this.formateoriginalEndDate.toISOString().slice(0, 10) : '';

            // Initialize other parameters with fallback to original values
            this.OrderStatusValue = this.searchcriteria.orderStatus || '';
            this.orderStatus = this.OrderStatusValue;

            // Handle ISBNs and POs, converting them to the necessary format
            this.specificISBNs = (this.searchcriteria.isbnList || []).join('\n');
            this.isbns = this.specificISBNs.split('\n').filter(Boolean);  // Convert to array for handleRunReport


            this.specificPOs = (this.searchcriteria.poList || []).join('\n');
            this.ipos = this.specificPOs.split('\n').filter(Boolean);  // Convert to array for handleRunReport

            // Handle sort orders
            this.SortOrder1 = this.searchcriteria.sortOrder1 || '';
            this.SortOrder2 = this.searchcriteria.sortOrder2 || '';
            this.SortOrder3 = this.searchcriteria.sortOrder3 || '';

            // Handle order entry period
            this.orderEntryPeriod = this.searchcriteria.orderEntryPeriod || '';
            this.updateOrderEntry();
            this.updateFromSearchCriteria();
            // Ensure the run report button is correctly enabled
            this.checkEnableRunReport();



        }



        this.editedreportName = this.editedreport;
        this.originalReportType = this.oldreporttype;




        this.setDescription();

        if (this.editedreport.endsWith('[custom]')) {
            this.displayedReportName = this.editedreport.replace(' [custom]', '');
            // this.displayedReportName =this.savedreportName.replace(' [custom]', '');
            this.customReportDescription = this.sentDescription
            this.customReportDescription = this.customdescription;



        } else {
            // For standard reports, use the name as is
            this.displayedReportName = this.editedreport;
        }
        getOrderStatusOptions().then(response => {

            let paser = JSON.parse(response);

            this.OrderStatusOptions1 = JSON.parse(response);
        }).catch(error => {

            this.isLoading1 = false;
        })
        getOrderEntryOptions().then(response => {

            let paser = JSON.parse(response);

            this.OrderEntryOptions1 = JSON.parse(response);
        }).catch(error => {

            this.isLoading1 = false;
        })

    }


    setDescription() {
        const standardDescriptions = {
            'Order Status Report – Summary': scc_OrderStatusReportSummary,
            'Order Status Report – Detail': scc_OrderStatusReportDetail,
            'Order Status Report – Tracking': scc_OrderStatusReportTracking
        };








        if (this.editedreport && standardDescriptions[this.editedreport]) {

            this.Description = standardDescriptions[this.editedreport];

            this.customReportDescription = this.Description;
        } else if (this.editedreport && this.editedreport.endsWith('[custom]')) {

            this.customReportDescription = this.Description;

        } else {


        }
    }
    labels = {
        scc_OrderStatusReportTracking,
        scc_OrderStatusReportSummary,
        scc_OrderStatusReportDetail,
        scc_calender_icon
    }
    alertIcon = imageIcons + '/Images/alert.png';

    handleCheckboxChange(event) {
        const field = event.target.dataset.id;

        if (field === 'include-all-isbns') {
            this.includeAllISBNs = event.target.checked;
            if (this.includeAllISBNs) {
                const textArea = this.template.querySelector('textarea[data-type="unique-includeAllISBNs"]');
                if (textArea) {
                    textArea.value = '';
                }
                this.checkEnableRunReport();
            }


        } else if (field === 'include-all-pos') {
            this.includeAllPOs = event.target.checked;

            if (this.includeAllPOs) {
                const textArea = this.template.querySelector('textarea[data-type="unique-includeAllPOs"]');
                if (textArea) {
                    textArea.value = '';
                }
                this.checkEnableRunReport();
            }

        }

    }
    handleRadioChange2(event) {


        //this.isRadio2Checked =!event.target.checked;
        this.isComboboxDisabled = !event.target.checked;
        this.endDate = '';
        this.startDate = '';
        this.OrderStatusValue = '';
        this.checkEnableRunReport();
    }
    @track isRadio1Checked = true;

    handleRadioChange1() {
        // this.isRadio1Checked=false;
        this.isComboboxDisabled = true
        this.orderEntryPeriod = '';
        this.checkEnableRunReport();

    }

    @track isComboboxDisabled = true;
    @track isRadio1Checked = true;
    @track isRadio2Checked = false
    // @track isCombobox2Disabled=true;
    handleSpecificISBNsChange(event) {

        this.specificISBNs = event.target.value;
        const rawInput = event.target.value;

        const lines = rawInput.split('\n');

        const cleanedLines = lines.map(line => line.trim().replace(/[^\dA-Za-z]/g, ''));

        const nonEmptyLines = cleanedLines.filter(line => line.length > 0);

        this.isbns = nonEmptyLines;

        this.checkEnableRunReport();
    }

    handleSpecificPOsChange(event) {
        this.specificPOs = event.target.value;
        const rawInput = event.target.value;

        const lines = rawInput.split('\n');

        const cleanedLines = lines.map(line => line.trim().replace(/[^\dA-Za-z]/g, ''));

        const nonEmptyLines = cleanedLines.filter(line => line.length > 0);

        this.ipos = nonEmptyLines;

        this.checkEnableRunReport();
    }
    get isISBNDisabled() {

        this.checkEnableRunReport();
        return this.includeAllISBNs;
    }

    get isPODisabled() {

        this.checkEnableRunReport();
        return this.includeAllPOs;
    }
    get OrderStatusOptions() {
        return this.OrderStatusOptions1;
    }
    get OrderEntryOptions() {
        return this.OrderEntryOptions1;
    }
    handleStartDateChange(event) {
        this.startDate = event.target.value;
        this.formatStartDate = new Date(this.startDate)

        this.checkEnableRunReport();
    }


    handleEndDateChange(event) {
        this.endDate = event.target.value;
        this.formatEndDate = new Date(this.endDate)

        this.checkEnableRunReport();
    }

    handleOrderStatusOptionChange(event) {
        this.OrderStatusValue = event.target.value;

        this.checkEnableRunReport();

    }


    handleOrderEntrOptionChange(event) {
        this.orderEntryPeriod = event.target.value;

        if (this.orderEntryPeriod == 'Last month') {
            this.Last_N_MONTH = '1';
        }
        if (this.orderEntryPeriod == 'Last 3 months') {
            this.Last_N_MONTH = '3';
        }
        if (this.orderEntryPeriod == 'Last 6 months') {
            this.Last_N_MONTH = '6';
        }
        if (this.orderEntryPeriod == 'Last 12 months') {
            this.Last_N_MONTH = '12';
        }
        if (this.orderEntryPeriod == 'Last 18 months') {
            this.Last_N_MONTH = '18';
        }
        if (this.orderEntryPeriod == 'Last 24 months') {
            this.Last_N_MONTH = '24';
        }
        if (this.orderEntryPeriod == 'Last 36 months') {
            this.Last_N_MONTH = '36';
        }

        this.checkEnableRunReport();
    }

    handleSearchOptionChange1(event) {
        this.SortOrder1 = event.target.value;
        this.checkEnableRunReport();

    }
    handleSearchOptionChange2(event) {
        this.SortOrder2 = event.target.value;
        this.checkEnableRunReport();

    }
    handleSearchOptionChange3(event) {
        this.SortOrder3 = event.target.value;
        this.checkEnableRunReport();

    }
    checkEnableRunReport() {
        this.runreportDisabled = !(
            this.startDate ||
            this.endDate || this.orderEntryPeriod ||
            this.OrderStatusValue ||
            this.SortOrder1 || this.SortOrder2 || this.SortOrder3 ||
            (!this.includeAllISBNs && this.specificISBNs) ||
            (!this.includeAllPOs && this.specificPOs)
        );
    }

    handleRunReport() {
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
            this.valuefromC = true;
            this.showEditPage = false;


            getOrderItemData({
                startDate: this.formatStartDate,
                endDate: this.formatEndDate,
                orderStatus: this.OrderStatusValue,
                poList: this.ipos,
                isbnList: this.isbns,
                sortOrder1: this.SortOrder1,
                sortOrder2: this.SortOrder2,
                sortOrder3: this.SortOrder3,
                orderEntryPeriod: this.Last_N_MONTH,


            })

                .then(data => {
                    this.records = data
                    this.enableSaveButton = true;

                    //data retrived caaling b comp


                    const resultsEvent = new CustomEvent('dataretrieved', {
                        detail: { results: this.records, valuefromC: this.valuefromC, editedreport: this.editedreport, enableSaveButton: this.enableSaveButton, originalReportType: this.originalReportType }


                    });
                    this.dispatchEvent(resultsEvent);





                })




                .catch(error => {
                    this.error = error;

                });

        }
    }

    handleClose(event) {
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {

            if (
                this.startDate ||
                this.endDate || this.orderEntryPeriod ||
                this.OrderStatusValue ||
                this.SortOrder1 || this.SortOrder2 || this.SortOrder3 ||
                (!this.includeAllISBNs && this.specificISBNs) ||
                (!this.includeAllPOs && this.specificPOs)
            ) {
                this.showclosewindow = true;
            }
            // 
            else {
                this.showEditPage = false;

                this.dispatchEvent(new CustomEvent('open', {
                    detail: {
                        editedreport: this.editedreport,
                        recordsData: this.recordsData
                    }
                }));
            }

        }
    }
    closeModal() {
        this.showclosewindow = false;
        const button = this.template.querySelector(".close");
        if (button) {
            setTimeout(() => {
                button.focus();
            }, 100);
        }
    }
    handleOpen() {
        this.showEditPage = false;

        this.dispatchEvent(new CustomEvent('open', {
            detail: {
                editedreport: this.editedreport,
                recordsData: this.recordsData
            }
        }));
    }
    handleCancel() {
        this.showclosewindow = false;
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