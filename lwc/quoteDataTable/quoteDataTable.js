import { LightningElement, wire, track, api } from 'lwc';
import fetchWrapperData from '@salesforce/apex/OpportunityQuoteSearchCntrl.getOrders';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

const columns = [
    { 
        label: 'Account Name',
        fieldName: 'accountName',
        type:'text',
        sortable: true
    },
    {
        label: 'Opportunity Name',
        fieldName: 'oppName',
        type: 'text',
        sortable: true
    },
    { 
        label: 'Quote Name',
        fieldName: 'quoteLink',
        type:'url',
        typeAttributes: {
            label: { 
                fieldName: 'quoteName'
            },
            target : '_blank'
        }
    },
    {
        label: 'Quote Number',
        fieldName: 'quoteNumber',
        type: 'text',
        wrapText: true,
    }
];

export default class QuoteDataTable extends LightningElement {
    @track columns = columns
    @track error;
    @track data;
    @track noData;

    @api caseId;
    @api accountId;

    async connectedCallback(){
        //defined a varibale
        if(this.accountId){
            try {
                const result = await fetchWrapperData({accountId:this.accountId});
                console.log('Results--');
                console.log(JSON.stringify(result));
                if (result.length !== 0) {
                    this.data = result;
                }
                else if(result.length === 0){
                    console.log('no data section');
                    this.noData = 'No current Quote associated Orders found';
                } 
            } catch (error) {
                this.error = error;
                throw new Error("Something went wrong with the request!");
            }
        }
    }    
}