import { LightningElement,api,track,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import fetchGenericContacts from '@salesforce/apex/FetchGenericContacts.searchSampleContacts';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { deleteRecord} from 'lightning/uiRecordApi';
import LightningConfirm from 'lightning/confirm';
const columnsVal=[
   /* {  label: 'Action',
    type: "button", typeAttributes: {  
    label: 'Edit',  
    fixedWidth: 30,
    name: 'Edit',  
    title: 'Edit',  
    disabled: false,  
    value: 'edit',  
    iconPosition: 'left'  
} }  ,
{   label: 'Action',
    type: "button", typeAttributes: {  
    label: 'Delete',  
    fixedWidth: 30,
    name: 'Delete',  
    title: 'Delete',  
    disabled: false,  
    value: 'delete',  
    iconPosition: 'left'  
} }, */
    {  label: 'Edit',
        type: 'button-icon',
        typeAttributes:
        {
            iconName: 'utility:edit',
            name: 'Edit',
            iconClass:'slds-icon-position--left'
    } }  ,
    {  label: 'Delete',
        type: 'button-icon',
        typeAttributes:
        {
            iconName: 'utility:delete',
            name: 'Delete',
            iconClass:'slds-icon--left'
             
    } }  ,
    { 
        label: 'Mass Sample/Free Contact: Sample Request Contact Number',
        fieldName: 'nameLink',
        type:'url',
		typeAttributes: {
            label: { 
                fieldName: 'name'
            },
            target : '_blank'
        }
    },
    { 
        label: 'Account Name',
        fieldName: 'accID',
        type:'url',
		 typeAttributes: {
            label: { 
                fieldName: 'accName'
            },
            target : '_blank'
        }
    },
    { 
        label: 'Generic Contact',
        fieldName: 'conName',
        type:'text'
    },
    { 
        label: 'Billing City',
        fieldName: 'accBillCityLink',
        type:'url',
		 typeAttributes: {
            label: { 
                fieldName: 'accBillCity'
            },
            target : '_blank'
        }
    },
	{ 
        label: 'Billing State/Province',
        fieldName: 'accBillStateLink',
        type:'url',
		 typeAttributes: {
            label: { 
                fieldName: 'accBillState'
            },
            target : '_blank'
        }
    },
    { 
        label: 'Billing Zip/Postal Code',
        fieldName: 'accBillZipLink',
        type:'url',
		 typeAttributes: {
            label: { 
                fieldName: 'accBillZip'
            },
            target : '_blank'
        }
    },
    { 
        label: 'Billing Country',
        fieldName: 'accBillCountryLink',
        type:'url',
		 typeAttributes: {
            label: { 
                fieldName: 'accBillCountry'
            },
            target : '_blank'
        }
    },
    { 
        label: 'Account Type',
        fieldName: 'accTypeLink',
        type:'url',
		 typeAttributes: {
            label: { 
                fieldName: 'accType'
            },
            target : '_blank'
        }
    },
	{ 
        label: 'MDR PID',
        fieldName: 'accMDRLink',
        type:'url',
		 typeAttributes: {
            label: { 
                fieldName: 'accMDR'
            },
            target : '_blank'
        }
    }
];
export default class MassSampleGenericContact extends NavigationMixin(LightningElement) {
    showGenericCreate;
    @api parentSampleId;
    wiredGenericFullData;
    @track recordList;
    @track showTable = false;
    @track fetchError;
    @track columnsVal = columnsVal;
    newGenericId;
    noData; 
    fullLoading = false; 
    loading = false;

    @wire(fetchGenericContacts,{massSampleId:'$parentSampleId'})
		wiredGenericContacts(response){ 
            this.loading = false;
            this.fullLoading = false;
            this.wiredGenericFullData = response;
			if (response.data) {
				console.log('went generic loop1:',response.data.length); 
				if(response.data.length === 0){
					console.log('no generic records:');
					this.showTable = false;		
					this.noData = 'No records to display';
					this.fetchError = '';
				}
				else{					
					this.recordList = response.data;
					this.showTable = true;		
					this.noData = '';
					this.fetchError = '';
				}
			} else if (response.error) {
				this.fetchError = response.error;
				this.showTable = false;	
				this.recordList = undefined;
			}

		}

    handleGenericCreate(){
        this.loading = true;
        this.newGenericId = '';
        this.showGenericCreate = true;
    }
    handleLoad(){
        this.loading = false;
        console.log('load complete: ');
    }
    addAccountFromList(){
        this.navigateURL = '/apex/SearchAccountGenericMassSamplePage?sampleId='+this.parentSampleId;
			this[NavigationMixin.Navigate]({
				type: 'standard__webPage',
				attributes: {
					url: this.navigateURL
				}
			})
    }  
    massSampleGenericCreation(){
        this.showGenericCreate = false;
        return refreshApex(this.wiredGenericFullData);
    }
    handleCancel(){
        this.newGenericId = false;
        this.showGenericCreate = false;
    }
    handleSave(){
        this.loading = true;
    }
    handleError(event){
        let message = event.detail.detail;
        this.showToast(message,'error');
    }
    showToast(theMessage, theVariant) {
        const event = new ShowToastEvent({
            message: theMessage,
            variant: theVariant
        });
     this.dispatchEvent(event);
    }
    handleRowAction(event){
        var action = event.detail.action.name; 
        this.newGenericId = event.detail.row.genericId; 
        if(action === 'Edit'){   
            this.loading = true;         
            this.showGenericCreate = true;
        }
        else if(action === 'Delete'){
            LightningConfirm.open({
                message: 'Are you sure?',
                variant: 'header',
                label: 'Please Confirm',
                theme: 'error',
            }) .then((result) => {
                if (result) {                    
                    this.fullLoading = true;
                    deleteRecord(this.newGenericId).then(response=>{
                        return refreshApex(this.wiredGenericFullData);
                    }).catch(error=>{
                        console.log('Error while deleting record',error );
                    })
                } else {
                    console.log('Delete not confirmed:');
                }
            })
        }

    }
}