import { LightningElement, api } from 'lwc';
import ensxtx_CartPDP_Field_NetPrice from '@salesforce/label/c.ensxtx_CartPDP_Field_NetPrice';
import ensxtx_CartPDP_Field_TaxAmount from '@salesforce/label/c.ensxtx_CartPDP_Field_TaxAmount';
import ensxtx_CartPDP_Message_NetPriceUnavailable from '@salesforce/label/c.ensxtx_CartPDP_Message_NetPriceUnavailable';
import ensxtx_CartPDP_Message_TaxAmountUnavailable from '@salesforce/label/c.ensxtx_CartPDP_Message_TaxAmountUnavailable';

export default class EnsxtxPricingDetails extends LightningElement {
    @api recordId;
    @api price;
    @api tax;
    @api conditions;
    @api currencyIsoCode;
    @api displayPrice;
    @api displayTax;
    @api displayConditionsValues = false;
    @api displayTiers = false;
    @api pricingTiers;
    @api displayConditions;

    label = {
        ensxtx_CartPDP_Field_NetPrice,
        ensxtx_CartPDP_Field_TaxAmount,
        ensxtx_CartPDP_Message_NetPriceUnavailable,
        ensxtx_CartPDP_Message_TaxAmountUnavailable
    };

    get hasPrice() {
        return (this.price || '').toString().length > 0;
    }

    get hasTax() {
        return (this.tax || '').toString().length > 0;
    }
}