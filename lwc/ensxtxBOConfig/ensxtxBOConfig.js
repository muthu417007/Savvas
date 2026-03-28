import { LightningElement } from 'lwc';
import getBOConfigs from '@salesforce/apex/ensxtx_CTRL_BOConfig.getBOConfigs'

// Import custom labels
import CustomizingID from '@salesforce/label/c.ensxtx_BOConfig_CustomizingID';
import BusinessObject from '@salesforce/label/c.ensxtx_BOConfig_BusinessObject';
import BusinessObjectTransaction from '@salesforce/label/c.ensxtx_BOConfig_BusinessObjectTransaction';
import VariableType from '@salesforce/label/c.ensxtx_BOConfig_VariableType';
import VariableName from '@salesforce/label/c.ensxtx_BOConfig_VariableName';
import VariableCount from '@salesforce/label/c.ensxtx_BOConfig_VariableCount';
import Sign from '@salesforce/label/c.ensxtx_BOConfig_Sign';
import Option from '@salesforce/label/c.ensxtx_BOConfig_Option';
import Low from '@salesforce/label/c.ensxtx_BOConfig_Low';
import High from '@salesforce/label/c.ensxtx_BOConfig_High';

const columns = [
    { label: CustomizingID, fieldName: 'CustomizingID', sortable: true },
    { label: BusinessObject, fieldName: 'BusinessObject', sortable: true },
    { label: BusinessObjectTransaction, fieldName: 'BusinessObjectTransaction', sortable: true },
    { label: VariableType, fieldName: 'VariableTypeDescription', sortable: true },
    { label: VariableName, fieldName: 'VariableName', sortable: true },
    { label: VariableCount, fieldName: 'VariableCount', sortable: true },
    { label: Sign, fieldName: 'Sign', sortable: true },
    { label: Option, fieldName: 'Option', sortable: true },
    { label: Low, fieldName: 'Low', sortable: true },
    { label: High, fieldName: 'High', sortable: true },
];

export default class EnsxtxBOConfig extends LightningElement{

    allData = []
    displayData = []
    columns = columns
    isLoading = true
    messages = []
    businessObjects = []
    totalRecords = 0
    sortedBy = ''
    sortedDirection = ''

    connectedCallback() {
        getBOConfigs()
            .then(response => {
                if (response) {
                    this.messages = response.messages
                    let setObjects = new Set();
                    let responseData = response.data.map(data => ({...data, VariableTypeDescription: this.variableTypeDescription(data.VariableType)}))
                    responseData.forEach(data => {
                        if (data.BusinessObject) setObjects.add(data.BusinessObject);
                    })
                    let businessObjectsList =
                        Array.from(setObjects)
                            .map(key => ({value: key, label: key}))
                    this.businessObjects = [{value: '', label: 'All'}, ...businessObjectsList]
                    this.totalRecords = responseData.length
                    this.displayData = responseData
                    this.allData = responseData
                }
                this.isLoading = false
            })
            .catch(response => {
                this.messages = [
                    {
                        key: 1,
                        messageType: 'ERROR',
                        message: response?.body?.message || response
                    }
                ]
                this.isLoading = false
            })
    }

    variableTypeDescription(variableType) {
        switch (variableType) {
            case 'P':
                return 'P - Parameter'
            case 'R':
                return 'R - Range'
            default:
                return variableType
        }
    }

    onSelectChange(event) {
        this.isLoading = true
        if (event.target.value) {
            this.displayData = this.allData.filter(data => data.BusinessObject === event.target.value)
        } else {
            this.displayData = this.allData
        }
        this.sortDisplayData()
        this.totalRecords = this.displayData.length
        this.isLoading = false
    }

    onSort(event) {
        this.sortedBy = event.detail.fieldName
        this.sortedDirection = event.detail.sortDirection
        this.sortDisplayData()
    }

    sortDisplayData() {
        this.displayData = [...this.displayData.sort(this.sortBy(this.sortedBy, this.sortedDirection === 'asc' ? 1 : -1))]
    }

    sortBy(field, reverse, primer) {
        const key = primer ? function(x) { return primer(x[field]) } : function(x) { return x[field] }
        return function (a, b) {
            const A = key(a) || ''
            const B = key(b) || ''
            return reverse * ((A > B) - (B > A));
        }
    }
}