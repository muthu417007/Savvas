import { LightningElement, api, track } from 'lwc';
import ensxtx_CartPDP_Message_AdditionalPricing from '@salesforce/label/c.ensxtx_CartPDP_Message_AdditionalPricing';
import ensxtx_CartPDP_Section_TieredPricing from '@salesforce/label/c.ensxtx_CartPDP_Section_TieredPricing';

export default class EnsxtxProductPricingTiers extends LightningElement {
    @api pricingTiers;

    @track tieredPricing = [];

    label = {
        ensxtx_CartPDP_Message_AdditionalPricing,
        ensxtx_CartPDP_Section_TieredPricing
    };

    get hasTiers() {
        return this.tieredPricing?.length > 1;
    };

    connectedCallback() {
        this.tieredPricing = this.pricingTiers?.map(item => {
            this.originalVal = item.FromValue === 1 ? item.Rate :  this.originalVal;
            this.originalPrice = item.FromValue === 1 ? Intl.NumberFormat(undefined, {minimumFractionDigits: 2}).format(item.Rate) + " " + item.FieldCurrency : this.originalPrice;
            const bottom = item.FromValue === 0 ? "" : "" + item.FromValue;
            const top = item.ToValue === 0 ? "" : "" + item.ToValue;
            this.salePrice = item.Rate;
            this.saleVal = item.Rate;
            return {
                key: item.SequenceNumber,
                range: bottom + " - " + top,
                price: Intl.NumberFormat(undefined, {minimumFractionDigits: 2}).format(item.Rate) + " " + item.FieldCurrency,
            };
        });
    }
}