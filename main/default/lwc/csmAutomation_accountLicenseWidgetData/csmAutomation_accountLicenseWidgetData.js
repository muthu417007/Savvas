import { LightningElement,wire,api } from 'lwc';
import Id from '@salesforce/user/Id';
import getAccounts from '@salesforce/apex/CSMAutomation_LicenseWidgetController.getAccounts';
import { loadScript } from 'lightning/platformResourceLoader';
import processLicenseData from '@salesforce/apex/CSMAutomation_LicenseWidgetController.processLicenseData';
import CHART_JS from '@salesforce/resourceUrl/ChartJS';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CsmAutomation_accountLicenseWidgetData extends LightningElement {
    accountOptions;accountOptions = [];
    selectedAccountId;
    chartData = [];
   
     // Wire Apex method to fetch accounts
     @wire(getAccounts)
     wiredAccounts({ error, data }) {
         if (data) {
             this.accountOptions = data.map(account => ({
                 label: account.Name,
                 value: account.Id,
                 sapId: account.Rumba_Organization_ID__c
             }));
         } else if (error) {
             console.error('Error fetching accounts:', error);
         }
     }
     handleAccountChange(event){
      this.selectedAccountId = event.detail.value;
     }

     handleGoClick(){
        if (this.selectedAccountId) {

        }
        else {
            alert('Please select an account');
        }
        
     }
//**********************************************CHART JS
    
 
}