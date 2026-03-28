import { LightningElement, api } from 'lwc';
import ensxtx_CartPDP_Button_AddToCart from '@salesforce/label/c.ensxtx_CartPDP_Button_AddToCart';
import ensxtx_CartPDP_Button_AddToList from '@salesforce/label/c.ensxtx_CartPDP_Button_AddToList';
import ensxtx_CartPDP_Field_Quantity from '@salesforce/label/c.ensxtx_CartPDP_Field_Quantity';
import ensxtx_CartPDP_Field_SKU from '@salesforce/label/c.ensxtx_CartPDP_Field_SKU';
import ensxtx_CartPDP_Message_InStock from '@salesforce/label/c.ensxtx_CartPDP_Message_InStock';
import ensxtx_CartPDP_Message_OutOfStock from '@salesforce/label/c.ensxtx_CartPDP_Message_OutOfStock';
import ensxtx_CartPDP_Section_Description from '@salesforce/label/c.ensxtx_CartPDP_Section_Description';

// A fixed entry for the home page.
const homePage = {
    name: 'Home',
    type: 'standard__namedPage',
    attributes: {
        pageName: 'home'
    }
};

/**
 * An organized display of product information.
 *
 * @fires ProductDetailsDisplay#addtocart
 * @fires ProductDetailsDisplay#createandaddtolist
 */
export default class EnsxtxProductDetailsDisplay extends LightningElement
{
    /**
     * An event fired when the user indicates the product should be added to their cart.
     *
     * Properties:
     *   - Bubbles: false
     *   - Composed: false
     *   - Cancelable: false
     *
     * @event ProductDetailsDisplay#addtocart
     * @type {CustomEvent}
     *
     * @property {string} detail.quantity
     *  The number of items to add to cart.
     *
     * @export
     */

    /**
     * An event fired when the user indicates the product should be added to a new wishlist
     *
     * Properties:
     *   - Bubbles: false
     *   - Composed: false
     *   - Cancelable: false
     *
     * @event ProductDetailsDisplay#createandaddtolist
     * @type {CustomEvent}
     *
     * @export
     */

    /**
     * A product image.
     * @typedef {object} Image
     *
     * @property {string} url
     *  The URL of an image.
     *
     * @property {string} alternativeText
     *  The alternative display text of the image.
     */

    /**
     * A product category.
     * @typedef {object} Category
     *
     * @property {string} id
     *  The unique identifier of a category.
     *
     * @property {string} name
     *  The localized display name of a category.
     */

    /**
     * A product price.	
     * @typedef {object} Price	
     *	
     * @property {string} negotiated	
     *  The negotiated price of a product.	
     *	
     * @property {string} currency	
     *  The ISO 4217 currency code of the price.	
     */

    /**
     * A product field.
     * @typedef {object} CustomField
     *
     * @property {string} name
     *  The name of the custom field.
     *
     * @property {string} value
     *  The value of the custom field.
     */

    @api recordId;
    @api customFields;
    @api cartLocked;
    @api description;
    @api image;
    @api inStock = false;
    @api name;
    @api price;
    @api currencyIsoCode;
    @api pricingTiers;
    @api availabilities;
    @api displayPrice;
    @api displayTax;
    @api tax;
    @api conditions;
    @api displayConditions;
    @api displayConditionsValues;
    @api conditionsToDisplay;
    @api displayTiers = false;
    @api sku;
    @api quantity = 1;
    @api

    label = {
        ensxtx_CartPDP_Button_AddToCart,
        ensxtx_CartPDP_Button_AddToList,
        ensxtx_CartPDP_Field_Quantity,
        ensxtx_CartPDP_Field_SKU,
        ensxtx_CartPDP_Message_InStock,
        ensxtx_CartPDP_Message_OutOfStock,
        ensxtx_CartPDP_Section_Description
    };

    _invalidQuantity = false;

    get hasPrice() {
        return ((this.price || {}).negotiatedPrice || '').toString().length > 0;
    }

    get hasConditions() {
        return (this.conditions || []).length > 0;
    }

    get _isAddToCartDisabled() {
        return this._invalidQuantity || this.cartLocked || !this.inStock;
    }

    handleQuantityChange(event) {
        if (event.target.validity.valid && event.target.value) {
            this._invalidQuantity = false;
            this.quantity = event.target.value;
        } else {
            this._invalidQuantity = true;
        }
        this.dispatchEvent(
            new CustomEvent('updatequantity', {
                detail: {
                    quantity: event.target.value
                }
            })
        )
    }

    notifyAddToCart() {
        let quantity = this.quantity;
        this.dispatchEvent(
            new CustomEvent('addtocart', {
                detail: {
                    quantity
                }
            })
        );
    }

    notifyAddToList() {
        this.dispatchEvent(new CustomEvent('addtolist'));
    }

    get _displayableFields() {
        // Enhance the fields with a synthetic ID for iteration.
        return (this.customFields || []).map((field, index) => ({
            ...field,
            id: index
        }));
    }
}