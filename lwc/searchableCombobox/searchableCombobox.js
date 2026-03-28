import { LightningElement, api } from 'lwc';
import fetchAccountsOptions from '@salesforce/apex/Sav_FSL_TimeSheetcontroller.fetchAccountsOptions';
export default class SearchableCombobox extends LightningElement {
    options = []
    @api iconName
    @api iconTitle
    @api placeHolder
    @api selectedValue = ''
    @api selectedActivity = ''
    @api thisDataId
    @api disabled
    @api required
    @api errorMessage
    showCombobox = false
    searchKey = ''
    comboboxIsOpen = false
    @api isValueSelected = false
    cancelBlur = false
    highlightCounter = null
    focussedOnce = false
    typingTimer

    connectedCallback() {
        if (this.selectedActivity == 'PILOT-STANDARD-FY24' || this.selectedActivity == 'PARTNERSHIP PLUS' || this.selectedActivity == 'PROJ MGT'||this.selectedActivity == 'CUST CXL-FORFEIT') {
            if (this.selectedValue != '') {
                fetchAccountsOptions({ searchString: '', selectedAccountId: this.selectedValue }).then(result => {
                    this.options = result.map(item => {
                        return {
                            label: item.Name,
                            value: item.Id
                        }
                    })
                }).then(success => {
                    this.showCombobox = true
                }).catch(error => {
                    console.error(error)
                })
            } else {
                fetchAccountsOptions({ searchString: '', selectedAccountId: '' }).then(result => {
                    this.options = result.map(item => {
                        return {
                            label: item.Name,
                            value: item.Id
                        }
                    })
                }).then(success => {
                    this.showCombobox = true
                }).catch(error => {
                    console.error(error)
                })
            }
        } else {
            this.showCombobox = false
        }
    }
    get isInvalid() {
        if((this.selectedValue=='' ||  this.selectedValue==undefined) && this.focussedOnce){
            return true
        }else{
            return false
        }
	}
     @api
        validate() {
            if(!this.isValueSelected && this.showCombobox) {
                this.focussedOnce = true;
                return false;
            }
            return true;
        }
    get isValueSelected() {
        if (this.selectedValue != '' && this.selectedValue != undefined) {
            return true
        } else {
            return false
        }
    }
    get selectedLabel() {
        let index = this.options.findIndex(item => item.value == this.selectedValue)
        if(index!=-1){
            return this.options[index].label
        }else{
            return ''
        }
    }
    get formElementClasses() {
        let classes = "slds-form-element"
        if (this.isInvalid) {
            classes += " slds-has-error"
        }
        return classes
    }
    get comboboxContainerClass() {
        let classes = 'slds-combobox_container'
        if (this.selectedValue != '' && this.comboboxIsOpen == false) {
            classes += ' slds-has-selection'
        }
        return classes
    }
    get comboboxClass() {
        let classes = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click'
        if (this.comboboxIsOpen) {
            classes += ' slds-is-open'
        }
        return classes
    }
    get inputClass() {
        let classes = 'slds-input slds-combobox__input'
        if (this.comboboxIsOpen) {
            classes += ' slds-has-focus'
        }
        if (this.selectedValue != '' && this.comboboxIsOpen) {
            classes += ' slds-combobox__input-value'
        }
        return classes
    }
    get tempOptions() {
        let options = this.options;
        if (this.searchKey != '') {
            options = this.options.filter((op) => op.label.toLowerCase().includes(this.searchKey.toLowerCase()));
        }
        return this.highLightOption(options);
    }
    highLightOption(options) {
        let classes = "slds-media slds-listbox__option slds-listbox__option_plain slds-media_small"
        return options.map((option, index) => {
            let cs = classes
            let focused = ""
            if (index === this.highlightCounter) {
                cs = classes + " slds-has-focus";
                focused = "yes";
            }
            return { classes: cs, focused, ...option };
        })
    }
    fireChange(value) {
        this.dispatchEvent(new CustomEvent("change", { detail: { dataId:this.thisDataId, label:this.selectedLabel , value: value } }));
    }
    handleSelect(event) {
        this.comboboxIsOpen = false
        this.cancelBlur = false
        this.selectedValue = event.currentTarget.dataset.value;
        // console.log(event.currentTarget.textContent)
        if (this.selectedValue != '') {
            this.isValueSelected = true
            this.fireChange(this.selectedValue)
        } else {
            this.isValueSelected = false
        }
    }
    @api clearSelection() {
        this.options = []
        this.selectedValue = ''
        this.isValueSelected = false
        this.searchKey = ''
        fetchAccountsOptions({ searchString: '', selectedAccountId: '' }).then(result => {
            this.options = result.map(item => {
                return {
                    label: item.Name,
                    value: item.Id
                }
            })
        }).then(success => {
            this.fireChange(this.selectedValue)
        })
    }
    handleSearchInput(event) {
        clearTimeout(this.typingTimer);
        this.searchKey = event.target.value
        this.typingTimer = setTimeout(() => {
            if (this.searchKey) {
                fetchAccountsOptions({ searchString: this.searchKey, selectedAccountId: '' }).then(result => {
                    if(result){
                        this.options=result.map(item=>{
                            return{
                                label:item.Name,
                                value:item.Id
                            }
                        })
                    }
                })
            }else{
                fetchAccountsOptions({ searchString: '', selectedAccountId: '' }).then(result => {
                    if(result){
                        this.options=result.map(item=>{
                            return{
                                label:item.Name,
                                value:item.Id
                            }
                        })
                    }
                })
            }
        }, 200);
    }
    focusCombobox() {
        this.focussedOnce = true
        this.comboboxIsOpen = true
        this.highlightCounter = null
    }
    blurCombobox() {
        if (!this.cancelBlur) {
            this.comboboxIsOpen = false
        }
        this.highlightCounter = null
    }
    handleDropdownMouseDown() {
        this.cancelBlur = true
    }
    handleDropdownMouseUp() {
        this.cancelBlur = false
    }
    handleKeyDown(event) {
        if (event.key == "Escape") {
            this.comboboxIsOpen = !this.comboboxIsOpen;
            this.highlightCounter = null;
        } else if (event.key === "Enter" && this.comboboxIsOpen) {
            if (this.highlightCounter !== null) {
                this.comboboxIsOpen = false
                this.cancelBlur = false
                this.selectedValue = this.tempOptions[this.highlightCounter].value;
                this.isValueSelected = true
                this.fireChange(this.selectedValue)
            }
        } else if (event.key === "Enter") {
            this.focusCombobox();
        }

        if (event.key === "ArrowDown" || event.key === "PageDown") {
            this.comboboxIsOpen = true;
            this.highlightCounter = this.highlightCounter === null ? 0 : this.highlightCounter + 1;
        } else if (event.key === "ArrowUp" || event.key === "PageUp") {
            this.comboboxIsOpen = true;
            this.highlightCounter = this.highlightCounter === null || this.highlightCounter === 0 ? this.tempOptions.length - 1 : this.highlightCounter - 1;
        }

        if (event.key === "ArrowDown" || event.key === "ArrowUp") {
            this.highlightCounter = Math.abs(this.highlightCounter) % this.tempOptions.length;
        }

        if (event.key === "Home") {
            this.highlightCounter = 0;
        } else if (event.key === "End") {
            this.highlightCounter = this.tempOptions.length - 1;
        }
    }
}