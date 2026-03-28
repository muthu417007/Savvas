import { LightningElement, api } from 'lwc';
import ensxtx_CartPDP_Table_Condition from '@salesforce/label/c.ensxtx_CartPDP_Table_Condition';
import ensxtx_CartPDP_Table_Rate from '@salesforce/label/c.ensxtx_CartPDP_Table_Rate';
import ensxtx_CartPDP_Table_Value from '@salesforce/label/c.ensxtx_CartPDP_Table_Value';

export default class EnsxtxPricingConditions extends LightningElement {
    @api conditions;
    @api displayValues = false;

    label = {
        ensxtx_CartPDP_Table_Condition,
        ensxtx_CartPDP_Table_Rate,
        ensxtx_CartPDP_Table_Value
    };

    get hasConditions() {
        return (this.conditions || {}).length > 0;
    }
}