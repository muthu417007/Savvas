import { LightningElement, wire, track, api } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getQuotes from '@salesforce/apex/SavQuoteController.getQuote';
import getReleases from '@salesforce/apex/SavQuoteController.getReleases';

// row actions
const actions = [
    { label: 'Set as Active Release', name: 'activate'},
    { label: 'Edit Release', name: 'edit'}
];

const cols = [
    { label: 'Name', fieldName: 'Name',type:"text" },
    { label: 'Status', fieldName: 'CameleonCPQ__Status__c',type:"text" },
    { label: 'Release Number', fieldName: 'CameleonCPQ__ReleaseNumber__c', type:'text'},
    { label: 'Created Date', fieldName: 'CreatedDate',type:"date" },
    { label: 'Created By', fieldName: 'CreatedBy.Name',type:"text" },
    { label: 'Active', fieldName: 'Active__c',type:"boolean" },
    {
        type: 'action',
        typeAttributes: {
            rowActions: actions,
            menuAlignment: 'right'
        }
    }
];

export default class  SavSelectActiveReleaseFromQuote extends NavigationMixin(LightningElement) {

    @api recordId;
    @track error;
    @track quote;
    @track release;
    @track columns = cols;
    @track draftValues = [];

    wiredResults;
    @wire(getReleases, { quoteId: '$recordId' }) 
    getReleases(result){  
        this.wiredResults = result;

        if(result.data) {
            //this is the final array into which the flattened response will be pushed. 
            let releaseArray = [];
            let data = result.data;

            console.log('Results of query: ' + JSON.stringify(result.data));
             
            for (let row of data) {
                 // this const stroes a single flattened row. 
                 const flattenedRow = {}
                 
                 // get keys of a single row — Name, Phone, LeadSource and etc
                 let rowKeys = Object.keys(row); 
                
                 //iterate 
                 rowKeys.forEach((rowKey) => {
                     
                     //get the value of each key of a single row. John, 999-999-999, Web and etc
                     const singleNodeValue = row[rowKey];
                     
                     //check if the value is a node(object) or a string
                     if(singleNodeValue.constructor === Object){
                         
                         //if it's an object flatten it
                         this._flatten(singleNodeValue, flattenedRow, rowKey)        
                     }else{
                         
                         //if it’s a normal string push it to the flattenedRow array
                         flattenedRow[rowKey] = singleNodeValue;
                     }
                     
                 });
                
                 //push all the flattened rows to the final array 
                 releaseArray.push(flattenedRow);
             }
             
             //assign the array to an array that's used in the template file
             this.release = releaseArray;
         } 

    }

    @wire(getQuotes, { quoteId: '$recordId' }) 
    getQuotes({ error, data }) {  
        if (data) {
            this.quote = data;
            
        } 
    }

    handleRowActions(event) {
        let actionName = event.detail.action.name;
        let row = event.detail.row;

        switch (actionName) {
            case 'activate':
                this.activateRelease(row);
                break;
            case 'edit' :
                this.editRelease(row);
            //add more switch cases if we want to expand this

        }
    }

    activateRelease(currentRow) {
        let record = {
            fields: {
                Id: this.recordId,
                CameleonCPQ__ActiveRelease__c: currentRow.CameleonCPQ__ReleaseNumber__c              
            },
        };

        updateRecord(record)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Active Release Set',
                        variant: 'success',
                    }),
                );
                return refreshApex(this.wiredResults);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error on data save',
                        message: error.message.body,
                        variant: 'error',
                    }),
                );
            });
    }

    editRelease(currentRow) {

            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: currentRow.Id,
                    objectApiName: 'CameleonCPQ__QuoteRelease__c',
                    actionName: 'edit'
                }
            });
    }

     //create keys in the format of OBJECT.FIELD this is to flatten nested JSON into a single array structure that a datatable can handle.
    _flatten = (nodeValue, flattenedRow, nodeName) => {        
        let rowKeys = Object.keys(nodeValue);
        rowKeys.forEach((key) => {
            let finalKey = nodeName + '.'+ key;
            flattenedRow[finalKey] = nodeValue[key];
        })
    }
}