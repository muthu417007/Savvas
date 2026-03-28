import { LightningElement,api,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CREATEDNAME_FIELD from '@salesforce/schema/SampleRequest__c.CreatedBy.Name';
import CREATEDDATE_FIELD from '@salesforce/schema/SampleRequest__c.CreatedDate';
import NAME_FIELD from '@salesforce/schema/SampleRequest__c.Name';
import SAMPLE_CONTACTS_FIELD from '@salesforce/schema/SampleRequest__c.Number_of_Contacts__c';
import GENERIC_CONTACTS_FIELD from '@salesforce/schema/SampleRequest__c.Number_of_Generic_Contacts__c';
const fieldArray = [CREATEDNAME_FIELD,CREATEDDATE_FIELD,NAME_FIELD,SAMPLE_CONTACTS_FIELD,GENERIC_CONTACTS_FIELD];
export default class MassSampleComponent extends NavigationMixin(LightningElement) {
    @api sampleId;
    sampleReqCreatedBy;
    sampleRegCreatedDate;
    sampleReqObjectLabel;
    sampleReqName;
    relatedSampleContacts;
    relatedGenericContacts;
    @api objectApiName;

    /*@wire(getObjectInfo,{objectApiName: SAMPLE_OBJECT})
    objectInfo({error,data}){       
        if(data){
            this.sampleReqObjectLabel = data.label;
            console.log('objectInfo1: ',data.label);        }
    }*/

    @wire(getRecord,{recordId : '$sampleId',fields:fieldArray})
    sampleReqRecord({error,data}){
        if(data)
        {  
            this.sampleReqCreatedBy = data.fields.CreatedBy.displayValue;
            this.sampleRegCreatedDate = data.fields.CreatedDate.displayValue;
            this.sampleReqName = data.fields.Name.value;
            this.relatedSampleContacts = data.fields.Number_of_Contacts__c.value;
            this.relatedGenericContacts = data.fields.Number_of_Generic_Contacts__c.value;
            console.log('sampleReqName; ',this.sampleReqName);
        }
    }

    handleLaunchMass(){        
        if(this.relatedGenericContacts === 0 && this.relatedSampleContacts === 0){
            console.log('no records!!!');
            this.dispatchEvent(
                new ShowToastEvent({
                    message: 'Request does not contain any account/contact',
                    variant: 'error'
                }),
            );
        }
        else{
            console.log('Yes records!!!');
            this.navigateURL = '/apex/MassSampleIFRAME?id='+this.sampleId;       
            console.log('went: ',this.navigateURL);
			this[NavigationMixin.Navigate]({
				type: 'standard__webPage',
				attributes: {
					url: this.navigateURL
				}
			})
        }
        
    }

      
}