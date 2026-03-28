import { LightningElement, api } from 'lwc';
export default class ChildStateCombobox extends LightningElement {
    @api thisDataId
    @api metadataMasterList
    @api selectedActivity
    @api thisValue
    @api disabled
    showThis=false
    options=[]
    statesList=[]
    connectedCallback() {
        if(this.selectedActivity){
            let metadataIndex = this.metadataMasterList.findIndex(item=>item.Label===this.selectedActivity)
            let metadataRecord = this.metadataMasterList[metadataIndex]
            if( metadataRecord.Label=='PILOT-STANDARD-FY24'){
                this.showThis = true
                this.statesList = metadataRecord.State__c.split(',')
                this.options = this.statesList.map(item=>{
                    return{
                        label:item,
                        value:item
                    }
                })
            }
        }
    }
    handleChange(event){
        this.dispatchEvent(new CustomEvent("valueselect",{
            detail: {value:event.detail.value,dataId:this.thisDataId}
        }))
    }
      @api isInputValid() {
     console.log('childacttype')
        let isValid = true;
        let inputFields = this.template.querySelectorAll('lightning-combobox');
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
        });
        return isValid;
    }
}