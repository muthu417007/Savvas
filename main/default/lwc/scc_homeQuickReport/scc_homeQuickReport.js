/*********************************************************
  Component Name       : scc_homeQuickReport
  Created Date         : 06/10/2024  
  Author               : Cognizant (@⁠Ponraj,Jaba Raj )
  Description          : This component used in Home page and functionality related to 
                         display Quick Report.
  
  Modifications Log
  06/10/2024     Zubiya           Initial Version
*********************************************************/

import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import getReportOptions from '@salesforce/apex/scc_Custom_ReportsController.getReportOptions';
import sendReportEmail from '@salesforce/apex/scc_reportEmailService.sendReportEmail';
import getDetailReport from '@salesforce/apex/scc_Custom_ReportsController.detailReport';
import fetchCustomReportData from '@salesforce/apex/scc_editReportController.fetchCustomReportData';
import scc_OrderStatusReportTracking from "@salesforce/label/c.scc_OrderStatusReportTracking";
import scc_OrderStatusReportSummary from "@salesforce/label/c.scc_OrderStatusReportSummary";
import scc_OrderStatusReportDetail from "@salesforce/label/c.scc_OrderStatusReportDetail";
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';

export default class scc_homeQuickReport extends NavigationMixin(LightningElement) {

    @track SearchByvalue = '';
    @track SearchByOptions = [];
    @track handleSearchDisabled = true;
    @track emailInput = '';
    @track decodedValues;
    @track emailAddresses = [];
    @track selectedreport = '';
    billnum = null;
    shipnum = null;
    showOnScreen = false;
    sendEmail = true;
    isRadioDisabled = false;
    @track optionsMap = new Map();
    @track optionsArray = [];
    @track selectedReportType = '';
    @track selectedReportName = '';
    @track emailRecords;
    @track matchedReportName = '';
    @track Description = '';
    @track originalReportType = '';
    @track customReportDescription = '';
    @track enableLogs = false;

    labels = {
        scc_OrderStatusReportTracking,
        scc_OrderStatusReportSummary,
        scc_OrderStatusReportDetail
    }

