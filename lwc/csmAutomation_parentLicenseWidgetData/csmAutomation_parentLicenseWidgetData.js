import { LightningElement } from 'lwc';
import getLicenseData from '@salesforce/apex/CSMAutomation_LicenseWidgetController.processLicenseData';

export default class CsmAutomation_parentLicenseWidgetData extends LightningElement {
    graphData;

    connectedCallback() {
        getLicenseData({ recordId: 'someRecordId' }) // Replace with your recordId
            .then((data) => {
                this.graphData = data; // Pass data to child component
            })
            .catch((error) => {
                console.error('Error fetching data', error);
            });
    }
}