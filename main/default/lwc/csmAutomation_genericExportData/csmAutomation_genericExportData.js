import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import getAccountHierarchy from '@salesforce/apex/CSMAutomation_LicenseServiceController.getAccountHierarchy';
const fields = [NAME_FIELD];

export default class CsmAutomation_genericExportData extends LightningElement {
    @api responseData; // Transformed data passed from parent
    @api accountId;
    buttonLabel = 'Export';
    accountMap = {};
    @wire(getAccountHierarchy, { recordId: '$accountId' })
    wiredgetAccountHierarchy({ error, data }) {
        if (data) {
            this.accountMap = data
            console.log('this.accountMap', this.accountMap);
        }
        else if (error) {
            console.error('Error fetching account hierarchy', error);
        }
    }
    // Define column names and mappings in the exportData component
    columnHeaders = [
        { label: 'Parent Account', fieldName: 'parentAccountName' },
        { label: 'Account', fieldName: 'accountName' },
        { label: 'A&E Product Name', fieldName: 'productDisplayName' },
        { label: 'ISBN Product', fieldName: 'orderedISBN' },
        { label: 'Customer PO', fieldName: 'customerPO' },
        { label: 'SAP Order Document #', fieldName: 'sapOrderDocumentNumber' },
        { label: 'SAP Order Type', fieldName: 'sapOrderType' },
        { label: 'A&E Licensepool ID', fieldName: 'licenseId' },
        { label: 'License Start Date', fieldName: 'startDate' },
        { label: 'License Exp Date', fieldName: 'endDate' },
        { label: '#License Provisioned', fieldName: 'quantity' },
        { label: 'License Status', fieldName: 'licensePoolStatus' },
        { label: 'Organization Name', fieldName: 'licensedOrganizationDisplayName' },
        { label: 'Organization ID', fieldName: 'organizationId' },
        { label: 'Org SAP ID', fieldName: 'orgSAPID' }
    ];

    @wire(getRecord, {
        recordId: "$accountId",
        fields
    })
    account;

    get name() {
        return getFieldValue(this.account.data, NAME_FIELD);
    }

    handleExport() {
        let csvString = '';
        const columnHeader = [];
        this.columnHeaders.forEach(column => {
            let label = column.label.toString().replace(/"/g, '""');
            label = label.replace(/#/g, '');
            columnHeader.push(`"${label}"`);
        });
        csvString += columnHeader.join(',') + '\n'; // Create header row

        if (!this.responseData) {
            console.error('No data provided for export.');
            return;
        }
        console.log('csvString' + csvString);
        // Generate CSV content

        this.responseData.forEach(record => {
            let row = [];
            let accountName = '';
            let parentAccountName = '';
            let orgSAPID = record['orgSAPID'];
             if(this.accountMap && this.accountMap[orgSAPID]){
                 accountName = this.accountMap[orgSAPID].AccountName;
                 parentAccountName = this.accountMap[orgSAPID].ParentAccountName;
             }
            this.columnHeaders.forEach(column => {
                let value = record[column.fieldName] !== undefined ? record[column.fieldName] : ''; // Handle undefined values
                // value = value.toString().replace(/"/g, '""');
                //  value = String(value);
                if (column.fieldName === 'accountName') {
                    value = accountName;
                    console.log('accountname<><> ', value);
                }
                if (column.fieldName === 'parentAccountName') {
                    value = parentAccountName;
                    console.log('parentAccountName<><> ', value);
                }
                //  value = value.replace(/"/g,'""');
                if (!isNaN(value) && value.toString().length > 10) {
                    value = `="` + value.toString() + `"`;
                    // value = `"${value}"`;
                }

                else if (typeof value === 'string' && (value.includes(',') || value.includes('\n') || value.includes('"'))) {
                    //value = `"${value}"`;
                    value = `"${value.replace(/"/g, '""')}"`;
                }
                //  row.push(`"${value}"`);
                row.push(value);
            });
            csvString += row.join(',') + '\n';
        });
        const now = new Date();
        const options = {
            day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit'
        };
        const formattedDateTime = now.toLocaleTimeString('en-GB', options);
        const anchor = document.createElement('a');
        anchor.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvString);
        anchor.target = '_self';
        anchor.download = `${this.name}_${formattedDateTime}_LicenseData.csv`;
        document.body.appendChild(anchor);
        anchor.click();
    }

}