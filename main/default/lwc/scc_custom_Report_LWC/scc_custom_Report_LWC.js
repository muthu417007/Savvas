/*********************************************************
  Component Name       : scc_custom_Report_LWC
  Created Date         : 07/21/2024  
  Author               : Sudha Rani pathivada- Cognizant
  Description          : Main component for  Reports 
  
  Modifications Log
  <Date>       <Author>            <Modification>
  
*********************************************************/

import { LightningElement, track, wire } from 'lwc';

import { CurrentPageReference } from 'lightning/navigation'; //Added by Zubiya for quick report
import { decodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import deleteCustomReportByName from '@salesforce/apex/scc_Custom_ReportsController.deleteCustomReportByName';
import { refreshApex } from '@salesforce/apex';
//Apex
import getReportOptions from '@salesforce/apex/scc_Custom_ReportsController.getReportOptions';// added by sudha W-014819
import getBillingAddress from '@salesforce/apex/scc_confirmAddress.getUserBillingAddress';
import getRelatedShippingAddress from '@salesforce/apex/scc_confirmAddress.getUserShippingAddress';
import { RefreshEvent } from 'lightning/refresh';

//labels
import scc_OrderStatusReportTracking from "@salesforce/label/c.scc_OrderStatusReportTracking";// added by sudha W-014819
import scc_OrderStatusReportSummary from "@salesforce/label/c.scc_OrderStatusReportSummary";// added by sudha W-014819
import scc_OrderStatusReportDetail from "@salesforce/label/c.scc_OrderStatusReportDetail";// added by sudha W-014819
export default class scc_custom_Report_LWC extends LightningElement {



    //track // added by sudha W-014819
    @track viewSampleDisabled = true;
    @track deletereportDisabled = true
    editcriteriaDisabled = true;
    @track runreportDisabled = true
    @track SearchByOptions = [];
    @track SearchByvalue = '';
    @track Description = '';
    @track SelectedValue = false;
    OrderStatusReportSummary = false;
    OrderStatusReportDetail = false;
    OrderStatusReportTracking = false;
    CustomReport = false;
    @track isSelectedviewsample = false;
    @track selectedReportType = '';
    @track mainPage = true;
    @track detailpageopen = false;
    @track showpageopen = false
    @track billToNumber;
    @track ShipToNumber;
    @track selectedBilling;
    @track records = [];
    @track msgfromc = false
    @track isEmailSent = false;

    labels = {
        scc_OrderStatusReportTracking,
        scc_OrderStatusReportSummary,
        scc_OrderStatusReportDetail
    }
    //edit component variables
    @track editCriteria = false;
    @track EditedReportName = '';
    // ended by sudha //
    // Mutliaddreess code start 
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
    lengthBillAddress;
    totalBillToRecords;
    totalShipToRecords
    selectedAccount;
    selectedShipAccount;
    previouslySelected;
    showMultiAddressPage = false;
    showSingleAddressPage = false;
    isChecked = true;

    constructor(){
         
        super();
        this.fetchBillingAddress();        

    }

    // decodedValues = null;
    @wire(CurrentPageReference)      //added by zubiya

    getStateParameters(currentPageReference) {

        if (currentPageReference) {
            if (currentPageReference.state.defaultFieldValues) {

                this.decodedValues = decodeDefaultFieldValues(currentPageReference.state.defaultFieldValues);
            }
            sessionStorage.setItem('decodedValues', JSON.stringify(this.decodedValues));
        }

    }

    getStateParameters(currentPageReference) {

        // Check if decodedValues already exist in session storage
        const storedValues = sessionStorage.getItem('decodedValues');

        if (!storedValues && currentPageReference && !this.skipDecoding) {  // Proceed only if no stored values exist
            if (currentPageReference.state.defaultFieldValues) {

                this.decodedValues = decodeDefaultFieldValues(currentPageReference.state.defaultFieldValues);
                sessionStorage.setItem('decodedValues', JSON.stringify(this.decodedValues)); // Store decoded values
            }
        }


    }
    getStateParameters(currentPageReference) {


        const storedValues = sessionStorage.getItem('decodedValues');

        if (!storedValues && currentPageReference && currentPageReference.state.defaultFieldValues) {


            // Decode the default field values from the page reference
            this.decodedValues = decodeDefaultFieldValues(currentPageReference.state.defaultFieldValues);

            // Store the decoded values in sessionStorage
            sessionStorage.setItem('decodedValues', JSON.stringify(this.decodedValues));

            // Clear the defaultFieldValues from the URL
            this.clearUrlState();

        } else if (storedValues) {
            // Use the stored values if available
            this.decodedValues = JSON.parse(storedValues);
        }


    }

    clearUrlState() {
        // Get the current URL without the query parameters (defaultFieldValues)
        let url = new URL(window.location.href);

        // Remove the 'defaultFieldValues' query parameter
        url.searchParams.delete('defaultFieldValues');

        // Push the new URL to the browser history without reloading the page
        window.history.pushState({}, document.title, url.toString());


    }

    fetchBillingAddress(){
        getBillingAddress().then(response => {
            this.billaddress = response;
            this.selectedBilling = this.billaddress.find(billing => billing.AccId === this.billaddress[0].AccId);

            this.billToNumber = this.selectedBilling.BillToNumber;

            this.totalRecords = response.length;
            this.billingaddreses = response;

            this.applyFilters();

            this.selectedAccount = response[0];
            this.selectedAccountId = response[0].AccId;

        }).catch(error => {
            this.error = error;            
            console.log('getBillingAddress error is', error);            
        })
    }

    @wire(getBillingAddress)
    wiredBillAddresss({ error, data }) {
        if (data) {
            this.billaddress = data;
            this.selectedBilling = this.billaddress.find(billing => billing.AccId === this.billaddress[0].AccId);

            this.billToNumber = this.selectedBilling.BillToNumber;

            this.totalRecords = data.length;
            this.billingaddreses = data;

            this.applyFilters();

            this.selectedAccount = data[0];
            this.selectedAccountId = data[0].AccId;

        } else if (error) {
            this.error = error;

        }
    }

    @wire(getRelatedShippingAddress)
    wiredShipAddress({ error, data }) {
        if (data) {
            this.Shipaddress = data;
            this.totalRecordsInShip = data.length;
            if (this.totalRecords > 1 || this.totalRecordsInShip > 1) {
                this.showMultiAddressPage = true;

            } else {
                this.showMultiAddressPage = false;

            }

            this.applyFilterss();
        }
        else if (error) {
            this.error = error;
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


    renderedCallback() {
        if (this.selectedAccountId) {
            const billingInputs = this.template.querySelectorAll('input[name="BillingAddresss"]');
            billingInputs.forEach(input => {
                if (input.value === this.selectedAccountId) {
                    input.checked = true;
                }
            });
        }
        if (this.selectedShipAccountId) {

            const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
            shippingInputs.forEach(input => {

                if (input.value === this.selectedShipAccountId) {

                    input.checked = true;
                }
            });
        }
    }
    handleRowClick(event) {

        this.selectedAccountId = event.currentTarget.dataset.recordId;
        this.billToNumber = event.target.getAttribute('data-attribute-billtonumber');

    }
    handleShipRowClick(event) {

        this.selectedShipAccountId = event.currentTarget.dataset.recordId;
        this.ShipToNumber = event.target.getAttribute('data-attribute-ShipToNumber');

        this.isChecked = false;
        const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
        shippingInputs.forEach(input => {
            if (input.value === this.selectedShipAccountId) {
                input.checked = true;
            }
        });

    }
    handlecheckboxChange(event) {
        this.isChecked = event.target.checked;

        if (this.isChecked == true) {
            this.ShipToNumber = '';
            const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
            shippingInputs.forEach(input => {
                if (input.value === this.selectedShipAccountId) {

                    input.checked = false;
                    this.handlechangemethod();
                }
            });
        }
        else {
            this.selectedShipAccountId = '';
        }
    }
    handlechangemethod() {
        if (this.selectedShipAccountId) {

            const shippingInputs = this.template.querySelectorAll('input[name="shipping-address"]');
            shippingInputs.forEach(input => {
                if (input.value === this.selectedShipAccountId) {

                    input.checked = false;
                }
            });
        }
    }
    handleUserInputs(event) {
        this.searchTerm = event.target.value.toLowerCase();

        this.applyFilters();
    }
    clearFilterInputBill() {
        this.searchTerm = '';

        this.applyFilters();
    }

    handleUserInputsShip(event) {
        this.searchTermShip = event.target.value.toLowerCase();

        this.applyFilterss();
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

        // this.selectedAccountId =this.filteredresult[0].AccId;
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

    // Mutliaddreess code end 

    // added by sudha // Custom ReportCode W-014819 //
    @track optionsArray = [];
    @track calledCurrentreference = false;
    connectedCallback() {

        const storedValues = sessionStorage.getItem('decodedValues');

        if (storedValues) {
            // Parse the stored JSON string and assign it to decodedValues
            this.decodedValues = JSON.parse(storedValues);


            // Set the SearchByvalue from the decoded values
            let Search = this.decodedValues.Search;
            this.SearchByvalue = Search;

            // Check if optionsArray exists and is a string
            if (this.decodedValues.optionsArray) {
                // Parse optionsArray as it is a string
                const parsedOptionsArray = JSON.parse(this.decodedValues.optionsArray);

                // Check if the parsedOptionsArray is indeed an array
                if (Array.isArray(parsedOptionsArray)) {
                    // Create a Map for optionsArray using the parsed values
                    this.optionsArray = new Map(parsedOptionsArray.map(item => [item.key, {
                        description: item.description,
                        source: item.source,
                        originalReportType: item.originalReportType
                    }]));

                } else {

                }
            } else {

            }

            // Set the description based on the decoded values
            this.setDescription();

            // Call the report handler with the current values
            this.runreporthander();
        } else {

        }
        this.loadReportOptions();
        //to catch escape keypress for accessibility

        this.template.addEventListener('keydown', this.handleKeydown.bind(this));

    }

    disconnectedCallback() {

        sessionStorage.removeItem('decodedValues');


        // Remove the keydown event listener when the component is removed from the DOM
        this.template.removeEventListener('keydown', this.handleKeydown);
    }

    //close popup when user press escape key -accessibility
    handleKeydown(event) {
        // Handle the keydown event
        if (event.key === 'Escape') {

            if (this.showDelete) {
                this.closeDetailModal();
            }
        }
    }
    runreportbuttonhander(event) {
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
            this.runreporthander();
        }
    }
    @track optionsMap = new Map();
    @track customReportDescription = '';

    loadReportOptions() {
        getReportOptions()
            .then(result => {
                const options = JSON.parse(result);

                this.SearchByOptions = options.map(option => {
                    return { label: option.label, value: option.value };
                });
                options.forEach(option => {

                    this.optionsMap.set(option.value, {
                        description: option.description,
                        source: option.source,
                        originalReportType: option.originalReportType
                        // originalReportType = option.originalReportType

                    });
                })

            })

            .catch(error => {

            });

        // Inside your setDescription method, add logs to trace the values:

    }

    handleSearchOptionChange(event) {
        this.SearchByvalue = event.detail.value;
        const selectedOption = this.optionsMap.get(this.SearchByvalue);



        if (selectedOption) {

            if (selectedOption.source === 'custom') {

                this.deletereportDisabled = false;
                this.EditedReportName = `${this.SearchByvalue} [custom]`;
                this.selectedReportType = `${this.SearchByvalue} [custom]`;


            } else {
                this.EditedReportName = this.SearchByvalue;

                this.deletereportDisabled = true;
            }
        }
        //   this.selectedDescription = this.optionsMap.get(selectedValue) || 'No description available';
        //this.EditedReportName = this.SearchByvalue;
        if (this.SearchByvalue && this.SearchByvalue.trim() !== '') {
            this.SelectedValue = true;
            this.viewSampleDisabled = false;
            // this.deletereportDisabled=true;
            this.editcriteriaDisabled = false;
            this.runreportDisabled = false
        } else {
            this.SelectedValue = false;
        }
        this.setDescription();
    }

    @track originalReportType = '';
    setDescription() {
        const standardDescriptions = {
            'Order Status Report – Summary': scc_OrderStatusReportSummary,
            'Order Status Report – Detail': scc_OrderStatusReportDetail,
            'Order Status Report – Tracking': scc_OrderStatusReportTracking
        };



        if (standardDescriptions[this.SearchByvalue]) {
            // Set the description from the predefined list if it matches
            this.Description = standardDescriptions[this.SearchByvalue];


        }
        else {
            if (this.decodedValues != null) {
                const selectedOption = this.optionsArray.get(this.SearchByvalue);
                if (selectedOption) {
                    this.Description = selectedOption.description;
                    this.customReportDescription = selectedOption.description;
                    this.originalReportType = selectedOption.originalReportType
                    this.originalReportTypefromEdit = selectedOption.originalReportType;


                } else {
                    this.Description = 'No description available';

                }
            }


            // If no standard description, try to get from optionsMap
            const selectedOption = this.optionsMap.get(this.SearchByvalue);
            if (selectedOption) {
                this.Description = selectedOption.description;
                this.customReportDescription = selectedOption.description;
                this.originalReportType = selectedOption.originalReportType
                this.originalReportTypefromEdit = selectedOption.originalReportType;

            } else {
                this.Description = 'No description available';

            }


        }



    }

    viewSamplehander(event) {
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
            this.mainPage = false;
            this.isSelectedviewsample = true;

            this.showpageopen = false
            const selectedOption = this.optionsMap.get(this.SearchByvalue);
            if (selectedOption.source === 'custom') {
                this.EditedReportName = `${this.SearchByvalue} [custom]`;
                this.selectedReportType = `${this.SearchByvalue} [custom]`;


            } else {
                this.selectedReportType = this.SearchByvalue;
            }

        }
    }
    runreporthander(event) {



        // Check if decodedValues and SearchByvalue are not null or undefined
        if (this.decodedValues && this.SearchByvalue) {
            this.mainPage = false;
            this.isSelectedviewsample = true;

            // Retrieve the selected option from optionsArray (which is now a Map)
            const selectedOption = this.optionsArray.get(this.SearchByvalue);

            // Check if the selectedOption exists before using its properties
            if (selectedOption) {
                if (selectedOption.source === 'custom') {
                    // Set names for custom reports
                    this.EditedReportName = `${this.SearchByvalue} [custom]`;
                    this.selectedReportType = `${this.SearchByvalue} [custom]`;


                } else {
                    // Handle standard reports
                    this.EditedReportName = this.SearchByvalue;
                    this.selectedReportType = this.SearchByvalue;
                }

                // Open the detailed page for the report
                this.detailpageopen = true;
                this.showpageopen = this.detailpageopen;

            }
        }
        else {
            //if (!JSON.parse(this.template.querySelector('.run-report').getAttribute('aria-disabled'))) {
            //if (this.SearchByvalue && this.optionsMap.has(this.SearchByvalue)) {

            this.mainPage = false;
            this.isSelectedviewsample = true;
            const selectedOption = this.optionsMap.get(this.SearchByvalue);
            if (selectedOption.source === 'custom') {

                this.EditedReportName = `${this.SearchByvalue} [custom]`;
                this.selectedReportType = `${this.SearchByvalue} [custom]`;


            } else {
                this.selectedReportType = this.SearchByvalue;

            }
            this.detailpageopen = true;
            this.showpageopen = this.detailpageopen;
            //this.selectedReportType= this.SearchByvalue;

        }
    }

    editcriteriahander() {
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
            this.editCriteria = true
            this.mainPage = false;

        }
    }
    handleClose(event) {
        this.decodedValues = null;
        sessionStorage.removeItem('decodedValues');
        this.calledCurrentreference = true;
        // CurrentPageReference='';

        this.mainPage = true

        this.runreportDisabled = true;
        this.SearchByvalue = event.detail.value; // Update the dropdown value
        this.isSelectedviewsample = false;

        this.deletereporthander
        return refreshApex(this.loadReportOptions);

    }
    handleDetailClose(event) {


        sessionStorage.removeItem('decodedValues');


        // Clear decodedValues in the component
        this.decodedValues = null;

        // Reset state flags
        this.skipDecoding = true;


        // Handle the detail close event, which does not send any value// for runreport 

        // Reset to initial state or handle as necessary
        this.msgfromc = event.detail.cmsg;

        // this.mainPage = true; 
        this.SearchByvalue = '';
        this.Description = '';
        this.SelectedValue = '';
        this.showpageopen = false;
        this.viewSampleDisabled = true;
        this.deletereportDisabled = true
        this.editcriteriaDisabled = true;
        this.runreportDisabled = true
        this.editCriteria = false;
        this.detailpageopen = false;
        //this.showMultiAddressPage=true;
        this.isSelectedviewsample = false;
        // return refreshApex(this.loadReportOptions);  
        window.location.reload();
    }
    @track originalReportTypefromEdit = '';
    handleDataRetrieved(event) {
        this.isSelectedviewsample = true;
        this.msgfromc = true;
        const fetchedRecords = event.detail.results;
        this.selectedReportType = event.detail.editedreport;
        this.originalReportTypefromEdit = event.detail.originalReportType;

        this.records = fetchedRecords;

    }
    handleOpen() {


        this.mainPage = true;
        this.SearchByvalue = '';
        this.Description = '';
        this.SelectedValue = '';
        this.showpageopen = false;
        this.viewSampleDisabled = true;
        this.deletereportDisabled = true
        this.editcriteriaDisabled = true;
        this.runreportDisabled = true
        this.isSelectedviewsample = false;
        this.editCriteria = false;
        this.msgfromc = false;




    }
    @track isLoading = false;
    handleEmailSent() {
        this.isSelectedviewsample = false;
        this.editCriteria = false;
        this.showMultiAddressPage = false;
        this.mainPage = true;
        this.isEmailSent = true;
        this.SearchByvalue = '';
        this.SelectedValue = false;
        this.viewSampleDisabled = true;
        this.runreportDisabled = true;
        this.deletereportDisabled = true;
        this.editcriteriaDisabled = true;
        return refreshApex(this.loadReportOptions);  
        
    }
    @track showDelete = false;
    deletereporthander() {
        if (!JSON.parse(event.target.getAttribute('aria-disabled'))) {
            this.showDelete = true;
            setTimeout(() => {
                this.template.querySelector('.deleteRprtCloseBtn').focus();
            }, 100);
            this.focusCloseButton();
            setTimeout(() => {
                button.focus();
            }, 100);

        }
    }
    selectDeleteHander() {
        this.deletereportDisabled = true;
        this.isLoading = true;

        const selectedOption = this.optionsMap.get(this.SearchByvalue);
        if (selectedOption && selectedOption.source === 'custom') {
            const reportNameToDelete = this.SearchByvalue


            deleteCustomReportByName({ reportName: reportNameToDelete })

                .then(() => {
                    //this.showDelete=false;
                    this.SearchByvalue = null;
                    this.Description = '';
                    this.optionsMap.delete(reportNameToDelete);
                    this.SearchByOptions = this.SearchByOptions.filter(option => option.value !== reportNameToDelete);
                    this.SearchByOptions = [...this.SearchByOptions];
                    this.showDelete = false;
                    this.deletereportDisabled = true
                    // this.showDelete = false;
                    this.isLoading = false;

                    return refreshApex(this.loadReportOptions);
                })

                .catch(error => {

                    this.isLoading = false;

                });
        }
    }
    CancelDeletePopUp() {
        this.showDelete = false;
        const button = this.template.querySelector(".delete-report");
        if (button) {
            setTimeout(() => {
                button.focus();
            }, 100);
        }
    }
    closeDetailModal() {
        this.showDelete = false;
        const button = this.template.querySelector(".delete-report");
        if (button) {
            setTimeout(() => {
                button.focus();
            }, 100);
        }
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