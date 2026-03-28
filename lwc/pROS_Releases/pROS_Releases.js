import { LightningElement, api, wire, track } from 'lwc';
import getReleasesList from '@salesforce/apex/PROSReleaseController.getReleasesList';
import setActiveRelease from '@salesforce/apex/PROSReleaseController.setActiveReleaseAndGetStatus';
import { refreshApex } from '@salesforce/apex';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';


export default class PROS_Releases extends LightningElement {
    @api recordId;
    message = '';
    record = {};
    selectedRows=[];
    @track columns = [{
        label: 'Version name',
        fieldName: 'Name',
        type: 'text',
        sortable: true
    },
    {
        label: 'Active',
        fieldName: 'Active__c',
        type: 'boolean',
        sortable: true
    },
    
    {
        label: 'Release Number',
        fieldName: 'CameleonCPQ__ReleaseNumber__c',
        type: 'int',
        sortable: true
    },

    {
        label: 'Status',
        fieldName: 'CameleonCPQ__Status__c',
        type: 'text',
        sortable: true
    }, 


    ];
    @track loaded = false;
    @track wiredDataResult;
    @track error;
    @track ressList;

    @wire(getReleasesList, { quoteId: '$recordId' })
    wiredReleases(response) {
        this.wiredDataResult = response;
        const data = response.data;
        const error = response.error;
        if (data) {
            this.loaded = true;
            this.ressList = data;
        } else if (error) {
            console.log(error)
            this.error = error.body.message;
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message;
            }
        } 

    }
 

    async handleSetAsActive() {
        var el = this.template.querySelector('lightning-datatable');
        
        var selected = el.getSelectedRows();
        var reId;
        for (const element of selected) {
            reId = element.Id;
        }
        this.loaded=false
        await setActiveRelease({ releaseId: reId })
            .then(result => {
                this.record = result;
                getRecordNotifyChange([{recordId: this.recordId}]);
                refreshApex(this.wiredDataResult);
                // eslint-disable-next-line no-eval
                eval("$A.get('e.force:refreshView').fire();");
                this.loaded=true;

            })
            .catch(error => {
              console.log(error)
                this.error = error;
            });
       
    }
    // refresh() {
    //     return refreshApex(this.wiredDataResult);
    // }

    getSelected() {
    //     var el = this.template.querySelector('lightning-datatable');
    //     // console.log(el);
    //     var selected = el.getSelectedRows();
    //     for (const element of selected) {
    //         console.log(element);
    //     }
    //     return refreshApex(this.ressList);


     }
}