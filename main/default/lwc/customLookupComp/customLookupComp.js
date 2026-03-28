import { LightningElement,api,wire,track} from 'lwc';
import fetchLookupData from '@salesforce/apex/CustomLookupLwcController.fetchLookupData';


export default class CustomLookupLwc extends LightningElement {
	
	@track searchTerm;
	@api dependentId;
    @api label;
    @api placeholder;
    @api objName;
    @api filter='';
    @track records;
    @api isValueSelected;
    @api selectedName;
    @api iconName;
    @api relatedField='';
    @api requiredFlag;
    @api inputVal;
    @api queryFields='';
    outsideClick;
    noFoundMessage = '';
    hasRecords = true;
    isAccount = false;
    isContact = false;
    //css
    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    @track inputClass = '';
	
    @wire(fetchLookupData, {searchTerm : '$searchTerm', myObject : '$objName', filter : '$filter', relatedField : '$relatedField', queryFields : '$queryFields'})
    wiredRecords({ error, data }) {
        console.log('searchTerm: ',this.searchTerm);
        console.log('Data: ',data);
        console.log('Data: ',data);
        if (data) {
            this.error = undefined;
            //this.hasRecords = data.length == 0  ? false : true;             
            if(data.length > 0){                
                this.records = data;
                this.outsideClick = false;
                this.hasRecords = true;
                this.noFoundMessage = '';
                if(this.label === 'Account'){
                    this.isAccount = true;
                    this.isContact = false;
                }
                else if(this.label === 'Contact'){
                    this.isAccount = false;
                    this.isContact = true;
                }
                console.log('went1:',this.records);
            }
            else{
                this.records = [];
            }
            if(data.length === 0 && this.label === 'Contact'){
                console.log('went if');
                this.outsideClick = true;
                this.hasRecords = false;
                if(this.filter !== ''){                    
                    this.noFoundMessage = 'This Contact is not found under the selected Account';
                }
                else{
                    this.noFoundMessage = 'Please select Account'; 
                }
            }
            else if(data.length === 0 && this.label === 'Account' && this.searchTerm !== ''){                
                this.hasRecords = false;
                this.outsideClick = true;
                console.log('went else if');
                this.noFoundMessage = 'Select an option from the picklist or remove the search term';
            }
            console.log('label: ',this.label);
        } else if (error) {
            console.log('Error: ',error);
            this.error = error;
            this.records = undefined;
        }
        console.log('went else if2: ',this.outsideClick, ' ', this.hasRecords);
    }

	handleClick(event) {
        this.searchTerm = event.target.value;     
        this.hasRecords = true;
        this.outsideClick = true;
        this.noFoundMessage = '';
        this.records = [];    
        this.inputClass = 'slds-has-focus';
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open';
   }
	
	onChange(event) {
        console.log('onchange');
        this.searchTerm = event.target.value;
        if(this.searchTerm === ''){
            this.hasRecords = true;
            this.outsideClick = true;
        }
       /* else{            
         this.outsideClick = false;
        }*/
    }

    onSelect(event) {
        let selectedId = event.currentTarget.dataset.id;
        let selectedName = event.currentTarget.dataset.name;
        const valueSelectedEvent = new CustomEvent('lookupselected', {detail:  selectedId });
        this.dispatchEvent(valueSelectedEvent);
        this.isValueSelected = true;
        this.selectedName = selectedName;
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    }

    handleRemovePill(event) {
        console.log('handleRemovePill:');
        this.isValueSelected = false;
        this.searchTerm = '';
        this.outsideClick = true;
        this.hasRecords = true;
        this.noFoundMessage = '';
        const valueSelectedEvent = new CustomEvent('lookupselected', {detail:  '' });
        this.dispatchEvent(valueSelectedEvent);
    }

    handleCommit(event){
        console.log('handleCommit:',event.target.localName);
        //this.outsideClick = true;
    }

    handleBlur(){
        console.log('handleBlur:' );
        this.hasRecords = true;
    }


}