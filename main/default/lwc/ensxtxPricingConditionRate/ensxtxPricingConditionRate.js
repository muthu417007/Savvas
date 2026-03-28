import { LightningElement, api } from 'lwc';

export default class EnsxtxPricingConditionRate extends LightningElement {
    @api condition;

    /**
     * Gets whether condition is a percent.
     *
     * @type {Boolean}
     * @readonly
     * @private
     */
    get isPercent() {
        return this.condition.RateUnit === '%';
    }

    /**
     * Divide the rate by 100.0 to get decimal for percentage
     * 
     * @type {decimal}
     * @readonly
     * @private
     */
    get asPercentDecimal() {
        return this.condition.Rate / 100.0;
    }
}