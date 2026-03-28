import { LightningElement,api, wire, track } from 'lwc';
import getMatchedAccounts from '@salesforce/apex/RPAMatchedAccountController.getMatchedAccounts';
const columns = [
    { 
        label: 'Account Name',
        fieldName: 'accountLink',
        type:'url',
        typeAttributes: {
            label: { 
                fieldName: 'accountName'
            },
            target : '_blank'
        }
    },
    { 
        label: 'Account Address',
        fieldName: 'accAddLink',
        type:'url',
        typeAttributes: {
            label: { 
                fieldName: 'accAddName'
            },
            target : '_blank'
        }
    },
    {
        label: 'Street',
        fieldName: 'street',
        type: 'text',
        wrapText: true,
    },
    {
        label: 'City',
        fieldName: 'city',
        type: 'text',
        wrapText: true,
    },
    {
        label: 'State',
        fieldName: 'state',
        type: 'text',
        wrapText: true,
    },
    {
        label: 'Zip',
        fieldName: 'zip',
        type: 'text',
        wrapText: true,
    },
    {
        label: 'Source',
        fieldName: 'source',
        type: 'text',
        wrapText: true,
    }
];

export default class Rpa_matched_accounts extends LightningElement {
    
    @track columns = columns
    @track error;
    @track data;
    @track noData;

    @api recordId;

    async connectedCallback(){
        //defined a varibale
        if(this.recordId){
            try {
                const result = await getMatchedAccounts({orderId:this.recordId});
                console.log('Results--');
                console.log(JSON.stringify(result));
                if (result.length !== 0) {
                    this.data = result;
                }
                else if(result.length === 0){
                    console.log('no data section');
                    this.noData = 'No matching Accounts found';
                } 
            } catch (error) {
                this.error = error;
                throw new Error("Something went wrong with the request!");
            }
        }
    }   
}