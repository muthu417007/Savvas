import { LightningElement,api,track,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import CONTACT from "@salesforce/schema/SampleRequestContact__c.Contact__c";
import ACCOUNT from "@salesforce/schema/SampleRequestContact__c.Account__c";
import CURRENCY from '@salesforce/schema/SampleRequestContact__c.CurrencyIsoCode';
import { createRecord,deleteRecord,updateRecord} from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningConfirm from 'lightning/confirm';
import fetchSampleRequestContacts from '@salesforce/apex/FetchMassSampleContactsClass.searchSampleContacts';
import fetchContactAccount from '@salesforce/apex/FetchMassSampleContactsClass.fetchContactAccount';
import fetchParentData from '@salesforce/apex/FetchMassSampleContactsClass.fetchParentData';

const actions = [
    { label: 'Edit', name: 'Edit',},
    { label: 'Delete', name: 'Delete' },
];
const columnsVal=[    
 
    {  label: 'Edit',
        type: 'button-icon',
        typeAttributes:
        {
            iconName: 'utility:edit',
            name: 'Edit',
            iconClass:'slds-float--right'  
    } }  ,
    {  label: 'Delete',
        type: 'button-icon',
        typeAttributes:
        {
            iconName: 'utility:delete',
            name: 'Delete'
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
        label: 'Last Name',
        fieldName: 'conLastNameLink',
        type:'url',
		typeAttributes: {
            label: { 
                fieldName: 'conLastName'
            },
            target : '_blank'
        }
    },
	{ 
        label: 'First Name',
        fieldName: 'conFirstNameLink',
        type:'url',
		 typeAttributes: {
            label: { 
                fieldName: 'conFirstName'
            },
            target : '_blank'
        }
    },
	{ 
        label: 'Email',
        fieldName: 'conEmailLink',
        type:'url',
		 typeAttributes: {
            label: { 
                fieldName: 'conEmail'
            },
            target : '_blank'
        }
    },
	{ 
        label: 'Account Name',
        fieldName: 'accLink',
        type:'url',
		 typeAttributes: {
            label: { 
                fieldName: 'accName'
            },
            target : '_blank'
        }
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
        label: 'MDR PID',
        fieldName: 'accMDRLink',
        type:'url',
		 typeAttributes: {
            label: { 
                fieldName: 'accMDR'
            },
            target : '_blank'
        }
    },
    /*{
        label: 'Actions',
        type: 'action',
        typeAttributes: { rowActions: actions, menuAlignment: 'right' },
    }*/
];
export default class MassSampleFreeContact extends NavigationMixin(LightningElement) {
		@api parentSampleId;
        @api massSampleName;
        relatedContacts;
        relatedGeneric;
        contactVal;
        accVal;
        oldAccId;
        oldConId;
		showSampleCreate = false;
		navigateURL='';
		noData;        
        totalrelated = 0;
		@track columnsVal = columnsVal;
		@track results;
		@track fetchError;
		@track sampleRequestContacts = [];
		@track recordList;
		@track showTable = false;
        selectedAccId = '';
        selectedConId = '';
        selectedCurrency;
        currencyValue = 'USD';
        newSampleConId;
        wiredFullData;
        parentData = [];
        isUpdate = false;
        contactList
        isValid = true;
        recId;
        isLoading = false;
        outsideClick;
        blankMessage = '';
        
       	@wire(fetchSampleRequestContacts,{massSampleId:'$parentSampleId'})
		wiredSampleContacts(response){ 
			console.log('Full data: ',response.data);             
            this.isLoading = false;
            this.wiredFullData = response;
			if (response.data) {
				console.log('went loop1:',response.data.length); 
				if(response.data.length === 0){
					console.log('no records:');
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

        @wire(getPicklistValues, {recordTypeId: '012000000000000AAA', fieldApiName: CURRENCY})
        currencyPicklistValues;

        handleSampleCreate(){
				this.showSampleCreate = true;
                this.accVal = '';
                this.contactVal = '';
                this.isUpdate = false;
                this.selectedAccId = '';
                this.selectedConId = '';
                this.outsideClick = true;
		}
        ignore(event){
            console.log('went ignore:',event.target.localName);
            if(event.target.localName === 'div'){
               this.outsideClick = false;
            }
        }
		handleCancel(){
			this.showSampleCreate = false;
            this.accVal = '';
            this.contactVal = '';
            this.isUpdate = false;
             this.outsideClick = true;
		}
		massSampleContactCreation(event){
			this.recordId = event.detail.id;
			this.showSampleCreate = false;
		}
		addContactFromList() {			
			this.navigateURL = '/apex/SearchContactMassSamplePage?sampleId='+this.parentSampleId;
			console.log('Navigate sucess1: ',this.navigateURL);
			console.log('parentSampleId1 ',this.parentSampleId);
			this[NavigationMixin.Navigate]({
				type: 'standard__webPage',
				attributes: {
					url: this.navigateURL
				}
			})
		}

        handleAccountSelection(event){
            this.selectedAccId = event.detail;
        }
        handleContactSelection(event){
            this.selectedConId = event.detail;
        }
        handleCurrencySelection(event) {
            //this.value = event.detail.value;
            this.selectedCurrency = event.detail.value;
        }
        /*handleLoad() {
            fetchSampleRequestContacts({massSampleId:this.parentSampleId})
                .then(result => {
                    this.recordList = result;
                    console.log('this.recordList',this.recordList);
                    this.showTable = true;		
					this.noData = '';
					this.fetchError = '';
                })
                .catch(error => {
                    this.fetchError = error;
                    this.recordList = undefined;
                });
        }*/
		handleSubmit(){
            console.log('update con: ',this.selectedConId);
            this.isLoading = true;
            if(this.selectedConId === '' || this.selectedAccId === ''){
                if(this.selectedAccId === ''){
                    this.blankMessage = 'Please populate Account';
                }
                else if(this.selectedConId === ''){
                    this.blankMessage = 'Please populate Contact';
                }
                this.isLoading = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: this.blankMessage,
                        variant: 'error'
                    }),
                );
            }
            else{
                this.showSampleCreate = false;
                const fields = {'Account__c' :this.selectedAccId,'Contact__c':this.selectedConId,'CurrencyIsoCode':this.selectedCurrency,'SampleRequest__c':this.parentSampleId};
                const recordInput = {apiName:'SampleRequestContact__c',fields}
                fetchParentData({parentID:this.parentSampleId}).then(response=>{
                    this.parentData = response;                                   
                    this.totalrelated = this.parentData[0].Number_of_Contacts__c + this.parentData[0].Number_of_Generic_Contacts__c;
                    console.log('totalrelated1',this.totalrelated);  
                    if(this.totalrelated > 19){
                        this.isLoading = false;
                        this.dispatchEvent(
                            new ShowToastEvent({
                                message: 'Only a total of 20 Contacts or Generic Contacts allowed',
                                variant: 'error'
                            }),
                        );
                    }
                    else {                    
                        if(this.isUpdate && this.oldAccId === this.selectedAccId &&
                            this.oldConId === this.selectedConId && 
                            this.currencyValue === this.selectedCurrency){
                                this.isLoading = false;
                        }
                        else{                         
                            fetchContactAccount({conID:this.selectedConId}).then(response=>{
                                this.contactList = response;
                                console.log('contactList1: ',this.contactList[0].AccountId);
                                console.log('contactList2: ',this.selectedAccId);
                                if(this.contactList[0].AccountId !== this.selectedAccId){
                                    console.log('Invalid');
                                    this.isLoading = false;
                                    this.showSampleCreate = true;
                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                            message: 'Invalid Contact selected. Please choose Contact from the selected Account',
                                            variant: 'error'
                                        }),
                                    );
                                }
                                else{
                                    if(!this.isUpdate){ 
                                        createRecord(recordInput).then(response=>{
                                            console.log('SampleReq Contact created',response.id);
                                            this.newSampleConId = response.id;
                                            //window.location.reload();
                                            //this.showTable = true;	
                                            return refreshApex(this.wiredFullData);
                                        }).catch(error=>{
                                            console.log('Error while creating account',error );
                                        })
                                    }
                                    else if(this.isUpdate){
                                        const fields = {};
                                        fields.Id = this.recId;
                                        fields[CONTACT.fieldApiName] = this.selectedConId;
                                        fields[ACCOUNT.fieldApiName] = this.selectedAccId;
                                        fields[CURRENCY.fieldApiName] = this.selectedCurrency;                            
                                        console.log('went5'); 
                                        const recordInput = {fields};
                                        updateRecord(recordInput)
                                        .then(() => {
                                            this.dispatchEvent(
                                                new ShowToastEvent({
                                                    title: "Success",
                                                    message: "Record updated successfully",
                                                    variant: "success"
                                                })
                                            );                                        
                                           return refreshApex(this.wiredFullData);
                                        })
                                        .catch((error) => {
                                        console.log('Record update error: ',error);
                                        });
                                    }
                                }
                            }).catch(error=>{
                                console.log('error :', error);
                            });                     
                            
                        } 
                        
                    } 
                }).catch(error=>{
                    console.log('error :', error);
                }); 
         
             }          

        }
        handleRowAction(event) {
            var action = event.detail.action.name; 
            this.recId =  event.detail.row.massSampleId;
            if(action === 'Edit'){
                this.contactVal =  event.detail.row.conFirstName +' '+event.detail.row.conLastName;
                this.oldAccId = event.detail.row.accLink;
                this.oldAccId = this.oldAccId.replace ('/', "");
                this.oldConId = event.detail.row.conFirstNameLink;
                this.oldConId = this.oldConId.replace ('/', "");
                this.accVal =  event.detail.row.accName;
                this.showSampleCreate = true;
                this.isUpdate = true;
                this.currencyValue = event.detail.row.currencyCode; 
                this.selectedAccId = this.oldAccId;
                this.selectedConId = this.oldConId;
                this.selectedCurrency = this.currencyValue;
            }
            else if(action === 'Delete'){           
                 LightningConfirm.open({
                    message: 'Are you sure?',
                    variant: 'header',
                    label: 'Please Confirm',
                    theme: 'error',
                }) .then((result) => {
                    if (result) {
                        console.log('Delete confirmed:');
                        this.isLoading = true;
                        deleteRecord(this.recId).then(response=>{                            
                            return refreshApex(this.wiredFullData);
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