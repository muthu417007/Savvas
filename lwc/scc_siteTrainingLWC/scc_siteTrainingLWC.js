/*
Lightning Web component: Scc_siteTrainingLWC
Author: CTS
Created Date: 
Reason: Backend logic for Site Training
Modified Date: 29/10/2024
*/
import { LightningElement, track } from 'lwc';
import getUserType from '@salesforce/apex/scc_accessCodeController.getUserType';
import SCC_HomePDF from '@salesforce/resourceUrl/SCC_HomePDF';
import SCC_ORDERSTATUS from '@salesforce/resourceUrl/SCC_ORDERSTATUS';
import SCC_PRICE from '@salesforce/resourceUrl/SCC_PRICE';
import SCC_PLACEORDER from '@salesforce/resourceUrl/SCC_PLACEORDER';
import SCC_FILE from '@salesforce/resourceUrl/SCC_FILE';
import SCC_REPORTS from '@salesforce/resourceUrl/SCC_REPORTS';
import SCC_DOCUMENTS from '@salesforce/resourceUrl/SCC_DOCUMENTS';
import SCC_ACCESSCODE from '@salesforce/resourceUrl/SCC_ACCESSCODE';
import SCC_INT_HOME from '@salesforce/resourceUrl/SCC_INT_HOME';
import SCC_INT_ORDERSTATUS from '@salesforce/resourceUrl/SCC_INT_ORDERSTATUS';
import SCC_INT_PRICE_AVAILABILITY from '@salesforce/resourceUrl/SCC_INT_PRICE_AVAILABILITY';
import SCC_INT_DOCUMENTS from '@salesforce/resourceUrl/SCC_INT_DOCUMENTS';
import SCC_INT_ACCESS_CODES from '@salesforce/resourceUrl/SCC_INT_ACCESS_CODES';
import SCC_INT_REPORTS from '@salesforce/resourceUrl/SCC_INT_REPORTS';
import getEnableConsoleLogsTrue from '@salesforce/apex/scc_headerLWC_Controller.getEnableConsoleLogsTrue';
export default class Scc_siteTrainingLWC extends LightningElement {
    @track isInternalUser = false;
    @track accountId;
    @track items = [];
    @track enableLogs = false;
    connectedCallback() {
        getEnableConsoleLogsTrue().then(response => {
            this.enableLogs = response;
            if (this.enableLogs) console.log('getEnableConsoleLogsTrue response is', response);
        }).catch(error => {
            if (this.enableLogs) console.log('error is', error);
        });
        this.checkUserType();
    }
    checkUserType() {
        getUserType()
            .then(result => {
                let parsedResult = JSON.parse(result);
                this.isInternalUser = parsedResult.isInternal;
                this.accountId = parsedResult.accountId;
                if (this.enableLogs) console.log('this.isInternalUser:', this.isInternalUser);
                if (this.enableLogs) console.log('User type:', this.isInternalUser ? 'Internal' : 'External');
                if (this.enableLogs) console.log('Account ID:', this.accountId);

                this.updateDisplay();
            })
            .catch(error => {
                if (this.enableLogs) console.error('Error fetching user type:', error);
            });
    }
    updateDisplay() {
        if (this.isInternalUser) {
            this.items = [
                { id: 1, title: 'HOME', type: SCC_INT_HOME, class: 'slds-hint-parent' },
                { id: 2, title: 'ORDER STATUS', type: SCC_INT_ORDERSTATUS },
                { id: 3, title: 'PRICE AND AVAILABILITY', type: SCC_INT_PRICE_AVAILABILITY, class: 'slds-hint-parent' },
                { id: 4, title: 'REPORTS', type: SCC_INT_REPORTS },
                { id: 5, title: 'DOCUMENTS', type: SCC_INT_DOCUMENTS },
                { id: 6, title: 'ACCESS CODES', type: SCC_INT_ACCESS_CODES }
            ];
        } else {
            this.items = [
                { id: 1, title: 'HOME', type: SCC_HomePDF, class: 'slds-hint-parent' },
                { id: 2, title: 'ORDER STATUS', type: SCC_ORDERSTATUS },
                { id: 3, title: 'PRICE AND AVAILABILITY', type: SCC_PRICE, class: 'slds-hint-parent' },
                { id: 4, title: 'PLACE ORDER', type: SCC_PLACEORDER },
                { id: 5, title: 'FILE CLAIM', type: SCC_FILE, class: 'slds-hint-parent' },
                { id: 6, title: 'REPORTS', type: SCC_REPORTS },
                { id: 7, title: 'DOCUMENTS', type: SCC_DOCUMENTS },
                { id: 8, title: 'ACCESS CODES', type: SCC_ACCESSCODE }
            ];
        }
    }
}