    connectedCallback() {
        this.isEmailSelected = true;
        this.loadReportOptions();
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        });

    }

    handleSearchOptionChange(event) {
        this.SearchByvalue = event.detail.value;
        const selectedOption = this.optionsMap.get(this.SearchByvalue);
        const standardReports = ['Order Status Report – Summary', 'Order Status Report – Detail', 'Order Status Report – Tracking'];
        this.matchedReportName = standardReports.find(report =>
            report === selectedOption.originalReportType ||
            report === this.SearchByvalue);

        let isStandardReport = !!this.matchedReportName;

        if (selectedOption) {
            if (selectedOption.source === 'custom') {
                this.selectedReportType = `${this.SearchByvalue} [custom]`;
                this.originalReportType = selectedOption.originalReportType;
                this.loadCustomReportData();
            }
            else {
                this.selectedReportType = this.SearchByvalue;
                this.originalReportType = this.SearchByvalue;
                this.fetchDetailReport();
            }
        }
        this.setDescription();
        this.updateRunButtonState();


    }
    // Radio button handler: "Show on Screen"
    handleRadio1() {
        this.showOnScreen = true
        this.isEmailSelected = false;
        this.showErrorMessage = false;
        this.updateRunButtonState();
    }
    // Radio button handler: "Email to"
    handleRadio2() {
        this.showOnScreen = false
        this.isEmailSelected = true;
        this.validateEmail();
        this.updateRunButtonState();
    }

    updateRunButtonState() {
        if (this.isEmailSelected) {
            this.handleSearchDisabled = !(this.emailInput.trim() && !this.showErrorMessage && this.SearchByvalue);
        }
        else {
            this.handleSearchDisabled = !this.SearchByvalue;
        }
    }
    handleEmailInput(event) {
        this.emailInput = event.target.value;
        this.validateEmail();
        this.updateRunButtonState();
    }

    validateEmail() {
        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        this.emailAddresses = this.emailInput.split(',').map(email => email.trim());
        const allValidEmails = this.emailAddresses.every(email => emailPattern.test(email));
        if (this.isEmailSelected && this.emailInput.trim() !== '' && !allValidEmails) {
            this.showErrorMessage = true;
            this.errorMessage = 'Please enter valid email addresses separated by commas.';
        } else {
            this.showErrorMessage = false;
            this.errorMessage = '';
        }
    }
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
                    });
                })
            })
            .catch(error => {
                if (this.enableLogs) console.error('Error fetching report options', error);
            });
    }
    setDescription() {
        const standardDescriptions = {
            'Order Status Report – Summary': scc_OrderStatusReportSummary,
            'Order Status Report – Detail': scc_OrderStatusReportDetail,
            'Order Status Report – Tracking': scc_OrderStatusReportTracking
        };

        if (standardDescriptions[this.SearchByvalue]) {
            this.Description = standardDescriptions[this.SearchByvalue];
        }
        else {
            const selectedOption = this.optionsMap.get(this.SearchByvalue);
            if (selectedOption) {
                this.Description = selectedOption.description;
                this.customReportDescription = selectedOption.description;
                this.originalReportType = selectedOption.originalReportType;
            } else {
                this.Description = 'No description available';
                if (this.enableLogs) console.log('No description found for:', this.SearchByvalue);
            }
        }
    }

    handleSearch() {
        this.optionsArray = Array.from(this.optionsMap.entries()).map(([key, value]) => {
            return { key, ...value };
        });
        if (this.showOnScreen == true && this.SearchByvalue) {
            const encodedValues = encodeDefaultFieldValues({
                Search: this.SearchByvalue,
                optionsArray: JSON.stringify(this.optionsArray)
            });
            this[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    name: 'Reports__c'  //Api name
                },
                state: {
                    defaultFieldValues: encodedValues
                }
            })
            this.clearDecodedValues();
            this.clearPageReference();
        }

        if (this.isEmailSelected == true && this.emailInput) {
            this.emailHandler();
        }
    }
    clearPageReference() {
        if (this.currentPageReference && this.currentPageReference.state.defaultFieldValues) {
            delete this.currentPageReference.state.defaultFieldValues;
        }
    }
    clearDecodedValues() {
        sessionStorage.removeItem('decodedValues');
        this.decodedValues = null;
        this.skipDecoding = true;
    }

    async emailHandler(event) {
        this.handleSearchDisabled = true;
        this.isLoader = true;
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

                if (this.matchedReportName === 'Order Status Report – Summary') {
                    return {
                        ...commonData,
                        'Shipped Qty': record.shippedQuantity != null ? record.shippedQuantity : 0,
                        'Backorder Qty': record.backorderQuantity != null ? record.backorderQuantity : 0,
                        'Due Date': record.dueDate || '',
                        'On Hold Qty': record.holdQuantity != null ? record.holdQuantity : 0,
                        'Cancelled Quantity': record.cancelledQuantity != null ? record.cancelledQuantity : 0,
                    };
                } else if (this.matchedReportName === 'Order Status Report – Detail') {
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
                } else if (this.matchedReportName === 'Order Status Report – Tracking') {
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
            const csvString = this.convertToCSV(filteredReportData, this.matchedReportName);
            if (this.enableLogs) console.log(csvString);

            // Call Apex method
            await sendReportEmail({
                emailAddresses: this.emailAddresses,
                reportType: this.matchedReportName,
                reportData: csvString,
                reportName: this.SearchByvalue
            });

            // Success handler
            this.isLoader = false;
            this.emailInput = '';
            this.handleSearchDisabled = true;
        } catch (error) {
            // Error handler
            this.isLoading = true;
            if (this.enableLogs) console.error('Error processing email:', error);
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

    loadCustomReportData() {
        fetchCustomReportData({ reportNameWithCustom: this.SearchByvalue })
            .then(result => {

                this.records = result;
                this.emailRecords = result;
            })
    }
    fetchDetailReport() {
        getDetailReport({ BillTo: this.billnum, ShipTo: this.shipnum })
            .then(data => {

                this.records = data
                this.emailRecords = data;
            })
            .catch(error => {
                this.error = error;
                if (this.enableLogs) console.error('Error fetching detail report:', error);
            });
    }
}