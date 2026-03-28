import { LightningElement, api } from 'lwc';
export default class ChildBreakCombobox extends LightningElement {
    @api thisDataId
    @api metadataMasterList
    @api selectedActivity
    @api thisValue
    @api disabled
    showThis=false
    options=[]
    breakList=[]
    connectedCallback() {
        if(this.selectedActivity){
            let metadataIndex = this.metadataMasterList.findIndex(item=>item.Label===this.selectedActivity)
            let metadataRecord = this.metadataMasterList[metadataIndex]
            if( metadataRecord.Label=='BREAK'){
                this.showThis = true
                this.breakList = metadataRecord.Break_During_Delivery_Of__c.split(',')
                this.options = this.breakList.map(item=>{
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